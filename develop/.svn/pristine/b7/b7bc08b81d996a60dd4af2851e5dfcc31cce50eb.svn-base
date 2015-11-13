//
//  CommandOperationParser.m
//  ASIHttp
//
//  Created by yunlai on 13-5-29.
//  Copyright (c) 2013年 yunlai. All rights reserved.
//

#import "CmdOperationParser.h"
#import "SBJson.h"
#import "NSObject+SBJson.h"
#import "JSONKit.h"
#import "Common.h"
#import "Global.h"
#import "HttpRequest.h"
#import "login_info_model.h"
#import "login_organization_model.h"
#import "member_card_model.h"
#import "org_list_model.h"
#import "circle_list_model.h"
#import "circle_member_list_model.h"
#import "org_member_list_model.h"
#import "dynamic_card_model.h"
#import "dynamic_relationme_model.h"
#import "dynamic_commentList_model.h"
#import "dynamic_support_model.h"
#import "userInfo_setting_model.h"
#import "user_circles_model.h"
#import "mainpage_company_model.h"
#import "mainpage_newpublish_model.h"
#import "mainpage_userInfo_model.h"
#import "mainpage_supplydemand_model.h"
#import "mianpage_company_dynamic_model.h"
#import "mainpage_openeduser_model.h"
#import "set_config_model.h"
#import "tool_privilege_model.h"
#import "circle_contacts_model.h"
#import "upgrade_model.h"
#import "secret_message_model.h"
#import "secretary_model.h"
#import "chooseOrg_model.h"
#import "chatmsg_list_model.h"
#import "PictureData.h"
#import "MessageData.h"
#import "MessageDataManager.h"
#import "TextData.h"
#import "welcome_info_model.h"
#import "set_aboutUs_model.h"
#import "temporary_circle_list_model.h"
#import "temporary_circle_member_list_model.h"
#import "PYMethod.h"
#import "theme_config_model.h"
#import "tool_tools_model.h"


@implementation CmdOperationParser

+(NSMutableArray*)parser:(int)commandId withJsonResult:(NSString*)jsonResult withVersion:(int*)ver withParam:(NSMutableDictionary*)param
{
    NSMutableArray *resultArray = nil;

    NSDictionary *resultDic = [jsonResult objectFromJSONString];
    
    if (resultDic != nil && resultDic.count > 0) {

            // 根据 commandId 来确定解析数据的操作
            switch (commandId)
            {
                case CHAT_EMOTICON_MODIFY_COMMAND_ID:
                {
                    resultArray = [self parseNormalFeedBack:resultDic getVersion:ver andParam:param];
                }
                    break;
                case CHAT_EMOTION_DETAIL_COMMAND_ID:
                {
                    resultArray = [self parseNormalFeedBack:resultDic getVersion:ver andParam:param];
                }
                    break;
                case CHAT_EMOTION_STORE_GET_INFO_COMMAND_ID:
                {
                    resultArray = [self parseNormalFeedBack:resultDic getVersion:ver andParam:param];
                }
                    break;
                case APNS_COMMAND_ID:
                {
                    resultArray = [self parseApns:resultDic getVersion:ver];
                }
                    break;
                case GUIDE_COMMAND_ID:
                {
                    resultArray = [self parseHotwrite:resultDic];
                }
                    break;
                case MEMBER_INVITED_COMMAND_ID:
                {
                    resultArray = [self parseInvitecode:resultDic getVersion:ver];
                }
                    break;
                    
                case MEMBER_AUTHCODE_COMMAND_ID:
                {
                    resultArray = [self parsesendAuthcode:resultDic];
                }
                    break;
                   
                case MEMBER_VERIFY_CODE_COMMAND_ID:
                {
                    resultArray = [self parsesendVerifycode:resultDic];
                }
                    break;
                    
                case MEMBER_LOGIN_COMMAND_ID:
                {
                    resultArray = [self parseLogin:resultDic andParam:param];
                }
                    break;
                case MEMBER_REGIST_COMMAND_ID:
                {
                    resultArray = [self parseRegister:resultDic];
                }
                    break;
                    
                case MEMBER_UPDATEPIMAGE_COMMAND_ID:
                {
                    resultArray = [self parseUpdateimgs:resultDic];
                }
                    break;
                    
                case VALIDATE_MOBILE_COMMAND_ID:
                {
                    resultArray = [self parseVerifyMoblie:resultDic];
                }
                    break;
                case MEMBER_UPDATEPWD_COMMAND_ID:
                {
                    resultArray = [self parseUpdatepwd:resultDic];
                }
                    break;
                    
                case MEMBER_LOGOUT_COMMAND_ID:
                {
                    resultArray = [self parseLogout:resultDic];
                }
                    break;
                    
                case MEMBER_QRCODE_COMMAND_ID:
                {
                    resultArray = [self parseQrcode:resultDic];
                }
                    break;
                    
                case MEMBER_CARD_COMMAND_ID:
                {
                    resultArray = [self parseCard:resultDic];
                }
                    break;
                case CIRCLE_MEMBER_DUTY_COMMAND_ID:
                {
                    resultArray = [self parseGroupMemberUpdateDuty:resultDic];
                }
                    break;
                    
                case MEMBER_LISTINFO_COMMAND_ID:
                {
                    resultArray = [self parseNotifylist:resultDic];
                }
                    break;
                case USERINFO_UPDATE_COMMAND_ID:
                {
                    resultArray = [self parseUpdataUserInfos:resultDic];
                }
                    break;
                case DYNAMIC_MAINLIST_COMMAND_ID:
                case DYNAMIC_MAINLIST_MORE_COMMAND_ID:
                {
                    resultArray = [self parseDynamicList:resultDic withCommandId:commandId];
                }
                    break;
                case DYNAMIC_RELATIONME_COMMAND_ID:
                {
                    resultArray = [self parseDynamicRelationme:resultDic];
                }
                    break;
                case DYNAMIC_SUPPORT_COMMAND_ID:
                {
                    resultArray = [self parseSupport:resultDic];
                }
                    break;
                case DYNAMIC_OOXX_COMMAND_ID:
                case DYNAMIC_OOXX_CANCEL_COMMAND_ID:
                {
                    resultArray = [self parseOOXX:resultDic];
                }
                    break;
                case DYNAMIC_COMMENTLIST_COMMAND_ID:
                case DYNAMIC_COMMENTLIST_MORE_COMMAND_ID:
                {
                    resultArray = [self parseCommentList:resultDic];
                }
                    break;
                case DYNAMIC_SUPPORTLIST_MORE_COMMAND_ID:
                {
                    resultArray = [self parseSupport:resultDic];
                }
                    break;
                case DYNAMIC_DELETECOMMENT_COMMAND_ID:
                {
                    resultArray = [self parseDeleteComment:resultDic];
                }
                    break;
                case DYNAMIC_PUBLISH_NEWS_COMMAND_ID:
                {
                    resultArray = [self parsePublishNews:resultDic];
                }
                    break;
                case DYNAMIC_PUBLISH_COMMENT_COMMAND_ID:
                {
                    resultArray = [self parsePublishComment:resultDic];
                }
                    break;
                case DYNAMIC_ABOUTMEMSGLIST_COMMAND_ID:
                case DYNAMIC_ABOUTMEMSGLIST_MORE_COMMAND_ID:
                {
                    resultArray = [self parseAboutMeMsgList:resultDic];
                }
                    break;
                case DYNAMIC_DETAIL_COMMAND_ID:
                {
                    resultArray = [self parseDynamicDetail:resultDic];
                }
                    break;
                case DYNAMIC_TOGETHER_COMMAND_ID:
                {
                    resultArray = [self parseJoinTogether:resultDic];
                }
                    break;
                case SET_FEEDBACK_COMMAND_ID:
                {
                    resultArray = [self parseFeedBackComment:resultDic];
                }
                    break;
                case SET_ABOUTUS_COMMAND_ID:
                {
                    resultArray = [self parseAboutUs:resultDic];
                }
                    break;
                case SET_MSGSET_COMMAND_ID:
                {
                    resultArray = [self parseMsgSet:resultDic];
                }
                    break;
                case SET_CHECKNEWVER_COMMAND_ID:
                {
                    resultArray = [self parseCheckNewVer:resultDic];
                }
                    break;
                case GROUP_LIST_COMMAND_ID:
                {
                    resultArray = [self parseAddressbook:resultDic getVersion:ver];
                }
                    break;
                case GROUP_CREATE_COMMAND_ID:
                {
                    resultArray = [self parseCreateCircle:resultDic];
                }
                    break;
                case GROUP_CONTACTLIST_COMMAND_ID:
                {
                    resultArray = [self parseGroupAllMember:resultDic];
                }
                    break;
                case INVITE_OTHER_COMMAND_ID:
                {
                    resultArray = [self parseNormalFeedBack:resultDic getVersion:ver andParam:param];
                }
                    break;
                case GROUP_MEMBER_LIST_COMMAND_ID:
                {
                    resultArray = [self parseCircleMember:resultDic getVersion:ver andCircleDic:param];
                }
                    break;
                case ORG_MEMBER_LIST_COMMAND_ID:
                {
                    resultArray = [self parseNormalFeedBack:resultDic getVersion:ver andParam:param];
                }
                    break;
                case CIRCLE_NAME_COMMAND_ID:
                {
                    resultArray = [self parseCircleIntroUpdate:resultDic];
                }
                    break;
                case CIRCLE_INTRO_COMMAND_ID:
                {
                    resultArray = [self parseOrgMemberList:resultDic getVersion:ver];
                }
                    break;
                case REMOVE_MEMBER_COMMAND_ID:
                {
                    resultArray = [self parseRemoveMember:resultDic];
                }
                    break;
                case TOOL_PRIVILEGELIST_COMMAND_ID:
                {
                    resultArray = [self parsePrivilegeList:resultDic];
                }
                    break;
                case CHAT_WELCOME_COMMAND_ID:
                {
                    resultArray = [self parseWelcomeInfoList:resultDic];
                }
                    break;
                    
                case MIANPAGE_INFO_COMMAND_ID:
                {
                    resultArray = [self parseMainPageUserinfo:resultDic];
                }
                    break;
                case INVITE_COMPANY_COMMAND_ID:
                {
                    resultArray = [self parseInvitecompany:resultDic];
                }
                    break;
                case MAINPAGE_LIKELIST_COMMAND_ID:
                {
                    resultArray = [self parseLikelist:resultDic];
                }
                    break;
                case MAINPAGE_VISITLIST_COMMAND_ID:
                {
                    resultArray = [self parseVisitlist:resultDic];
                }
                    break;
                case MAINPAGE_LIKELIST_MORE_COMMAND_ID:
                {
                    resultArray = [self parseLikelistMore:resultDic];
                }
                    break;
                    
                case MAINPAGE_VISITLIST_MORE_COMMAND_ID:
                {
                    resultArray = [self parseVisitlistMore:resultDic];
                }
                    break;
                case MEMBER_NOCOUNTTIPS_COMMAND_ID:
                {
                    resultArray = [self parseNoAcoutTips:resultDic];
                }
                    break;
                case MIANPAGE_INFO_OTHER_COMMAND_ID:
                {
                    resultArray = [self parseMainPageUserOtherInfo:resultDic];
                }
                    break;
                case MAINPAGE_DYNAMIC_COMMAND_ID:
                {
                    resultArray = [self parseMyDynamics:resultDic];
                }
                    break;
                case MAINPAGE_DYNAMIC_MORE_COMMAND_ID:
                {
                    resultArray = [self parseMyDynamicMore:resultDic];
                }
                    break;
                case MAINPAGE_SUPPLUYDEMAND_COMMAND_ID:
                {
                    resultArray = [self parseMySupplyDecand:resultDic];
                }
                    break;
                case MAINPAGE_DELETEDYANMIC_COMMAND_ID:
                {
                    resultArray = [self parseDeleteDynamic:resultDic];
                }
                    break;
                case TEMPRORAY_INFO_COMMAND_ID:
                {
                    resultArray = [self parseTempCircleInfor:resultDic getVersion:ver andParam:param];
                }
                    break;
                case CHAT_PICTURE_DATA_SEND_COMMAND_ID:
                {
                    resultArray = [self parseSendPictureMessageSuccessInfoWith:resultDic getVersion:ver andParam:param];
                }
                    break;
                case CIRCLE_MEMBER_DELETE_COMMAND_ID:
                {
                    resultArray = [self parseDeleteCircleMemberFeedbackWith:resultDic getVersion:ver andParam:param];
                }
                    break;
                case CIRCLE_DISMISS_COMMAND_ID:
                {
                    resultArray = [self parseDismissCircleFeedback:resultDic getVersion:ver andParam:param];
                }
                    break;
                case CIRCLE_INFO_COMMAND_ID:
                {
                    resultArray = [self parseCircleInfo:resultDic getVersion:ver andParam:param];
                }
                    break;
                case TEMP_CIRCLE_DISMISS_COMMAND_ID:
                {
                    resultArray = [self parseTempCircleDismissFeedback:resultDic getVersion:ver andParam:param];
                }
                    break;
                case CHAT_VOICE_DATA_SEND_COMMAND_ID:
                {
                    resultArray = [self parseNormalFeedBack:resultDic getVersion:ver andParam:param];
                }
                    break;
                case TOOL_LIST_COMMAND_ID:
                {
                    resultArray = [self parseToolList:resultDic];
                }
                    break;
                case CHANGE_SCREENIMAGE_ID:
                {
                    resultArray = [self parseChangeScreenImage:resultDic];
                }
                    break;
                case CONTENT_MODIFY_NOTICE_ID:
                {
                    resultArray = [self parseContentModifyNotice:resultDic];
                }
                    break;
                case BIND_CIRCLE_COMMAND_ID:
                {
                    resultArray = [self parseBindCircle:resultDic];
                }
                    break;
                default:
                    break;
            }

    } else {
        resultArray = [NSMutableArray arrayWithObject:CwRequestTimeout];
    }

    return resultArray;
}

