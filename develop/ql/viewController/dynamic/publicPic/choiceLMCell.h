//
//  choiceLMCell.h
//  ql
//
//  Created by yunlai on 14-4-3.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface choiceLMCell : UITableViewCell

@property(nonatomic,retain) UIImageView* selectImgV;//选择的圆点标记
@property(nonatomic,retain) UIImageView* userHearV;//用户头像
@property(nonatomic,retain) UILabel* userNameLab;//用户名
@property(nonatomic,retain) UILabel* company_nameLab;//公司名

// chenfeng 5.9 add 隐藏选择图标
- (void)hiddenSelectImgv;

@end
