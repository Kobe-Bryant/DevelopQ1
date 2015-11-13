//
//  MemberTopView.h
//  ql
//
//  Created by yunlai on 14-4-9.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MemberTopViewDelegate <NSObject>

- (void)topViewHeadClick;

// 访客
- (void)topViewVisitorClick;

// 赞
- (void)topViewlikesClick;

@end

@interface MemberTopView : UIView
{
    id<MemberTopViewDelegate>delegate;
    UILabel *signLabel;//签名
    UILabel *nameLabel;//名字
    UIImageView *sexImage;//性别
    UILabel *roleLabel;//角色
    UILabel *_visitorLabel;//访客
    UILabel *_likeLabel;//点赞
    CGSize nameSize;//名字长度

}

@property (nonatomic, assign) id<MemberTopViewDelegate>delegate;
@property (nonatomic, retain) UIImageView *headView;//头像

@property (nonatomic, retain) UILabel *visitorRedPoint;  //访客红点标志
@property (nonatomic, retain) UILabel *likesRedPoint;    //点赞红点标志


//初始化用户信息设置代理回调
- (id)initWithFrame:(CGRect)frame userInfoArr:(NSArray *)arr delegate:(id<MemberTopViewDelegate>)Memberdelegate;
//设置用户头像
- (void)setHeadImage:(UIImage *)img;
//更新用户数据
- (void)writeDataInfo:(NSArray *)arr;

@end