//解析上传音频文件成功回馈
+ (NSMutableArray *)parseNormalFeedBack:(NSDictionary *)resultDic getVersion:(int *)ver andParam:(NSMutableDictionary *)param
{
    NSMutableArray * resultArr = [NSMutableArray arrayWithObjects:resultDic,param,nil];
    return resultArr;
}


//收到解散临时圈子反馈解析方法
+ (NSMutableArray *)parseTempCircleDismissFeedback:(NSDictionary *)resultDic getVersion:(int *)ver andParam:(NSMutableDictionary *)param
{
    NSMutableArray * resultArr = [NSMutableArray arrayWithObjects:resultDic,param,nil];
    return resultArr;
}

//解析固定圈子详细信息并且插入到数据库
+ (NSMutableArray *)parseCircleInfo:(NSDictionary *)resultDic getVersion:(int *)ver andParam:(NSMutableDictionary *)param
{
       
    NSMutableArray * resultArr = [NSMutableArray arrayWithObjects:resultDic,param,nil];
    return resultArr;
}

//解散圈子回馈
+ (NSMutableArray *)parseDismissCircleFeedback:(NSDictionary *)resultDic getVersion:(int *)ver andParam:(NSMutableDictionary *)param
{
    NSMutableArray * resultArr = [NSMutableArray arrayWithObjects:resultDic,param,nil];
    return resultArr;
}

//解析删除成员回馈数据
+ (NSMutableArray *)parseDeleteCircleMemberFeedbackWith:(NSDictionary *)resultDic getVersion:(int *)ver andParam:(NSMutableDictionary *)param
{
    NSMutableArray * resultArr = [NSMutableArray arrayWithObjects:resultDic,param,nil];
    return resultArr;
}

//传输图片成功解析图片的地址
+ (NSMutableArray *)parseSendPictureMessageSuccessInfoWith:(NSDictionary *)resultDic getVersion:(int *)ver andParam:(NSMutableDictionary *)param
{
    NSMutableArray * resultArr = [NSMutableArray arrayWithObjects:resultDic,param,nil];
    return resultArr;
}

//获取临时圈子信息
+ (NSMutableArray *)parseTempCircleInfor:(NSDictionary *)resultDic getVersion:(int *)ver andParam:(NSMutableDictionary *)param
{
    NSMutableArray * returnArr = [NSMutableArray arrayWithObjects:resultDic,param,nil];
    return returnArr;
}

//设备令牌接口
+ (NSMutableArray*)parseApns:(NSDictionary *)resultDic getVersion:(int*)ver
{
    return [NSMutableArray arrayWithObjects:resultDic,nil];
}

// 首页动态展示
+ (NSMutableArray*)parseHotwrite:(NSDictionary *)resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}


// 邀请码
+ (NSMutableArray*)parseInvitecode:(NSDictionary *)resultDic getVersion:(int*)ver{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];

    [arry addObject:resultDic];
    return arry;
}

// 会员验证码
+ (NSMutableArray*)parsesendAuthcode:(NSDictionary *)resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// 会员验证手机号和验证码
+ (NSMutableArray*)parsesendVerifycode:(NSDictionary *)resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// 验证手机号
+ (NSMutableArray*)parseVerifyMoblie:(NSDictionary *)resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// 会员登录
+ (NSMutableArray*)parseLogin:(NSDictionary *)resultDic andParam:(NSDictionary *)param
{
    
    NSMutableArray *arry=[NSMutableArray arrayWithCapacity:0];

    if (resultDic) {

        [arry addObject:resultDic];
        if (param != nil) {
            [arry addObject:param];
        }
        return arry;
    }else{
        return nil;
    }
}

