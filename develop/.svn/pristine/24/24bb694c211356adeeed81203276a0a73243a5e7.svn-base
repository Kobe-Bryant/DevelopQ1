//
//  MessageDataManager.m
//  ql
//
//  Created by LazySnail on 14-5-6.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "MessageDataManager.h"
#import "personal_chat_msg_model.h"
#import "chatmsg_list_model.h"
#import "circle_contacts_model.h"
#import "SBJson.h"
#import "TextData.h"
#import "circle_chat_msg_model.h"
#import "circle_member_list_model.h"
#import "temporary_circle_chat_msg_model.h"
#import "temporary_circle_member_list_model.h"

//消息时间展示的间隔。
#define MessageShowTimeInterval 60 * 5

@implementation MessageDataManager

static id _messageDataManager;

+ (MessageDataManager *)shareMessageDataManager
{
    if (_messageDataManager == nil) {
        _messageDataManager = [MessageDataManager new];
    }
    return _messageDataManager;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
         _dataQueue = [[NSMutableArray alloc]init];
        _waitToResendQueue = [[NSMutableArray alloc]init];
    }
    return self;
}

- (BOOL)updateData:(MessageData *)msgData
{
    [msgData.msg removeAllObjects];
    [msgData addMessageDataToMsg:msgData.msgData];

    NSString *msgStr = [msgData.msg JSONRepresentation];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithLongLong:msgData.locmsgid],@"id",nil];
    
    if (msgStr != nil) {
        [dataDic setObject:[self getNoSqlExceptionStringFromStr:msgStr] forKey:@"msg"];
    }
    
    BOOL successJuger = NO;
    if (msgData.sendCommandType == CMD_PERSONAL_MSGSEND || msgData.sendCommandType == CMD_PERSONAL_MSGRECV) {
       successJuger = [personal_chat_msg_model insertOrUpdateDictionaryIntoChatList:dataDic];
    } else if (msgData.sendCommandType == CMD_CIRCLE_MSG_SEND || msgData.sendCommandType == CMD_CIRCLE_MSG_RECEIVE) {
        //为了防止记录的用户ID 和圈子id 相等将圈子聊天中的用户ID制置0
       successJuger = [circle_chat_msg_model insertOrUpdateDictionaryIntoCircleChatList:dataDic];
    } else if (msgData.sendCommandType == CMD_TEMP_CIRCLE_MSGSEND || msgData.sendCommandType == CMD_TEMP_CIRCLE_MSGRECV) {
       successJuger = [temporary_circle_chat_msg_model insertOrUpdateDictionaryIntoTempCircleChatList:dataDic];
    }
    return successJuger;
}

