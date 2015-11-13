//
//  TcpRequestHelper.m
//  ql
//
//  Created by yunlai on 14-5-4.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//


#import "TcpRequestHelper.h"
#import "headParseClass.h"
#import "JSONKit.h"
#import "NSObject+SBJson.h"
#import "MessageDataManager.h"
#import "invite_join_circlemsg_model.h"
#import "chatmsg_list_model.h"
#import "TextData.h"
#import "ChatTcpHelper.h"
#import "circle_member_list_model.h"
#import "circle_list_model.h"
#import "NSString+MessageDataExtension.h"
#import "DataChecker.h"
#import "TcpReceiveOfflineMsgFeedbackPackage.h"
#import "CircleManager.h"
#import "temporary_circle_member_list_model.h"

#import "circle_list_model.h"
#import "temporary_circle_list_model.h"
#import "chatmsg_list_model.h"
#import "wantHaveData.h"
#import "MessageNotifyManager.h"

#import "TogetherData.h"

#import "org_member_list_model.h"

#define kWaitMsgArr @"WaitMsgArr"
#define kDataChecker @"DataChecker"

#import "MessageNotifyManager.h"

#import "LocalNotifyManager.h"

static int  heartBeatInterval = 30;

TcpRequestHelper *TcpRequestHelperSINGLE;

@interface TcpRequestHelper ()
{
    
}

@end

@implementation TcpRequestHelper
{
    NSMutableDictionary * _waitForStoreData;
}


+ (TcpRequestHelper *)shareTcpRequestHelperHelper {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (TcpRequestHelperSINGLE==nil) {
            TcpRequestHelperSINGLE = [[TcpRequestHelper alloc] init];
        }
    });
    
    return TcpRequestHelperSINGLE;
}

- (instancetype)init {
    if (self = [super init]) {
        _waitForStoreData = [NSMutableDictionary new];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(restoreWaitingMessage:) name:kNotiUpdateTempCircleInfo object:nil];
    }
    return self;
}

- (void)receiveXintiaoPackage:(id)data {
    
    ////解析包体数据
    NSString *bodyStr = [headParseClass parseIMPortPackaging:data];
    
    NSDictionary *bodyJson = [bodyStr JSONValue];
    
    NSLog(@"心跳包:%@",bodyJson);
    
    heartBeatInterval = [[bodyJson objectForKey:@"step"]intValue];
    if (heartBeatInterval <=0 ) {
        NSAssert(false, @"Receive interval error");
    }
    
    // NSNumber is a object so you can not use it as the type Snail 4.8
    [self performSelector:@selector(sendXingtiaoPackageCommandId:) withObject:nil afterDelay:heartBeatInterval];
}

- (void)sendXingtiaoPackageCommandId:(int)type{
    
    TcpSendPackage *xintiaoPackage = [TcpSendPackage createXintiaoPackage];
    NSData *data = [xintiaoPackage data];
    // Snail 4.8
    [[ChatTcpHelper shareChatTcpHelper] sendMessage:data withTimeout:-1 tag:TCP_XINTIAO_COMMAND_ID];
    
}

- (void)sendLogingPackageCommandId:(int)type{
    
    TcpSendPackage *loginPackage = [TcpSendPackage createLoginPackage];
    NSData *data = [loginPackage data];
    
    NSData *test = [data copy];
    NSDictionary *dic = [headParseClass getPackageHeaderInfo:test];
    NSLog(@"%@",dic);
    // snail 4.8
    [[ChatTcpHelper shareChatTcpHelper] sendMessage:data withTimeout:-1 tag:TCP_LOGIN_COMMAND_ID];
}

- (void)receiveLoginResponse:(id)data {
    //解析包体数据
    NSString *bodyStr = [headParseClass parseIMPortPackaging:data];
    
    NSDictionary *bodyJson = [bodyStr JSONValue];
    
    NSLog(@"IM请求结果=%@",bodyJson);
    
    
    if ([[bodyJson objectForKey:@"rcode"]intValue] == 0) {
        //登录成功后，发送心跳包
        [self sendXingtiaoPackageCommandId:TCP_XINTIAO_COMMAND_ID];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotiLoginSuccess object:nil];
        
    }else if([[bodyJson objectForKey:@"rcode"]intValue] == 2){
        
        NSString *ip = [NSString stringWithFormat:@"%@",[bodyJson objectForKey:@"ip"]];
        //登录重定向连接
        [[ChatTcpHelper shareChatTcpHelper]redirectConnectToHost:ip port:[[bodyJson objectForKey:@"port"] intValue]];
    }
}

-(void) sendLogoutPackageCommandId:(int)type{
    TcpSendPackage *logoutPackage = [TcpSendPackage createLogoutPackage];
    NSData *data = [logoutPackage data];
    [[ChatTcpHelper shareChatTcpHelper] sendMessage:data withTimeout:-1 tag:type];
}

- (void)sendMessagePackageCommandId:(int)type andMessageData:(MessageData *)msgData
{
    TcpSendPackage *textMessagePackage = [TcpSendPackage createMessagePackageWith:msgData];
    NSData *data = [textMessagePackage data];
    
    [[ChatTcpHelper shareChatTcpHelper] sendMessage:data withTimeout:-1 tag:type];
}

-(void) receiveLogoutResponse:(id)data{
    //解析包体数据
    NSString *bodyStr = [headParseClass parseIMPortPackaging:data];
    
    NSDictionary *bodyJson = [bodyStr JSONValue];
    
    
    if ([[bodyJson objectForKey:@"rcode"]intValue] == 0) {
        //登录成功后，发送心跳包
        NSLog(@"=====logoutSuccess=====");
        [[ChatTcpHelper shareChatTcpHelper] disConnectHost];
    }
    NSLog(@"IM请求结果=%@",bodyJson);
}


