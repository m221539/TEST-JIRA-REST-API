//
//  JREntranceService.m
//  JIRA-REST
//
//  Created by ray on 16/10/28.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "JREntranceService.h"
#import "JRRequestCenter.h"
#import "TCHTTPRequest.h"

typedef NS_ENUM(NSUInteger, JRLoginReason) {
    kJRLoginReasonOK,
    kJRLoginReasonFailed,
    kJRLoginReasonDenied,
    
    JRLoginReasonCount
};

@interface JREntranceService ()

@property (nonatomic, assign) BOOL isLogining;

@end

@implementation JREntranceService

- (void)dealloc {
    [[JRRequestCenter defaultCenter] removeRequestObserver:self];
}

- (BOOL)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
                  captcha:(NSString *)captcha
              resultBlock:(void (^)(BOOL, UIImage *))resultBlock {
    if (self.isLogining) {
        return NO;
    }
    
    static NSDictionary *reasonMap = nil;
    if (nil == reasonMap) {
        reasonMap = @{@"OK": @(kJRLoginReasonOK),
                      @"AUTHENTICATED_FAILED": @(kJRLoginReasonFailed),
                      @"AUTHENTICATION_DENIED": @(kJRLoginReasonDenied)};
    }
        
    __weak typeof(self) wSelf = self;
    BOOL res = nil != [[JRRequestCenter defaultCenter] loginWitUserName:userName password:password captcha:captcha beforeRun:^(id<TCHTTPRequest> request) {
        request.observer = self;
        request.resultBlock = ^(id<TCHTTPRequest> request, BOOL success) {
            
            wSelf.isLogining = NO;
            NSDictionary *allHeaderFields = ((NSHTTPURLResponse *)(((TCHTTPRequest *)request).requestTask.response)).allHeaderFields;
            NSLog(@"%@", allHeaderFields);
            if (nil != allHeaderFields) {
                static NSString * const loginResonKey = @"X-Seraph-LoginReason";
                NSString *loginReason = allHeaderFields[loginResonKey];
                if (nil != loginReason && nil != reasonMap[loginReason]) {
                    JRLoginReason reason = [reasonMap[loginReason] integerValue];
                    switch (reason) {
                        case kJRLoginReasonOK: {
                            if (nil != resultBlock) {
                                resultBlock(YES, nil);
                            }
                            return;
                        }
                        case kJRLoginReasonFailed: {
                            if (nil != resultBlock) {
                                resultBlock(NO, nil);
                            }
                            return;
                        }
                        case kJRLoginReasonDenied: {
                            if (nil != resultBlock) {
                                [wSelf fetchCaptcha:^(UIImage *image) {
                                    resultBlock(NO, image);
                                }];
                            }
                            return;
                        }
                        default:
                            return;
                    }
                }
            }
            if (nil != resultBlock) {
                resultBlock(NO, nil);
            }
        };
    }];
    
    wSelf.isLogining = res;
    
    return res;
}

- (void)logout {
    NSArray<NSHTTPCookie *> *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    [cookies enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSHTTPCookie  *_Nonnull cookie, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([cookie.domain isEqualToString:@"jira.sudiyi.cn"] && ([cookie.name isEqualToString:@"atlassian.xsrf.token"] || [cookie.name isEqualToString:@"JSESSIONID"])) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }];
}

- (BOOL)fetchCaptcha:(void (^)(UIImage *image))resultBlock {
    
    
    BOOL res = nil != [[JRRequestCenter defaultCenter] fetchCaptchaBeforeRun:^(id<TCHTTPRequest> request) {
        request.observer = self;
        request.resultBlock = ^(id<TCHTTPRequest> request, BOOL success) {
            UIImage *image = nil;
            if (success) {
                NSURL *url = ((TCHTTPRequest *)request).responseObject;
                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            }
            if (nil != resultBlock) {
                resultBlock(image);
            }
        };
    }];
    
    return res;
}

@end
