//
//  TcpCircleMemberDeletePackage.h
//  ql
//
//  Created by yunlai on 14-5-13.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TcpSendPackage.h"

@interface TcpCircleMemberDeletePackage : TcpSendPackage

@property (nonatomic , retain) NSDictionary *inviteInfoDic;
@property (nonatomic , assign) int deleteUserId;

@end
