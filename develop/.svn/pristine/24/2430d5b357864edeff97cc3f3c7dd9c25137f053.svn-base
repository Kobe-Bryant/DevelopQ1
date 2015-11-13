//
//  TemporaryCircleManager.m
//  ql
//
//  Created by LazySnail on 14-5-21.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TemporaryCircleManager.h"
#import "TcpRequestHelper.h"
#import "temporary_circle_list_model.h"
#import "temporary_circle_member_list_model.h"
#import "temporary_circle_chat_msg_model.h"
#import "chatmsg_list_model.h"
#import "NSString+MessageDataExtension.h"
#import "TextData.h"
#import "SBJson.h"
#import "PYMethod.h"

@interface TemporaryCircleManager ()
{
    
}

@property (nonatomic, assign) long long quitTempCircleID;

@end

@implementation TemporaryCircleManager
{
    BOOL _isCreate ;
}

+ (BOOL)deleteAllTempCircleDataInfoWithTempCircleID:(long long)TempCircleID
{
    BOOL successJuger =
    [temporary_circle_list_model deleteTemporaryCircleInfoWithCircleID:TempCircleID] &&
    [temporary_circle_member_list_model deleteAllTempCircleMmbersWithCircleID:TempCircleID]&&
    [chatmsg_list_model deleteChatMsgListWithTalkType:MessageListTypeTempCircle andID:TempCircleID];
    long long userID = [[[Global sharedGlobal]user_id]longLongValue];
    [temporary_circle_chat_msg_model deleteAllChatDataWithSenderID:TempCircleID andReceiverID:userID];
    
    return successJuger;
}

- (id)init{
    self = [super init];
    if (self != nil) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addTemporaryCircleMemberFeedback:) name:kNotiCreateTempCircleFb object:nil];
        _isCreate = NO;
    }
    return self;
}

- (void)createTemporaryCielre
{
    _isCreate = YES;
    [self addMemberFromMemberArr];
}

- (void)dismissTempCircleWithUserID:(long long)userID andTempCircleID:(long long)tempCircleID
{
    NSMutableDictionary * sendInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithLongLong:userID],@"user_id",
                                         [NSNumber numberWithLongLong:tempCircleID],@"temp_circle_id",
                                         nil];
    [[NetManager sharedManager]accessService:sendInfoDic data:nil command:TEMP_CIRCLE_DISMISS_COMMAND_ID accessAdress:@"tempcircle/delete.do?param=" delegate:self withParam:sendInfoDic];
}

- (void)addTemporaryCircleMemberFeedback:(NSNotification *)noti
{
    NSDictionary * dic = [noti object];
    NSNumber * circle_id = [dic objectForKey:@"circleid"];
    NSNumber *timeNum = [NSNumber numberWithInt:[[NSDate date]timeIntervalSince1970]];
    NSDictionary * insertMsgListDic = nil;
    
    if ([[dic objectForKey:@"rcode"]intValue] == 0 ) {
        if (_isCreate) {
            NSMutableString * nameStr = [[NSMutableString alloc]init];
            NSMutableArray * porMuArr = [[NSMutableArray alloc]init];
            
            for (int i = 0;i < self.memberArr.count; i ++) {
                NSDictionary * dic = [self.memberArr objectAtIndex:i];
                if (i != self.memberArr.count - 1 && i < 2 ) {
                    NSString * nameItem = [NSString stringWithFormat:@"%@、",[dic objectForKey:@"realname"]];
                    [nameStr appendString:nameItem];
                    [porMuArr addObject:[dic objectForKey:@"portrait"]];
                    
                } else {
                    NSString * nameItem2 = [NSString stringWithFormat:@"%@",[dic objectForKey:@"realname"]];
                    [nameStr appendString:nameItem2];
                    [porMuArr addObject:[dic objectForKey:@"portrait"]];
                }
                
                if (i == 2) {
                    break;
                }
            }
            
            TextData *tData = [TextData new];
            NSString * tDataJsonStr =[NSString getStrWithMessageDatas:tData,nil];
            RELEASE_SAFE(tData);
            
            NSString * porMuArrStr = [porMuArr JSONRepresentation];
            
            insertMsgListDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                       circle_id,@"id",
                                       [NSNumber numberWithInt:MessageListTypeTempCircle],@"talk_type",nameStr,@"title",
                                       timeNum,@"send_time",
                                       porMuArrStr,@"icon_path",
                                       tDataJsonStr,@"content",
                                       nil];
            // 创建列表项
            [chatmsg_list_model insertOrUpdateRecordWithDic:insertMsgListDic];
            
            //将临时圈子信息写入临时圈子数据库表中
            NSString * realName = [[[Global sharedGlobal]userInfo]objectForKey:@"realname"];
            NSString * firstLatter = [PYMethod getPinYin:[realName substringToIndex:1]];
            NSDictionary * insertTCDic = [NSDictionary dictionaryWithObjectsAndKeys:circle_id,@"temp_circle_id",nameStr,@"name",firstLatter,@"front_character",realName,@"creater_name",[NSNumber numberWithInt:1],@"user_sum",porMuArrStr,@"portrait",[NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"creater_id",nil];
            
            [temporary_circle_list_model insertOrUpdateDictionaryIntoTempCirlceList:insertTCDic];
            RELEASE_SAFE(nameStr);
            RELEASE_SAFE(porMuArr);
            
        }
        
        NSMutableArray * insertTCArr = [[NSMutableArray alloc]init];
        for (NSDictionary * dic in self.memberArr) {
            NSDictionary *insertTCDic = [NSDictionary dictionaryWithObjectsAndKeys:circle_id,@"circle_id",[dic objectForKey:@"user_id"],@"user_id",[dic objectForKey:@"realname"],@"realname",[dic objectForKey:@"portrait"],@"portrait",[dic objectForKey:@"role"],@"role",timeNum,@"created",nil];
            [insertTCArr addObject:insertTCDic];
        }
        
        //将数据信息插入临时圈子的成员列表
        temporary_circle_member_list_model * tcListGeter = [temporary_circle_member_list_model new];
        for (NSDictionary * insertTCMDIC in insertTCArr) {
            NSString *whereStr = [NSString stringWithFormat:@"circle_id = %lld and user_id = %lld",circle_id.longLongValue,[[insertTCMDIC objectForKey:@"user_id"]longLongValue]];
            tcListGeter.where = whereStr;
            NSArray *tcList = [tcListGeter getList];
            if (tcList.count > 0) {
                [tcListGeter updateDB:insertTCMDIC];
            } else {
                [tcListGeter insertDB:insertTCMDIC];
            }
        }
        
        RELEASE_SAFE(tcListGeter);
        RELEASE_SAFE(insertTCArr);
        
        if (circle_id.intValue != 0 && _isCreate) {
            [self.tempdelegate createTemporaryCircleSuccessWithSender:self CircleDic:insertMsgListDic];
        } else {
            [self.tempdelegate addMemberSuccessWithSender:self CircleID:circle_id.longLongValue];
        }
    }else {
        if (_isCreate) {
            [Common checkProgressHUD:@"哦豁 创建临时会话失败了!!" andImage:nil showInView:APPKEYWINDOW];
        } else {
            [Common checkProgressHUD:@"哦豁 添加圈子成员失败" andImage:nil showInView:APPKEYWINDOW];
        }
    }
}

