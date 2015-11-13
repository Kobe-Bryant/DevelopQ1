//
//  chatmsg_list_model.m
//  ql
//
//  Created by LazySnail on 14-5-7.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "chatmsg_list_model.h"
#import "SBJson.h"

@implementation chatmsg_list_model

+ (BOOL)insertOrUpdateRecordWithDic:(NSDictionary *)dic{
    
    // 将头像数组转换为Json数据进行插入
    NSMutableDictionary * insertMutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString * insertStr = nil;
    if ([[dic objectForKey:@"icon_path"]isKindOfClass:[NSArray class]]) {
        NSArray * iconArr = [dic objectForKey:@"icon_path"];
        insertStr = [iconArr JSONRepresentation];
        [insertMutDic removeObjectForKey:@"icon_path"];
        [insertMutDic setObject:insertStr forKey:@"icon_path"];
    }
    
    chatmsg_list_model * clistGeter = [chatmsg_list_model new];
    clistGeter.where = [NSString stringWithFormat:@"id = %lld and talk_type = %d",[[dic objectForKey:@"id"]longLongValue],[[dic objectForKey:@"talk_type"]intValue]];
    NSArray * clist = [clistGeter getList];
    int oprationNum = 0;
    BOOL isSuccess;
    if (clist.count > 0) {
       isSuccess = [clistGeter updateDB:insertMutDic];
    } else {
       oprationNum = [clistGeter insertDB:insertMutDic];
       isSuccess = oprationNum == 0 ? NO : YES;
    }
    
    RELEASE_SAFE(clistGeter);
    
    return isSuccess;
}

+ (BOOL)deleteChatMsgListWithTalkType:(int)talkType andID:(long long) theID
{
    BOOL successJudger = NO;
    chatmsg_list_model * clistGeter = [chatmsg_list_model new];
    clistGeter.where = [NSString stringWithFormat:@"id = %lld and talk_type = %d",theID,talkType];
    NSArray * clist = [clistGeter getList];
    if (clist.count == 0) {
        successJudger = YES;
        RELEASE_SAFE(clistGeter);
        return successJudger;
    } else {
        successJudger = [clistGeter deleteDBdata];
        RELEASE_SAFE(clistGeter);
        
        return successJudger;
    }
}

+ (NSDictionary *)getListDicWithTalkType:(int)talkType andID:(long long )theID
{
    chatmsg_list_model * geter = [chatmsg_list_model new];
    geter.where = [NSString stringWithFormat:@"talk_type = %d and id = %lld",talkType,theID];
    
    NSArray * theArr = [geter getList];
    return [theArr firstObject];
    
}

+(int) getUnreadNumber{
    chatmsg_list_model* chatMsgMod = [[chatmsg_list_model alloc] init];
    chatMsgMod.where = [NSString stringWithFormat:@"unreaded != 0"];
    NSArray* arr = [chatMsgMod getList];
    
    int totalNum = 0;
    for (NSDictionary* dic in arr) {
        totalNum += [[dic objectForKey:@"unreaded"] intValue];
    }
    
    RELEASE_SAFE(chatMsgMod);
    return totalNum;
}

@end
