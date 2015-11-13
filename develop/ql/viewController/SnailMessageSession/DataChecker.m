//
//  DataChecker.m
//  ql
//
//  Created by LazySnail on 14-5-26.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "DataChecker.h"
#import "temporary_circle_list_model.h"
#import "temporary_circle_member_list_model.h"
#import "circle_list_model.h"
#import "circle_member_list_model.h"
#import "chatmsg_list_model.h"
#import "SBJson.h"
#import "circle_contacts_model.h"
#import "org_member_list_model.h"
#import "PYMethod.h"

@implementation DataChecker

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ifModifyChatList = YES;
        return self;
    }
    return nil;
}

- (BOOL)checkTempCirleExistWithID:(NSNumber *)tempCircleId
{
    NSDictionary * tcDic = [temporary_circle_list_model getTemporaryCircleListWithTempCircleID:tempCircleId.longLongValue];
    
    NSArray * memberArr = [temporary_circle_member_list_model  getAllMemberFormTempCircle:tempCircleId.longLongValue];
    if (tcDic != nil && memberArr.count != 0 ) {
        return YES;
    } else {
        return NO;
    }
}

- (void)updateTempCircleInfoWithID:(NSNumber *)tempCirleId
{
    NSMutableDictionary * requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 tempCirleId,@"id",
                                 [NSNumber numberWithInt:0],@"circle_ver",
                                 [NSNumber numberWithInt:0],@"member_ver",
                                 nil];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:tempCirleId,@"circle_id",nil];
    
    [[NetManager sharedManager]accessService:requestDic data:nil command:TEMPRORAY_INFO_COMMAND_ID accessAdress:@"tempcircle/detail.do?param=" delegate:self withParam:param];
}

- (void)updateCircleInfoWithID:(long long)circleID
{
    NSMutableDictionary * requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithLongLong:circleID],@"circle_id",
                                        [NSNumber numberWithInt:[Global sharedGlobal].org_id.intValue],@"org_id",
                                        nil];
    [[NetManager sharedManager]accessService:requestDic data:nil command:CIRCLE_INFO_COMMAND_ID accessAdress:@"circle/info.do?param=" delegate:self withParam:requestDic];
}

- (void)updateOrgInfoWithOrgID:(long long)orgID
{
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                                        [NSNumber numberWithLongLong:orgID],@"org_id",
                                        nil];
	
	[[NetManager sharedManager]accessService:requestDic data:nil command:ORG_MEMBER_LIST_COMMAND_ID accessAdress:@"organizationdetail.do?param=" delegate:self withParam:requestDic];
}

#pragma HttpRequestDelegate 

