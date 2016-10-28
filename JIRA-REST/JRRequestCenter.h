//
//  JRRequestCenter.h
//  JIRA-REST
//
//  Created by ray on 16/10/24.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "TCHTTPRequestCenter.h"

@interface JRRequestCenter : TCHTTPRequestCenter


#pragma mark - login

- (id<TCHTTPRequest>)loginWitUserName:(NSString *)name password:(NSString *)password
                              captcha:(NSString *)captche
                            beforeRun:(void (^)(id<TCHTTPRequest> request))beforeRun;

- (id<TCHTTPRequest>)fetchCaptchaBeforeRun:(void (^)(id<TCHTTPRequest> request))beforeRun;


- (id<TCHTTPRequest>)fetchIssueCreateMetaWithProjectId:(NSString *)projectId
                                           issuetypeId:(NSString *)issuetypeId
                                             beforeRun:(void(^)(id<TCHTTPRequest> request))beforeRun;

- (id<TCHTTPRequest>)updateIssue:(NSDictionary *)data beforeRun:(void (^)(id<TCHTTPRequest> request))beforeRun;


@end