- (void)receiveMessageSended:(id)data
{
    // 获取包体
    NSDictionary *bodyDic = [self retrieveBodyDicFrom:data];
    
    if ([[bodyDic objectForKey:@"rcode"]intValue] == 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiSendMessageSuccess object:bodyDic];
    } else {
        NSLog(@"message send faild with dic %@",bodyDic);
        
        
    }
    
}

- (void)receiveCircleMessageSended:(NSData *)data
{
    NSDictionary *bodyDic = [self retrieveBodyDicFrom:data];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiSendMessageSuccess object:bodyDic];
}

- (void)receiveChatMessage:(NSData *)data
{
    //获取包头
    NSDictionary *headDic = [headParseClass getHeaderInfo:data];
    //获取包体
    NSDictionary *bodyDic = [self retrieveBodyDicFrom:data];
    
    //本地通知
    NSDictionary* dic = [[bodyDic objectForKey:@"msg"] firstObject];
    //消息类型
    int objtype = [[dic objectForKey:@"objtype"] intValue];
    //文本
    NSDictionary* txtDic = [dic objectForKey:@"data"];
    [self locaLnotifyWith:[bodyDic objectForKey:@"speakerinfo"] type:objtype txt:[txtDic objectForKey:@"txt"]];
    
    //解析并存储消息数据
    [self parseMessageWithHeadDic:headDic andBodyDic:bodyDic];
}

- (NSDictionary *)retrieveBodyDicFrom:(NSData *)data
{
    
    NSString *reterieveBody = [headParseClass parseIMPortPackaging:data];
    
    NSDictionary *bodyDic = [reterieveBody JSONValue];
    
    NSLog(@"get dic %@",bodyDic);
    return bodyDic;
}

//邀请成员加入圈子
- (void)sendInviteJoinCircleCommandId:(int)type receive:(int)receiveId bodyJson:(NSDictionary *)bodyDic {
    
    TcpSendPackage *logoutPackage = [TcpSendPackage createInviteJoinPackage:receiveId bodyJson:bodyDic];
    NSData *data = [logoutPackage data];
    [[ChatTcpHelper shareChatTcpHelper] sendMessage:data withTimeout:-1 tag:type];
}

//邀请加入的回调
- (void)receiveInviteJoinResponse:(id)data{
    
    NSString *reterieveBody = [headParseClass parseIMPortPackaging:data];
    
    NSDictionary *bodyDic = [reterieveBody JSONValue];
    
    NSLog(@"InviteJoinResponse: %@",bodyDic);
    
    if ([[bodyDic objectForKey:@"rcode"]intValue] == 0) {
        
//        [Common checkProgressHUD:@"邀请成功" andImage:nil showInView:[[UIApplication sharedApplication]keyWindow]];
        [Common checkProgressHUDShowInAppKeyWindow:@"邀请成功" andImage:KAccessSuccessIMG];
    }
}

//收到圈子消息
- (void)receiveCircleChatMessage:(NSData *)data
{
    //获取包头
    NSDictionary *headDic = [headParseClass getPackageHeaderInfo:data];
    //获取包体
    NSDictionary *bodyDic = [self retrieveBodyDicFrom:data];
    NSMutableDictionary *mutBody = [NSMutableDictionary dictionaryWithDictionary:bodyDic];
    
    NSNumber * recieverID  = [headDic objectForKey:@"llDestUid"];
    if (recieverID.intValue == 0) {
        recieverID = [NSNumber numberWithInt:[[[Global sharedGlobal] user_id] intValue]];
    }
    [mutBody setObject:[headDic objectForKey:@"llSrcUid"] forKey:@"sender_id"];
    [mutBody setObject:recieverID forKey:@"receiver_id"];
    
  
    //获取圈子名称拿来作为title
    NSDictionary * dic = [circle_list_model getCircleListWithCircleID:[[mutBody objectForKey:@"sender_id"]longLongValue]];
    [mutBody setObject:[dic objectForKey:@"name"] forKey:@"title"];
    
    
    MessageData * msgData = [[MessageData alloc]initWithDic:mutBody];
    msgData.talkType = MessageListTypeCircle;
    
    if ([[mutBody objectForKey:@"msgtype"]intValue] == kMessageTypeNormal) {
        MessageDataManager *manager = [[MessageDataManager alloc]init];
        msgData.sendCommandType = CMD_CIRCLE_MSG_RECEIVE;
        msgData.msgData.status = ReceiveMessageUnread;
        msgData.msgData = msgData.msgData;
        [manager restoreData:msgData];
        [[MessageNotifyManager shareNotifyManager]playVibrate];
    }
    
    if (bodyDic != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chatMessageReceive" object:msgData];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiUpdateLeftbarMark object:nil];
    }
    NSNumber* circleId = [mutBody objectForKey:@"sender_id"];
    NSNumber* msgid = [mutBody objectForKey:@"msgid"];
    
    [self updateCircleMsgid:[msgid longLongValue] circleId:[circleId longLongValue]];
    
    //本地通知
    NSDictionary* msgDic = [[bodyDic objectForKey:@"msg"] firstObject];
    //消息类型
    int objtype = [[msgDic objectForKey:@"objtype"] intValue];
    //文本
    NSDictionary* txtDic = [msgDic objectForKey:@"data"];
    [self locaLnotifyWith:[bodyDic objectForKey:@"speakerinfo"] type:objtype txt:[txtDic objectForKey:@"txt"]];
}

