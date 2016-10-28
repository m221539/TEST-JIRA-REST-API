//
//  JRCreateMeta.h
//  JIRA-REST
//
//  Created by ray on 16/10/26.
//  Copyright © 2016年 ray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRCreateMeta : NSObject

@property (nonatomic, strong) NSURL *self_url; // self=>
@property (nonatomic, copy) NSString *identifier; // id=>
@property (nonatomic, copy) NSString *des; // description=>
@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSURL *iconUrl;
@property (nonatomic, strong) NSDictionary<NSString *, NSURL *> *avatarUrls;


@end
