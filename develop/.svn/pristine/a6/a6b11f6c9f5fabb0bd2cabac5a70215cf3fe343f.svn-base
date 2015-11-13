//
//  guestCell.m
//  ql
//
//  Created by yunlai on 14-2-28.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "guestCell.h"

@implementation guestCell
@synthesize userName = _userName;
@synthesize headView = _headView;
@synthesize dutyL = _dutyL;
@synthesize companyL = _companyL;
@synthesize timeL = _timeL;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //头像
        _headView = [[UIImageView alloc]initWithFrame:CGRectMake(20.f, 7.f, 45.f, 45.f)];
        _headView.layer.cornerRadius = 23;
        _headView.clipsToBounds = YES;
        _headView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_headView];
        
        //用户名
        _userName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_headView.frame) + 30, 10.f, 200.f, 20.f)];
        _userName.backgroundColor = [UIColor clearColor];
        _userName.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
//        _userName.textColor = COLOR_GRAY2;
        _userName.font = KQLboldSystemFont(15);
        [self.contentView addSubview:_userName];
        
        //职务
//        _dutyL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_headView.frame) + 90, 10.f, 200.f, 20.f)];
//        _dutyL.backgroundColor = [UIColor clearColor];
////        _dutyL.textColor = [UIColor whiteColor];
//        _dutyL.textColor = _userName.textColor;
//        _dutyL.font = KQLboldSystemFont(15);
//        [self.contentView addSubview:_dutyL];
        
        //公司
        _companyL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_headView.frame) + 30, 30.f, 200.f, 20.f)];
        _companyL.backgroundColor = [UIColor clearColor];
        _companyL.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
        _companyL.layer.opacity = 0.7;
//        _companyL.textColor = COLOR_GRAY;
        _companyL.font = KQLSystemFont(12);
        [self.contentView addSubview:_companyL];
        
        //时间
        _timeL = [[UILabel alloc]initWithFrame:CGRectMake(KUIScreenWidth - 80.f, 20.f, 80.f, 20.f)];
        _timeL.backgroundColor = [UIColor clearColor];
        _timeL.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
        _timeL.layer.opacity = 0.7;
//        _timeL.textColor = COLOR_GRAY;
        _timeL.textAlignment = NSTextAlignmentCenter;
        _timeL.font = KQLSystemFont(12);
        [self.contentView addSubview:_timeL];
        
        // 分割线
//        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 59.f, KUIScreenWidth, 1.0f)];
//        line.backgroundColor = RGBACOLOR(46, 50, 56, 0.9);
//        [self.contentView addSubview:line];
//        RELEASE_SAFE(line);
    }
    return self;
}


- (void)dealloc
{
    RELEASE_SAFE(_userName);
    RELEASE_SAFE(_headView);
//    RELEASE_SAFE(_dutyL);
    RELEASE_SAFE(_companyL);
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