- (void)restoreData:(MessageData *)msgData
{
    [self judgeAndAppendShowTimeSignInsertDataWithMessage:msgData];
    
    NSNumber * insertID;
    NSNumber * unreadNum;
    NSDictionary *chatDic = nil;
    long long userID = [[Global sharedGlobal]user_id].longLongValue;
    if (msgData.senderID == userID) {
        insertID = [NSNumber numberWithLongLong:msgData.receiverID];
        unreadNum = [NSNumber numberWithInt:0];
        // 当圈子ID 和使用者ID 相同时加以区分
        if (msgData.sendCommandType == CMD_CIRCLE_MSG_RECEIVE && msgData.talkType == MessageListTypeCircle) {
            unreadNum = [NSNumber numberWithInt:1];
        }
        
        if (msgData.sendCommandType == CMD_TEMP_CIRCLE_MSGRECV && msgData.talkType == MessageListTypeTempCircle) {
            unreadNum = [NSNumber numberWithInt:1];
        }
        
    } else {
        insertID = [NSNumber numberWithLongLong:msgData.senderID];
        unreadNum = [NSNumber numberWithInt:1];
    }
    
    chatmsg_list_model * chatListGeter = [[chatmsg_list_model alloc]init];
    chatListGeter.where = [NSString stringWithFormat:@"id = %lld",insertID.longLongValue];
    NSArray * chatlist = [chatListGeter getList];
    chatDic = [chatlist firstObject];
    
    int originInt = [[chatDic objectForKey:@"unreaded"]intValue];
    originInt += unreadNum.intValue;
    NSNumber *insertNum = [NSNumber numberWithInt:originInt];
    
    NSDictionary * textDic = [msgData.msg firstObject];
    NSArray *textArr = [NSArray arrayWithObjects:textDic, nil];
    NSString * textJsonStr = [textArr JSONRepresentation];
    
    
    NSMutableDictionary *chatUpdate = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       insertID,@"id",
                                       [NSNumber numberWithInt:msgData.talkType],@"talk_type",
                                       [NSNumber numberWithInt:msgData.sendtime],@"send_time",
                                       insertNum,@"unreaded",
                                       [msgData.speakerinfo  objectForKey:@"nickname"],@"speak_name",
                                       [msgData.speakerinfo objectForKey:@"uid"],@"speak_id",
                                       nil];
    
    if (textJsonStr != nil && ![textJsonStr isEqualToString:@""]) {
        [chatUpdate setObject:[self getNoSqlExceptionStringFromStr:textJsonStr] forKey:@"content"];
    }
    
    if (msgData.title != nil && ![msgData.title isEqualToString:@""]) {
        [chatUpdate setObject:[self getNoSqlExceptionStringFromStr:msgData.title] forKey:@"title"];
    }
    
    //判断头像icon 是否已经插入到聊天列表 如果没有则做更新
    if (chatDic != nil) {
        NSString * iconPath = [chatDic objectForKey:@"icon_path"];
        if (iconPath == nil || [iconPath isEqualToString:@""]) {
            iconPath = [self searchIconPathWithID:insertID andMsgdata:msgData];
            if (iconPath != nil) {
                [chatUpdate setObject:iconPath forKey:@"icon_path"];
            }
        }
        [chatListGeter updateDB:chatUpdate];
    } else {
        NSString *iconPath = [self searchIconPathWithID:insertID andMsgdata:msgData];
        if (iconPath != nil) {
            [chatUpdate setObject:iconPath forKey:@"icon_path"];
        }
        chatListGeter.where = nil;
        [chatListGeter insertDB:chatUpdate];
    }
}

- (NSMutableString *)getNoSqlExceptionStringFromStr:(NSString *)str
{
    NSMutableString *noExceptionStr = [NSMutableString stringWithString:str];
    [noExceptionStr replaceOccurrencesOfString:@"'" withString:@"‘" options:NSLiteralSearch range:NSMakeRange(0, str.length)];
    return noExceptionStr;
}

