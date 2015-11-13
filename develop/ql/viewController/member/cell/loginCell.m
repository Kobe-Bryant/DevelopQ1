//
//  loginCell.m
//  ql
//
//  Created by yunlai on 14-4-3.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "loginCell.h"
#import "config.h"
#import "Global.h"

@implementation loginCell
@synthesize iconV = _iconV;
@synthesize loginField = _loginField;
@synthesize getAuthCode = _getAuthCode;
@synthesize rightIcon = _rightIcon;
@synthesize tipLabel = _tipLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _loginField = [[CustomTextField alloc] initWithFrame:CGRectMake(10, 0, 285, 44)];
        _loginField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//字体垂直居中对齐
        _loginField.font = [UIFont systemFontOfSize:18];
        _loginField.backgroundColor =[UIColor clearColor];
      
        [_loginField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_loginField setKeyboardType:UIKeyboardTypeNumberPad];
        [self.contentView addSubview:_loginField];
        
//        add vincent 2014.7.5 账号已经注册
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(190.f, 7.f, 120.f, 30)];
        _tipLabel.text = @"这个账号未注册哦";
        //    tips.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
        _tipLabel.textColor = COLOR_GRAY2;
        _tipLabel.font = KQLSystemFont(15);
        _tipLabel.hidden = YES;
        [self.contentView addSubview:_tipLabel];
        
        _rightIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        _rightIcon.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_rightIcon];
        
        _getAuthCode = [UIButton buttonWithType:UIButtonTypeCustom];
        _getAuthCode.frame = CGRectZero;
        _getAuthCode.titleLabel.font = KQLSystemFont(16);
        [_getAuthCode setTitleColor:COLOR_FONT forState:UIControlStateNormal];
        [_getAuthCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        
//        [self.contentView addSubview:_getAuthCode];
        
        // 分割线
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 49.f, KUIScreenWidth, 1.0f)];
//        line.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LINE"];
        line.backgroundColor = COLOR_LINE;
        [self.contentView addSubview:line];
        RELEASE_SAFE(line);
    }
    return self;
}

- (void)dealloc
{
//    RELEASE_SAFE(_iconV);
    RELEASE_SAFE(_tipLabel);
    RELEASE_SAFE(_loginField);
    RELEASE_SAFE(_rightIcon);
    [super dealloc];
}

// CELL右侧控件是图标还是按钮
- (void)setCellStyleIcon:(BOOL)rightIcon hiddenAll:(BOOL)controls{
    if (!controls) {
        if (rightIcon) {
            _rightIcon.frame = CGRectMake(KUIScreenWidth - 50.f, 10.f, 25, 25.f);
            _getAuthCode.hidden = YES;
            _loginField.frame = CGRectMake(10, 0, 185, 44);
        }else{
            _getAuthCode.frame = CGRectMake(KUIScreenWidth - 140.f, 8.f, 150, 30.f);
            _loginField.frame = CGRectMake(10, 0, 185, 44);
            _rightIcon.hidden = YES;
        }
    }else{
         _rightIcon.hidden = YES;
        _getAuthCode.hidden = YES;
        _loginField.frame = CGRectMake(10, 0, 285, 44);
    }
   
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
