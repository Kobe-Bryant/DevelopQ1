//
//  MemberTopView.m
//  ql
//
//  Created by yunlai on 14-4-9.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "MemberTopView.h"
#import "UIImageView+WebCache.h"

@implementation MemberTopView
@synthesize delegate;
@synthesize headView = _headView;
@synthesize visitorRedPoint = _visitorRedPoint;
@synthesize likesRedPoint = _likesRedPoint;

#define kleftPadding 20.f
#define kpadding 15.f
#define kWidth 30.f
#define kHightPadding 60.f


- (id)initWithFrame:(CGRect)frame userInfoArr:(NSArray *)arr delegate:(id<MemberTopViewDelegate>)Memberdelegate
{
    self = [super initWithFrame:frame];
    if (self) {
//        注册更新用户头像通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatesHeadView:) name:@"updateHeadImage" object:nil];
        
        self.backgroundColor = [UIColor colorWithPatternImage:IMGREADFILE(@"img_member_banner.png")];
        self.delegate = Memberdelegate;
        
//        UI布局
        signLabel = [[UILabel alloc]initWithFrame:CGRectMake((KUIScreenWidth - 200)/2, 70.f, 200, 50.f)];
        if (arr.count > 0) {
            NSString* signStr = [[arr objectAtIndex:0] objectForKey:@"signature"];
            if (signStr.length) {
                signLabel.text = [NSString stringWithFormat:@"\"%@\"",signStr];
            }
        }
        
        signLabel.textColor = [UIColor whiteColor];
        signLabel.backgroundColor = [UIColor clearColor];
        signLabel.font = KQLSystemFont(15);
        signLabel.numberOfLines = 2;
        signLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        signLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:signLabel];
        
        _headView = [[UIImageView alloc]initWithFrame:CGRectMake(20.f,145.f, 50.f, 50.f)];
        _headView.clipsToBounds = YES;
        _headView.layer.cornerRadius = 25;
        _headView.userInteractionEnabled = YES;
        _headView.layer.borderWidth = 1.5;
        _headView.layer.borderColor = [UIColor whiteColor].CGColor;
        if (arr.count > 0) {
            NSURL *urlStr = [NSURL URLWithString:[[arr objectAtIndex:0]objectForKey:@"portrait"]];
            if ([[[arr objectAtIndex:0]objectForKey:@"sex"] intValue] == 1) {
                 [_headView setImageWithURL:urlStr placeholderImage:IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME)];
            }else{
                 [_headView setImageWithURL:urlStr placeholderImage:IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME)];
            }
            
        }
        
        [self addSubview:_headView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headClick)];
        [_headView addGestureRecognizer:tap];
        RELEASE_SAFE(tap);
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(85.f, 145.f,120.f, 30.f)];
        nameLabel.font = [UIFont systemFontOfSize:14.0];
        nameLabel.backgroundColor = [UIColor clearColor];
        
        if (arr.count > 0) {
            nameLabel.text = [[arr objectAtIndex:0]objectForKey:@"realname"];
        }
        nameSize = [nameLabel.text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(90, 30)];//获取字符的宽度
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.frame = CGRectMake(85.0, 145, 90, 30);
        [self addSubview:nameLabel];
        //add by devin 2014.7.4
        sexImage = [[UIImageView alloc]initWithFrame:CGRectMake(85.f+nameSize.width+2, 154.f,12.f, 12.f)];
        [self addSubview:sexImage];
        [sexImage release];
        if (arr.count > 0) {
            if ([[[arr objectAtIndex:0]objectForKey:@"sex"] intValue] == 1) {
                [sexImage setImage:[UIImage imageNamed:@"img_sex_girl.png"]];
            }else{
                [sexImage setImage:[UIImage imageNamed:@"img_sex_boy.png"]];
            }
        }
        
        roleLabel = [[UILabel alloc]initWithFrame:CGRectMake(85.f, 175.f,100.f, 20.f)];
        roleLabel.backgroundColor = [UIColor clearColor];
        roleLabel.textColor = [UIColor whiteColor];
        roleLabel.font = KQLSystemFont(14);
        [self addSubview:roleLabel];
        if (arr.count > 0) {
            roleLabel.text = [[arr objectAtIndex:0] objectForKey:@"role"];
        }
        
        UIButton *_visitorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _visitorBtn.frame = CGRectMake(170.f, 155, 60, 80);
        [_visitorBtn addTarget:self action:@selector(visitorClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_visitorBtn];
        
        UILabel *visitor = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 0, 80.f, 20.f)];
        visitor.text = @"访客";
        visitor.textAlignment = NSTextAlignmentCenter;
        visitor.textColor = [UIColor whiteColor];
        visitor.font = KQLSystemFont(15);
        visitor.backgroundColor = [UIColor clearColor];
        [_visitorBtn addSubview:visitor];
        
        //访客红点提示
        _visitorRedPoint = [[UILabel alloc]initWithFrame:CGRectMake(57.f, 0, 15, 15)];
        _visitorRedPoint.text = @"●";
        _visitorRedPoint.hidden = YES;
        _visitorRedPoint.textColor = [UIColor redColor];
        _visitorRedPoint.font = KQLSystemFont(18);
        _visitorRedPoint.backgroundColor = [UIColor clearColor];
        [_visitorBtn addSubview:_visitorRedPoint];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_visitorBtn.frame) + 10,160, 1, 30.f)];
        line.backgroundColor = [UIColor whiteColor];
        line.alpha = 0.2;
        [self addSubview:line];
        
        UIButton *_likesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _likesBtn.frame = CGRectMake(CGRectGetMaxX(line.frame), 155, 60, 80);
        [_likesBtn addTarget:self action:@selector(likesClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_likesBtn];
        
        UILabel *likes = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f, 80.f, 20.f)];
        likes.text = @"赞";
        likes.textColor = [UIColor whiteColor];
        likes.font = KQLSystemFont(15);
        likes.textAlignment = NSTextAlignmentCenter;
        likes.backgroundColor = [UIColor clearColor];
        [_likesBtn addSubview:likes];
        
        //新的点赞红点提示
        _likesRedPoint = [[UILabel alloc]initWithFrame:CGRectMake(49.f, 0, 15, 15)];
        _likesRedPoint.text = @"●";
        _likesRedPoint.hidden = YES;
        _likesRedPoint.textColor = [UIColor redColor];
        _likesRedPoint.font = KQLSystemFont(18);
        _likesRedPoint.backgroundColor = [UIColor clearColor];
        [_likesBtn addSubview:_likesRedPoint];

        
        _visitorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 20.f, 80.f, 20.f)];
        _visitorLabel.backgroundColor = [UIColor clearColor];
        _visitorLabel.textAlignment = NSTextAlignmentCenter;
        _visitorLabel.textColor = [UIColor whiteColor];
    
        if (arr.count > 0) {
            _visitorLabel.text = [[arr objectAtIndex:0]objectForKey:@"visitor_sum"];
        }
        
        [_visitorBtn addSubview:_visitorLabel];
        
        _likeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.f,  20.f, 80.f, 20.f)];
        _likeLabel.backgroundColor = [UIColor clearColor];
        _likeLabel.textColor = [UIColor whiteColor];
        _likeLabel.textAlignment = NSTextAlignmentCenter;
        
        if (arr.count > 0) {
            _likeLabel.text = [[arr objectAtIndex:0]objectForKey:@"care_sum"];
        }
        [_likesBtn addSubview:_likeLabel];
        
        
        RELEASE_SAFE(visitor);
        RELEASE_SAFE(line);
        RELEASE_SAFE(likes);
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateInfo:) name:@"updateMainPage" object:nil];
   
    }
    return self;
}