//收到好友的邀请加入圈子信息
- (void)receiveInviteMessage:(NSData *)data{
    //解析包头 获取发送方信息
    NSString *reterieveBody = [headParseClass parseIMPortPackaging:data];
    
    NSDictionary *headDic = [headParseClass getHeaderInfo:data];
    NSLog(@"receive Package head : %@",headDic);
    NSDictionary *bodyDic = [reterieveBody JSONValue];
    NSLog(@"receiveInviteMessage: %@",bodyDic);
    TextData * inviteTextData = nil;
    
    if (bodyDic) {
        if ([bodyDic objectForKey:@"msg"] != nil && [bodyDic objectForKey:@"msg"]!= NULL) {
            inviteTextData = [[TextData alloc]initWithDic:[[bodyDic objectForKey:@"msg"]firstObject]];
        }
    }
    
    NSString * inviteText = inviteTextData.txt;
    NSDictionary *speakerinfoDic = [bodyDic objectForKey:@"speakerinfo"];
    
    //将消息存入数据库
    invite_join_circlemsg_model *joinMsg = [[invite_join_circlemsg_model alloc]init];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [headDic objectForKey:@"sender_id"],@"sender_id",
                         [speakerinfoDic objectForKey:@"nickname"],@"nickname",
                         [speakerinfoDic objectForKey:@"clienttype"],@"client_type",
                         [bodyDic objectForKey:@"sendtime"],@"send_time",
                         inviteText,@"msg",
                         [bodyDic objectForKey:@"circlename"],@"circle_name",
                         [bodyDic objectForKey:@"circleid"],@"circle_id",
                         [bodyDic objectForKey:@"circleavator"],@"circle_portrait",
                         [NSNumber numberWithInt:0],@"joined"
                         ,nil];
    
    joinMsg.where = [NSString stringWithFormat:@"sender_id = %d",[[headDic objectForKey:@"sender_id"]intValue]];
    NSArray * oldArr = [joinMsg getList];
    NSDictionary * oldDic = [oldArr lastObject];
    
    if (oldArr.count > 0 && [[oldDic objectForKey:@"joined"]intValue] == 0) {
        [joinMsg updateDB:dic];
    } else {
        [joinMsg insertDB:dic];
    }
    RELEASE_SAFE(joinMsg);
    
    TextData * tData = [[TextData alloc]init];
    tData.txt = [NSString stringWithFormat:@"[%@]",inviteText];
    NSString * content =[NSString getStrWithMessageDatas:tData,nil];
    int unreaded = 1;
    int intCircleID = [[dic objectForKey:@"circle_id"]intValue];
    
    NSString * icon_pathStr = [dic objectForKey:@"circle_portrait"];
    NSArray * iconStrArr = [NSArray arrayWithObject:icon_pathStr];
    NSString * iconArrStr = [iconStrArr JSONRepresentation];
    
    NSMutableDictionary * insertDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [dic objectForKey:@"circle_id"],@"id",
                                       [NSNumber numberWithInt:MessageListTypeCircle],
                                       @"talk_type",
                                       iconArrStr,@"icon_path",
                                       [dic objectForKey:@"circle_name"],@"title",
                                       [dic objectForKey:@"sender_id"],@"speak_id",
                                       [dic objectForKey:@"nickname"],@"speak_name",
                                       content,@"content",
                                       [bodyDic objectForKey:@"sendtime"],@"send_time",
                                       [NSNumber numberWithInt:1],@"invited_sign",
                                       nil];
    
    chatmsg_list_model * clistGeter = [[chatmsg_list_model alloc]init];
    clistGeter.where = [NSString stringWithFormat:@"id = %d and talk_type = %d",intCircleID,MessageListTypeCircle];
    NSArray * oldDataArr = [clistGeter getList];
    
    if (oldDataArr.count != 0) {
        NSDictionary *oldDataDic = [oldDataArr lastObject];
        unreaded += [[oldDataDic objectForKey:@"unreaded"]intValue];
    }
    [insertDic setValue:[NSNumber numberWithInt:unreaded] forKey:@"unreaded"];
    
    if (oldDataArr.count == 0) {
        [clistGeter insertDB:insertDic];
    } else {
        [clistGeter updateDB:insertDic];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"inviteMessageReceive" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotiUpdateLeftbarMark object:nil];
    
}

//确认加入圈子信息
- (void)sendInviteJoinCircleConfirmCommandId:(int)type inviteId:(long long)inviteId bodyJson:(NSDictionary *)bodyDic{
    
    TcpSendPackage *logoutPackage = [TcpSendPackage createInviteJoinConfirmPackage:inviteId bodyJson:bodyDic];
    NSData *data = [logoutPackage data];
    [[ChatTcpHelper shareChatTcpHelper] sendMessage:data withTimeout:-1 tag:type];
    
}

//确认加入圈子回调
- (void)receiveConfirmInviteCircleResponse:(id)data{
    NSString *reterieveBody = [headParseClass parseIMPortPackaging:data];
    
    NSDictionary *bodyDic = [reterieveBody JSONValue];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotiConfirmJoinCircle object:bodyDic];
    
}

//圈子成员变更
- (void)sendCircleMemberUpdateCommandId:(int)type receive:(int)userId bodyJson:(NSDictionary *)bodyDic{
    
    TcpSendPackage *logoutPackage = [TcpSendPackage createCircleMemberUpdatePackage:userId bodyJson:bodyDic];
    NSData *data = [logoutPackage data];
    [[ChatTcpHelper shareChatTcpHelper] sendMessage:data withTimeout:-1 tag:type];
}

//圈子成员变更的回调
- (void)receiveCircleMemberUpdateResponse:(id)data{
    
    NSString *reterieveBody = [headParseClass parseIMPortPackaging:data];
    
    NSDictionary *bodyDic = [reterieveBody JSONValue];
    
    NSLog(@"receiveEditCircleMemberResponse: %@",bodyDic);
    
    NSNumber * judgeFlag = [bodyDic objectForKey:@"flag"];
    NSNumber * circleID = [bodyDic objectForKey:@"circleid"];
    NSNumber * userID = [[bodyDic objectForKey:@"userinfo"] objectForKey:@"uid"];
    
    //成员变更数据更新
    NSDictionary *memDic = [NSDictionary dictionaryWithObjectsAndKeys:[bodyDic objectForKey:@"circleid"],@"circle_id",
                            [[bodyDic objectForKey:@"userinfo"] objectForKey:@"uid"],@"user_id",
                            [[bodyDic objectForKey:@"userinfo"] objectForKey:@"realname"],@"realname",
                            [[bodyDic objectForKey:@"userinfo"] objectForKey:@"headlogo"],@"portrait",
                            [[bodyDic objectForKey:@"userinfo"] objectForKey:@"companytitle"],@"role",
                            [bodyDic objectForKey:@"sendtime"] ,@"created",
                            nil];
    
    //用于判断变更状态.1 为添加 2 为删除
    if (judgeFlag.intValue == 2) {
        if (userID.longLongValue == [[[Global sharedGlobal]user_id]longLongValue]) {
            [CircleManager deleteCircleListAndMemberListWithCircleID:circleID.longLongValue];
            //booky 自己被提出
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotiCircleBeOut object:nil];
            
        } else {
            [CircleManager deleteCircleMemberWithCircleID:circleID.longLongValue andMemberID:userID.longLongValue];
        }
        
    } else if (judgeFlag.intValue == 1){
        [CircleManager insertCircleMemberWithMemberDic:memDic];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiCircleMemberChange object:bodyDic];
