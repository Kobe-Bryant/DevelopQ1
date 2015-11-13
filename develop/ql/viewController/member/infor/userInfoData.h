//
//  userInfoData.h
//  ql
//
//  Created by yunlai on 14-5-14.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userInfoData : NSObject

@property (nonatomic , assign) int userId;
@property (nonatomic , assign) int careSum;
@property (nonatomic , assign) int visitorSum;
@property (nonatomic , retain) NSString *company_name;
@property (nonatomic , retain) NSString *company_role;
@property (nonatomic , retain) NSString *email;
@property (nonatomic , retain) NSString *interests;
@property (nonatomic , retain) NSString *mobile;
@property (nonatomic , retain) NSString *nickname;
@property (nonatomic , retain) NSString *portrait;
@property (nonatomic , retain) NSString *realname;
@property (nonatomic , retain) NSString *role;
@property (nonatomic , retain) NSString *signature;

- (instancetype)initAssignmentUserInfo:(NSArray *)userArr;
- (instancetype)init;

@end
