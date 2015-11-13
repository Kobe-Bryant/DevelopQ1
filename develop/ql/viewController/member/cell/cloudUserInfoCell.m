//
//  cloudUserInfoCell.m
//  ql
//
//  Created by yunlai on 14-2-27.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "cloudUserInfoCell.h"

@implementation cloudUserInfoCell
@synthesize iconView = _iconView;
@synthesize moblie = _moblie;
@synthesize mobileLabel = _mobileLabel;
@synthesize email = _email;
@synthesize emailLabel = _emailLabel;
@synthesize weixin = _weixin;
@synthesize weixinLabel = _weixinLabel;
@synthesize weibo = _weibo;
@synthesize weiboLaebl = _weiboLaebl;
@synthesize delegate,bgView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        bgView = [[UIImageView alloc]initWithFrame:CGRectMake(5.f, 5.f, KUIScreenWidth - 10.f,90.f)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.userInteractionEnabled = YES;
        [self addSubview:bgView];
        
         UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureButtonClicked)];
        [bgView addGestureRecognizer:tap];
        RELEASE_SAFE(tap);
        
        UILabel *tips = [[UILabel alloc]initWithFrame:CGRectMake(5.f, 7.f, 100.f, 20)];
//        tips.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
        tips.textColor = COLOR_GRAY2;
        tips.text = @"个人信息";
        tips.font = KQLSystemFont(14);
        [bgView addSubview:tips];
        RELEASE_SAFE(tips);
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 30.f, bgView.frame.size.width, 1.f)];
//        line.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LINE"];
        line.backgroundColor = COLOR_LINE;
        [bgView addSubview:line];
        RELEASE_SAFE(line);
        
        _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10.f, 40.f, 40.f, 40.f)];
        _iconView.backgroundColor = [UIColor grayColor];
        [bgView addSubview:_iconView];
        
        _moblie = [[UILabel alloc]initWithFrame:CGRectMake(60.f, 38.f, 200.f, 20.f)];
        _moblie.backgroundColor = [UIColor clearColor];
        _moblie.text = @"电话";
        _moblie.font = KQLSystemFont(13);
        [bgView addSubview:_moblie];
        
        _mobileLabel = [[UILabel alloc]initWithFrame:CGRectMake(60.f, 38.f, 200.f, 20.f)];
        _mobileLabel.backgroundColor = [UIColor clearColor];
        _mobileLabel.font = KQLSystemFont(13);
        [bgView addSubview:_mobileLabel];
        
        line2 = [[UILabel alloc]initWithFrame:CGRectMake(60.f, CGRectGetMaxY(_moblie.frame)  + 20, bgView.frame.size.width - 60.f, 1.f)];
//        line2.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LINE"];
        line2.backgroundColor = COLOR_LINE;
        [bgView addSubview:line2];
        
        
        _email = [[UILabel alloc]initWithFrame:CGRectMake(60.f, CGRectGetMaxY(_moblie.frame)+ 26, 200.f, 20.f)];
        _email.backgroundColor = [UIColor clearColor];
        _email.text = @"邮箱";
        _email.font = KQLSystemFont(13);
        [bgView addSubview:_email];
        
        _emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(60.f, CGRectGetMaxY(_moblie.frame) , 200.f, 20.f)];
        _emailLabel.backgroundColor = [UIColor clearColor];
        _emailLabel.font = KQLSystemFont(13);
        [bgView addSubview:_emailLabel];
        
        UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(60.f, CGRectGetMaxY(_email.frame) + 20, bgView.frame.size.width - 60.f, 1.f)];
//        line3.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LINE"];
        line3.backgroundColor = COLOR_LINE;
        [bgView addSubview:line3];
        RELEASE_SAFE(line3);
        
        _weixin = [[UILabel alloc]initWithFrame:CGRectMake(60.f, CGRectGetMaxY(_email.frame)+ 20, 200.f, 20.f)];
        _weixin.backgroundColor = [UIColor clearColor];
        _weixin.font = KQLSystemFont(13);
        _weixin.text = @"微信";
        [bgView addSubview:_weixin];
        
        _weixinLabel = [[UILabel alloc]initWithFrame:CGRectMake(60.f, CGRectGetMaxY(_weixin.frame), 200.f, 20.f)];
        _weixinLabel.backgroundColor = [UIColor clearColor];
        _weixinLabel.font = KQLSystemFont(13);
        [bgView addSubview:_weixinLabel];
        
        UILabel *line4 = [[UILabel alloc]initWithFrame:CGRectMake(60.f, CGRectGetMaxY(_weixinLabel.frame), bgView.frame.size.width - 60.f, 1.f)];