//                    add vincent 圈子红点去掉
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"circleChangeLeftSiderNotice" object:nil];
    
    NSNumber* msgid = [bodyDic objectForKey:@"msgid"];
    [self updateCircleMsgid:[msgid longLongValue] circleId:[circleID longLongValue]];
    
    //更新unread
    [circle_list_model insertOrUpdateDictionaryIntoCirlceList:[NSDictionary dictionaryWithObjectsAndKeys:
                                                               circleID,@"circle_id",
                                                               [NSNumber numberWithInt:1],@"unread",
                                                               nil]];
}

- (void)receiveTempCircleMemberUpdateResponse:(NSData *)data
{    
    NSDictionary * bodyDic = [headParseClass getBodyDic:data];
    NSNumber * tempCircleID = [bodyDic objectForKey:@"circleid"];
    
    DataChecker * tempCircleChecker = [[DataChecker alloc]init];
    if (![tempCircleChecker checkTempCirleExistWithID:tempCircleID]) {
        [tempCircleChecker updateTempCircleInfoWithID:tempCircleID];
        return;
    }
    
    //用于判断1添加 2删除
    int flag = [[bodyDic objectForKey:@"flag"]intValue];
    NSNumber * msgid = [bodyDic objectForKey:@"msgid"];
    NSDictionary * memberInfo = [bodyDic objectForKey:@"userinfo"];
    
    //临时圈子成员变更数据更新
    NSDictionary *memDic = [NSDictionary dictionaryWithObjectsAndKeys:[bodyDic objectForKey:@"circleid"],@"circle_id",
                            [memberInfo objectForKey:@"uid"],@"user_id",
                            [memberInfo objectForKey:@"realname"],@"realname",
                            [memberInfo objectForKey:@"headlogo"],@"portrait",
                            [memberInfo objectForKey:@"companytitle"],@"role",
                            [bodyDic objectForKey:@"sendtime"] ,@"created",
                            nil];
    
    if (flag == 1) {
        [temporary_circle_member_list_model insertOrUpdateTempDictionaryIntoCirlceMemberList:memDic];
    } else if (flag ==2 ){
        //如果被提出的成员是自己，则删除表信息
        [temporary_circle_member_list_model deleteTempCircleMemberWithCircleID:tempCircleID.longLongValue andMemberID:[[memberInfo objectForKey:@"uid"]longLongValue]];
        //booky 自己被删除，通知聊天界面，处理
        if ([[memDic objectForKey:@"user_id"] intValue] == [[Global sharedGlobal].user_id intValue]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotiCircleBeOut object:nil];
        }
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotiTempCircleMmberChange object:bodyDic];
    
    [self updateTempCircleMsgid:[msgid longLongValue] circleId:[tempCircleID longLongValue]];
}

- (void)sendCreateTemporaryCircleRequestWithUserList:(NSArray *)uList
{
    TcpSendPackage * createTempPack = [TcpSendPackage generateCreateTemporaryCirclePackageWithUserList:uList];
    
    NSData *sendData = [createTempPack data];
    
    [[ChatTcpHelper shareChatTcpHelper] sendMessage:sendData withTimeout:-1 tag:TCP_CREATE_TEMPORARY_CIRCLE];
}

- (void)sendAddTemporaryCircleRequestWithUserList:(NSArray *)uList AndTempCircleID:(long long)TempCircle
{
   NSData * addTempData =  [TcpSendPackage generateAddTemporaryCircleDataWithUserList:uList andTempCircleID:TempCircle];
    
    [[ChatTcpHelper shareChatTcpHelper]sendMessage:addTempData withTimeout:-1 tag:TCP_ADD_TEMPORARY_MEMBER];
}

- (void)receiveCreateTemporaryCircleFeedback:(NSData *)data
{
    NSDictionary * headDic = [headParseClass getHeaderInfo:data];
    NSLog(@"Receive CreateTC feedWithDicHead %@",headDic);
    NSString * bodyStr = [headParseClass parseIMPortPackaging:data];
    NSDictionary *bodyDic = [bodyStr JSONValue];
    NSLog(@"Recevve BodyDic %@",bodyDic);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotiCreateTempCircleFb object:bodyDic];
}

- (void)receiveTempCircleMessageFeedback:(NSData *)data{
    NSString * bodyStr = [headParseClass parseIMPortPackaging:data];
    NSDictionary * bodyDic = [bodyStr JSONValue];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotiSendMessageSuccess object:bodyDic];
}

