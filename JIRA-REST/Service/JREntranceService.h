//
//  JREntranceService.h
//  JIRA-REST
//
//  Created by ray on 16/10/28.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "TCHTTPRequestProcessor.h"

@interface JREntranceService : TCHTTPRequestProcessor

- (BOOL)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
                  captcha:(NSString *)captcha
              resultBlock:(void (^)(BOOL successed, UIImage *captcha))resultBlock;

@end
