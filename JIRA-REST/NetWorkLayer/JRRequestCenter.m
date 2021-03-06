//
//  JRRequestCenter.m
//  JIRA-REST
//
//  Created by ray on 16/10/24.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "JRRequestCenter.h"
#import "JRAccount.h"

static NSString * const kHost = @"http://jira.sudiyi.cn";

#define API_LOGIN @"jira/login.jsp"
#define API_CAPTCHA @"jira/captcha"

NS_INLINE NSString * API_JR(NSString *api) {
    return [NSString stringWithFormat:@"jira/rest/api/2/%@", api];
}

@implementation JRRequestCenter

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    if (self = [super initWithBaseURL:[NSURL URLWithString:kHost] sessionConfiguration:configuration]) {
        self.timeoutInterval = 30.0f;
        self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
        
    }
    return self;
}


#pragma mark - entrance

- (id<TCHTTPRequest>)loginWitUserName:(NSString *)name password:(NSString *)password
                              captcha:(NSString *)captche
                            beforeRun:(void (^)(id<TCHTTPRequest> request))beforeRun {
    if (nil == name || name.length < 1 || nil == password || password.length < 1 || JRAccount.currentAccount.isValid) {
        return nil;
    }
    
    id<TCHTTPRequest> request = [self requestWithMethod:kTCHTTPMethodPost apiUrl:API_LOGIN host:nil];
    
    request.parameters = @{@"os_username": name,
                           @"os_password": password,
                           @"os_destination": @"",
                           @"os_captcha": captche ?: NSNull.null};
    if (nil != beforeRun) {
        beforeRun(request);
    }
    
    return [request start:NULL] ? request : nil;
}

- (id<TCHTTPRequest>)fetchCaptchaBeforeRun:(void (^)(id<TCHTTPRequest> request))beforeRun {
    
    static TCHTTPStreamPolicy *streamPolicy = nil;
    if (nil == streamPolicy) {
        streamPolicy = [[TCHTTPStreamPolicy alloc] init];
    }
    id<TCHTTPRequest> request = [self requestForDownload:API_CAPTCHA streamPolicy:streamPolicy cachePolicy:nil];
    
    streamPolicy.downloadDestinationPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[@"captcha_" stringByAppendingString:request.identifier]];
    
    request.parameters = @{@"ts": @(floor([[NSDate date] timeIntervalSince1970]))};
    
    if (nil != beforeRun) {
        beforeRun(request);
    }

    return [request start:NULL] ? request : nil;
}


#pragma mark - create&update issue

- (id<TCHTTPRequest>)fetchCreateMetaWithProjectId:(NSString *)projectId
                                          issueId:(NSString *)issuetypeId
                                     expandFields:(BOOL)expandFields
                                        beforeRun:(void(^)(id<TCHTTPRequest> request))beforeRun
{
    if (nil == projectId || ![projectId isKindOfClass:NSString.class] || projectId.length < 1 || !JRAccount.currentAccount.isValid) {
        return nil;
    }
    
    NSDictionary *parameters = @{@"projectId": projectId,
                                 @"issuetypeId": issuetypeId ?: NSNull.class,
                                 @"expand": expandFields ? @"projects.issuetypes.fields" : NSNull.null};
    
    TCHTTPCachePolicy *policy = [[TCHTTPCachePolicy alloc] init];
    policy.cacheTimeoutInterval = 5 * D_MINUTE;
    policy.shouldExpiredCacheValid = YES;
    [policy setCachePathFilterWithRequestParameters:parameters sensitiveData:JRAccount.currentAccount.name];
    
    id<TCHTTPRequest> request = [self requestWithMethod:kTCHTTPMethodGet cachePolicy:policy apiUrl:API_JR(@"issue/createmeta") host:nil];
    request.parameters = parameters;
    
    if (nil != beforeRun) {
        beforeRun(request);
    }
    
    return [request start:NULL] ? request : nil;
}

- (id<TCHTTPRequest>)createIssue:(NSDictionary *)data beforeRun:(void (^)(id<TCHTTPRequest> request))beforeRun {
    if (nil == data || data.count < 1 || !JRAccount.currentAccount.isValid) {
        return nil;
    }
    
    id<TCHTTPRequest> request = [self requestWithMethod:kTCHTTPMethodPostJSON apiUrl:API_JR(@"issue") host:nil];
    
    request.parameters = data;
    
    if (nil != beforeRun) {
        beforeRun(request);
    }
    
    return [request start:NULL] ? request : nil;
}


#pragma mark -

- (id<TCHTTPRequest>)fetchProjectListBeforeRun:(void (^)(id<TCHTTPRequest> request))beforeRun {
    
    if (!JRAccount.currentAccount.isValid) {
        return nil;
    }
    
    TCHTTPCachePolicy *policy = [[TCHTTPCachePolicy alloc] init];
    policy.cacheTimeoutInterval = 5 * D_MINUTE;
    policy.shouldExpiredCacheValid = YES;
    [policy setCachePathFilterWithRequestParameters:nil sensitiveData:JRAccount.currentAccount.name];
    
    id<TCHTTPRequest> request = [self requestWithMethod:kTCHTTPMethodGet cachePolicy:policy apiUrl:API_JR(@"project") host:nil];

    if (nil != beforeRun) {
        beforeRun(request);
    }
    
    return [request start:NULL] ? request : nil;
}


@end
