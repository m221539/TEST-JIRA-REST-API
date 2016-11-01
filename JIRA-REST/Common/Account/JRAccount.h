//
//  JRAccount.h
//  JIRA-REST
//
//  Created by ray on 16/10/31.
//  Copyright © 2016年 ray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRAccount : NSObject

+ (instancetype)currentAccount;

- (BOOL)refreshAccountWithName:(NSString *)name; // call when loged in
- (BOOL)isValid;
- (void)signout;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *token;

@end