- (void)judgeAndAppendShowTimeSignInsertDataWithMessage:(MessageData *)msgData
{
    NSString *msgStr = [msgData.msg JSONRepresentation];
    
    NSString *speakerStr = [msgData.speakerinfo JSONRepresentation];
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithLongLong:msgData.senderID],@"sender_id",
                                    [NSNumber numberWithLongLong:msgData.receiverID],@"receiver_id",
                                    [NSNumber numberWithInt:(int)msgData.msgtype],@"msgtype",
                                    [NSNumber numberWithLongLong:msgData.msgid],@"msgid",
                                    [NSNumber numberWithInt:msgData.sendtime],@"sendtime" ,nil];
    if (msgStr != nil) {
        [dataDic setObject:[self getNoSqlExceptionStringFromStr:msgStr] forKey:@"msg"];
    } if (speakerStr != nil) {
        [dataDic setObject:[self getNoSqlExceptionStringFromStr:speakerStr] forKey:@"speakerinfo"];
    }
    
    db_model * dataMng  = nil;
    
    if (msgData.sendCommandType == CMD_PERSONAL_MSGSEND || msgData.sendCommandType == CMD_PERSONAL_MSGRECV) {
        dataMng = [[personal_chat_msg_model alloc]init];
   
    } else if (msgData.sendCommandType == CMD_CIRCLE_MSG_SEND ) {
        //为了防止记录的用户ID 和圈子id 相等将圈子聊天中的用户ID制置0
        //        [dataDic setObject:[NSNumber numberWithLongLong:0] forKey:@"sender_id"];
        dataMng = [[circle_chat_msg_model alloc]init];
    } else if (msgData.sendCommandType == CMD_CIRCLE_MSG_RECEIVE) {
        dataMng = [[circle_chat_msg_model alloc]init];
    } else if (msgData.sendCommandType == CMD_TEMP_CIRCLE_MSGSEND) {
        //        [dataDic setObject:[NSNumber numberWithLongLong:0] forKey:@"sender_id"];
        dataMng = [temporary_circle_chat_msg_model new];
    } else if (msgData.sendCommandType == CMD_TEMP_CIRCLE_MSGRECV){
        dataMng = [temporary_circle_chat_msg_model new];
    }
    
    //判断该消息与之对应的会话中最新的一条消息和现在这个
    dataMng.where = [NSString stringWithFormat:@"(sender_id = %lld and receiver_id = %lld) or (sender_id = %lld and receiver_id = %lld) order by sendtime desc",msgData.senderID,msgData.receiverID,msgData.receiverID,msgData.senderID];
    NSMutableArray * oldMessageArr =[dataMng getList];
    if (oldMessageArr.count > 0) {
        NSDictionary * latest = [oldMessageArr firstObject];
        NSTimeInterval latestMsgTime = [[latest objectForKey:@"sendtime"]doubleValue];
        NSDate * currentDate = [[NSDate alloc]init];
        NSTimeInterval now = [currentDate timeIntervalSince1970];
        NSTimeInterval distant = now - latestMsgTime;
        RELEASE_SAFE(currentDate);
        
        if (distant > MessageShowTimeInterval) {
            [dataDic setObject:[NSNumber numberWithBool:YES] forKey:@"show_time"];
            msgData.showTimeSign = YES;
        }
    } else {
        [dataDic setObject:[NSNumber numberWithBool:YES] forKey:@"show_time"];
        msgData.showTimeSign = YES;
    }
    
    [dataMng insertDB:dataDic];
    dataMng.where = [NSString stringWithFormat:@"msg = '%@' and sendtime = %d",[self getNoSqlExceptionStringFromStr:msgStr],msgData.sendtime];
    NSDictionary * value = [[dataMng getList]lastObject];
    //存储过程中生成本地消息id 用于在得到发送回馈后判断哪些消息发送成功
    msgData.locmsgid = [[value objectForKey:@"id"]longLongValue];
    RELEASE_SAFE(dataMng);
}

