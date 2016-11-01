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

- (BOOL)createIssue:(JRIssueUpdateModel *)issue resultBlock:(void (^)(BOOL successed, NSError *error))resultBlock {
    if (nil == issue.fields) {
        return nil;
    }
    
    BOOL res = nil != [[JRRequestCenter defaultCenter] createIssue:issue.toUpdateData beforeRun:^(id<TCHTTPRequest> request) {
        request.observer = self;
        
        request.resultBlock = ^(id<TCHTTPRequest> request, BOOL success) {
            NSLog(@"%@",request);
        };
    }];
    
    return res;
}

- (BOOL)fetchIssuesCreateMetaOfProject:(NSString *)projectId issue:(NSString *)issueId expandFields:(BOOL)expandFields resultBlock:(void (^)(BOOL successed, NSError *error))resultBlock {
    
    if (nil == projectId || ![projectId isKindOfClass:NSString.class] || projectId.length < 1) {
        return NO;
    }
    
    __weak typeof(self) wSelf = self;
    BOOL res = nil != [[JRRequestCenter defaultCenter] fetchCreateMetaWithProjectId:projectId issueId:issueId expandFields:expandFields beforeRun:^(id<TCHTTPRequest> request) {
        request.observer = self;
        request.resultBlock = ^(id<TCHTTPRequest> request, BOOL success) {
            NSLog(@"%@",request);
            
            do {
                if (!success) {
                    break;
                }
                NSDictionary *responseData = request.responseValidator.data;
                if (![responseData isKindOfClass:NSDictionary.class]) {
                    break;
                }
                NSArray *projects = responseData[@"projects"];
                if (nil == projects || ![projects isKindOfClass:NSArray.class] || [projects count] < 1) {
                    break;
                }
                JRProjectCreateMeta *projectData = [JRProjectCreateMeta tc_mappingWithDictionary:projects.firstObject];
                if (nil == projectData) {
                    break;
                }
                if (nil == wSelf.projectCreateMetaDic) {
                    wSelf.projectCreateMetaDic = [NSMutableDictionary dictionary];
                }
                wSelf.projectCreateMetaDic[projectId] = projectData;
    
            } while (false);
            
            if (nil != resultBlock) {
                resultBlock(success, request.responseValidator.error);
            }
        };

    }];
    
    return res;
}


@end