// 会员注册
+ (NSMutableArray*)parseRegister:(NSDictionary *)resultDic{
    NSMutableArray *arry=[NSMutableArray arrayWithCapacity:0];
    
    if (resultDic) {
        
        [arry addObject:resultDic];
        
//        //创建模型
//        login_info_model *memMod = [[login_info_model alloc] init];
//        [memMod deleteDBdata];
//        
//        //更新数据
//        NSDictionary *listDic = [resultDic objectForKey:@"userInfo"];
//        
//        NSLog(@"userInfo==%@",listDic);
//        memMod.where = nil;
//        
//        //保存数据
//        if ([[resultDic objectForKey:@"ret"]intValue] == 1)
//        {
//            NSDictionary *memdic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [listDic objectForKey:@"id"],@"id",
//                                    [listDic objectForKey:@"realname"],@"realname",
//                                    [listDic objectForKey:@"portrait"],@"portrait",
//                                    [listDic objectForKey:@"qr_id"],@"qr_id",
//                                    nil];
//            
//            memMod.where = [NSString stringWithFormat:@"id = %d",[[listDic objectForKey:@"id"] intValue]];
//            NSLog(@"userId =%d",[[listDic objectForKey:@"id"] intValue]);
//            
//            NSMutableArray *dbArray = [memMod getList];
//            
//            if ([dbArray count] > 0)
//            {
//                [memMod updateDB:memdic];
//            }
//            else
//            {
//                [memMod insertDB:memdic];
//            }
//            
//            //登陆成功后会员组织信息
//            address_book_model *orgMod = [[address_book_model alloc]init];
//            [orgMod deleteDBdata];
//            
//            NSDictionary *orgDic = [[listDic objectForKey:@"organization"]objectAtIndex:0];
//            
//            NSDictionary *memOrgdic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                       [orgDic objectForKey:@"id"],@"id",
//                                       [orgDic objectForKey:@"org_id"],@"org_id",
//                                       [orgDic objectForKey:@"name"],@"name",
//                                       [orgDic objectForKey:@"parent_id"],@"parent_id",
//                                       [orgDic objectForKey:@"position"],@"position",
//                                       [orgDic objectForKey:@"cat_pic"],@"cat_pic",
//                                       nil];
//            
//            memMod.where = [NSString stringWithFormat:@"id = %d",[[listDic objectForKey:@"id"] intValue]];
//            
//            NSMutableArray *orgArray = [orgMod getList];
//            
//            if ([orgArray count] > 0)
//            {
//                [orgMod updateDB:memOrgdic];
//            }
//            else
//            {
//                [orgMod insertDB:memOrgdic];
//            }
//            
//            RELEASE_SAFE(orgMod);
//        }
//        
//        [memMod release];
        
        return arry;
    }else{
        return nil;
    }

}

// 会员注销
+ (NSMutableArray*)parseLogout:(NSDictionary *)resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// 会员重置密码
+ (NSMutableArray*)parseUpdatepwd:(NSDictionary *)resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// 会员修改头像
+ (NSMutableArray*)parseUpdateimgs:(NSDictionary *)resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// 个人信息修改
+ (NSMutableArray*)parseUpdataUserInfos:(NSDictionary *)resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// 会员的我的二维码
+ (NSMutableArray*)parseQrcode:(NSDictionary *)resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// 会员我的名片夹
+ (NSMutableArray*)parseCard:(NSDictionary *)resultDic{
    NSMutableArray *arry=[NSMutableArray arrayWithCapacity:0];
    
    if (resultDic) {
        
        [arry addObject:resultDic];
        
        //创建模型
        member_card_model *cardMod = [[member_card_model alloc] init];
        
        //更新数据
        NSDictionary *listDic = [resultDic objectForKey:@"friends"];
        
        NSLog(@"friends==%@",listDic);
        cardMod.where = nil;
        
        NSDictionary *cardDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [listDic objectForKey:@"id"],@"id",
                                    [listDic objectForKey:@"username"],@"username",
                                    [listDic objectForKey:@"realname"],@"realname",
                                    [listDic objectForKey:@"email"],@"email",
                                    [listDic objectForKey:@"portrait"],@"portrait",
                                    [listDic objectForKey:@"mobile"],@"mobile",
                                    [listDic objectForKey:@"sex"],@"sex",
                                    [listDic objectForKey:@"weixin"],@"weixin",
                                    [listDic objectForKey:@"weibo"],@"weibo",
                                    [listDic objectForKey:@"birthday"],@"birthday",
                                    [listDic objectForKey:@"signature"],@"signature",
                                    [listDic objectForKey:@"visitor_sum"],@"visitor_sum",
                                    [listDic objectForKey:@"agree_sum"],@"agree_sum",
                                    [listDic objectForKey:@"permission"],@"permission",
                                    [listDic objectForKey:@"is_login"],@"is_login",
                                   nil];
        
        cardMod.where = [NSString stringWithFormat:@"id = %d",[[listDic objectForKey:@"id"] intValue]];
        
        NSMutableArray *cardArray = [cardMod getList];
        
        if ([cardArray count] > 0)
        {
            [cardMod updateDB:cardDic];
        }
        else
        {
            [cardMod insertDB:cardDic];
        }
        
        RELEASE_SAFE(cardMod);
            
        }
    
        
    return arry;
}

// 消息列表
+ (NSMutableArray*)parseNotifylist:(NSDictionary *)resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// 通讯录列表
+ (NSMutableArray*)parseAddressbook:(NSDictionary *)resultDic getVersion:(int*)ver{
    *ver = NO_UPDATE;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
   
    NSLog(@"resultDic==%@",resultDic);
    //创建模型
    org_list_model *orgMod = [[org_list_model alloc] init];
    circle_list_model *circleMod = [[circle_list_model alloc] init];
    
    [orgMod deleteDBdata];
    [circleMod deleteDBdata];
    
    NSMutableArray *orgArray = [resultDic objectForKey:@"organizations"];
    NSMutableArray *ciclesArray = [resultDic objectForKey:@"circles"];
    
    for (int i =0; i< orgArray.count; i++) {
        NSDictionary *orgDic = [orgArray objectAtIndex:i];
        
        //组织列表信息
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [orgDic objectForKey:@"id"],@"id",
                              [orgDic objectForKey:@"name"],@"name",
                              [orgDic objectForKey:@"parent_id"],@"parent_id",
                              [orgDic objectForKey:@"position"],@"position",
                              [orgDic objectForKey:@"cat_pic"],@"cat_pic",
                              [orgDic objectForKey:@"front_character"],@"front_character",
                              [orgDic objectForKey:@"member_count"],@"member_count",
                              nil];
        
        orgMod.where = [NSString stringWithFormat:@"id = %d",[[orgDic objectForKey:@"id"] intValue]];
        NSMutableArray *dbArray = [orgMod getList];
        if ([dbArray count] > 0) {
            [orgMod updateDB:dict];
        } else {
            [orgMod insertDB:dict];
        }
        

    }
    int org_ver = [[resultDic objectForKey:@"org_ver"] intValue];
    
    if ([[Common getVersion:GROUP_LIST_COMMAND_ID] intValue] != org_ver) {
        [orgMod deleteDBdata];
    }
    
    
    // 圈子信息
    for (int i =0; i< ciclesArray.count; i++) {
        NSDictionary *circleDic = [ciclesArray objectAtIndex:i];
        
        //组织列表信息
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [circleDic objectForKey:@"image_path"],@"image_path",
                              [circleDic objectForKey:@"content"],@"content",
                              [circleDic objectForKey:@"portrait"],@"portrait",
                              [circleDic objectForKey:@"id"],@"circle_id",
                              [circleDic objectForKey:@"front_character"],@"front_character",
                              [circleDic objectForKey:@"user_sum"],@"user_sum",
                              [circleDic objectForKey:@"creater_name"],@"creater_name",
                              [circleDic objectForKey:@"user_id"],@"creater_id",
                              [circleDic objectForKey:@"name"],@"name",
                              nil];
        
        circleMod.where = [NSString stringWithFormat:@"circle_id = %lld",[[circleDic objectForKey:@"id"] longLongValue]];
        NSMutableArray *dbArray = [circleMod getList];
        if ([dbArray count] > 0) {
            [circleMod updateDB:dict];
        } else {
            [circleMod insertDB:dict];
        }
        
    }
    
    int circle_ver = [[resultDic objectForKey:@"circle_ver"] intValue];
    
    if ([[Common getVersion:GROUP_LIST_COMMAND_ID] intValue] != circle_ver) {
        [circleMod deleteDBdata];
    }
    
    
    [orgMod release];
    [circleMod release];

    [pool release];

    return nil;
}

