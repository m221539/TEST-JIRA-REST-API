//
//  JREntranceService.m
//  JIRA-REST
//
//  Created by ray on 16/10/28.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "JREntranceService.h"
#import "JRRequestCenter.h"
#import "TCHTTPRequest.h"
#import "JRAccount.h"

typedef NS_ENUM(NSUInteger, JRLoginReason) {
    kJRLoginReasonOK,
    kJRLoginReasonFailed,
    kJRLoginReasonDenied,
    
    JRLoginReasonCount
};

@interface JREntranceService ()

@property (nonatomic, assign) BOOL isLogining;

@end

@implementation JREntranceService

- (void)dealloc {
    [[JRRequestCenter defaultCenter] removeRequestObserver:self];
}

- (BOOL)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
                  captcha:(NSString *)captcha
              resultBlock:(void (^)(BOOL, UIImage *))resultBlock {
    if (self.isLogining) {
        return NO;
    }
    
    static NSDictionary *reasonMap = nil;
    if (nil == reasonMap) {
        reasonMap = @{@"OK": @(kJRLoginReasonOK),
                      @"AUTHENTICATED_FAILED": @(kJRLoginReasonFailed),
                      @"AUTHENTICATION_DENIED": @(kJRLoginReasonDenied)};
    }
        
    __weak typeof(self) wSelf = self;
    BOOL res = nil != [[JRRequestCenter defaultCenter] loginWitUserName:userName password:password captcha:captcha beforeRun:^(id<TCHTTPRequest> request) {
        request.observer = self;
        request.resultBlock = ^(id<TCHTTPRequest> request, BOOL success) {
            
            wSelf.isLogining = NO;
            NSDictionary *allHeaderFields = ((NSHTTPURLResponse *)(((TCHTTPRequest *)request).requestTask.response)).allHeaderFields;
            NSLog(@"%@", allHeaderFields);
            
            do {
                if (nil == allHeaderFields) {
                    break;
                }
                
                static NSString * const loginResonKey = @"X-Seraph-LoginReason";
                NSString *loginReason = allHeaderFields[loginResonKey];
                
                if (nil == loginReason || nil == reasonMap[loginReason]) {
                    break;
                }
                
                if (nil == resultBlock) {
                    break;
                }
                
                JRLoginReason reason = [reasonMap[loginReason] integerValue];
                switch (reason) {
                    case kJRLoginReasonOK: {
                        [JRAccount.currentAccount refreshAccountWithName:userName];
                        resultBlock(YES, nil);
                        return;
                    }
                    case kJRLoginReasonFailed: {
                        resultBlock(NO, nil);
                        return;
                    }
                    case kJRLoginReasonDenied: {
                        [wSelf fetchCaptcha:^(UIImage *image) {
                            resultBlock(NO, image);
                        }];
                        return;
                    }
                    default:
                        break;
                }
            } while (false);
            

            if (nil != resultBlock) {
                resultBlock(NO, nil);
            }
        };
    }];
    
    wSelf.isLogining = res;
    
    return res;
}



- (BOOL)fetchCaptcha:(void (^)(UIImage *image))resultBlock {
    
    
    BOOL res = nil != [[JRRequestCenter defaultCenter] fetchCaptchaBeforeRun:^(id<TCHTTPRequest> request) {
        request.observer = self;
        request.resultBlock = ^(id<TCHTTPRequest> request, BOOL success) {
            UIImage *image = nil;
            if (success) {
                NSURL *url = ((TCHTTPRequest *)request).responseObject;
                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            }
            if (nil != resultBlock) {
                resultBlock(image);
            }
        };
    }];
    
    return res;
}

@end