- (NSString *)searchIconPathWithID:(NSNumber *)num  andMsgdata:(MessageData *)msgData
{
    // 单聊消息时获取联系人头像 Json数据数据
    if (msgData.sendCommandType == CMD_PERSONAL_MSGSEND || msgData.sendCommandType == CMD_PERSONAL_MSGRECV) {
        circle_contacts_model *clistGeter = [[circle_contacts_model alloc]init];
        clistGeter.where = [NSString stringWithFormat:@"user_id = %d",num.intValue];
        NSArray * clist = [clistGeter getList];
        NSDictionary * cDic = [clist firstObject];
        NSMutableArray *porArr = [NSMutableArray arrayWithObjects:[cDic objectForKey:@"portrait"], nil];
        NSString * porArrStr = [porArr JSONRepresentation];
        return porArrStr;
        
    } else if (msgData.sendCommandType == CMD_CIRCLE_MSG_SEND || msgData.sendCommandType == CMD_CIRCLE_MSG_RECEIVE || msgData.sendCommandType == CMD_TEMP_CIRCLE_MSGSEND || msgData.sendCommandType == CMD_TEMP_CIRCLE_MSGRECV){
        
        NSNumber * tcircle_id = nil;
        
        // 获取临时圈子联系人头像 或者 圈子联系人头像
        // 通过类型判断圈子的id
        if (msgData.sendCommandType == CMD_CIRCLE_MSG_SEND || msgData.sendCommandType == CMD_TEMP_CIRCLE_MSGSEND) {
            tcircle_id  = [NSNumber numberWithLongLong:msgData.receiverID];
        } else if (msgData.sendCommandType == CMD_CIRCLE_MSG_RECEIVE || msgData.sendCommandType ==  CMD_TEMP_CIRCLE_MSGRECV){
            tcircle_id = [NSNumber numberWithLongLong:msgData.senderID];
        }
        
        db_model * cmListGeter = nil;
        // 通过类型判断数据模型
        if (msgData.sendCommandType == CMD_CIRCLE_MSG_SEND || msgData.sendCommandType == CMD_CIRCLE_MSG_RECEIVE ) {
            cmListGeter = [circle_member_list_model new];

        }else if (msgData.sendCommandType == CMD_TEMP_CIRCLE_MSGSEND || msgData.sendCommandType == CMD_TEMP_CIRCLE_MSGRECV){
            cmListGeter = [temporary_circle_member_list_model new];
        }

        cmListGeter.where = [NSString stringWithFormat:@"circle_id = %lld order by created asc",tcircle_id.longLongValue];
        NSArray *cmList = [cmListGeter getList];
        NSMutableArray * porMuArr = [NSMutableArray new];
        if (cmList.count > 0) {
            for (int i = 0 ; i < cmList.count; i ++) {
                //只取前三人
                if (i > 2) {
                    break;
                }
                NSDictionary *porDic = [cmList objectAtIndex:i];
                NSString *portraitStr = [porDic objectForKey:@"portrait"];
                [porMuArr addObject:portraitStr];
            }
        } else {
            //当member list 不存在时取数据
            //固定圈子成员列表更新
            if (msgData.sendCommandType == CMD_CIRCLE_MSG_SEND || msgData.sendCommandType == CMD_CIRCLE_MSG_RECEIVE) {
                NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                    [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                                                    tcircle_id,@"circle_id",
                                                    [NSNumber numberWithInt:0],@"ver",
                                                    nil];
                
                NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:tcircle_id,@"circle_id",msgData,@"msg_data", nil];
                
                [[NetManager sharedManager]accessService:jsontestDic data:nil command:GROUP_MEMBER_LIST_COMMAND_ID accessAdress:@"circle/detail.do?param=" delegate:self withParam:param];
            } else
            //临时圈子成员列表更新
            {
                NSLog(@"未完待续 临时圈子成员列表跟新 在%@",self);
            }
        }
        
        NSString * retJosnStr = [porMuArr JSONRepresentation];
        
        RELEASE_SAFE(porMuArr);
        RELEASE_SAFE(cmListGeter);
        
        return retJosnStr;
    }
    return Nil;
}


- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver
{
    ParseMethod method = ^{
        switch (commandid) {
            case GROUP_MEMBER_LIST_COMMAND_ID:
                for (int i = 0; i < resultArray.count; i ++) {
                    NSDictionary * dic = [resultArray objectAtIndex:i];
                    //跟新之前为拿到的头像
                    if ([dic objectForKey:@"msg_data"]) {
                        MessageData * msgData = [dic objectForKey:@"msg_data"];
                        NSLog(@"**** 如果本函数无限循环调用 服务端则获取member信息出问题");
                        
                        NSArray * memberArr = [self getCorrespondingMemberListWithMessageData:msgData];
                        
                        if (memberArr.count > 0) {
                            NSString *porArrStr =  [self searchIconPathWithID:[NSNumber numberWithLongLong:msgData.senderID] andMsgdata:msgData];
                            
                            chatmsg_list_model * cListGeter = [chatmsg_list_model new];
                            cListGeter.where = [NSString stringWithFormat:@"id = %lld",msgData.senderID];
                            NSDictionary * updateDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLongLong:msgData.senderID],@"id",porArrStr,@"icon_path", nil];
                            [cListGeter updateDB:updateDic];
                            
                            RELEASE_SAFE(cListGeter);
                        } else {
                            [Common checkProgressHUDShowInAppKeyWindow:@"网络请求有误，请求成员列表失败" andImage:nil];
                        }
                    }
                }
                break;
                
            default:
                break;
        }
    };
    [Common securelyparseHttpResultArr:resultArray andMethod:method];
}

