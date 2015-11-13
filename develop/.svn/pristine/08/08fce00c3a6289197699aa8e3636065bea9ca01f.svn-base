//
//  temporary_circle_chat_msg_model.m
//  ql
//
//  Created by LazySnail on 14-5-22.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "temporary_circle_chat_msg_model.h"

@implementation temporary_circle_chat_msg_model

+ (BOOL)insertOrUpdateDictionaryIntoTempCircleChatList:(NSDictionary *)dic
{
    NSNumber * msgID = [dic objectForKey:@"id"];
    
    temporary_circle_chat_msg_model * listGeter = [temporary_circle_chat_msg_model new];
    listGeter.where = [NSString stringWithFormat:@"id = %lld",msgID.longLongValue];
    
    return [db_model updateDataWithModel:listGeter withDic:dic];
}

+ (BOOL)deleteAllChatDataWithSenderID:(long long)senderID andReceiverID:(long long)receiverID
{
    temporary_circle_chat_msg_model * tlistGeter =[temporary_circle_chat_msg_model new];
    tlistGeter.where = [NSString stringWithFormat:@"(sender_id = %lld and receiver_id = %lld) or (sender_id = %lld and receiver_id = %lld)",senderID,receiverID,receiverID,senderID];
    
    return [db_model deleteAllDataWithModel:tlistGeter];
}

@end
