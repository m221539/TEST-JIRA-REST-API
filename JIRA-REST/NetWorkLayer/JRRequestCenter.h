//
//  JRRequestCenter.h
//  JIRA-REST
//
//  Created by ray on 16/10/24.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "TCHTTPRequestCenter.h"

@interface JRRequestCenter : TCHTTPRequestCenter


#pragma mark - entrance

- (id<TCHTTPRequest>)loginWitUserName:(NSString *)name password:(NSString *)password
                              captcha:(NSString *)captche
                            beforeRun:(void (^)(id<TCHTTPRequest> request))beforeRun;

- (id<TCHTTPRequest>)fetchCaptchaBeforeRun:(void (^)(id<TCHTTPRequest> request))beforeRun;


#pragma mark - create&update issue

- (id<TCHTTPRequest>)fetchCreateMetaWithProjectId:(NSString *)projectId
                                          issueId:(NSString *)issuetypeId
                                     expandFields:(BOOL)expandFields
                                        beforeRun:(void(^)(id<TCHTTPRequest> request))beforeRun;

- (id<TCHTTPRequest>)createIssue:(NSDictionary *)data beforeRun:(void (^)(id<TCHTTPRequest> request))beforeRun;


#pragma mark - 

- (id<TCHTTPRequest>)fetchProjectListBeforeRun:(void (^)(id<TCHTTPRequest> request))beforeRun;

@end
