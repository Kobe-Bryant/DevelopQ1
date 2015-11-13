//
//  CommandOperationParser.h
//  ASIHttp
//
//  Created by yunlai on 13-5-29.
//  Copyright (c) 2013年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CmdOperationParser : NSObject

+ (NSMutableArray*)parser:(int)commandId withJsonResult:(NSString*)jsonResult withVersion:(int*)ver withParam:(NSMutableDictionary*)param;

// 设备令牌接口
+ (NSMutableArray*)parseApns:(NSDictionary *)resultDic getVersion:(int*)ver;

// 首页动态展示
+ (NSMutableArray*)parseHotwrite:(NSDictionary *)resultDic;

// 会员邀请码
+ (NSMutableArray*)parseInvitecode:(NSDictionary *)resultDic getVersion:(int*)ver;

// 会员验证码
+ (NSMutableArray*)parsesendAuthcode:(NSDictionary *)resultDic;

// 会员验证手机号和验证码
+ (NSMutableArray*)parsesendVerifycode:(NSDictionary *)resultDic;

// 会员登录
+ (NSMutableArray*)parseLogin:(NSDictionary *)resultDic;

// 会员注册
+ (NSMutableArray*)parseRegister:(NSDictionary *)resultDic;

// 会员注销
+ (NSMutableArray*)parseLogout:(NSDictionary *)resultDic;

// 重置密码
+ (NSMutableArray*)parseUpdatepwd:(NSDictionary *)resultDic;

// 验证手机号
+ (NSMutableArray*)parseVerifyMoblie:(NSDictionary *)resultDic;

// 会员修改头像
+ (NSMutableArray*)parseUpdateimgs:(NSDictionary *)resultDic;

// 会员的我的二维码
+ (NSMutableArray*)parseQrcode:(NSDictionary *)resultDic;

// 个人信息修改
+ (NSMutableArray*)parseUpdataUserInfos:(NSDictionary *)resultDic;

// 会员我的名片夹
+ (NSMutableArray*)parseCard:(NSDictionary *)resultDic;

// 消息列表
+ (NSMutableArray*)parseNotifylist:(NSDictionary *)resultDic;

// 通讯录列表
+ (NSMutableArray*)parseAddressbook:(NSDictionary *)resultDic getVersion:(int*)ver;

// 圈子成员列表
+ (NSMutableArray*)parseCircleMember:(NSDictionary *)resultDic getVersion:(int*)ver andCircleDic:(NSMutableDictionary *)circleDic;

// 组织成员列表
+ (NSMutableArray*)parseOrgMemberList:(NSDictionary *)resultDic getVersion:(int*)ver;

// 动态列表
+(NSMutableArray*) parseDynamicList:(NSDictionary*) resultDic withCommandId:(int) commandId;

// 创建圈子
+ (NSMutableArray*)parseCreateCircle:(NSDictionary *)resultDic;

// 与我有关的动态
+(NSMutableArray*) parseDynamicRelationme:(NSDictionary*) resultDic;

// 成员列表邀请
+ (NSMutableArray*)parseInviteOther:(NSDictionary *)resultDic;

// 圈子名称修改
+ (NSMutableArray*)parseCircleNameUpdate:(NSDictionary *)resultDic;

// 圈子介绍修改
+ (NSMutableArray*)parseCircleIntroUpdate:(NSDictionary *)resultDic;

// 踢出圈子成员
+ (NSMutableArray*)parseRemoveMember:(NSDictionary *)resultDic;

// 圈子联系人列表
+ (NSMutableArray*)parseGroupAllMember:(NSDictionary *)resultDic;

// 圈子成员列表头衔修改
+ (NSMutableArray*)parseGroupMemberUpdateDuty:(NSDictionary *)resultDic;


// 点赞
+(NSMutableArray*) parseSupport:(NSDictionary*) resultDic;

// OOXX
+(NSMutableArray*) parseOOXX:(NSDictionary*) resultDic;

// 评论列表
+(NSMutableArray*) parseCommentList:(NSDictionary*) resultDic;

// 发布动态
+(NSMutableArray*) parsePublishNews:(NSDictionary*) resultDic;

// 发表评论
+(NSMutableArray*) parsePublishComment:(NSDictionary*) resultDic;

// 删除评论
+(NSMutableArray*) parseDeleteComment:(NSDictionary*) resultDic;

// @我
+(NSMutableArray*) parseAboutMeMsgList:(NSDictionary*) resultDic;

// 提意见
+(NSMutableArray*) parseFeedBackComment:(NSDictionary*) resultDic;

// 关于我们
+(NSMutableArray*) parseAboutUs:(NSDictionary*) resultDic;

// 提醒
+(NSMutableArray*) parseMsgSet:(NSDictionary*) resultDic;

// 检查新版本
+(NSMutableArray*) parseCheckNewVer:(NSDictionary*) resultDic;

// 商务助手特权列表
+(NSMutableArray*) parsePrivilegeList:(NSDictionary*) resultDic;

// 云主页详细信息
+(NSMutableArray*) parseMainPageUserinfo:(NSDictionary*) resultDic;

// 他人云主页详细信息
+(NSMutableArray*) parseMainPageUserOtherInfo:(NSDictionary*) resultDic;

// 云主页邀请开通
+(NSMutableArray*) parseInvitecompany:(NSDictionary*) resultDic;

// 云主页赞列表
+(NSMutableArray*) parseLikelist:(NSDictionary*) resultDic;

// 云主页赞列表加载更多
+(NSMutableArray*) parseLikelistMore:(NSDictionary*) resultDic;

// 云主页访客列表
+(NSMutableArray*) parseVisitlist:(NSDictionary*) resultDic;

// 云主页访客列表更多
+(NSMutableArray*) parseVisitlistMore:(NSDictionary*) resultDic;

// 没有帐号小秘书
+(NSMutableArray*) parseNoAcoutTips:(NSDictionary*) resultDic;

// 云主页我的动态
+(NSMutableArray*) parseMyDynamics:(NSDictionary*) resultDic;

// 云主页我的动态加载更多
+(NSMutableArray*) parseMyDynamicMore:(NSDictionary*) resultDic;

// 云主页我有我要
+(NSMutableArray*) parseMySupplyDecand:(NSDictionary*) resultDic;

//booky 云主页删除我的动态
+(NSMutableArray*) parseDeleteDynamic:(NSDictionary*) resultDic;

//查询单条动态详情
+(NSMutableArray*) parseDynamicDetail:(NSDictionary*) resultDic;

//商务工具列表
+(NSMutableArray*) parseToolList:(NSDictionary*) resultDic;

//闪屏
+(NSMutableArray*) parseChangeScreenImage:(NSDictionary*) resultDic;

//内容更新通知
+(NSMutableArray*) parseContentModifyNotice:(NSDictionary*) resultDic;

//绑定聚聚和临时会话
+(NSMutableArray*) parseBindCircle:(NSDictionary*) resultDic;

//参加聚聚
+(NSMutableArray*) parseJoinTogether:(NSDictionary*) resultDic;

@end