// 创建圈子
+ (NSMutableArray*)parseCreateCircle:(NSDictionary *)resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// 圈子名称修改
+ (NSMutableArray*)parseCircleNameUpdate:(NSDictionary *)resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// 圈子介绍修改
+ (NSMutableArray*)parseCircleIntroUpdate:(NSDictionary *)resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// 圈子成员列表
+ (NSMutableArray*)parseCircleMember:(NSDictionary *)resultDic getVersion:(int*)ver andCircleDic:(NSMutableDictionary *)circleDic
{
    NSNumber * circle_id_num = [circleDic objectForKey:@"circle_id"];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    
    //创建模型
    circle_member_list_model *circlelistMod = [[circle_member_list_model alloc] init];
    
    NSMutableArray *orglistArray = [resultDic objectForKey:@"members"];
    
    for (int i =0; i< orglistArray.count; i++) {
        NSDictionary *orgDic = [orglistArray objectAtIndex:i];
        
        //组织列表信息
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [orgDic objectForKey:@"user_id"],@"user_id",
                              [orgDic objectForKey:@"created"],@"created",
                              [orgDic objectForKey:@"portrait"],@"portrait",
                              [orgDic objectForKey:@"realname"],@"realname",
                              [orgDic objectForKey:@"role"],@"role",
                              [orgDic objectForKey:@"sex"],@"sex",
                               circle_id_num,@"circle_id",
                              nil];
        
        circlelistMod.where = [NSString stringWithFormat:@"user_id = %d and circle_id = %d",[[orgDic objectForKey:@"user_id"] intValue], circle_id_num.intValue];
        
        NSMutableArray *dbArray = [circlelistMod getList];
        
        if ([dbArray count] > 0) {
            [circlelistMod updateDB:dict];
        } else {
            [circlelistMod insertDB:dict];
        }
    }
    [circlelistMod release];
    [pool release];
    
    NSLog(@"resultDic==%@",resultDic);
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    [arry addObject:resultDic];
    if (circleDic != nil) {
        [arry addObject:circleDic];
    }
    
    return arry;
}

// 圈子联系人列表
+ (NSMutableArray*)parseGroupAllMember:(NSDictionary *)resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}


// 踢出圈子成员
+ (NSMutableArray*)parseRemoveMember:(NSDictionary *)resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// 圈子成员列表头衔修改
+ (NSMutableArray*)parseGroupMemberUpdateDuty:(NSDictionary *)resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}


// 组织成员列表
+ (NSMutableArray*)parseOrgMemberList:(NSDictionary *)resultDic getVersion:(int*)ver{
    NSLog(@"resultDic==%@",resultDic);
    *ver = NO_UPDATE;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    
    //创建模型
    org_member_list_model *orgListMod = [[org_member_list_model alloc] init];
    
    if ([orgListMod getList].count >0) {
        [orgListMod deleteDBdata];
    }
    
    NSMutableArray *orglistArray = [resultDic objectForKey:@"members"];
    
    for (int i =0; i< orglistArray.count; i++) {
        NSDictionary *orgDic = [orglistArray objectAtIndex:i];
        
        //组织列表信息
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [orgDic objectForKey:@"user_id"],@"user_id",
                              [orgDic objectForKey:@"status"],@"status",
                              [orgDic objectForKey:@"portrait"],@"portrait",
                              [orgDic objectForKey:@"company_name"],@"company_name",
                              [orgDic objectForKey:@"front_character"],@"front_character",
                              [orgDic objectForKey:@"is_supply"],@"is_supply",
                              [orgDic objectForKey:@"realname"],@"realname",
                              [orgDic objectForKey:@"invite_status"],@"invite_status",
                              [orgDic objectForKey:@"honor"],@"honor",
                              nil];
        
        orgListMod.where = [NSString stringWithFormat:@"user_id = %d",[[orgDic objectForKey:@"user_id"] intValue]];
        
        NSMutableArray *dbArray = [orgListMod getList];
        
        if ([dbArray count] > 0) {
            [orgListMod updateDB:dict];
        } else {
            [orgListMod insertDB:dict];
        }
        
        
    }
    int org_ver = [[resultDic objectForKey:@"ver"] intValue];
    
    if ([[Common getVersion:ORG_MEMBER_LIST_COMMAND_ID] intValue] != org_ver) {
        [orgListMod deleteDBdata];
    }
    
    [orgListMod release];
    
    
    [pool release];
    
    return nil;
}


+(NSMutableArray*) parseDynamicList:(NSDictionary *)resultDic withCommandId:(int)commandId{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    
    if (resultDic) {
        
//        [array addObject:resultDic];
        
        [Global sharedGlobal].dyMe_unread_num = [[resultDic objectForKey:@"unread_num"] intValue];
        
        //创建模型
        dynamic_card_model *cardMod = [[dynamic_card_model alloc] init];
        
        if (commandId == DYNAMIC_MAINLIST_COMMAND_ID) {
            [cardMod deleteDBdata];
        }
        
        //更新数据
        NSArray *listArr = [resultDic objectForKey:@"publishs"];
        
//        NSLog(@"publishs==%@",listArr);
        
        for (NSDictionary* listDic in listArr) {
            NSArray *pics = [listDic objectForKey:@"pics"];
            NSMutableArray *picArray = [NSMutableArray array];
            for (NSDictionary *picDic in pics)
            {
                NSString *picUrl = [picDic objectForKey:@"image_path"];
                [picArray addObject:picUrl];
            }
            NSString *picsStr = [picArray componentsJoinedByString:@","];
            
//            cardMod.where = nil;
            
            NSDictionary *cardDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [listDic objectForKey:@"id"],@"id",
                                     [listDic objectForKey:@"user_id"],@"user_id",
                                     [listDic objectForKey:@"type"],@"type",
                                     [listDic objectForKey:@"realname"],@"realname",
                                     [listDic objectForKey:@"title"],@"title",
                                     [listDic objectForKey:@"content"],@"content",
                                     picsStr,@"pics",
                                     [listDic objectForKey:@"province"],@"province",
                                     [listDic objectForKey:@"city"],@"city",
                                     [listDic objectForKey:@"care_sum"],@"care_sum",
                                     [listDic objectForKey:@"comment_sum"],@"comment_sum",
                                     [listDic objectForKey:@"response_sum"],@"response_sum",
                                     [listDic objectForKey:@"start_time"],@"start_time",
                                     [listDic objectForKey:@"end_time"],@"end_time",
                                     [listDic objectForKey:@"url_content"],@"url_content",
                                     [listDic objectForKey:@"created"],@"created",
                                     [listDic objectForKey:@"portrait"],@"portrait",
                                     [listDic objectForKey:@"is_care"],@"is_care",
                                     [listDic objectForKey:@"is_choice"],@"is_choice",
                                     [listDic objectForKey:@"choice1_sum"],@"choice1_sum",
                                     [listDic objectForKey:@"choice2_sum"],@"choice2_sum",
                                     [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                     [listDic objectForKey:@"sex"],@"sex",
                                     [listDic objectForKey:@"address"],@"address",
                                     [listDic objectForKey:@"user_choice"],@"user_choice",
                                     nil];
            
            cardMod.where = [NSString stringWithFormat:@"id = %d",[[listDic objectForKey:@"id"] intValue]];
            
            NSMutableArray *cardArray = [cardMod getList];
            
            if ([cardArray count] > 0)
            {
                [cardMod updateDB:cardDic];
            }
            else
            {
//                NSLog(@"==%@==",cardDic);
                [cardMod insertDB:cardDic];
            }
            
            [array addObject:cardDic];
        }
        
        RELEASE_SAFE(cardMod);
        
    }
    
    return array;
}

