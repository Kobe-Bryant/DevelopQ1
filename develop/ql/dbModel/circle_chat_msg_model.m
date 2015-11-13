//
//  circle_chat_msg_model.m
//  ql
//
//  Created by LazySnail on 14-5-17.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "circle_chat_msg_model.h"

@implementation circle_chat_msg_model

+ (BOOL)insertOrUpdateDictionaryIntoCircleChatList:(NSDictionary *)dic
{
    NSNumber * msgID = [dic objectForKey:@"id"];
    
    circle_chat_msg_model * listGeter = [circle_chat_msg_model new];
    listGeter.where = [NSString stringWithFormat:@"id = %lld",msgID.longLongValue];
    return [db_model updateDataWithModel:listGeter withDic:dic];
}

+ (BOOL)deleteAllChatDataWithSenderID:(long long)senderID andReceiverID:(long long)receiverID
{
    circle_chat_msg_model * clistGeter = [circle_chat_msg_model new];
    clistGeter.where = [NSString stringWithFormat:@"(sender_id = %lld and receiver_id = %lld) or (sender_id = %lld and receiver_id = %lld)",senderID,receiverID,receiverID,senderID];
    return [db_model deleteAllDataWithModel:clistGeter];
}

@end
