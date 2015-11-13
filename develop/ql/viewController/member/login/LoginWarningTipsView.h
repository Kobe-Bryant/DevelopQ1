//
//  LoginWarningTipsView.h
//  ql
//
//  Created by yunlai on 14-7-7.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginWarningTipsView : UIView

@property (nonatomic,retain) UIView *warningView;
@property (nonatomic,retain) NSString *warningString;//add vicnent 提示文字
@property (nonatomic,retain) UIImageView *warningImageView;// 提示图片
@property (nonatomic,retain) UILabel *warningLabel;//提示的label
@end
