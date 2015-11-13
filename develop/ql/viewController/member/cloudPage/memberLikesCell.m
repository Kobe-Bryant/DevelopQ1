//
//  memberLikesCell.m
//  ql
//
//  Created by yunlai on 14-4-16.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "memberLikesCell.h"

#define kPadding 10.f

@implementation memberLikesCell
@synthesize headView = _headView;
@synthesize companyL = _companyL;
@synthesize userName = _userName;
@synthesize professional = _professional;
@synthesize thumbnailImage = _thumbnailImage;
@synthesize introLabel = _introLabel;
@synthesize likeTime = _likeTime;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headView = [[UIImageView alloc]initWithFrame:CGRectMake(kPadding, kPadding, 45.f, 45.f)];
        _headView.layer.cornerRadius = 23;
        _headView.clipsToBounds = YES;
        _headView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_headView];
        
        _userName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_headView.frame)+ kPadding, kPadding, 200.f, 30.f)];
        _userName.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
//        _userName.textColor = COLOR_GRAY2;
        _userName.font = KQLboldSystemFont(16);
         _userName.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_userName];
        
//        _professional = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_headView.frame) +CGRectGetMaxY(_userName.frame)+ kPadding * 3, kPadding, 70.f, 30.f)];
//        _professional.textColor = [UIColor whiteColor];
//        _professional.font = KQLboldSystemFont(16);
//         _professional.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:_professional];
        
        _companyL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_headView.frame)+ kPadding, CGRectGetMaxY(_userName.frame), 200.f, 20.f)];
//        _companyL.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY"];
        _companyL.textColor = COLOR_GRAY;
        _companyL.font = KQLSystemFont(13);
         _companyL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_companyL];
        
        _likeTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_headView.frame)+ kPadding, CGRectGetMaxY(_companyL.frame), 200.f, 20.f)];
//        _likeTime.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY"];
        _likeTime.textColor = COLOR_GRAY;
        _likeTime.font = KQLSystemFont(13);
        _likeTime.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_likeTime];
        
        _thumbnailImage = [[UIImageView alloc]initWithFrame:CGRectMake(KUIScreenWidth - 80.f, kPadding, 60.f, 60.f)];
        _thumbnailImage.backgroundColor = [UIColor grayColor];
        _thumbnailImage.hidden = YES;
        [self.contentView addSubview:_thumbnailImage];
        
        _introLabel = [[UILabel alloc]initWithFrame:CGRectMake(KUIScreenWidth - 80.f,kPadding, 60.f, 60.f)];
        _introLabel.numberOfLines = 2;
        _introLabel.textAlignment = NSTextAlignmentCenter;
        _introLabel.textColor = [UIColor grayColor];
        _introLabel.font = KQLSystemFont(15);
        _introLabel.hidden = YES;
        [self.contentView addSubview:_introLabel];
        
        // 分割线
//        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 89.f, KUIScreenWidth, 1.0f)];
//        line.backgroundColor = RGBACOLOR(46, 50, 56, 0.9);
//        [self.contentView addSubview:line];
//        RELEASE_SAFE(line);
    }
    return self;
}

- (void)setCellTypeShow:(cellTypeSytle)cellType{
    switch (cellType) {
        case cellTypeThumbImage:
        {
            _thumbnailImage.hidden = NO;
            _introLabel.hidden = YES;
        }
            break;
        case cellTypeIntroLabel:
        {
            _thumbnailImage.hidden = YES;
            _introLabel.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)dealloc
{
    RELEASE_SAFE(_headView);
//    RELEASE_SAFE(_professional);
    RELEASE_SAFE(_userName);
    RELEASE_SAFE(_companyL);
    RELEASE_SAFE(_likeTime);
    RELEASE_SAFE(_thumbnailImage);
    RELEASE_SAFE(_introLabel);
    [super dealloc];
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
