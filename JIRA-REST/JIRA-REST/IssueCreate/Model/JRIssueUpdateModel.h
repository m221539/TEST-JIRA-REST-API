//
//  JRIssueUpdateModel.h
//  JIRA-REST
//
//  Created by ray on 16/10/26.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "JRFieldsUpdateModel.h"

@interface JRIssueUpdateModel : NSObject

@property (nonatomic, strong) JRFieldsUpdateModel *fields;

- (NSDictionary *)toUpdateData;

@end
