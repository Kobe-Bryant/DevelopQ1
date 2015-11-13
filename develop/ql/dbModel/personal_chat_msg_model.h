//
//  personal_chat_msg_model.h
//  ql
//
//  Created by LazySnail on 14-5-7.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "db_model.h"

@interface personal_chat_msg_model : db_model

+ (BOOL)insertOrUpdateDictionaryIntoChatList:(NSDictionary *)dic;

+ (BOOL)deleteAllChatDataWithSenderID:(long long)senderID andReceiverID:(long long)receiverID;

@end
