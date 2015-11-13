//
//  userInfoData.m
//  ql
//
//  Created by yunlai on 14-5-14.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "userInfoData.h"

@implementation userInfoData

- (instancetype)init {
    self = [super init];
    if (self != nil) {
 
    }
    return self;
}

- (instancetype)initAssignmentUserInfo:(NSArray *)userArr{
    self = [self init];
    if (self != nil) {
        
        _careSum = [[[userArr lastObject] objectForKey:@"care_sum"] intValue];
        _userId = [[[userArr lastObject] objectForKey:@"id"] intValue];
        _company_name = [[userArr lastObject] objectForKey:@"company_name"];
        _company_role = [[userArr lastObject] objectForKey:@"company_role"];
        _email = [[userArr lastObject] objectForKey:@"email"];
        _interests  = [[userArr lastObject] objectForKey:@"interests"];
        _mobile = [[userArr lastObject] objectForKey:@"mobile"];
        _nickname = [[userArr lastObject] objectForKey:@"nickname"];
        _portrait = [[userArr lastObject] objectForKey:@"portrait"];
        _realname = [[userArr lastObject] objectForKey:@"realname"];
        _role = [[userArr lastObject] objectForKey:@"role"];
        _signature = [[userArr lastObject] objectForKey:@"signature"];
        _visitorSum = [[[userArr lastObject] objectForKey:@"visitor_sum"] intValue];
        
    }
    return self;
}
@end
