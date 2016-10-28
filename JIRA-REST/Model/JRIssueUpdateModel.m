//
//  JRIssueUpdateModel.m
//  JIRA-REST
//
//  Created by ray on 16/10/26.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "JRIssueUpdateModel.h"
#import "NSObject+TCCoding.h"

@implementation JRIssueUpdateModel

- (NSDictionary *)toUpdateData {
    if (nil == self.fields) {
        return nil;
    }
    
    NSMutableDictionary *filedsDic = [NSMutableDictionary dictionary];
    if (nil != self.fields.projectId && [self.fields.projectId isKindOfClass:NSString.class]) {
        filedsDic[@"project"] = @{@"id": self.fields.projectId};
    }
    if (nil != self.fields.issueTypeId && [self.fields.issueTypeId isKindOfClass:NSString.class]) {
        filedsDic[@"issuetype"] = @{@"id": self.fields.issueTypeId};
    }
    if (nil != self.fields.priorityId && [self.fields.priorityId isKindOfClass:NSString.class]) {
        filedsDic[@"priority"] = @{@"id": self.fields.priorityId};
    }
    if (nil != self.fields.summary && [self.fields.summary isKindOfClass:NSString.class]) {
        filedsDic[@"summary"] = self.fields.summary;
    }
    if (nil != self.fields.assigneeName && [self.fields.assigneeName isKindOfClass:NSString.class]) {
        filedsDic[@"assignee"] = @{@"name": self.fields.assigneeName};
    }
    if (nil != self.fields.components && self.fields.components.count > 0) {
        NSMutableArray *components = [NSMutableArray arrayWithCapacity:self.fields.components.count];
        for (NSString *componentId in self.fields.components) {
            if ([componentId isKindOfClass:NSString.class]) {
                [components addObject:@{@"id": componentId}];
            }
        }
        filedsDic[@"components"] = components;
    }
    if (nil != self.fields.versions && self.fields.versions.count > 0) {
        NSMutableArray *versions = [NSMutableArray arrayWithCapacity:self.fields.versions.count];
        for (NSString *versionId in self.fields.versions) {
            if ([versionId isKindOfClass:NSString.class]) {
                [versions addObject:@{@"id": versionId}];
            }
        }
        filedsDic[@"versions"] = versions;
    }
    if (nil != self.fields.customFields && self.fields.customFields.count > 0) {
        [self.fields.customFields enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            filedsDic[[@"customfield_" stringByAppendingString:key]] = obj;
        }];
    }
    if (filedsDic.count > 0) {
        return @{PropertySTR(fields): filedsDic};
    }
    return nil;
}

@end