- (void)didFinishCommand:(NSMutableArray *)resultArray cmd:(int)commandid withVersion:(int)ver
{
    ParseMethod safeMethod = ^(){
        switch (commandid) {
            case ORG_MEMBER_LIST_COMMAND_ID:
            {
                NSDictionary * resultDic = [resultArray firstObject];
                NSDictionary * paramDic = [resultArray lastObject];
                
                NSArray * memberArr = [resultDic objectForKey:@"members"];
                
                for (NSDictionary * orgMemberDic in memberArr) {
                    NSNumber * orgID = [paramDic objectForKey:@"org_id"];
                    
                    NSMutableDictionary * orgMemberInsertDic = [NSMutableDictionary dictionaryWithDictionary:orgMemberDic];
                    [orgMemberInsertDic setValue:orgID forKey:@"org_id"];
                    
                    [org_member_list_model insertOrUpdateOrgMemberListWithDic:orgMemberInsertDic];
                }
                [self.delegate dataCheckerUpdateOrganizationInfoSuccessWithSender:self];
            }
                break;
            case TEMPRORAY_INFO_COMMAND_ID:
            {
                NSLog(@"Get tempCirle info %@",resultArray);
                NSDictionary * resultDic = [resultArray firstObject];
                NSDictionary * param = [resultArray lastObject];
                
                
                temporary_circle_member_list_model *tcmListGeter =[temporary_circle_member_list_model new];
                NSArray * memberArr = [resultDic objectForKey:@"members"];
                NSMutableArray * memberPorMuArr = [NSMutableArray new];
                NSMutableString * titleStr = [NSMutableString new];
                NSDictionary * createrDic = nil;
                int sumCount = 0;
                
                for (int i = 0; i < memberArr.count ; i++) {
                    NSDictionary * dic = [memberArr objectAtIndex:i];
                    NSNumber * user_id = [dic objectForKey:@"id"];
                    
                    //查找联系人 然后将其对应于服务器得到的memberID 然后插入临时圈子联系人表中
                    circle_contacts_model * ccListGeter = [circle_contacts_model new];
                    ccListGeter.where = [NSString stringWithFormat:@"user_id = %lld",user_id.longLongValue];
                    NSArray * ccList = [ccListGeter getList];
                    if (ccList.count > 0) {
                        NSDictionary * contactDic = [ccList firstObject];
                        
                        if (memberPorMuArr.count < 3) {
                            [memberPorMuArr addObject:[contactDic objectForKey:@"portrait"]];
                            if (memberPorMuArr.count == memberArr.count || memberPorMuArr.count == 3) {
                                [titleStr appendString:[NSString stringWithFormat:@"%@",[contactDic objectForKey:@"realname"]]];
                            }else {
                                [titleStr appendString:[NSString stringWithFormat:@"%@、",[contactDic objectForKey:@"realname"]]];
                            }
                        }
                        
                        NSDictionary * insertDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    [param objectForKey:@"circle_id"],@"circle_id",
                                                    [contactDic objectForKey:@"user_id"],@"user_id",
                                                    [contactDic objectForKey:@"realname"],@"realname",
                                                    [contactDic objectForKey:@"portrait"],@"portrait",
                                                    [contactDic objectForKey:@"role"],@"role",
                                                    [NSNumber numberWithInt:[[NSDate date]timeIntervalSince1970]],@"created"
                                                    , nil];
                        if ([[contactDic objectForKey:@"user_id"]longLongValue] == [[[resultDic objectForKey:@"circle"]objectForKey:@"user_id"]longLongValue]) {
                            createrDic = insertDic;
                        }
                        
                        tcmListGeter.where = [NSString stringWithFormat:@"circle_id = %lld and user_id = %lld",[[param objectForKey:@"circle_id"]longLongValue],[[contactDic objectForKey:@"user_id"]longLongValue]];
                        NSArray * tcmlist = [tcmListGeter getList];
                        if (tcmlist.count > 0) {
                            [tcmListGeter updateDB:insertDic];
                        } else {
                            [tcmListGeter insertDB:insertDic];
                        }
                        sumCount ++;
                    }
                    RELEASE_SAFE(ccListGeter);
                }
                
                RELEASE_SAFE(tcmListGeter);
                
                NSString *name = [[resultDic objectForKey:@"circle"]objectForKey:@"name"];
                
                //----7.2 booky----//
                NSNumber* creater_id = [[resultDic objectForKey:@"circle"] objectForKey:@"user_id"];
                NSNumber* circle_id = [[resultDic objectForKey:@"circle"] objectForKey:@"id"];
                
                if (name == nil || [name isEqualToString:@""]) {
                    name = titleStr;
                }
                
                NSString *firstLatter = nil;

                if (name != nil && name.length >1) {
                   firstLatter = [PYMethod getPinYin:[name substringWithRange:NSMakeRange(0, 1)]];
                }
                
                temporary_circle_list_model * tcListGeter = [[temporary_circle_list_model alloc]init];
                NSDictionary * tcInsertDic =[NSDictionary dictionaryWithObjectsAndKeys:
                                             name,@"name",
                                             [memberPorMuArr JSONRepresentation],@"portrait",
                                             firstLatter,@"front_character",
                                             [createrDic objectForKey:@"realname"],@"creater_name",
                                             [NSNumber numberWithInt:sumCount],@"user_sum",
                                             creater_id,@"creater_id",
                                             circle_id,@"temp_circle_id",
                                             nil];
                
                tcListGeter.where = [NSString stringWithFormat:@"temp_circle_id = %lld",[[param objectForKey:@"circle_id"]longLongValue]];
                NSArray * tclist = [tcListGeter getList];
                if (tclist.count > 0) {
                    [tcListGeter updateDB:tcInsertDic];
                } else {
                    [tcListGeter insertDB:tcInsertDic];
                }
                NSDictionary * listDic =  [chatmsg_list_model getListDicWithTalkType:MessageListTypeTempCircle andID:circle_id.longLongValue];
                if (listDic!= nil) {
                    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                          circle_id,@"id",
                                          [NSNumber numberWithInt:MessageListTypeTempCircle],@"talk_type",
                                          name,@"title"
                                          , nil];
                    [chatmsg_list_model insertOrUpdateRecordWithDic:dic];
                }
                
                RELEASE_SAFE(memberPorMuArr);
                RELEASE_SAFE(tcListGeter);
                [resultArray addObject:name];
                RELEASE_SAFE(titleStr);
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotiUpdateTempCircleInfo object:resultArray];
            }
                break;
            case CIRCLE_INFO_COMMAND_ID:
            {
                NSLog(@"update circle info %@",resultArray);
                NSDictionary *resultDic = [resultArray firstObject];
                
                NSDictionary * circleInfo = [resultDic objectForKey:@"circle"];
                
                NSNumber * circleID = [circleInfo objectForKey:@"id"];
                NSNumber * user_sum = [circleInfo objectForKey:@"user_sum"];
                NSString * portrait = [circleInfo objectForKey:@"image_path"];
                NSString * signature = [circleInfo objectForKey:@"content"];
                NSString * createrName = [circleInfo objectForKey:@"creater_name"];
                NSString * circleName = [circleInfo objectForKey:@"name"];
                NSNumber * createrID = [circleInfo objectForKey:@"user_id"];
                
                NSDictionary * insertCircleListDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      circleID,@"circle_id",
                                                      user_sum,@"user_sum",
                                                      portrait,@"portrait",
                                                      signature,@"content",
                                                      circleName,@"name",
                                                      createrName,@"creater_name",
                                                      createrID,@"creater_id",
                                                      nil];
                [circle_list_model insertOrUpdateDictionaryIntoCirlceList:insertCircleListDic];
                
                NSArray * memberArr = [circleInfo objectForKey:@"members"];
                NSMutableArray * contacts = [NSMutableArray new];
                
                for (NSDictionary * dic in memberArr)
                {
                    NSMutableDictionary * insertCircleMemberDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                    
                    [insertCircleMemberDic setObject:circleID forKey:@"circle_id"];
                    [circle_member_list_model insertOrUpdateDictionaryIntoCirlceMemberList:insertCircleMemberDic];
                    
                    [contacts addObject:insertCircleMemberDic];
                }
                
                NSDictionary * portraitNameDic = [Common generatePortraitNameDicJsonStrWithContactArr:contacts];
                NSArray * portraitsArr = [portraitNameDic objectForKey:@"icon_path"];
                NSString * portraitJsonStr = [portraitsArr JSONRepresentation];
                
                
                // 更新聊天列表圈子的头像 换成前三个人的头像少于三人的话就全部加上
                if (self.ifModifyChatList) {
                    NSDictionary * updateDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                circleID,@"id",
                                                [NSNumber numberWithInt:MessageListTypeCircle],@"talk_type",
                                                circleName,@"title",
                                                portraitJsonStr,@"icon_path",nil];
                    if ([chatmsg_list_model insertOrUpdateRecordWithDic:updateDic] != YES) {
                        [Common checkProgressHUD:@"更新圈子头像和信息出问题" andImage:nil showInView:APPKEYWINDOW];
                    }
                }
                
                [self.delegate dataCheckerUpdateCircleInfoSuccessWithSender:self andCircleContects:contacts];
            }
                break;
            default:
                break;
        }
    };
    
    [Common securelyparseHttpResultArr:resultArray andMethod:safeMethod];
}

@end
