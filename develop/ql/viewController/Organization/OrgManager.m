//
//  OrgManager.m
//  ql
//
//  Created by LazySnail on 14-7-14.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "OrgManager.h"
#import "HttpRequest.h"
#import "org_member_list_model.h"

@interface OrgManager () <HttpRequestDelegate>
{
    
}

@end

@implementation OrgManager

- (void)inviteOrgMemberWithMemberID:(long long)memberID orgId:(long long)orgId
{
    NSMutableDictionary *inviteDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                                        [NSNumber numberWithLongLong:memberID],@"invitee_id",
                                        [Global sharedGlobal].org_id,@"org_id",
                                        nil];
	
    NSMutableDictionary* jsonParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      [Global sharedGlobal].user_id,@"user_id",
                                      [NSNumber numberWithLongLong:memberID],@"invitee_id",
                                      [NSNumber numberWithLongLong:orgId],@"org_id",
                                      nil];
    
	[[NetManager sharedManager]accessService:inviteDic data:nil command:INVITE_OTHER_COMMAND_ID accessAdress:@"inviteactivation.do?param=" delegate:self withParam:jsonParam];
}

- (void)didFinishCommand:(NSMutableArray *)resultArray cmd:(int)commandid withVersion:(int)ver
{
    ParseMethod method = ^(){
        
        switch (commandid) {
            case INVITE_OTHER_COMMAND_ID:
            {
                NSDictionary * resultDic = [resultArray firstObject];
                NSDictionary * param = [resultArray lastObject];
                
                int ret = [[resultDic objectForKey:@"ret"]intValue];
                
                if (ret == 1) {
                    NSDictionary * updateDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [param objectForKey:@"org_id"],@"org_id",
                                                [param objectForKey:@"invitee_id"],@"user_id",
                                                [NSNumber numberWithInt:1],@"invite_status",
                                                nil];
                    [org_member_list_model insertOrUpdateOrgMemberListWithDic:updateDic];
                    
                    if (_delegate && [_delegate respondsToSelector:@selector(inviteOrgMemberSuccess:)]) {
                        [_delegate inviteOrgMemberSuccess:self];
                    }
                    
                } else {
//                    [Common checkProgressHUDShowInAppKeyWindow:@"邀请失败" andImage:nil];
                    [Common checkProgressHUDShowInAppKeyWindow:@"邀请失败" andImage:KAccessFailedIMG];
                }
            }
                break;
                
            default:
                break;
        }
};
    
    [Common securelyparseHttpResultArr:resultArray andMethod:method];
}

@end