+(NSMutableArray*) parseDynamicRelationme:(NSDictionary *)resultDic{
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (resultDic) {
        
        //创建模型
        dynamic_card_model *cardMod = [[dynamic_card_model alloc] init];
        
        //更新数据
        NSArray *listArr = [resultDic objectForKey:@"relations"];
        
        NSLog(@"relations==%@",listArr);
        
        for (NSDictionary* listDic in listArr) {
            cardMod.where = nil;
            
            NSDictionary *cardDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [listDic objectForKey:@"id"],@"id",
                                     [listDic objectForKey:@"user_id"],@"user_id",
                                     [listDic objectForKey:@"type"],@"type",
                                     [listDic objectForKey:@"realname"],@"realname",
                                     [listDic objectForKey:@"title"],@"title",
                                     [listDic objectForKey:@"content"],@"content",
                                     [listDic objectForKey:@"portrait"],@"portrait",
                                     [listDic objectForKey:@"image_path"],@"image_path",
                                     [listDic objectForKey:@"is_care"],@"is_care",
                                     [listDic objectForKey:@"is_choice"],@"is_choice",
                                     [listDic objectForKey:@"choice1_sum"],@"choice1_sum",
                                     [listDic objectForKey:@"choice2_sum"],@"choice2_sum",
                                     [listDic objectForKey:@"created"],@"created",
                                     [listDic objectForKey:@"sex"],@"sex",
                                     nil];
            
            cardMod.where = [NSString stringWithFormat:@"id = %d",[[listDic objectForKey:@"id"] intValue]];
            
            NSMutableArray *cardArray = [cardMod getList];
            
            if ([cardArray count] > 0)
            {
                [cardMod updateDB:cardDic];
            }
            else
            {
                [cardMod insertDB:cardDic];
            }
            
            RELEASE_SAFE(cardMod);
            
            [array addObject:cardDic];
        }
    }
    
    return array;
}

// 点赞
+(NSMutableArray*) parseSupport:(NSDictionary*) resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// OOXX
+(NSMutableArray*) parseOOXX:(NSDictionary*) resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// 评论列表
+(NSMutableArray*) parseCommentList:(NSDictionary*) resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableArray* commentArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray* caresArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray* oosArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray* xxsArr = [NSMutableArray arrayWithCapacity:0];
    
    if (resultDic) {
        
        //创建模型
//        dynamic_commentList_model *cardMod = [[dynamic_commentList_model alloc] init];
//        dynamic_support_model* supportMod = [[dynamic_support_model alloc] init];
        
        //更新数据
        NSArray *listArr = [resultDic objectForKey:@"comments"];
        NSArray* supportArr = [resultDic objectForKey:@"cares"];
        NSArray* ooArr = [resultDic objectForKey:@"choice1_voters"];
        NSArray* xxArr = [resultDic objectForKey:@"choice2_voters"];
        
        NSLog(@"comments==%@",listArr);
        NSLog(@"cares==%@",supportArr);
        
        //comment
        for (NSDictionary* listDic in listArr) {
//            cardMod.where = nil;
            
            NSDictionary *cardDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [listDic objectForKey:@"id"],@"id",
                                     [listDic objectForKey:@"from_id"],@"from_id",
                                     [listDic objectForKey:@"from_name"],@"from_name",
                                     [listDic objectForKey:@"content"],@"content",
                                     [listDic objectForKey:@"from_portrait"],@"from_portrait",
                                     [listDic objectForKey:@"to_id"],@"to_id",
                                     [listDic objectForKey:@"to_name"],@"to_name",
                                     [listDic objectForKey:@"to_portrait"],@"to_portrait",
                                     
                                     [listDic objectForKey:@"created"],@"created",
                                     [listDic objectForKey:@"parent_comment_id"],@"parent_comment_id",
                                     [listDic objectForKey:@"from_sex"],@"from_sex",
                                     [listDic objectForKey:@"to_sex"],@"to_sex",
                                     nil];
            
//            cardMod.where = [NSString stringWithFormat:@"id = %d",[[listDic objectForKey:@"id"] intValue]];
//            
//            NSMutableArray *cardArray = [cardMod getList];
//            
//            if ([cardArray count] > 0)
//            {
//                [cardMod updateDB:cardDic];
//            }
//            else
//            {
//                [cardMod insertDB:cardDic];
//            }
//            
//            RELEASE_SAFE(cardMod);
            
            [commentArr addObject:cardDic];
        }
        
        //care
        for (NSDictionary* supDic in supportArr) {
//            supportMod.where = nil;
            
            NSDictionary *supportDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [supDic objectForKey:@"id"],@"id",
                                     [supDic objectForKey:@"user_id"],@"user_id",
                                     [supDic objectForKey:@"portrait"],@"portrait",
                                     nil];
            
//            supportMod.where = [NSString stringWithFormat:@"id = %d",[[supDic objectForKey:@"id"] intValue]];
//            
//            NSMutableArray *supArray = [supportMod getList];
//            
//            if ([supArray count] > 0)
//            {
//                [supportMod updateDB:supportDic];
//            }
//            else
//            {
//                [supportMod insertDB:supportDic];
//            }
//            
//            RELEASE_SAFE(supportMod);
            
            [caresArr addObject:supportDic];
        }
        
        //oo
        for (NSDictionary* ooDic in ooArr) {
            NSDictionary* oodic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [ooDic objectForKey:@"user_id"],@"user_id",
                                   [ooDic objectForKey:@"realname"],@"realname",
                                   nil];
            [oosArr addObject:oodic];
        }
        
        //xx
        for (NSDictionary* xxDic in xxArr) {
            NSDictionary* xxdic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [xxDic objectForKey:@"user_id"],@"user_id",
                                   [xxDic objectForKey:@"realname"],@"realname",
                                   nil];
            [xxsArr addObject:xxdic];
        }
        
        //page
        NSNumber* pageNum = [resultDic objectForKey:@"page"];
        
        [arry addObject:commentArr];
        [arry addObject:caresArr];
        [arry addObject:oosArr];
        [arry addObject:xxsArr];
        [arry addObject:pageNum];
    }
    
    return arry;
}

// 发布动态
+(NSMutableArray*) parsePublishNews:(NSDictionary*) resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// 发表评论
+(NSMutableArray*) parsePublishComment:(NSDictionary*) resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// 删除评论
+(NSMutableArray*) parseDeleteComment:(NSDictionary*) resultDic{
    NSMutableArray* arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    
    return arry;
}

// @我
+(NSMutableArray*) parseAboutMeMsgList:(NSDictionary *)resultDic{
    NSMutableArray* arry = [NSMutableArray arrayWithCapacity:0];
    if (resultDic) {
        
        dynamic_relationme_model* relationmeMod = [[dynamic_relationme_model alloc] init];
        
        NSArray* msgArr = [resultDic objectForKey:@"relations"];
        for (NSDictionary* dic in msgArr) {
            NSDictionary* msgDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [dic objectForKey:@"user_id"],@"user_id",
                                    [dic objectForKey:@"type"],@"type",
                                    [dic objectForKey:@"relation_id"],@"relation_id",
                                    [dic objectForKey:@"realname"],@"realname",
                                    [dic objectForKey:@"relation_type"],@"relation_type",
                                    [dic objectForKey:@"portrait"],@"portrait",
                                    [dic objectForKey:@"title"],@"title",
                                    [dic objectForKey:@"content"],@"content",
                                    [dic objectForKey:@"image_path"],@"image_path",
                                    [dic objectForKey:@"created"],@"created",
                                    [dic objectForKey:@"id"],@"id",
                                    [dic objectForKey:@"user_choice"],@"user_choice",
                                    [dic objectForKey:@"parent_comment_id"],@"parent_comment_id",
                                    nil];
            
            relationmeMod.where = [NSString stringWithFormat:@"id = %d",[[dic objectForKey:@"id"] intValue]];
            
            NSArray* arr = [relationmeMod getList];
            if (arr.count) {
                [relationmeMod updateDB:msgDic];
            }else{
                [relationmeMod insertDB:msgDic];
            }
            
            [arry addObject:msgDic];
        }
        RELEASE_SAFE(relationmeMod);
    }
    
    return arry;
}

