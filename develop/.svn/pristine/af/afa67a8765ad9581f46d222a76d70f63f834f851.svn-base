//
//  personal_chat_msg_model.m
//  ql
//
//  Created by LazySnail on 14-5-7.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "personal_chat_msg_model.h"

@implementation personal_chat_msg_model

+ (BOOL)insertOrUpdateDictionaryIntoChatList:(NSDictionary *)dic
{
    NSNumber * msgID = [dic objectForKey:@"id"];
    
    personal_chat_msg_model * pListGeter = [personal_chat_msg_model new];
    pListGeter.where = [NSString stringWithFormat:@"id = %lld",msgID.longLongValue];
    // 注意这个pListGeter实例在会在 下面这个方发里面释放掉

    return [db_model updateDataWithModel:pListGeter withDic:dic];
}

+ (BOOL)deleteAllChatDataWithSenderID:(long long)senderID andReceiverID:(long long)receiverID
{
    BOOL successJuger = NO;
    personal_chat_msg_model * pChatGeter =[[personal_chat_msg_model alloc]init];
    NSString * whereStr =[NSString stringWithFormat:@"(sender_id = %lld and receiver_id = %lld) or (sender_id = %lld and receiver_id = %lld)",senderID,receiverID,receiverID,senderID];
    pChatGeter.where = whereStr;
    successJuger = [pChatGeter deleteDBdata];
    
    RELEASE_SAFE(pChatGeter);
    return successJuger;
}

@end
