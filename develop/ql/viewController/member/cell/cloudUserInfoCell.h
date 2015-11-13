//
//  cloudUserInfoCell.h
//  ql
//
//  Created by yunlai on 14-2-27.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol cellDelegate <NSObject>

- (void)changeHightForRow:(NSNumber *)row AndExtraHeight:(NSNumber *)extraHeight;

@end

@interface cloudUserInfoCell : UITableViewCell
{
    UIImageView *_iconView;
    UILabel *_moblie;
    UILabel *_mobileLabel;
    UILabel *_email;
    UILabel *_emailLabel;
    UILabel *_weixin;
    UILabel *_weixinLabel;
    UILabel *_weibo;
    UILabel *_weiboLaebl;
    UILabel *line2;
    BOOL _isExpand;
    UIImageView *bgView;
}
@property(nonatomic,assign) id delegate;
@property (nonatomic, retain) UIImageView *iconView;
@property (nonatomic, retain) UILabel *moblie;
@property (nonatomic, retain) UILabel *mobileLabel;
@property (nonatomic, retain) UILabel *email;
@property (nonatomic, retain) UILabel *emailLabel;
@property (nonatomic, retain) UILabel *weixin;
@property (nonatomic, retain) UILabel *weixinLabel;
@property (nonatomic, retain) UILabel *weibo;
@property (nonatomic, retain) UILabel *weiboLaebl;
@property (nonatomic, retain) UIImageView *bgView;

@end

