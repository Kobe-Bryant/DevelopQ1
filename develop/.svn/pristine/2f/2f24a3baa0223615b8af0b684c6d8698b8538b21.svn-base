//
//  inviteJoinInfoCell.m
//  ql
//
//  Created by yunlai on 14-5-12.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "inviteJoinInfoCell.h"
#import "UIImageView+WebCache.h"
#import "CircleDownBarView.h"

#import "org_member_list_model.h"

@interface InviteJoinInfoCell () <CircleDownBarViewDelegate>
{
    
}

@property (nonatomic, retain) CircleDownBarView * confirmBar;

@property (nonatomic, retain) UIImageView * inviteCardBackgroud;

@property (nonatomic, retain) MBProgressHUD * confirmProgress;

@end

@implementation InviteJoinInfoCell
@synthesize inviteMsg = _inviteMsg;
@synthesize inviteCompany = _inviteCompany;
@synthesize inviteName = _inviteName;
@synthesize inviteTime = _inviteTime;
@synthesize inviteUserHeadImg = _inviteUserHeadImg;
@synthesize inviteRole = _inviteRole;

#define kMargin 15.f

//计算出该Cell的高度
+ (float)caculateCellHeighFrom:(NSDictionary *)messageDic
{
    return 190.f + kMargin + 30.f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self setupView];
        
    }
    return self;
}


- (void)setupView{
    //时间
    _inviteTime = [[UILabel alloc]initWithFrame:CGRectMake(110.f, kMargin, timeLabelWidth, timeLabelHight)];
    _inviteTime.font = KQLSystemFont(SessionViewTimeFront);
    _inviteTime.backgroundColor = [UIColor clearColor];
    _inviteTime.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
    _inviteTime.layer.opacity = 0.7;
    _inviteTime.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_inviteTime];
    
    self.inviteCardBackgroud = [[UIImageView alloc]initWithFrame:CGRectMake(kMargin, CGRectGetMaxY(_inviteTime.frame), 290.f, 190.f)];
    [self.inviteCardBackgroud setImage:IMGREADFILE(@"img_bg_invite_card.png")];
    [self.inviteCardBackgroud sizeToFit];
    self.inviteCardBackgroud.userInteractionEnabled = YES;
    [self.contentView addSubview:self.inviteCardBackgroud];
    
    
    UILabel *invite = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f, 290.f, 44.f)];
    invite.text = @"邀请函";
    invite.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
    invite.layer.opacity = 0.7;
    invite.font = KQLSystemFont(19);
    invite.textAlignment = NSTextAlignmentCenter;
    [self.inviteCardBackgroud addSubview:invite];
    
    
    //邀请内容
    _inviteMsg =  [[UILabel alloc]initWithFrame:CGRectMake(0.f, CGRectGetMaxY(invite.frame), 290.f, 55.f)];
    _inviteMsg.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
    _inviteMsg.textAlignment = NSTextAlignmentCenter;
    _inviteMsg.backgroundColor = [UIColor clearColor];
    [self.inviteCardBackgroud addSubview:_inviteMsg];
    
    //头像
    _inviteUserHeadImg = [[UIImageView alloc]initWithFrame:CGRectMake(10.f, CGRectGetMaxY(_inviteMsg.frame)+ 2, 45.f, 45.f)];
    _inviteUserHeadImg.layer.cornerRadius = 22;
    _inviteUserHeadImg.clipsToBounds = YES;
    [self.inviteCardBackgroud addSubview:_inviteUserHeadImg];
    
    //姓名
    _inviteName =  [[UILabel alloc]initWithFrame:CGRectMake( 65.f , CGRectGetMaxY(_inviteMsg.frame)+ 5, 100.f, 20.f)];
    _inviteName.font = KQLSystemFont(16);
    _inviteName.backgroundColor = [UIColor clearColor];
    _inviteName.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
    _inviteName.textAlignment = NSTextAlignmentLeft;
    [self.inviteCardBackgroud addSubview:_inviteName];
    
    //职务
    _inviteRole =  [[UILabel alloc]initWithFrame:CGRectMake(160.f ,CGRectGetMaxY(_inviteMsg.frame)+ 5, 80.f, 20.f)];
    _inviteRole.font = KQLSystemFont(13);
    _inviteRole.backgroundColor = [UIColor clearColor];
    _inviteRole.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
    [self.inviteCardBackgroud addSubview:_inviteRole];
    
    //公司
    _inviteCompany =  [[UILabel alloc]initWithFrame:CGRectMake(65.f ,CGRectGetMaxY(_inviteName.frame) + 5, 180.f, 20.f)];
    _inviteCompany.font = KQLSystemFont(13);
    _inviteCompany.backgroundColor = [UIColor clearColor];
    _inviteCompany.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
    [self.inviteCardBackgroud addSubview:_inviteCompany];
    
    //是否通过
    _isPassImage = [[UIImageView alloc]initWithFrame:CGRectMake(220.f, CGRectGetMinY(_inviteName.frame), 60.f, 25.f)];
    _isPassImage.image = IMGREADFILE(@"btn_pass.png");
    _isPassImage.hidden = YES;
    [self.inviteCardBackgroud addSubview:_isPassImage];
    
    self.confirmBar = [[CircleDownBarView alloc]initWithFrame:CGRectMake(0,150, 290.f, 40) type:1];
    self.confirmBar.delegate = self;
    self.confirmBar.backgroundColor = [UIColor clearColor];
    [self.inviteCardBackgroud addSubview:self.confirmBar];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(confirmJoinCircleSuccess) name:kNotiConfirmJoinCircle object:nil];
    
    RELEASE_SAFE(invite);
}

