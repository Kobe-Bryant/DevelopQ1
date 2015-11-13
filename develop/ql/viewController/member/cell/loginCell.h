//
//  loginCell.h
//  ql
//
//  Created by yunlai on 14-4-3.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"

@interface loginCell : UITableViewCell
{
    UIImageView *_iconV;
    UITextField *_loginField;
    UIImageView *_rightIcon;
    UIButton *_getAuthCode;
}
@property (nonatomic, retain) UIImageView *iconV;
@property (nonatomic, retain) UITextField *loginField;
@property (nonatomic, retain) UIImageView *rightIcon;
@property (nonatomic, retain) UIButton *getAuthCode;
@property (nonatomic, retain) UILabel *tipLabel;//add vincent  2014.7.5 未注册账号提示

- (void)setCellStyleIcon:(BOOL)rightIcon hiddenAll:(BOOL)controls;
@end
