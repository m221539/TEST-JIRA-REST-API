//
//  JRIssueService.h
//  JIRA-REST
//
//  Created by ray on 16/10/24.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "TCHTTPRequestProcessor.h"
#import "JRIssueUpdateModel.h"

@interface JRIssueService : TCHTTPRequestProcessor

- (BOOL)updateIssue:(JRIssueUpdateModel *)issue resultBlock:(void (^)(BOOL successed, NSError *error))resultBlock;

@end
