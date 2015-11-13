//
//  chatmsg_list_model.h
//  ql
//
//  Created by LazySnail on 14-5-7.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "db_model.h"

@interface chatmsg_list_model : db_model

// 根据所给字典插入一条list数据
+ (BOOL)insertOrUpdateRecordWithDic:(NSDictionary *)dic;

// 根据talk_type和id来删除一条list记录
+ (BOOL)deleteChatMsgListWithTalkType:(int)talkType andID:(long long) theID;

// 获取自定列表消息
+ (NSDictionary *)getListDicWithTalkType:(int)talkTyoe andID:(long long )theID;

//获取未读消息数目
+(int) getUnreadNumber;

@end