// 更换头像
- (void)updatesHeadView:(NSNotification *)note{
    
    [_headView setImage:note.object];
}

- (void)setHeadImage:(UIImage *)img{
//    _headView.image = img;
}

//更新头部数据
- (void)writeDataInfo:(NSArray *)arr{
    if (arr.count !=0) {
        signLabel.text = [NSString stringWithFormat:@"\"%@\"",[[arr lastObject] objectForKey:@"signature"]];
        
        NSURL *urlStr = [NSURL URLWithString:[[arr lastObject] objectForKey:@"portrait"]];
        
        nameLabel.text = [[arr lastObject] objectForKey:@"realname"];
        //add by devin 2014.7.4
        nameSize = [nameLabel.text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(90, 30)];//获取字符的宽度
       sexImage.frame = CGRectMake(85.f+nameSize.width+2, 154.f,12.f, 12.f);
        if ([[[arr lastObject]objectForKey:@"sex"] intValue] == 1) {
            [sexImage setImage:[UIImage imageNamed:@"img_sex_girl.png"]];
            [_headView setImageWithURL:urlStr placeholderImage:IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME)];
        }else{
            [sexImage setImage:[UIImage imageNamed:@"img_sex_boy.png"]];
            [_headView setImageWithURL:urlStr placeholderImage:IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME)];
        }
        
        roleLabel.text = [[arr lastObject] objectForKey:@"role"];
        
        _visitorLabel.text = [NSString stringWithFormat:@"%@", [[arr lastObject] objectForKey:@"visitor_sum"]];
        
        _likeLabel.text = [NSString stringWithFormat:@"%@", [[arr lastObject] objectForKey:@"care_sum"]];
    }
}

