//
//  FatherManager.m
//  ql
//
//  Created by LazySnail on 14-6-13.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "FatherCircleManager.h"
#import "CircleManager.h"
#import "TemporaryCircleManager.h"
#import "circle_member_list_model.h"
#import "DataChecker.h"

@interface FatherCircleManager () <DataCheckerDelegate>
{
    
}

@end

@implementation FatherCircleManager

typedef BOOL (^ dismissParseMethod) (void);
typedef BOOL (^ dismissJudger) (dismissParseMethod theMethod,NSDictionary * firstDic,NSDictionary * lastDic);

dismissJudger tDismissJudger = ^(dismissParseMethod theMethod,NSDictionary * firstDic,NSDictionary * lastDic)
{
    
    if ([[firstDic objectForKey:@"ret"]intValue]==1) {
        // 如果删除成功。则处理本地的圈子数据删除本地圈子对应的数据库
        BOOL judger = theMethod();
        if (judger)
        {
//            [Common checkProgressHUD:@"解散圈子成功" andImage:nil showInView:APPKEYWINDOW];
            [Common checkProgressHUDShowInAppKeyWindow:@"解散圈子成功" andImage:KAccessSuccessIMG];
            return YES;
        } else {
//            [Common checkProgressHUD:@"删除圈子数据失败" andImage:nil showInView:APPKEYWINDOW];
            [Common checkProgressHUDShowInAppKeyWindow:@"删除圈子数据失败" andImage:KAccessFailedIMG];
            return NO;
        }
    } else {
//        [Common checkProgressHUD:@"删除圈子失败" andImage:nil showInView:APPKEYWINDOW];
        [Common checkProgressHUDShowInAppKeyWindow:@"删除圈子失败" andImage:KAccessFailedIMG];
        return NO;
    }
};


- (void)didFinishCommand:(NSMutableArray *)resultArray cmd:(int)commandid withVersion:(int)ver
{
    //安全解析返回数据
    ParseMethod method = ^(){
        NSDictionary * resultDic = [resultArray firstObject];
        switch (commandid) {
            case TEMP_CIRCLE_DISMISS_COMMAND_ID:
            {
                if ([[resultDic objectForKey:@"ret"]intValue] == 1) {
                    [self.fatherDelegate dismissCircleSuccess:self];
                    
                } else{
//                    [Common checkProgressHUD:@"解散失败" andImage:nil showInView:APPKEYWINDOW];
                    [Common checkProgressHUDShowInAppKeyWindow:@"解散失败" andImage:KAccessFailedIMG];
                }
            }
                break;
            case CIRCLE_DISMISS_COMMAND_ID:
            {
                if ([[resultDic objectForKey:@"ret"]intValue] == 1) {
                    [self.fatherDelegate dismissCircleSuccess:self];
                    
                } else{
//                    [Common checkProgressHUD:@"解散失败" andImage:nil showInView:APPKEYWINDOW];
                    [Common checkProgressHUDShowInAppKeyWindow:@"解散失败" andImage:KAccessFailedIMG];
                }
            }
                break;
            case CIRCLE_MEMBER_DELETE_COMMAND_ID:
            {
                if ([[resultDic objectForKey:@"ret"]intValue] == 1) {
                    [self.fatherDelegate removeMemberSucess:self];
                } else {
//                    [Common checkProgressHUD:@"删除成员失败" andImage:nil showInView:APPKEYWINDOW];
                    [Common checkProgressHUDShowInAppKeyWindow:@"删除成员失败" andImage:KAccessFailedIMG];
                }
            }
                break;
            case GROUP_CREATE_COMMAND_ID:
            {
                NSNumber * circleIDNum = [resultDic objectForKey:@"id"];
                DataChecker * checker = [DataChecker new];
                checker.delegate = self;
                checker.ifModifyChatList = NO;
                [checker updateCircleInfoWithID:[circleIDNum longLongValue]];
            }
            default:
                break;
        }
    };
    [Common securelyparseHttpResultArr:resultArray andMethod:method];
}

- (void)dataCheckerUpdateCircleInfoSuccessWithSender:(DataChecker *)sender andCircleContects:(NSMutableArray *)contacts
{
    NSDictionary * contactDic = [contacts firstObject];
    long long circleID = [[contactDic objectForKey:@"circle_id"]longLongValue];
    
    [self.fatherDelegate createCircleSucess:self andCircleID:circleID];
    RELEASE_SAFE(sender);
}

@end