// 云主页详细信息
+(NSMutableArray*) parseMainPageUserinfo:(NSDictionary*) resultDic{

    NSMutableArray *arry=[NSMutableArray arrayWithCapacity:0];
    
    if (resultDic) {
        
        [arry addObject:resultDic];
        
        //创建模型
        mainpage_userInfo_model *userInfoMod = [[mainpage_userInfo_model alloc] init];
        mainpage_company_model *companyMod = [[mainpage_company_model alloc]init];
        mainpage_newpublish_model *publishMod = [[mainpage_newpublish_model alloc]init];
        mainpage_supplydemand_model *supMod = [[mainpage_supplydemand_model alloc]init];
        mianpage_company_dynamic_model *dynamicMod = [[mianpage_company_dynamic_model alloc]init];
        mainpage_openeduser_model *openeduserMod = [[mainpage_openeduser_model alloc]init];
        //更新数据
        NSDictionary *userlistDic = [resultDic objectForKey:@"userinfo"];
        
        userInfoMod.where = nil;
        companyMod.where = nil;
        publishMod.where = nil;
        supMod.where = nil;
        dynamicMod.where = nil;
        openeduserMod.where = nil;
        
        [userInfoMod deleteDBdata];
        [companyMod deleteDBdata];
        [publishMod deleteDBdata];
        [supMod deleteDBdata];
        [dynamicMod deleteDBdata];
        [openeduserMod deleteDBdata];
        
        //保存数据
        if (userlistDic)
        {
            NSDictionary *memdic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [userlistDic objectForKey:@"id"],@"id",
                                    [Global sharedGlobal].user_id,@"id",
                                    [userlistDic objectForKey:@"sex"],@"sex",
                                    [userlistDic objectForKey:@"realname"],@"realname",
                                    [userlistDic objectForKey:@"portrait"],@"portrait",
                                    [userlistDic objectForKey:@"company_name"],@"company_name",
                                    [userlistDic objectForKey:@"company_role"],@"company_role",
                                    [userlistDic objectForKey:@"email"],@"email",
                                    [userlistDic objectForKey:@"interests"],@"interests",
                                    [userlistDic objectForKey:@"mobile"],@"mobile",
                                    [userlistDic objectForKey:@"care_sum"],@"care_sum",
                                    [userlistDic objectForKey:@"visitor_sum"],@"visitor_sum",
                                    [userlistDic objectForKey:@"signature"],@"signature",
                                    [userlistDic objectForKey:@"role"],@"role",
                                    [userlistDic objectForKey:@"nickname"],@"nickname",
                                    [userlistDic objectForKey:@"is_new_vistor"],@"is_new_vistor",
                                    [userlistDic objectForKey:@"is_new_care"],@"is_new_care",
                                    nil];
            
            userInfoMod.where = [NSString stringWithFormat:@"id = %d",[[userlistDic objectForKey:@"id"] intValue]];
            
            NSLog(@"userId =%d",[[userlistDic objectForKey:@"id"] intValue]);
            
            NSMutableArray *dbArray = [userInfoMod getList];
            DLog(@"%@",memdic);
            
            if ([dbArray count] > 0)
            {
                [userInfoMod updateDB:memdic];
            }
            else
            {
                [userInfoMod insertDB:memdic];
            }
            
            NSArray *companyArr = [resultDic objectForKey:@"company"];
            
            for (int i=0; i<companyArr.count; i++) {
                NSDictionary *cpydic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [[companyArr objectAtIndex:i] objectForKey:@"id"],@"id",
                                        [[companyArr objectAtIndex:i] objectForKey:@"name"],@"name",
                                        [[companyArr objectAtIndex:i] objectForKey:@"role"],@"role",
                                        [[companyArr objectAtIndex:i] objectForKey:@"user_id"],@"user_id",
                                        [[companyArr objectAtIndex:i] objectForKey:@"image_path"],@"image_path",
                                        [[companyArr objectAtIndex:i] objectForKey:@"describe"],@"describe",
                                        [[companyArr objectAtIndex:i] objectForKey:@"lightapp"],@"lightapp",
                                        [[companyArr objectAtIndex:i] objectForKey:@"scan_sum"],@"scan_sum",
                                        nil];
                
                companyMod.where = [NSString stringWithFormat:@"id = %d",[[[companyArr objectAtIndex:i] objectForKey:@"id"] intValue]];
                
                NSMutableArray *comArray = [companyMod getList];
                
                if ([comArray count] > 0)
                {
                    [companyMod updateDB:cpydic];
                }
                else
                {
                    [companyMod insertDB:cpydic];
                }

            }
            
            NSDictionary *publishDic = [resultDic objectForKey:@"lastestPublish"];
            
            NSDictionary *pubdic = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [publishDic objectForKey:@"id"],@"id",
                                    [publishDic objectForKey:@"content"],@"content",
                                    [publishDic objectForKey:@"created"],@"created",
                                    [publishDic objectForKey:@"type"],@"type",
                                    nil];
            
            publishMod.where = [NSString stringWithFormat:@"id = %d",[[publishDic objectForKey:@"id"] intValue]];
            
            NSMutableArray *pubArray = [publishMod getList];
            
            if ([pubArray count] > 0)
            {
                [publishMod updateDB:pubdic];
            }
            else
            {
                [publishMod insertDB:pubdic];
            }
            
            
            NSArray *supplyArr = [resultDic objectForKey:@"supplydemand"];
            
            for (int i =0; i<supplyArr.count; i++) {
                
                NSDictionary *suppdic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [[supplyArr objectAtIndex:i] objectForKey:@"id"],@"id",
                                         [[supplyArr objectAtIndex:i] objectForKey:@"content"],@"content",
                                         [[supplyArr objectAtIndex:i] objectForKey:@"created"],@"created",
                                         [[supplyArr objectAtIndex:i] objectForKey:@"type"],@"type",
                                         nil];
                
                supMod.where = [NSString stringWithFormat:@"id = %d",[[[supplyArr objectAtIndex:i] objectForKey:@"id"] intValue]];
                
                NSMutableArray *supArray = [supMod getList];
                
                if ([supArray count] > 0)
                {
                    [supMod updateDB:suppdic];
                }
                else
                {
                    [supMod insertDB:suppdic];
                }
            }
            
            
            
            NSArray *dynamicArr = [resultDic objectForKey:@"company_dynamic"];
            
            for (int i =0; i<dynamicArr.count; i++) {
                
                NSDictionary *dynamicdic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [[dynamicArr objectAtIndex:i] objectForKey:@"id"],@"id",
                                         [[dynamicArr objectAtIndex:i] objectForKey:@"content"],@"content",
                                         [[dynamicArr objectAtIndex:i] objectForKey:@"url"],@"url",
                                            [[dynamicArr objectAtIndex:i] objectForKey:@"created"],@"created",
                                         nil];
                
                dynamicMod.where = [NSString stringWithFormat:@"id = %d",[[[dynamicArr objectAtIndex:i] objectForKey:@"id"] intValue]];
                
                NSMutableArray *dyArray = [dynamicMod getList];
                
                if ([dyArray count] > 0)
                {
                    [dynamicMod updateDB:dynamicdic];
                }
                else
                {
                    [dynamicMod insertDB:dynamicdic];
                }
            }
            //已经开通的的公司介绍
            NSArray *openeduserArr = [resultDic objectForKey:@"open_company_users"];
            for (int i =0; i<openeduserArr.count; i++) {
                                
                NSDictionary *openeduserdic = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [[openeduserArr objectAtIndex:i] objectForKey:@"id"],@"id",
                                            [[openeduserArr objectAtIndex:i] objectForKey:@"realname"],@"realname",
                                            [[openeduserArr objectAtIndex:i] objectForKey:@"portrait"],@"portrait",
                                            [[openeduserArr objectAtIndex:i] objectForKey:@"company_name"],@"company_name",[[openeduserArr objectAtIndex:i] objectForKey:@"lightapp"],@"lightapp",
                                            nil];
                
                openeduserMod.where = [NSString stringWithFormat:@"id = %d",[[[openeduserArr objectAtIndex:i] objectForKey:@"id"] intValue]];
                NSMutableArray *ouArray = [openeduserMod getList];
                
                if ([ouArray count] > 0)
                {
                    [openeduserMod updateDB:openeduserdic];
                }
                else
                {
                    [openeduserMod insertDB:openeduserdic];
                }
            }
            
            RELEASE_SAFE(userInfoMod);
            RELEASE_SAFE(companyMod);
            RELEASE_SAFE(publishMod);
            RELEASE_SAFE(supMod);
            RELEASE_SAFE(dynamicMod);
            RELEASE_SAFE(openeduserMod);
        }
    }
    return arry;
}

// 他人云主页详细信息
+(NSMutableArray*) parseMainPageUserOtherInfo:(NSDictionary*) resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// 提意见
+(NSMutableArray*) parseFeedBackComment:(NSDictionary*) resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// 关于我们
+(NSMutableArray*) parseAboutUs:(NSDictionary*) resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    //....数据库
    if (resultDic) {
        set_aboutUs_model* aMod = [[set_aboutUs_model alloc] init];
        NSArray* arr = [aMod getList];
        if (arr.count) {
            [aMod deleteDBdata];
        }
        
        int ver = [[resultDic objectForKey:@"ver"] intValue];
        NSDictionary* dic = [resultDic objectForKey:@"about"];
        NSDictionary* aDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:ver],@"ver",
                              [dic objectForKey:@"image_path"],@"image_path",
                              [dic objectForKey:@"phone"],@"phone",
                              nil];
        [aMod insertDB:aDic];
        
        [aMod release];
        
        [arry addObject:aDic];
    }
    
    return arry;
}