- (void)receiveTempCircleChatMessage:(NSData *)data
{
    NSDictionary * headDic = [headParseClass getHeaderInfo:data];
    NSLog(@"Receive TempCircleChatMessage HeadDic = %@",headDic);
    
    NSDictionary * bodyDic = [headParseClass getBodyDic:data];
    NSLog(@"And BodyDic %@",bodyDic);
    
    NSMutableDictionary *mutBody = [NSMutableDictionary dictionaryWithDictionary:bodyDic];
    [mutBody setObject:[headDic objectForKey:@"sender_id"] forKey:@"sender_id"];
    [mutBody setObject:[[Global sharedGlobal] user_id] forKey:@"receiver_id"];
    
    MessageData * storeMsg = [[MessageData alloc]initWithDic:mutBody];
    storeMsg.sendCommandType = CMD_TEMP_CIRCLE_MSGRECV;
    storeMsg.msgData.status = ReceiveMessageUnread;
    storeMsg.msgData = storeMsg.msgData;
    storeMsg.talkType = MessageListTypeTempCircle;
    
    NSNumber * tempCircleId = [headDic objectForKey:@"sender_id"];
    DataChecker * tempDataChecker = [DataChecker new];
    BOOL haveTempCircle = [tempDataChecker checkTempCirleExistWithID:tempCircleId];
    if (haveTempCircle) {
        MessageDataManager * messageManager =[MessageDataManager new];
        NSDictionary * tempCircleDic = [temporary_circle_list_model getTemporaryCircleListWithTempCircleID:tempCircleId.longLongValue];
        
        storeMsg.title = [tempCircleDic objectForKey:@"name"];
        [messageManager restoreData:storeMsg];
        [[MessageNotifyManager shareNotifyManager]playVibrate];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiReceiveTempCircleMsg object:storeMsg];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotiUpdateLeftbarMark object:nil];
    } else {
        //存下 Datachecker 和 message data 用于后面存储和释放
        NSArray * waitMsgArr = [NSArray arrayWithObjects:storeMsg,nil];
        
        NSDictionary * waitInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      waitMsgArr,kWaitMsgArr,
                                      tempDataChecker,kDataChecker,
                                      nil];
        
        [_waitForStoreData setObject:waitInfoDic forKey:tempCircleId];
        [tempDataChecker updateTempCircleInfoWithID:tempCircleId];
    }
    
    [self updateTempCircleMsgid:[[mutBody objectForKey:@"msgid"] longLongValue] circleId:[tempCircleId longLongValue]];
    
    //本地通知
    NSDictionary* msgDic = [[bodyDic objectForKey:@"msg"] firstObject];
    //消息类型
    int objtype = [[msgDic objectForKey:@"objtype"] intValue];
    //文本
    NSDictionary* txtDic = [msgDic objectForKey:@"data"];
    [self locaLnotifyWith:[bodyDic objectForKey:@"speakerinfo"] type:objtype txt:[txtDic objectForKey:@"txt"]];
}

#pragma mark - DataCheckerRecall
// 更新完临时圈子信息后回调 从新插入之前存储的消息 并释放之前new 出来的变量
- (void)restoreWaitingMessage:(NSNotification *)noti
{
    NSArray * resultArr = [noti object];
    NSDictionary * param = [resultArr objectAtIndex:1];
    NSString * titleName = [resultArr lastObject];
    NSNumber * circle_id = [param objectForKey:@"circle_id"];
    NSDictionary * waitInfoDic = [_waitForStoreData objectForKey:circle_id];
    MessageDataManager * messageManager =[MessageDataManager new];
    
    NSArray * waitInsertMsgArr = [waitInfoDic objectForKey:kWaitMsgArr];
    if (waitInsertMsgArr.count > 0) {
        for (MessageData * restoreMsgData in waitInsertMsgArr) {
            restoreMsgData.title = titleName;
            [messageManager restoreData:restoreMsgData];
            [[MessageNotifyManager shareNotifyManager]playVibrate];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotiReceiveTempCircleMsg object:restoreMsgData];
            
        }
    }
    if (waitInfoDic != nil) {
        [_waitForStoreData removeObjectForKey:circle_id];
    }
}

- (void)receiveOfflineMessage:(NSData *)data
{
    NSDictionary * olMessageHead = [headParseClass getHeaderInfo:data];
    NSDictionary * bodyDic = [headParseClass getBodyDic:data];
    NSLog(@"Get offline Dic head %@ \n and body %@",olMessageHead,bodyDic);
    
    NSArray * msgList = [bodyDic objectForKey:@"msglist"];
    if (msgList != nil && [msgList respondsToSelector:@selector(count)] && msgList.count ) {
        for (NSDictionary * olmsgDic in msgList) {
            [self parseMessageWithHeadDic:olMessageHead andBodyDic:olmsgDic];
        }
        
        NSDictionary * latestMsgDic = [msgList lastObject];
        NSDictionary * resultDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:0],@"rcode",
                                    [latestMsgDic objectForKey:@"msgid"],@"recvmsgid",
                                    nil];
        [self sendOfflineMessageReceiveFeedBackWithDic:resultDic];
    } else {
        [Common checkProgressHUD:@"消息数据Json 格式有误" andImage:nil showInView:APPKEYWINDOW];
    }
    
}

- (void)sendOfflineMessageReceiveFeedBackWithDic:(NSDictionary *)latestMsgDic
{
    NSData * sendData = [TcpReceiveOfflineMsgFeedbackPackage generateDataWithMsgDic:latestMsgDic];
    [[ChatTcpHelper shareChatTcpHelper]sendMessage:sendData withTimeout:-1 tag:0];
}