- (NSMutableArray *)getCorrespondingMemberListWithMessageData:(MessageData *)msgData{
    
    NSNumber * tcircle_id = nil;
    
    // 获取临时圈子联系人头像 或者 圈子联系人头像
    // 通过类型判断圈子的id
    if (msgData.sendCommandType == CMD_CIRCLE_MSG_SEND || msgData.sendCommandType == CMD_TEMP_CIRCLE_MSGSEND) {
        tcircle_id  = [NSNumber numberWithLongLong:msgData.receiverID];
    } else if (msgData.sendCommandType == CMD_CIRCLE_MSG_RECEIVE || msgData.sendCommandType ==  CMD_TEMP_CIRCLE_MSGRECV){
        tcircle_id = [NSNumber numberWithLongLong:msgData.senderID];
    }
    
    db_model * cmListGeter = nil;
    // 通过类型判断数据模型
    if (msgData.sendCommandType == CMD_CIRCLE_MSG_SEND || msgData.sendCommandType == CMD_CIRCLE_MSG_RECEIVE ) {
        cmListGeter = [circle_member_list_model new];
        
    }else if (msgData.sendCommandType == CMD_TEMP_CIRCLE_MSGSEND || msgData.sendCommandType == CMD_TEMP_CIRCLE_MSGRECV){
        cmListGeter = [temporary_circle_member_list_model new];
    }
    
    cmListGeter.where = [NSString stringWithFormat:@"circle_id = %lld order by created asc",tcircle_id.longLongValue];
    NSMutableArray *cmList = [cmListGeter getList];
    return cmList;
}

+ (MessageData *)getMessageDataFromDBDic:(NSDictionary *)dataDic
{
    MessageData * msgData = [MessageData new];
    msgData.locmsgid = [[dataDic objectForKey:@"id"]longLongValue];
    msgData.msgid = [[dataDic objectForKey:@"msgid"]longLongValue];
    msgData.senderID = [[dataDic objectForKey:@"sender_id"]longLongValue];
    msgData.receiverID = [[dataDic objectForKey:@"receiver_id"]longLongValue];
    msgData.msg = [[dataDic objectForKey:@"msg"]JSONValue];
    msgData.msgtype = [[dataDic objectForKey:@"msgtype"]intValue];
    msgData.speakerinfo = [[dataDic objectForKey:@"speakerinfo"]JSONValue];
    msgData.sendtime = [[dataDic objectForKey:@"sendtime"]intValue];
    msgData.showTimeSign = [[dataDic objectForKey:@"show_time"]boolValue];
    return msgData;
}

+ (BOOL)deleteChatDBdataWithTalkType:(MessageListType) talkType andSenderID:(long long)senderID andReceiverID:(long long)receiverID
{
    BOOL successJuder = NO;
    switch (talkType) {
        case MessageListTypePerson:
        case MessageListTypeSecretory:
        case MessageListTypeOrg:

        {
           successJuder = [personal_chat_msg_model deleteAllChatDataWithSenderID:senderID andReceiverID:receiverID];
        }
            break;
        // 这里为了避免圈子iD和人的ID 重复所以将自己的iD替换为了 0
        case MessageListTypeCircle:
        {
           successJuder = [circle_chat_msg_model deleteAllChatDataWithSenderID:senderID andReceiverID:receiverID];
        }
         case MessageListTypeTempCircle:
        {
            successJuder = [temporary_circle_chat_msg_model deleteAllChatDataWithSenderID:senderID andReceiverID:receiverID];
        }
            
        default:
            break;
    }
    successJuder = successJuder && [chatmsg_list_model deleteChatMsgListWithTalkType:talkType andID:senderID];
    return successJuder;
}

- (void)dealloc
{
    LOG_RELESE_SELF;
    [_dataQueue removeAllObjects];
    RELEASE_SAFE(_dataQueue);
    [_waitToResendQueue removeAllObjects];
    RELEASE_SAFE(_waitToResendQueue);
    [super dealloc];
    
   
}

@end