// 提醒
+(NSMutableArray*) parseMsgSet:(NSDictionary*) resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// 检查新版本
+(NSMutableArray*) parseCheckNewVer:(NSDictionary*) resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// 商务助手特权列表
+(NSMutableArray*) parsePrivilegeList:(NSDictionary *)resultDic{
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (resultDic) {
        
        tool_privilege_model* privilegeMod = [[tool_privilege_model alloc] init];
        NSArray* arr = [privilegeMod getList];
        if (arr.count) {
            [privilegeMod deleteDBdata];
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:[resultDic objectForKey:@"image_path"] forKey:@"privilegeBigImageBG"];
        
        NSArray* privilegeArr = [resultDic objectForKey:@"privileges"];
        for (NSDictionary* dic in privilegeArr) {
            NSDictionary* pdic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [dic objectForKey:@"id"],@"id",
                                  [dic objectForKey:@"title"],@"title",
                                  [dic objectForKey:@"image_path"],@"image_path",
                                  [dic objectForKey:@"start_time"],@"start_time",
                                  [dic objectForKey:@"end_time"],@"end_time",
                                  [dic objectForKey:@"desc"],@"desc",
                                  [dic objectForKey:@"use_explain"],@"use_explain",
                                  [dic objectForKey:@"update_time"],@"update_time",
                                  nil];
 
            [privilegeMod insertDB:pdic];
            
            [array addObject:pdic];
        }
        RELEASE_SAFE(privilegeMod);
    }
    
    return array;
}

+(NSMutableArray *)parseWelcomeInfoList:(NSDictionary *)resultDic {
    NSMutableArray * resultArray = [NSMutableArray arrayWithObject:resultDic];
    return  resultArray;
}

// 云主页邀请开通
+(NSMutableArray*) parseInvitecompany:(NSDictionary*) resultDic{
    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
    
    [arry addObject:resultDic];
    return arry;
}

// 云主页赞列表
+(NSMutableArray*) parseLikelist:(NSDictionary*) resultDic{
    NSMutableArray *likeListArr = [NSMutableArray arrayWithCapacity:0];
    
    [likeListArr addObject:resultDic];
    return likeListArr;
}

// 云主页赞列表加载更多
+(NSMutableArray*) parseLikelistMore:(NSDictionary*) resultDic{
    NSMutableArray *likeListArr = [NSMutableArray arrayWithCapacity:0];
    
    [likeListArr addObject:resultDic];
    return likeListArr;
}

// 云主页访客列表
+(NSMutableArray*) parseVisitlist:(NSDictionary*) resultDic{
    NSMutableArray *visitArr = [NSMutableArray arrayWithCapacity:0];
    
    [visitArr addObject:resultDic];
    return visitArr;
}

// 云主页访客列表更多
+(NSMutableArray*) parseVisitlistMore:(NSDictionary*) resultDic{
    NSMutableArray *visitArr = [NSMutableArray arrayWithCapacity:0];
    
    [visitArr addObject:resultDic];
    return visitArr;
}

// 没有帐号小秘书
+(NSMutableArray*) parseNoAcoutTips:(NSDictionary*) resultDic{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    
    [array addObject:resultDic];
    
    return array;
}

// 云主页我的动态
+(NSMutableArray*) parseMyDynamics:(NSDictionary*) resultDic{
    NSMutableArray *dynamicArr = [NSMutableArray arrayWithCapacity:0];
    
    if (resultDic) {
        
        //更新云主页的最新动态数据
        mainpage_newpublish_model* mainPubMod = [[mainpage_newpublish_model alloc] init];
        mainpage_supplydemand_model* mainSupMod = [[mainpage_supplydemand_model alloc] init];
        
        //更新数据
        NSArray *listArr = [resultDic objectForKey:@"publishs"];
        
        [mainPubMod deleteDBdata];
        
        int i = 0;
        for (NSDictionary* listDic in listArr) {
            NSArray *pics = [listDic objectForKey:@"pics"];
            NSMutableArray *picArray = [NSMutableArray array];
            for (NSDictionary *picDic in pics)
            {
                NSString *picUrl = [picDic objectForKey:@"image_path"];
                [picArray addObject:picUrl];
            }
            NSString *picsStr = [picArray componentsJoinedByString:@","];
     
            NSDictionary *cardDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [listDic objectForKey:@"id"],@"id",
                                     [listDic objectForKey:@"user_id"],@"user_id",
                                     [listDic objectForKey:@"type"],@"type",
                                     [listDic objectForKey:@"realname"],@"realname",
                                     [listDic objectForKey:@"title"],@"title",
                                     [listDic objectForKey:@"content"],@"content",
                                     picsStr,@"pics",
                                     [listDic objectForKey:@"province"],@"province",
                                     [listDic objectForKey:@"city"],@"city",
                                     [listDic objectForKey:@"care_sum"],@"care_sum",
                                     [listDic objectForKey:@"comment_sum"],@"comment_sum",
                                     [listDic objectForKey:@"response_sum"],@"response_sum",
                                     [listDic objectForKey:@"start_time"],@"start_time",
                                     [listDic objectForKey:@"end_time"],@"end_time",
                                     [listDic objectForKey:@"url_content"],@"url_content",
                                     [listDic objectForKey:@"created"],@"created",
                                     [listDic objectForKey:@"portrait"],@"portrait",
                                     [listDic objectForKey:@"is_care"],@"is_care",
                                     [listDic objectForKey:@"is_choice"],@"is_choice",
                                     [listDic objectForKey:@"choice1_sum"],@"choice1_sum",
                                     [listDic objectForKey:@"choice2_sum"],@"choice2_sum",
                                     [listDic objectForKey:@"address"],@"address",
                                     nil];
            [dynamicArr addObject:cardDic];
            
            if (i == 0) {
                NSDictionary* mainPubDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [listDic objectForKey:@"id"],@"id",
                                            [listDic objectForKey:@"title"],@"content",
                                            [listDic objectForKey:@"created"],@"created",
                                            [listDic objectForKey:@"type"],@"type",
                                            nil];
                
                [mainPubMod insertDB:mainPubDic];
            }
            
            if ([[listDic objectForKey:@"type"] intValue] == 3 || [[listDic objectForKey:@"type"] intValue] == 4) {
                
                NSDictionary* mainSupDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [listDic objectForKey:@"id"],@"id",
                                            [listDic objectForKey:@"title"],@"content",
                                            [listDic objectForKey:@"created"],@"created",
                                            [listDic objectForKey:@"type"],@"type",
                                            nil];
                
                [mainSupMod insertDB:mainSupDic];
                
            }
            
            i++;
            
        }
        
        [mainPubMod release];
        [mainSupMod release];
    }
    
    return dynamicArr;
}

// 云主页我的加载更多
+(NSMutableArray*) parseMyDynamicMore:(NSDictionary *)resultDic{
    NSMutableArray *dynamicArr = [NSMutableArray arrayWithCapacity:0];
    
    if (resultDic) {
        
        //更新数据
        NSArray *listArr = [resultDic objectForKey:@"publishs"];
        
        for (NSDictionary* listDic in listArr) {
            NSArray *pics = [listDic objectForKey:@"pics"];
            NSMutableArray *picArray = [NSMutableArray array];
            for (NSDictionary *picDic in pics)
            {
                NSString *picUrl = [picDic objectForKey:@"image_path"];
                [picArray addObject:picUrl];
            }
            NSString *picsStr = [picArray componentsJoinedByString:@","];
            
            NSDictionary *cardDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [listDic objectForKey:@"id"],@"id",
                                     [listDic objectForKey:@"user_id"],@"user_id",
                                     [listDic objectForKey:@"type"],@"type",
                                     [listDic objectForKey:@"realname"],@"realname",
                                     [listDic objectForKey:@"title"],@"title",
                                     [listDic objectForKey:@"content"],@"content",
                                     picsStr,@"pics",
                                     [listDic objectForKey:@"province"],@"province",
                                     [listDic objectForKey:@"city"],@"city",
                                     [listDic objectForKey:@"care_sum"],@"care_sum",
                                     [listDic objectForKey:@"comment_sum"],@"comment_sum",
                                     [listDic objectForKey:@"response_sum"],@"response_sum",
                                     [listDic objectForKey:@"start_time"],@"start_time",
                                     [listDic objectForKey:@"end_time"],@"end_time",
                                     [listDic objectForKey:@"url_content"],@"url_content",
                                     [listDic objectForKey:@"created"],@"created",
                                     [listDic objectForKey:@"portrait"],@"portrait",
                                     [listDic objectForKey:@"is_care"],@"is_care",
                                     [listDic objectForKey:@"is_choice"],@"is_choice",
                                     [listDic objectForKey:@"choice1_sum"],@"choice1_sum",
                                     [listDic objectForKey:@"choice2_sum"],@"choice2_sum",
                                     [listDic objectForKey:@"address"],@"address",
                                     nil];
            [dynamicArr addObject:cardDic];
            
        }
        
    }
    
    return dynamicArr;
}

