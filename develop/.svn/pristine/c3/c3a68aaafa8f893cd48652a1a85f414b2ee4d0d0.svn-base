//
//  OrganizeCell.m
//  ql
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "OrganizeCell.h"
#define ktopPadding 15.f
#define kpadding 10.f

@implementation OrganizeCell
@synthesize headView = _headView;
@synthesize userName = _userName;
@synthesize markLabel = _markLabel;
@synthesize positionLabel = _positionLabel;
@synthesize cornerImage = _cornerImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headView = [[UIImageView alloc]initWithFrame:CGRectMake(kpadding, kpadding - 5, 50, 50)];
        _headView.userInteractionEnabled = YES;
        _headView.layer.cornerRadius = 25;
        _headView.clipsToBounds = YES;
        _headView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_headView];
        
        _markLabel = [[UILabel alloc]initWithFrame:CGRectMake(kpadding + 35.f, kpadding + 2, 15, 15)];
        _markLabel.backgroundColor = COLOR_CONTROL;
        _markLabel.textColor = [UIColor whiteColor];
        _markLabel.layer.cornerRadius = 10;
        _markLabel.clipsToBounds = YES;
        _markLabel.textAlignment = NSTextAlignmentCenter;
        _markLabel.hidden = YES;
        [self.contentView addSubview:_markLabel];
        
        _userName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_headView.frame) + ktopPadding, ktopPadding, 150, 30)];
        _userName.textColor = [UIColor blackColor];
        _userName.backgroundColor = [UIColor clearColor];
        _userName.font = KQLboldSystemFont(15);
        [self.contentView addSubview:_userName];
        
    
        _cornerImage =[[UIImageView alloc]initWithFrame:CGRectMake(KUIScreenWidth - 40.f, ktopPadding + kpadding, 18, 10)];
        _cornerImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_cornerImage];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 59.f, KUIScreenWidth, 1.f)];
//        line.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LINE"];
        line.backgroundColor = COLOR_LINE;
        [self.contentView addSubview:line];
        RELEASE_SAFE(line);
    }
    return self;
}

- (void)dealloc
{
    RELEASE_SAFE(_markLabel);
    RELEASE_SAFE(_headView);
    RELEASE_SAFE(_positionLabel);
    RELEASE_SAFE(_userName);
    RELEASE_SAFE(_cornerImage);
    [super dealloc];
}

- (void)changeArrowWithUp:(BOOL)up
{
    if (up) {
        self.cornerImage.image = [UIImage imageNamed:@"UpAccessory.png"];
    }else
    {
        self.cornerImage.image = [UIImage imageNamed:@"DownAccessory.png"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