- (void)assignCellValue:(NSDictionary *)dic{
    
    //从org_member_list表中，获取用户的头衔、头像、公司信息 booky
    org_member_list_model* orgMemMod = [[org_member_list_model alloc] init];
    orgMemMod.where = [NSString stringWithFormat:@"user_id = %lld",[[dic objectForKey:@"sender_id"] longLongValue]];
    NSArray* arr = [orgMemMod getList];
    NSDictionary* userDic = [arr firstObject];
    [orgMemMod release];
    
    int inviteTime =  [[dic objectForKey:@"send_time"]doubleValue];
    _inviteTime.text = [Common makeSessionViewHumanizedTimeForWithTime:inviteTime];
//    _inviteMsg.text = [dic objectForKey:@"msg"];
    _inviteMsg.text = @"一起来聊聊吧";
    
//    NSURL *imgUrl = [NSURL URLWithString:[dic objectForKey:@"headlogo"]];
    NSURL* imgUrl = [NSURL URLWithString:[userDic objectForKey:@"portrait"]];
    
    [_inviteUserHeadImg setImageWithURL:imgUrl placeholderImage:IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME)];
    _inviteName.text = [dic objectForKey:@"nickname"];
//    _inviteRole.text = @"(邀请人)";
    if ([[dic objectForKey:@"honor"] isKindOfClass:[NSNull class]] || [[dic objectForKey:@"honor"] length] == 0) {
        _inviteRole.text = @"(邀请人)";
    }else{
        _inviteRole.text = [NSString stringWithFormat:@"%@  (邀请人)",[dic objectForKey:@"honor"]];
    }
//    _inviteCompany.text = [dic objectForKey:@"companyname"];
    if ([[dic objectForKey:@"honor"] isKindOfClass:[NSNull class]] || [[dic objectForKey:@"honor"] length] == 0) {
        _inviteCompany.text = @"";
    }else{
        _inviteCompany.text = [userDic objectForKey:@"company_name"];
    }
//    _inviteCompany.text = [userDic objectForKey:@"company_name"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - CircleDownBarDelegate

- (void)actionDownBar:(CircleDownBarView *)circleDownBarView clickedButtonAtIndex:(UIButton *)buttonIndex
{
    switch (buttonIndex.tag) {
        case 0:// 加入圈子
        {
            self.confirmProgress = [MBProgressHUD showHUDAddedTo:APPKEYWINDOW animated:YES];
            self.confirmProgress.mode = MBProgressHUDModeIndeterminate;
            [self.delegate confirmJoinCircle];
        }
            break;
        case 1:// 忽略
        {
            _isPassImage.image = IMGREADFILE(@"btn_ ignore.png");
            _isPassImage.hidden = NO;
            [self.delegate ignoreCircle];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - ConfirmJoinCircleSuccess

- (void)confirmJoinCircleSuccess
{
    [MBProgressHUD hideHUDForView:APPKEYWINDOW animated:YES];
    _isPassImage.hidden = NO;
    self.confirmBar.hidden = YES;
}

- (void)dealloc
{
    RELEASE_SAFE(_isPassImage);
    RELEASE_SAFE(_inviteCompany);
    RELEASE_SAFE(_inviteMsg);
    RELEASE_SAFE(_inviteName);
    RELEASE_SAFE(_inviteRole);
    RELEASE_SAFE(_inviteTime);
    RELEASE_SAFE(_inviteUserHeadImg);
    RELEASE_SAFE(_confirmBar);
    [super dealloc];
}

@end