//        line4.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LINE"];
        line4.backgroundColor = COLOR_LINE;
        [bgView addSubview:line4];
        RELEASE_SAFE(line4);
        
        _weibo = [[UILabel alloc]initWithFrame:CGRectMake(60.f, CGRectGetMaxY(_weixinLabel.frame)+ 6, 200.f, 20.f)];
        _weibo.backgroundColor = [UIColor clearColor];
        _weibo.text = @"微博";
        _weibo.font = KQLSystemFont(13);
        [bgView addSubview:_weibo];
        
        _weiboLaebl = [[UILabel alloc]initWithFrame:CGRectMake(60.f, CGRectGetMaxY(_weibo.frame), 200.f, 20.f)];
        _weiboLaebl.backgroundColor = [UIColor clearColor];
        _weiboLaebl.font = KQLSystemFont(13);
        [bgView addSubview:_weiboLaebl];
        
        UILabel *line5 = [[UILabel alloc]initWithFrame:CGRectMake(60.f, CGRectGetMaxY(_weiboLaebl.frame), bgView.frame.size.width - 60.f, 1.f)];
//        line5.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LINE"];
        line5.backgroundColor = COLOR_LINE;
        [bgView addSubview:line5];
        RELEASE_SAFE(line5);
        
        _moblie.hidden = YES;
        _email.hidden = YES;
        line2.hidden = YES;
        _weixin.hidden = YES;
        _weibo.hidden = YES;
        _weixinLabel.hidden = YES;
        _weiboLaebl.hidden = YES;
        
        _mobileLabel.frame = CGRectMake(60.f, 38.f, 200.f, 20.f);
        _emailLabel.frame = CGRectMake(60.f, CGRectGetMaxY(_moblie.frame) , 200.f, 20.f);
      
    }
    return self;
}

- (void)dealloc
{
    RELEASE_SAFE(_iconView);
    RELEASE_SAFE(_moblie);
    RELEASE_SAFE(_mobileLabel);
    RELEASE_SAFE(_email);
    RELEASE_SAFE(_emailLabel);
    RELEASE_SAFE(_weixin);
    RELEASE_SAFE(_weixinLabel);
    RELEASE_SAFE(_weibo);
    RELEASE_SAFE(_weiboLaebl);
    RELEASE_SAFE(line2);
    [super dealloc];
}

- (void)gestureButtonClicked{
   
    if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(changeHightForRow: AndExtraHeight:)]) {
        CATransition * animation = [CATransition animation];
        animation.duration = 0.4;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionFade;
        [bgView.layer addAnimation:animation forKey:nil];
      
        if (!_isExpand) {
            [bgView setFrame:CGRectMake(5.f, 5.f, KUIScreenWidth - 10.f,220.f)];
           
            _mobileLabel.frame = CGRectMake(60.f, CGRectGetMaxY(_moblie.frame), 200.f, 20.f);
            _emailLabel.frame = CGRectMake(60.f, CGRectGetMaxY(_email.frame), 200.f, 20.f);
            _moblie.hidden = NO;
            _email.hidden = NO;
            line2.hidden = NO;
            _weixin.hidden = NO;
            _weibo.hidden = NO;
            _weixinLabel.hidden = NO;
            _weiboLaebl.hidden = NO;
            
        } else {
            [bgView setFrame:CGRectMake(5.f, 5.f, KUIScreenWidth - 10.f,90.f)];
            
            _moblie.hidden = YES;
            _email.hidden = YES;
            line2.hidden = YES;
            _weixin.hidden = YES;
            _weibo.hidden = YES;
            _weixinLabel.hidden = YES;
            _weiboLaebl.hidden = YES;
            _mobileLabel.frame = CGRectMake(60.f, 38.f, 200.f, 20.f);
            _emailLabel.frame = CGRectMake(60.f, CGRectGetMaxY(_moblie.frame) , 200.f, 20.f);
        }

        [self.delegate performSelector:@selector(changeHightForRow: AndExtraHeight:) withObject:[NSNumber numberWithInt:0] withObject:[NSNumber numberWithInt:(220.f - 90.f)*!_isExpand]];
        
        _isExpand = !_isExpand;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
