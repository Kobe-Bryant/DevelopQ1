//
//  userInfoClass.m
//  ql
//
//  Created by yunlai on 14-4-11.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "userInfoClass.h"

@implementation userInfoClass

@synthesize userName;
@synthesize userOrgId;

- (instancetype)init
{
    self = [super init];
    if (self) {
        userName = [[NSString alloc]init];
        userOrgId = [[NSString alloc]init];
    }
    return self;
}

- (void)dealloc
{
    self.userName = nil;
    self.userOrgId = nil;
    [super dealloc];
}
@end
