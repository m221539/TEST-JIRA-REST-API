//
//  JRFieldCreateMeta.h
//  JIRA-REST
//
//  Created by ray on 16/10/24.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "JRCreateMeta.h"

@interface JRFieldOptionValue : JRCreateMeta

@end


@interface JRFieldCreateMeta : JRCreateMeta

@property (nonatomic, assign) BOOL required;
@property (nonatomic, strong) NSDictionary *schema;
@property (nonatomic, assign) BOOL hasDefaultValue;
@property (nonatomic, strong) NSArray<NSString *> *operations; // "set","add","remove"
@property (nonatomic, strong) NSArray<JRFieldOptionValue *> *allowedValues;


@end