// 云主页我有我要
+(NSMutableArray*) parseMySupplyDecand:(NSDictionary*) resultDic{
    NSMutableArray *supplyArr = [NSMutableArray arrayWithCapacity:0];
    if (resultDic) {
        
        //更新云主页最新动态数据
        mainpage_newpublish_model* mainPubMod = [[mainpage_newpublish_model alloc] init];
        //更新云主页最新我有我要数据
        mainpage_supplydemand_model* mainSupMod = [[mainpage_supplydemand_model alloc] init];
        
        //更新数据
        NSArray *listArr = [resultDic objectForKey:@"publishs"];
        [mainPubMod deleteDBdata];
        [mainSupMod deleteDBdata];
        
        int i = 0;
        for (NSDictionary* listDic in listArr) {
            NSArray *pics = [listDic objectForKey:@"pics"];
            NSMutableArray *picArray = [NSMutableArray array];
            for (NSDictionary *picDic in pics)
            {
                NSString *picUrl = [picDic objectForKey:@"image_path"];
                [picArray addObject:picUrl];
            }
            NSString *picsStr = [picArray componentsJoinedByString:@","];
            
            NSDictionary *cardDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [listDic objectForKey:@"id"],@"id",
                                     [listDic objectForKey:@"user_id"],@"user_id",
                                     [listDic objectForKey:@"type"],@"type",
                                     [listDic objectForKey:@"realname"],@"realname",
                                     [listDic objectForKey:@"title"],@"title",
                                     [listDic objectForKey:@"content"],@"content",
                                     picsStr,@"pics",
                                     [listDic objectForKey:@"province"],@"province",
                                     [listDic objectForKey:@"city"],@"city",
                                     [listDic objectForKey:@"care_sum"],@"care_sum",
                                     [listDic objectForKey:@"comment_sum"],@"comment_sum",
                                     [listDic objectForKey:@"response_sum"],@"response_sum",
                                     [listDic objectForKey:@"start_time"],@"start_time",
                                     [listDic objectForKey:@"end_time"],@"end_time",
                                     [listDic objectForKey:@"url_content"],@"url_content",
                                     [listDic objectForKey:@"created"],@"created",
                                     [listDic objectForKey:@"portrait"],@"portrait",
                                     [listDic objectForKey:@"is_care"],@"is_care",
                                     [listDic objectForKey:@"is_choice"],@"is_choice",
                                     [listDic objectForKey:@"choice1_sum"],@"choice1_sum",
                                     [listDic objectForKey:@"choice2_sum"],@"choice2_sum",
                                     nil];
            [supplyArr addObject:cardDic];
            
            NSDictionary* mainPubDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [listDic objectForKey:@"id"],@"id",
                                        [listDic objectForKey:@"title"],@"content",
                                        [listDic objectForKey:@"created"],@"created",
                                        [listDic objectForKey:@"type"],@"type",
                                        nil];
            mainPubMod.where = [NSString stringWithFormat:@"id = %d",[[listDic objectForKey:@"id"] intValue]];
            if ([mainPubMod getList].count == 0) {
                [mainPubMod insertDB:mainPubDic];
            }
            
            [mainSupMod insertDB:mainPubDic];
            
            i++;
        }
        [mainPubMod release];
        [mainSupMod release];
    }
    
    return supplyArr;
}

+(NSMutableArray*) parseDeleteDynamic:(NSDictionary *)resultDic{
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:0];
    [arr addObject:resultDic];
    
    return arr;
}

+(NSMutableArray*) parseDynamicDetail:(NSDictionary *)resultDic{
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:0];
    if (resultDic) {
        NSArray *pics = [resultDic objectForKey:@"pics"];
        NSMutableArray *picArray = [NSMutableArray array];
        for (NSDictionary *picDic in pics)
        {
            NSString *picUrl = [picDic objectForKey:@"image_path"];
            [picArray addObject:picUrl];
        }
        NSString *picsStr = [picArray componentsJoinedByString:@","];
        
        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:resultDic];
        [dic removeObjectForKey:@"pics"];
        [dic setObject:picsStr forKey:@"pics"];
        [arr addObject:dic];
        
//        NSDictionary *cardDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 [resultDic objectForKey:@"id"],@"id",
//                                 [resultDic objectForKey:@"user_id"],@"user_id",
//                                 [resultDic objectForKey:@"type"],@"type",
//                                 [resultDic objectForKey:@"realname"],@"realname",
//                                 [resultDic objectForKey:@"title"],@"title",
//                                 [resultDic objectForKey:@"content"],@"content",
//                                 picsStr,@"pics",
//                                 [resultDic objectForKey:@"province"],@"province",
//                                 [resultDic objectForKey:@"city"],@"city",
//                                 [resultDic objectForKey:@"care_sum"],@"care_sum",
//                                 [resultDic objectForKey:@"comment_sum"],@"comment_sum",
//                                 [resultDic objectForKey:@"response_sum"],@"response_sum",
//                                 [resultDic objectForKey:@"start_time"],@"start_time",
//                                 [resultDic objectForKey:@"end_time"],@"end_time",
//                                 [resultDic objectForKey:@"url_content"],@"url_content",
//                                 [resultDic objectForKey:@"created"],@"created",
//                                 [resultDic objectForKey:@"portrait"],@"portrait",
//                                 [resultDic objectForKey:@"is_care"],@"is_care",
//                                 [resultDic objectForKey:@"is_choice"],@"is_choice",
//                                 [resultDic objectForKey:@"choice1_sum"],@"choice1_sum",
//                                 [resultDic objectForKey:@"choice2_sum"],@"choice2_sum",
//                                 [resultDic objectForKey:@"sex"],@"sex",
//                                 [resultDic objectForKey:@"address"],@"address",
//                                 [resultDic objectForKey:@"user_choice"],@"user_choice",
//                                 nil];
//        [arr addObject:cardDic];
        
    }
    
    return arr;
}

+(NSMutableArray*) parseToolList:(NSDictionary *)resultDic{
    NSMutableArray* dicArr = [NSMutableArray arrayWithCapacity:0];
    
    if (resultDic) {
//        NSMutableArray* toolsArr = [NSMutableArray arrayWithCapacity:0];
//        
//        int scan_show = [[resultDic objectForKey:@"scan_show"] intValue];
//        
//        [[NSUserDefaults standardUserDefaults] setBool:scan_show forKey:@"ShowScan"];
//        
//        NSArray* arr = [resultDic objectForKey:@"tools"];
//        
//        tool_tools_model* toolMod = [[tool_tools_model alloc] init];
//        [toolMod deleteDBdata];
//        
//        for (NSDictionary* dic in arr) {
//            NSDictionary* toolDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                     [NSNumber numberWithInt:[[dic objectForKey:@"tool_id"] intValue]],@"tool_id",
//                                     [dic objectForKey:@"tool_name"],@"tool_name",
//                                     [dic objectForKey:@"tool_image"],@"tool_image",
//                                     nil];
//            [toolsArr addObject:toolDic];
//            [toolMod insertDB:toolDic];
//        }
//        
//        [toolMod release];
//        
//        NSDictionary* toolsDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                  toolsArr,@"tools",
//                                  [NSNumber numberWithInt:scan_show],@"scan_show",
//                                  nil];
//        
//        [dicArr addObject:toolsDic];
        
        NSArray *arr = [resultDic objectForKey:@"plugs"];
        
        for (NSDictionary* dic in arr) {
            NSDictionary* plugDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [dic objectForKey:@"plug_name"],@"plug_name",
                                     [dic objectForKey:@"plug_type"],@"plug_type",
                                     [dic objectForKey:@"plug_image"],@"plug_image",
                                     [dic objectForKey:@"plug_url"],@"plug_url",
                                     [dic objectForKey:@"plug_id"],@"plug_id",
                                     [dic objectForKey:@"plug_update_time"],@"plug_update_time",
                                     nil];

            [dicArr addObject:plugDic];
        }
        
    }
    
    return dicArr;
}

//闪屏
+(NSMutableArray*) parseChangeScreenImage:(NSDictionary*) resultDic {
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:0];
    [arr addObject:resultDic];

    return arr;
}

//内容更新通知
+(NSMutableArray*) parseContentModifyNotice:(NSDictionary*) resultDic {
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:0];
    [arr addObject:resultDic];
    
    return arr;
}

//绑定聚聚和临时会话
+(NSMutableArray*) parseBindCircle:(NSDictionary*) resultDic{
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:0];
    [arr addObject:resultDic];
    
    return arr;
}

//参加聚聚
+(NSMutableArray*) parseJoinTogether:(NSDictionary*) resultDic{
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:0];
    [arr addObject:resultDic];
    
    return arr;
}

@end