- (void)addMemberFromMemberArr
{
    NSMutableArray * insertSelfArr = [NSMutableArray arrayWithArray:self.memberArr];
    if (_isCreate) {
        // 通过个人信息来作判断，如果已经在联系人列表里面选择了则不插入，如果为选择则插入
        NSDictionary *userInfo =[[Global sharedGlobal]userInfo];
        
        NSDictionary * selfDic = nil;
        
        if (userInfo != nil) {
            selfDic = [NSDictionary dictionaryWithObjectsAndKeys:[userInfo objectForKey:@"id"],@"user_id",[userInfo objectForKey:@"portrait"],@"portrait",[userInfo objectForKey:@"front_character"],@"front_character",[userInfo objectForKey:@"company_name"],@"company_name",[userInfo objectForKey:@"realname"],@"realname",[userInfo objectForKey:@"role"],@"role", nil];
        }
        
        for (int i = 0; i < insertSelfArr.count; i ++) {
            NSDictionary * judgeDic = [insertSelfArr objectAtIndex:i];
            long long judgeID = [[judgeDic objectForKey:@"user_id"]longLongValue];
            if (judgeID == [[selfDic objectForKey:@"user_id"]longLongValue]) {
                selfDic = nil;
            }
        }
        if (selfDic != nil) {
            [insertSelfArr addObject:selfDic];
            self.memberArr = [NSArray arrayWithArray:insertSelfArr];
        }
    }

    NSMutableArray * uidList = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in insertSelfArr) {
        NSNumber * uid = [dic objectForKey:@"user_id"];
        [uidList addObject:uid];
    }
    
    if (_isCreate) {
        [[TcpRequestHelper shareTcpRequestHelperHelper]sendCreateTemporaryCircleRequestWithUserList:uidList];
    } else {
        [[TcpRequestHelper shareTcpRequestHelperHelper] sendAddTemporaryCircleRequestWithUserList:uidList AndTempCircleID:self.tempCircleID];
    }
    
    RELEASE_SAFE(uidList);
}

- (void)removeTemporaryMemberWithTempCircleID:(long long)tempCircleID AndMemebrID:(long long)memberID
{
    NSMutableDictionary * deleteInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithLongLong:memberID],@"user_id",
                                           [NSNumber numberWithLongLong:tempCircleID],@"circle_id",
                                           //圈子类型 0 为固定圈子 1 为临时圈子
                                           [NSNumber numberWithInt:1],@"circle_type",
                                           nil];
    NSMutableDictionary * paramDic = [NSMutableDictionary dictionaryWithDictionary:deleteInfoDic];
    
    NSString * interfaceStr = @"circle/removecircle.do?param=";
    
    [[NetManager sharedManager]accessService:deleteInfoDic data:nil command:CIRCLE_MEMBER_DELETE_COMMAND_ID accessAdress:interfaceStr delegate:self withParam:paramDic];
}

- (void)quitTempCircleWithCircleID:(long long)tempCircleID
{
    NSDictionary * headDic = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSNumber numberWithLongLong:tempCircleID],@"temp_circle_id",
               [NSNumber numberWithLongLong:[[Global sharedGlobal].user_id longLongValue]],@"user_id",
               nil];
    
    [[TcpRequestHelper shareTcpRequestHelperHelper] sendQuitTempCircleMessage:headDic];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitTempCircleSuccess:) name:KNotiQuitTempCircle object:nil];
}

- (void)quitTempCircleSuccess:(NSNotification *)notification
{
    NSDictionary * quitFeedback = [notification object];
    if ([[quitFeedback objectForKey:@"rcode"]intValue] == 0) {
        [TemporaryCircleManager deleteAllTempCircleDataInfoWithTempCircleID:self.tempCircleID];
    } else {
        [Common checkProgressHUDShowInAppKeyWindow:[quitFeedback objectForKey:@"other"]  andImage:nil];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KNotiQuitTempCircle object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotiCreateTempCircleFb object:nil];
    [super dealloc];
}

@end
