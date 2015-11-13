//
//  OrgManager.h
//  ql
//
//  Created by LazySnail on 14-7-14.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrgManager;

@protocol OrgManagerDelegate <NSObject>

@optional
- (void)inviteOrgMemberSuccess:(OrgManager *)sender;

@end

@interface OrgManager : NSObject

@property(nonatomic,assign) id<OrgManagerDelegate> delegate;

//邀请组织成员
- (void)inviteOrgMemberWithMemberID:(long long)memberID orgId:(long long) orgId;

@end