- (void)parseMessageWithHeadDic:(NSDictionary *)headDic andBodyDic:(NSDictionary *)bodyDic
{
    //收到单聊消息音频播放音频通知
//    [[MessageNotifyManager shareNotifyManager]playChatMessageReciveSystemMusic];
    
    NSMutableDictionary *mutBody = [NSMutableDictionary dictionaryWithDictionary:bodyDic];
    NSDictionary *speakerinfo = [mutBody objectForKey:@"speakerinfo"];
    NSString *name = [speakerinfo objectForKey:@"nickname"];
    //----booky 5.16------//
    int msgType = [[bodyDic objectForKey:@"msgtype"] intValue];
    //-------------------//
    [mutBody setObject:[speakerinfo objectForKey:@"uid"] forKey:@"sender_id"];
    [mutBody setObject:[headDic objectForKey:@"receiver_id"] forKey:@"receiver_id"];
    [mutBody setObject:name forKey:@"title"];
    
    MessageData * msgData = [[MessageData alloc]initWithDic:mutBody];
    msgData.talkType = MessageListTypePerson;
    
    //添加语音未读消息标识
    if (msgData.msgData.objtype == dataTypeVoice) {
        msgData.msgData.status =  ReceiveMessageUnread;
        msgData.msgData = msgData.msgData;
    }
    
    if (msgType == kMessageTypeNormal || msgType == kMessageTypePush) {
        MessageDataManager *manager = [[MessageDataManager alloc]init];
        msgData.sendCommandType = CMD_PERSONAL_MSGRECV;
        [manager restoreData:msgData];
        [[MessageNotifyManager shareNotifyManager]playVibrate];
    }
    
    //-----booky 5.21-----//
    if (msgType == kMessageTypeReplayHave) {
        MessageDataManager* manager = [[MessageDataManager alloc] init];
        msgData.sendCommandType = CMD_PERSONAL_MSGRECV;
        
        //被circle坑了 添加消息type来做判断我有我要
        if ([msgData.msgData isKindOfClass:[wantHaveData class]]) {
            wantHaveData * haveData = (wantHaveData *)msgData.msgData;
            haveData.type = PersonMessageHave;
        }
        [manager restoreData:msgData];
        [[MessageNotifyManager shareNotifyManager]playVibrate];
    }
    
    if (msgType == kMessageTypeReplyWant) {
        MessageDataManager* manager = [[MessageDataManager alloc] init];
        msgData.sendCommandType = CMD_PERSONAL_MSGRECV;
        
        //被circle坑了 添加消息type来做判断我有我要
        wantHaveData * haveData = (wantHaveData *)msgData.msgData;
        haveData.type = PersonMessageWant;
        [manager restoreData:msgData];
        [[MessageNotifyManager shareNotifyManager]playVibrate];
    }
    
    //booky 8.20 聚聚类型//
    if (msgType == kMessageTypeTogether) {
        if (msgData.msg.count != 0) {
            MessageDataManager* manager = [[MessageDataManager alloc] init];
            msgData.sendCommandType = CMD_PERSONAL_MSGRECV;
            [manager restoreData:msgData];
        }
        
    }
    
    if (bodyDic != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chatMessageReceive" object:msgData];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiUpdateLeftbarMark object:nil];
        
        if (msgData.senderID == [[[Global sharedGlobal].secretInfo objectForKey:@"id"] intValue]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tipsMessageReceive" object:msgData];
        }
        
        //--------booky 5.16---------//
        if (msgType == kMessageTypeDynamic) {
            [Global sharedGlobal].newDynamicNum += 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newDynamicNotice" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dynamicLeftSiderNotice" object:nil];
        }
        //----------新动态提醒----------------//
        
        //--------booky 5.19---------//
        if (msgType == kMessageTypeComment) {
            [Global sharedGlobal].dyMe_unread_num += 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dynamicAboutMeNotice" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dynamicLeftSiderNotice" object:nil];
        }
        //----------与我相关得动态提醒----------------//
    }
}

//
- (void)receiveOfflineCircleMessage:(NSData *)data
{
    //获取包头包体信息
    NSDictionary * headDic = [headParseClass getHeaderInfo:data];
    NSDictionary * bodyDic = [headParseClass getBodyDic:data];
    NSLog(@"Have receive Offline Message headDic = %@ \n and bodyDic = %@",headDic,bodyDic);
    
    //得到该圈子中所有消息的数组 拼接上包头的发送方信息然后作圈子消息接收类似的处理进行存储和展现
    NSArray * offLineMsgList = [bodyDic objectForKey:@"msglist"];
    
    if (offLineMsgList.count > 0) {
        for (NSDictionary * msgBodyDic in offLineMsgList)
        {
            NSMutableDictionary *mutBody = [NSMutableDictionary dictionaryWithDictionary:msgBodyDic];
            [mutBody setObject:[headDic objectForKey:@"sender_id"] forKey:@"sender_id"];
            [mutBody setObject:[headDic objectForKey:@"receiver_id"] forKey:@"receiver_id"];
            
            NSNumber * circleIDNum = [headDic objectForKey:@"sender_id"];
            NSDictionary * circleDic = [circle_list_model getCircleListWithCircleID:circleIDNum.longLongValue];
            
            
            if (circleDic) {
                [mutBody setObject:[circleDic objectForKey:@"name"] forKey:@"title"];
            }
            
            MessageData * msgData = [[MessageData alloc]initWithDic:mutBody];
            msgData.talkType = MessageListTypeCircle;
            
            if ([[mutBody objectForKey:@"msgtype"]intValue] == kMessageTypeNormal) {
                MessageDataManager *manager = [[MessageDataManager alloc]init];
                msgData.sendCommandType = CMD_CIRCLE_MSG_RECEIVE;
                msgData.msgData.status = ReceiveMessageUnread;
                msgData.msgData = msgData.msgData;
                [manager restoreData:msgData];
            }
            
            if (bodyDic != nil) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"chatMessageReceive" object:msgData];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotiUpdateLeftbarMark object:nil];
            }
        }
        NSNumber* circleId = [headDic objectForKey:@"sender_id"];
        
        [self updateCircleMsgid:[[[offLineMsgList lastObject] objectForKey:@"msgid"] longLongValue] circleId:[circleId longLongValue]];
    }
}