//更新头部数据 通知
- (void)updateInfo:(NSNotification *)note{

    NSMutableArray *userInfo = [[NSMutableArray alloc]initWithCapacity:0];
    [userInfo addObject:note.object];

    if (userInfo.count !=0) {
        signLabel.text = [NSString stringWithFormat:@"\"%@\"",[[userInfo lastObject] objectForKey:@"signature"]];
        
        NSURL *urlStr = [NSURL URLWithString:[[userInfo lastObject] objectForKey:@"portrait"]];
        
        if ([[[userInfo objectAtIndex:0]objectForKey:@"sex"] intValue] == 1) {
            [_headView setImageWithURL:urlStr placeholderImage:IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME)];
        }else{
            [_headView setImageWithURL:urlStr placeholderImage:IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME)];
        }
        
        nameLabel.text = [[userInfo lastObject] objectForKey:@"realname"];
        //add by devin 2014.7.4
        nameSize = [nameLabel.text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(100, 30)];//获取字符的宽度 booky长度限制
        sexImage.frame = CGRectMake(85.f+nameSize.width+2, 154.f,12.f, 12.f);
        if ([[[userInfo objectAtIndex:0]objectForKey:@"sex"] intValue] == 1) {
            [sexImage setImage:[UIImage imageNamed:@"img_sex_girl.png"]];
        }else{
            [sexImage setImage:[UIImage imageNamed:@"img_sex_boy.png"]];
        }
        
        _visitorLabel.text = [NSString stringWithFormat:@"%@", [[userInfo lastObject] objectForKey:@"visitor_sum"]];
        
        _likeLabel.text = [NSString stringWithFormat:@"%@", [[userInfo lastObject] objectForKey:@"care_sum"]];
    }
    RELEASE_SAFE(userInfo);
}

// 头像点击
- (void)headClick{
    if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(topViewHeadClick)]) {
        [self.delegate performSelector:@selector(topViewHeadClick)];
    }
}

// 访客列表
- (void)visitorClick{
    if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(topViewVisitorClick)]) {
        [self.delegate performSelector:@selector(topViewVisitorClick)];
    }
}

// 赞列表
- (void)likesClick{
    if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(topViewlikesClick)]) {
        [self.delegate performSelector:@selector(topViewlikesClick)];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    RELEASE_SAFE(_headView);
    RELEASE_SAFE(_visitorLabel);
    RELEASE_SAFE(_likeLabel);
    RELEASE_SAFE(signLabel);
    RELEASE_SAFE(roleLabel);
    RELEASE_SAFE(nameLabel);
    RELEASE_SAFE(_visitorRedPoint);
    RELEASE_SAFE(_likesRedPoint);
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"updateMainPage" object:nil];
    [super dealloc];
}

@end
