//
//  JRIssueService.h
//  JIRA-REST
//
//  Created by ray on 16/10/24.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "TCHTTPRequestProcessor.h"
#import "JRIssueUpdateModel.h"
#import "JRProjectCreateMeta.h"

@interface JRIssueService : TCHTTPRequestProcessor

- (BOOL)createIssue:(JRIssueUpdateModel *)issue resultBlock:(void (^)(BOOL successed, NSError *error))resultBlock;

- (BOOL)fetchIssuesCreateMetaOfProject:(NSString *)projectId issue:(NSString *)issueId expandFields:(BOOL)expandFields resultBlock:(void (^)(BOOL successed, NSError *error))resultBlock;

@property (nonatomic, strong) NSMutableDictionary<NSString *, JRProjectCreateMeta *> *projectCreateMetaDic;

@end
