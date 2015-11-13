//
//  aboutMeMsgCell.m
//  ql
//
//  Created by yunlai on 14-5-4.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "aboutMeMsgCell.h"

@implementation aboutMeMsgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

-(void) setup{
    //头像
    _headImgV = [[UIImageView alloc] init];
    _headImgV.frame = CGRectMake(10, 5, 50, 50);
    _headImgV.layer.cornerRadius = _headImgV.bounds.size.height/2;
    [_headImgV.layer setMasksToBounds:YES];
    [self.contentView addSubview:_headImgV];
    
    //name
    _nameLab = [[UILabel alloc] init];
    _nameLab.textAlignment = UITextAlignmentLeft;
    _nameLab.backgroundColor = [UIColor clearColor];
    _nameLab.textColor = [UIColor colorWithRed:0.25 green:0.66 blue:0.90 alpha:1.0];
    _nameLab.font = KQLboldSystemFont(15);
    _nameLab.frame = CGRectMake(CGRectGetMaxX(_headImgV.frame) + 10, CGRectGetMinY(_headImgV.frame), 150, 20);
    [self.contentView addSubview:_nameLab];
    
    //content
    _contentLab = [[TQRichTextView alloc] init];
    _contentLab.textColor = [UIColor darkGrayColor];
    _contentLab.backgroundColor = [UIColor clearColor];
    _contentLab.font = KQLboldSystemFont(15);
    _contentLab.frame = CGRectMake(CGRectGetMinX(_nameLab.frame), CGRectGetMaxY(_nameLab.frame) + 5, 200, 60);
    [self.contentView addSubview:_contentLab];
    _contentLab.userInteractionEnabled = NO;
    
    //time
    _timeLab = [[UILabel alloc] init];
    _timeLab.textAlignment = UITextAlignmentRight;
    _timeLab.textColor = [UIColor darkGrayColor];
    _timeLab.alpha = 0.8;
    _timeLab.font = KQLboldSystemFont(13);
    _timeLab.backgroundColor = [UIColor clearColor];
    _timeLab.frame = CGRectMake(self.bounds.size.width - 100, CGRectGetMinY(_nameLab.frame), 90, 15);
    [self.contentView addSubview:_timeLab];
    
    _newsImgV = [[UIImageView alloc] init];
    _newsImgV.frame = CGRectMake(self.bounds.size.width - 50, CGRectGetMaxY(_timeLab.frame) + 5, 45, 45);
    _newsImgV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_newsImgV];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.frame = CGRectMake(self.bounds.size.width - 50, CGRectGetMaxY(_timeLab.frame) + 5, 45, 45);
    _titleLab.numberOfLines = 0;
    _titleLab.lineBreakMode = UILineBreakModeWordWrap;
    _titleLab.tag = 1000;
    _titleLab.font = KQLboldSystemFont(13);
    _titleLab.textColor = [UIColor darkGrayColor];
    _titleLab.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_titleLab];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) dealloc{
    RELEASE_SAFE(_titleLab);
    RELEASE_SAFE(_headImgV);
    RELEASE_SAFE(_nameLab);
    RELEASE_SAFE(_contentLab);
    RELEASE_SAFE(_timeLab);
    RELEASE_SAFE(_newsImgV);
    [super dealloc];
}

@end