// 单独写一套消息解析逻辑是为了方便处理本地没有临时消息信息时进行数据延迟存储
- (void)receiveOfflineTempCircleMessage:(NSData *)data
{
    NSDictionary * headDic = [headParseClass getHeaderInfo:data];
    NSLog(@"Receive TempCircleChatMessage HeadDic = %@",headDic);
    
    NSDictionary * bodyDic = [headParseClass getBodyDic:data];
    NSLog(@"And BodyDic %@",bodyDic);
    
    //获取推送的临时圈子列表
    NSArray * tempMsgList = [bodyDic objectForKey:@"msglist"];
    NSNumber * tempCircleId = [headDic objectForKey:@"sender_id"];
    //判断该临时圈子是否存在
    DataChecker * tempDataChecker = [DataChecker new];
    BOOL haveTempCircle = [tempDataChecker checkTempCirleExistWithID:tempCircleId];
    
    if (haveTempCircle == NO)
    {
        //如果不存在则跟新临时圈子信息.并将消息存储到等待存储数据库队列中
        [tempDataChecker updateTempCircleInfoWithID:tempCircleId];
        //待存储数组队列。在数组存储过后会被释放
        NSMutableArray * waitInsertMsgArr = [NSMutableArray new];
        
        if (tempMsgList.count > 0) {
            for (NSDictionary * tempMsgDic in tempMsgList) {
                NSMutableDictionary *mutBody = [NSMutableDictionary dictionaryWithDictionary:tempMsgDic];
                [mutBody setObject:[headDic objectForKey:@"sender_id"] forKey:@"sender_id"];
                [mutBody setObject:[headDic objectForKey:@"receiver_id"] forKey:@"receiver_id"];
                
                MessageData * storeMsg = [[MessageData alloc]initWithDic:mutBody];
                storeMsg.sendCommandType = CMD_TEMP_CIRCLE_MSGRECV;
                storeMsg.talkType = MessageListTypeTempCircle;
                storeMsg.msgData.status = ReceiveMessageUnread;
                storeMsg.msgData = storeMsg.msgData;
                [waitInsertMsgArr addObject:storeMsg];
            }
        }
        //跟新等待处理的信息字典 里面会装一个带存储的消息数组和一个DataChecker 用于释放
        NSDictionary * updateWaitInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                         waitInsertMsgArr,kWaitMsgArr,
                                         tempDataChecker,kDataChecker,nil];
        [_waitForStoreData setObject:updateWaitInfo forKey:tempCircleId];
    }
    else {
        if (tempMsgList.count > 0) {
            for (NSDictionary * tempMsgDic in tempMsgList) {
                NSMutableDictionary *mutBody = [NSMutableDictionary dictionaryWithDictionary:tempMsgDic];
                [mutBody setObject:[headDic objectForKey:@"sender_id"] forKey:@"sender_id"];
                [mutBody setObject:[headDic objectForKey:@"receiver_id"] forKey:@"receiver_id"];
                
                MessageData * storeMsg = [[MessageData alloc]initWithDic:mutBody];
                storeMsg.sendCommandType = CMD_TEMP_CIRCLE_MSGRECV;
                storeMsg.talkType = MessageListTypeTempCircle;
                MessageDataManager * messageManager =[MessageDataManager shareMessageDataManager];
                [messageManager restoreData:storeMsg];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotiReceiveTempCircleMsg object:storeMsg];
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotiUpdateLeftbarMark object:nil];
            }
        }
    }
    
    [self updateTempCircleMsgid:[[[tempMsgList lastObject] objectForKey:@"msgid"] longLongValue] circleId:[tempCircleId longLongValue]];
}

-(void) recieveCircleInfoChangeNotify:(NSData *)data{
    NSDictionary * bodyDic = [headParseClass getBodyDic:data];
    
    long long circleID = [[bodyDic objectForKey:@"circleid"] longLongValue];
    int flag = [[bodyDic objectForKey:@"flag"] intValue];
    long long msgid = [[bodyDic objectForKey:@"msgid"] longLongValue];
    
    circle_list_model* circleMod = [[circle_list_model alloc] init];
    circleMod.where = [NSString stringWithFormat:@"circle_id = %lld",circleID];
    
    NSString* circlename = [bodyDic objectForKey:@"circlename"];
    
    //flag :1修改 2删除
    if (flag == 1) {
        
        NSString* circledesc = [bodyDic objectForKey:@"circledesc"];
        
        NSMutableDictionary* circleDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          circlename,@"name",
                                          [NSNumber numberWithLongLong:msgid],@"msgid",
                                          [NSNumber numberWithInt:1],@"unread",
                                          nil];
        if (circledesc.length > 0) {
            [circleDic setObject:circledesc forKey:@"content"];
        }
        [circleMod updateDB:circleDic];
        [self updateChatMsgTitleWithCircleId:circleID talkType:MessageListTypeCircle title:circlename];
        NSLog(@"圈子信息修改 %@",circleDic);
        
    }else{
        //解散
        NSLog(@"圈子解散 %@",bodyDic);
        [circleMod deleteDBdata];
        
        [self deleteChatMsgTitleWithCircleId:circleID talkType:MessageListTypeCircle title:circlename];
        [circle_member_list_model deleteAllCircleMmbersWithCircleID:circleID];
    }
    
    [circleMod release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotiCircleInfoChange object:nil];
//                    add vincent 圈子红点去掉
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"circleChangeLeftSiderNotice" object:nil];
    
}

-(void)recieveTempCircleInfoChangeNotify:(NSData *)data{
    NSDictionary * bodyDic = [headParseClass getBodyDic:data];
    
    long long circleID = [[bodyDic objectForKey:@"circleid"] longLongValue];
    int flag = [[bodyDic objectForKey:@"flag"] intValue];
    long long msgid = [[bodyDic objectForKey:@"msgid"] longLongValue];
    
    temporary_circle_list_model* tempCircleMod = [[temporary_circle_list_model alloc] init];
    tempCircleMod.where = [NSString stringWithFormat:@"temp_circle_id = %lld",circleID];
    
    NSString* circlename = [bodyDic objectForKey:@"circlename"];
    //flag：1修改 2删除
    if (flag == 1) {
        
        NSString* circledesc = [bodyDic objectForKey:@"circledesc"];
        
        NSMutableDictionary* circleDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          circlename,@"name",
                                          [NSNumber numberWithLongLong:msgid],@"msgid",
                                          nil];
        if (circledesc.length > 0) {
            [circleDic setObject:circledesc forKey:@"content"];
        }
        [tempCircleMod updateDB:circleDic];
        
        [self updateChatMsgTitleWithCircleId:circleID talkType:MessageListTypeTempCircle title:circlename];
        
    }else{
        //解散
        [tempCircleMod deleteDBdata];
        
        [self deleteChatMsgTitleWithCircleId:circleID talkType:MessageListTypeTempCircle title:circlename];
        
        [temporary_circle_member_list_model deleteAllTempCircleMmbersWithCircleID:circleID];
    }
    
    [tempCircleMod release];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"tempCircleInfoChangeNotify" object:nil];
}

