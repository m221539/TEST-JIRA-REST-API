//
//  JRIssueCreateMeta.m
//  JIRA-REST
//
//  Created by ray on 16/10/24.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "JRIssueCreateMeta.h"

@implementation JRIssueCreateMeta


- (NSArray *)sortedFieldsKey {

    static NSArray *systemFieldsOrder = nil;
    if (nil == systemFieldsOrder) {
        systemFieldsOrder = @[@"project", @"issuetype", @"summary", @"priority", @"components", @"versions", @"environment"];
    }
    
    NSMutableArray<NSString *> *fieldsAllKey = [self.fields.allKeys mutableCopy];
    [fieldsAllKey sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(NSString *  _Nonnull key1, NSString *  _Nonnull key2) {
        
        static NSString * const kCustomFieldKeyPrefix = @"customfield";
        
        if ([key1 hasPrefix:kCustomFieldKeyPrefix]) {
            if ([key2 hasPrefix:kCustomFieldKeyPrefix]) {
                return [key1 compare:key2];
            } else {
                return NSOrderedDescending;
            }
        }
        if ([key2 hasPrefix:kCustomFieldKeyPrefix]) {
            if ([key1 hasPrefix:kCustomFieldKeyPrefix]) {
                return [key1 compare:key2];
            } else {
                return NSOrderedAscending;
            }
        }
        if ([systemFieldsOrder containsObject:key1]) {
            if ([systemFieldsOrder containsObject:key2]) {
                return [systemFieldsOrder indexOfObject:key1] < [systemFieldsOrder indexOfObject:key2];
            } else {
                return NSOrderedAscending;
            }
        }
        if ([systemFieldsOrder containsObject:key2]) {
            if ([systemFieldsOrder containsObject:key1]) {
                return [systemFieldsOrder indexOfObject:key1] < [systemFieldsOrder indexOfObject:key2];
            } else {
                return NSOrderedDescending;
            }
        }
        
        return [key1 compare:key2];
    }];
    
    return fieldsAllKey;
}


@end
