//
//  inviteJoinInfoCell.h
//  ql
//
//  Created by yunlai on 14-5-12.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InviteJoinInfoCellDelegate <NSObject>

//确认加入圈子
- (void)confirmJoinCircle;
//忽略
- (void)ignoreCircle;

@end

@interface InviteJoinInfoCell : UITableViewCell
{
    UILabel *_inviteTime;
    UILabel *_inviteMsg;
    UIImageView *_inviteUserHeadImg;
    UILabel *_inviteName;
    UILabel *_inviteRole;
    UILabel *_inviteCompany;
    UIImageView *_isPassImage;
}

@property (nonatomic , retain) UILabel *inviteTime;
@property (nonatomic , retain) UILabel *inviteMsg;
@property (nonatomic , retain) UILabel *inviteName;
@property (nonatomic , retain) UILabel *inviteRole;
@property (nonatomic , retain) UILabel *inviteCompany;
@property (nonatomic , retain) UIImageView *inviteUserHeadImg;
@property (nonatomic , assign) id <InviteJoinInfoCellDelegate> delegate;

- (void)assignCellValue:(NSDictionary *)dic;
//自己计算自己所需要的高度
+ (float)caculateCellHeighFrom:(NSDictionary *)messageDic;

@end