-(void) updateChatMsgTitleWithCircleId:(long long) circleId talkType:(MessageListType) type title:(NSString*) title{
    chatmsg_list_model* chatMsgMod = [[chatmsg_list_model alloc] init];
    
    chatMsgMod.where = [NSString stringWithFormat:@"id = %lld and talk_type = %d",circleId,type];
    [chatMsgMod updateDB:[NSDictionary dictionaryWithObjectsAndKeys:
                          title,@"title",
                          nil]];
    
    [chatMsgMod release];
}

-(void) deleteChatMsgTitleWithCircleId:(long long) circleId talkType:(MessageListType) type title:(NSString*) title{
    chatmsg_list_model* chatMsgMod = [[chatmsg_list_model alloc] init];
    
    chatMsgMod.where = [NSString stringWithFormat:@"id = %lld and talk_type = %d",circleId,type];
    [chatMsgMod deleteDBdata];
    
    [chatMsgMod release];
}

//变更固定圈子msgid
-(void) updateCircleMsgid:(long long) msgid circleId:(long long) circleid{
    [circle_list_model insertOrUpdateDictionaryIntoCirlceList:[NSDictionary dictionaryWithObjectsAndKeys:
                                                               [NSNumber numberWithLongLong:circleid],@"circle_id",
                                                               [NSNumber numberWithLongLong:msgid],@"msgid",
                                                               nil]];
}

//变更临时圈子msgid
-(void) updateTempCircleMsgid:(long long) msgid circleId:(long long) circleid{
    [temporary_circle_list_model insertOrUpdateDictionaryIntoTempCirlceList:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                             [NSNumber numberWithLongLong:circleid],@"temp_circle_id",
                                                                             [NSNumber numberWithLongLong:msgid],@"msgid",
                                                                             nil]];
}

-(void) sendQuitCircleMessage:(NSDictionary *)dic{
    long long senderID = [[[Global sharedGlobal] user_id]longLongValue];
    long long receiverID = [[dic objectForKey:@"circle_id"]longLongValue];
    
    NSMutableData * data = [headParseClass generateSendDataWithCommand:CMD_QUIT_CIRCLE
                                                               version:IM_PACKAGE_NO_ENCRYPTION
                                                          serialNumber:0
                                                              senderID:senderID
                                                            receiverID:receiverID
                                                              andValue:[NSDictionary dictionary]];
    [[ChatTcpHelper shareChatTcpHelper] sendMessage:data withTimeout:-1 tag:0];
}

-(void) recieveQuitCircleMessage:(NSData *)data{
    ////解析包体数据
    NSString *bodyStr = [headParseClass parseIMPortPackaging:data];
    
    NSDictionary* bodyDic = [bodyStr JSONValue];

    [[NSNotificationCenter defaultCenter] postNotificationName:KNotiQuitCircle object:bodyDic];
}

-(void) sendQuitTempCircleMessage:(NSDictionary *)dic{
    NSDictionary* bodyDic = [NSDictionary dictionary];
    NSString* bodyStr = [bodyDic JSONRepresentation];
    NSData* bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    int length = bodyData.length;
    
    NSData* packageData = [headParseClass sendIMPortPackaging:length wCmd:CMD_QUIT_TEMP_CIRCLE srcUid:[[dic objectForKey:@"user_id"] longLongValue] destUid:[[dic objectForKey:@"temp_circle_id"] longLongValue]];
    
    NSMutableData* allData = [NSMutableData dataWithCapacity:0];
    [allData appendData:packageData];
    [allData appendData:bodyData];
    
    [[ChatTcpHelper shareChatTcpHelper] sendMessage:allData withTimeout:-1 tag:0];
}

-(void) recieveQuitTempCircleMessage:(NSData *)data{
    ////解析包体数据
    NSString *bodyStr = [headParseClass parseIMPortPackaging:data];
    
    NSDictionary* bodyDic = [bodyStr JSONValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotiQuitTempCircle object:bodyDic];
}

- (void)receiveCompelQuitMessage:(NSData *)data
{
    NSDictionary * bodyDic = [headParseClass getBodyDic:data];
    NSLog(@"receive Login out message %@",bodyDic);
    MessageData * quitMessage = [MessageData generateMessageDataWithMessageRetrieveDic:bodyDic];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiCompelQuitMessage object:quitMessage];
}

-(void) locaLnotifyWith:(NSDictionary*) speakInfo type:(int) objtype txt:(NSString*) txt{
    //本地推送
    if ([Global sharedGlobal].isBackGround) {
        //文本消息
        NSString* message = nil;
        //name
        NSString* nickName = [speakInfo objectForKey:@"nickname"];
        
        NSString* msgTxt = nil;
        
        switch (objtype) {
            case dataTypeText:
            {
                msgTxt = txt;
            }
                break;
            case dataTypePicture:
            {
                msgTxt = @"发来一张图片";
            }
                break;
            case dataTypeVoice:
            {
                msgTxt = @"发来一段语音";
            }
                break;
            default:
                break;
        }
        if (msgTxt != nil && nickName != nil && nickName.length != 0) {
            message = [NSString stringWithFormat:@"%@:%@",nickName,msgTxt];
        }
        
        [[LocalNotifyManager shareManager] showLocalNotifyMessage:message];
    }
}

#pragma mark - Dealloc
- (void)dealloc
{
    LOG_RELESE_SELF;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotiUpdateTempCircleInfo object:nil];
    RELEASE_SAFE(_waitForStoreData);
    [super dealloc];
}

@end
