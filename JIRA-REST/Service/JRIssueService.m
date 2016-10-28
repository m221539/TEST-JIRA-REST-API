//
//  JRIssueService.m
//  JIRA-REST
//
//  Created by ray on 16/10/24.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "JRIssueService.h"
#import "JRRequestCenter.h"

@implementation JRIssueService

- (void)dealloc {
    [[JRRequestCenter defaultCenter] removeRequestObserver:self];
}

- (BOOL)updateIssue:(JRIssueUpdateModel *)issue resultBlock:(void (^)(BOOL successed, NSError *error))resultBlock {
    if (nil == issue.fields) {
        return nil;
    }
    
    BOOL res = nil != [[JRRequestCenter defaultCenter] updateIssue:issue.toUpdateData beforeRun:^(id<TCHTTPRequest> request) {
        request.observer = self;
        
        request.resultBlock = ^(id<TCHTTPRequest> request, BOOL success) {
            NSLog(@"%@",request);
        };
    }];
    
    return res;
}

@end
