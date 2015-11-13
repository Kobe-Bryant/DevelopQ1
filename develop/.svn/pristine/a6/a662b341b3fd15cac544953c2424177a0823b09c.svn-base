//
//  cloudTopCell.m
//  ql
//
//  Created by yunlai on 14-2-27.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "cloudTopCell.h"

#define kleftPadding 20.f
#define kpadding 15.f
#define kWidth 30.f
#define kHightPadding 60.f

@implementation cloudTopCell
@synthesize headView = _headView;
@synthesize bgImageView = _bgImageView;
@synthesize likeLabel = _likeLabel;
@synthesize visitorLabel = _visitorLabel;
@synthesize visitorBtn = _visitorBtn;
@synthesize likesBtn = _likesBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSLog(@"===%f",self.frame.size.height);
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.frame.size.width, 200.f)];
        _bgImageView.backgroundColor = [UIColor clearColor];
        _bgImageView.userInteractionEnabled = YES;
        [self addSubview:_bgImageView];
        
        _headView = [[UIImageView alloc]initWithFrame:CGRectMake(kpadding, _bgImageView.frame.size.height - kHightPadding, 60, 60)];
        _headView.userInteractionEnabled = YES;
        _headView.layer.cornerRadius = 30;
        _headView.clipsToBounds = YES;
        _headView.backgroundColor = [UIColor grayColor];
        [_bgImageView addSubview:_headView];
        
        _visitorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _visitorBtn.frame = CGRectMake(150.f, _bgImageView.frame.size.height - kHightPadding + 20, 60, 80);
        [_bgImageView addSubview:_visitorBtn];
        
        UILabel *visitor = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 0, 80.f, 20.f)];
        visitor.text = @"访客";
        visitor.textAlignment = NSTextAlignmentCenter;
        visitor.textColor = [UIColor whiteColor];
        visitor.backgroundColor = [UIColor clearColor];
        [_visitorBtn addSubview:visitor];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_visitorBtn.frame), _bgImageView.frame.size.height - kHightPadding + 20, 1, 40.f)];
        line.backgroundColor = [UIColor whiteColor];
        line.alpha = 0.3;
        [_bgImageView addSubview:line];
        
        _likesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _likesBtn.frame = CGRectMake(CGRectGetMaxX(line.frame) + 2, _bgImageView.frame.size.height - kHightPadding + 20, 60, 80);
    
        [_bgImageView addSubview:_likesBtn];
        
        UILabel *likes = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f, 80.f, 20.f)];
        likes.text = @"赞";
        likes.textColor = [UIColor whiteColor];
        likes.textAlignment = NSTextAlignmentCenter;
        likes.backgroundColor = [UIColor clearColor];
        [_likesBtn addSubview:likes];
        
        _visitorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 20.f, 80.f, 20.f)];
        _visitorLabel.backgroundColor = [UIColor clearColor];
        _visitorLabel.textAlignment = NSTextAlignmentCenter;
        _visitorLabel.textColor = [UIColor whiteColor];
        [_visitorBtn addSubview:_visitorLabel];
        
        _likeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.f,  20.f, 80.f, 20.f)];
        _likeLabel.backgroundColor = [UIColor clearColor];
        _likeLabel.textColor = [UIColor whiteColor];
        _likeLabel.textAlignment = NSTextAlignmentCenter;;
        [_likesBtn addSubview:_likeLabel];
        
        RELEASE_SAFE(visitor);
        RELEASE_SAFE(likes);
        RELEASE_SAFE(line);
    }
    return self;
}


- (void)dealloc
{
    RELEASE_SAFE(_bgImageView);
    RELEASE_SAFE(_headView);
    RELEASE_SAFE(_visitorLabel);
    RELEASE_SAFE(_likeLabel);
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
