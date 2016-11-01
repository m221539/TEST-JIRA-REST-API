//
//  JRAccount.m
//  JIRA-REST
//
//  Created by ray on 16/10/31.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "JRAccount.h"

static NSString * const kJRDomain = @"jira.sudiyi.cn";
static NSString * const kJRTokenKey = @"atlassian.xsrf.token";
static NSString * const kSessionIdKey = @"JSESSIONID";


@implementation JRAccount

+ (instancetype)currentAccount {
    static JRAccount *account = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        account = [[self alloc] init];
    });
    return account;
}

- (void)getInfoFromCookie:(void (^)(NSString *sessionId, NSString *token))resultBlock {
    __block NSString *cookieSessionId = nil;
    __block NSString *cookieToken = nil;
    NSArray<NSHTTPCookie *> *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    [cookies enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSHTTPCookie  *_Nonnull cookie, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([cookie.domain isEqualToString:kJRDomain]) {
            if ([cookie.name isEqualToString:kJRTokenKey]) {
                cookieToken = cookie.value;
            } else if ([cookie.name isEqualToString:kSessionIdKey]) {
                cookieSessionId = cookie.value;
            }
        }
    }];
    resultBlock(cookieSessionId, cookieToken);
}

- (BOOL)isValid {
    
    __block NSString *cookieSessionId = nil;
    __block NSString *cookieToken = nil;
    [self getInfoFromCookie:^(NSString *sessionId, NSString *token) {
        cookieSessionId = sessionId;
        cookieToken = token;
    }];
    
    if (nil == cookieSessionId || nil == cookieToken) {
        return NO;
    }
    
    return nil != self.name && self.name.length > 0 && nil != self.sessionId && self.sessionId.length > 0 && nil != self.token && self.token.length > 0 && [self.sessionId isEqualToString:cookieSessionId] && [self.token isEqualToString:cookieToken];
}

- (BOOL)refreshAccountWithName:(NSString *)name {
    [self getInfoFromCookie:^(NSString *sessionId, NSString *token) {
        self.name = name;
        self.token = token;
        self.sessionId = sessionId;
    }];
    return nil != self.name && self.name.length > 0 && nil != self.sessionId && self.sessionId.length > 0 && nil != self.token && self.token.length > 0;
}

- (void)signout {
    NSArray<NSHTTPCookie *> *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    [cookies enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSHTTPCookie  *_Nonnull cookie, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([cookie.domain isEqualToString:kJRDomain] && ([cookie.name isEqualToString:kJRTokenKey] || [cookie.name isEqualToString:kSessionIdKey])) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }];
}

@end
