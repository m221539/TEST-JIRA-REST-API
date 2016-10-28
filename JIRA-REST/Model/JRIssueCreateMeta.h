//
//  JRIssueCreateMeta.h
//  JIRA-REST
//
//  Created by ray on 16/10/24.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "JRCreateMeta.h"
#import "JRFieldCreateMeta.h"

@interface JRIssueCreateMeta : JRCreateMeta

@property (nonatomic, assign) BOOL subtask;
@property (nonatomic, strong) NSDictionary<NSString *, JRFieldCreateMeta *> *fields;

@end
