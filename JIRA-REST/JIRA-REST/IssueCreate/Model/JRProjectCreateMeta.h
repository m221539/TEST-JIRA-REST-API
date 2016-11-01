//
//  JRProjectCreateMeta.h
//  JIRA-REST
//
//  Created by ray on 16/10/26.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "JRIssueCreateMeta.h"

@interface JRProjectCreateMeta : JRCreateMeta

@property (nonatomic, strong) NSArray<JRIssueCreateMeta *> *issuetypes;

@end
