//
//  JRFieldsUpdateModel.h
//  JIRA-REST
//
//  Created by ray on 16/10/26.
//  Copyright © 2016年 ray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRFieldsUpdateModel : NSObject

@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *issueTypeId;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *priorityId;
@property (nonatomic, copy) NSString *assigneeName;
@property (nonatomic, strong) NSArray<NSString/* component_id */ *> *components;
@property (nonatomic, strong) NSArray<NSString/* version_id */ *> *versions;
@property (nonatomic, strong) NSDictionary<NSString/* custom_field_id */ *, id/* string, array, dic */> *customFields;


@end
