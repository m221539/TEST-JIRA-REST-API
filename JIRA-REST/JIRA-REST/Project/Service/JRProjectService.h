//
//  JRProjectService.h
//  JIRA-REST
//
//  Created by ray on 16/10/31.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "TCHTTPRequestProcessor.h"
#import "JRProjectCreateMeta.h"

@interface JRProjectService : TCHTTPRequestProcessor

- (BOOL)fetchProjectList:(void (^)(BOOL successed, NSError *error))resultBlock;

@property (nonatomic, strong) NSArray<JRProjectCreateMeta *> *projects;

@end
