//
//  personCell.m
//  ql
//
//  Created by yunlai on 14-4-10.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "personCell.h"

@implementation personCell
@synthesize iconImgV = _iconImgV;
@synthesize txtLabel = _txtLabel;
@synthesize headImgV = _headImgV;
@synthesize tipsNameL = _tipsNameL;
@synthesize cellType,showType;

#define kTopPadding 10.f
#define kPadding 5.f

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _tipsNameL = [[UILabel alloc]initWithFrame:CGRectMake(20.f, 5.f, 80.f, 40.f)];
        _tipsNameL.font = KQLboldSystemFont(16);
        [_tipsNameL setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_tipsNameL];
        
        _txtLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        
        _txtLabel.font = KQLSystemFont(15);
//        _txtLabel.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
        _txtLabel.textColor = COLOR_GRAY2;
        _txtLabel.numberOfLines = 2;
        _txtLabel.lineBreakMode = UILineBreakModeWordWrap;
        [_txtLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_txtLabel];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)dealloc
{
    RELEASE_SAFE(_tipsNameL);
    RELEASE_SAFE(_txtLabel);
    RELEASE_SAFE(_headImgV);
    RELEASE_SAFE(_iconImgV);
    [super dealloc];
}

- (void)setCellShowType:(CellShowType)type{
    
    if (type == CellShowTypeRight) {
        _txtLabel.frame = CGRectMake(CGRectGetMaxY(_tipsNameL.frame) + 45.f, 5.f, 200.f, 40.f);
        _txtLabel.textAlignment = NSTextAlignmentRight;
    }
    else if (type == CellShowTypeLeft) {
        _txtLabel.frame = CGRectMake(75.f, 5.f, 200.f, 40.f);
        _txtLabel.textAlignment = NSTextAlignmentLeft;
    }
}

- (void)setCellType:(CellType)cellTypes{
    switch (cellTypes) {
        // 签名
        case CellTypeNomal:
        {
            
        }
            break;
        // 昵称
        case CellTypeNameLabel:
        {
            
        }
            break;
        // 头像
        case CellTypeHeadImageView:
        {
            if (nil == _headImgV) {
                _headImgV = [[UIImageView alloc]initWithFrame:CGRectMake(KUIScreenWidth - 75.f, kPadding, 40.f, 40.f)];
            }
           
            _headImgV.layer.cornerRadius = 20;
            _headImgV.clipsToBounds = YES;
            _headImgV.image = IMGREADFILE(@"ico_group_portrait_88.png");
            [self.contentView addSubview:_headImgV];
            
        }
            break;
        // 图标
        case CellTypeIocnImageView:
        {
            if (nil == _iconImgV) {
                _iconImgV = [[UIImageView alloc]initWithFrame:CGRectMake(KUIScreenWidth - 65.f, kTopPadding, 30.f, 30.f)];

            }
            
            [self.contentView addSubview:_iconImgV];
        }
            break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
