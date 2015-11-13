//
//  commentCell.m
//  ql
//
//  Created by yunlai on 14-4-18.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "commentCell.h"

#define NAMECOLOR [UIColor colorWithRed:0.13 green:0.58 blue:0.90 alpha:1.0]

@implementation commentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setup];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setup{
    _headImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
    _headImgV.layer.cornerRadius = _headImgV.frame.size.height/2;
    [_headImgV.layer setMasksToBounds:YES];
    [self.contentView addSubview:_headImgV];
    
    _userNameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImgV.frame) + 5, CGRectGetMinY(_headImgV.frame), 100, 20)];
    _userNameLab.font = KQLboldSystemFont(14);
    _userNameLab.textColor = NAMECOLOR;
    _userNameLab.textAlignment = UITextAlignmentLeft;
    _userNameLab.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_userNameLab];
    
    _contentLab = [[TQRichTextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImgV.frame) + 5, CGRectGetMaxY(_userNameLab.frame), 200, 30)];
    _contentLab.font = KQLboldSystemFont(13);
    _contentLab.textColor = [UIColor darkGrayColor];
    _contentLab.backgroundColor = [UIColor clearColor];
    _contentLab.lineSpacing = 1.2;
    [self.contentView addSubview:_contentLab];
    _contentLab.userInteractionEnabled = NO;
    
    _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - CGRectGetMinX(_headImgV.frame) - 100, CGRectGetMinY(_headImgV.frame) + 5, 90, 10)];
    _timeLab.font = KQLboldSystemFont(10);
    _timeLab.textColor = [UIColor darkGrayColor];
    _timeLab.textAlignment = UITextAlignmentRight;
    _timeLab.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_timeLab];
    
    _delLab = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeLab.frame) - 20, CGRectGetMaxY(_timeLab.frame) + 10, 20, 20)];
    _delLab.image = IMG(@"ico_comment_del");
    [self.contentView addSubview:_delLab];
    
}

-(void) dealloc{
    RELEASE_SAFE(_delLab);
    RELEASE_SAFE(_headImgV);
    RELEASE_SAFE(_userNameLab);
    RELEASE_SAFE(_contentLab);
    RELEASE_SAFE(_timeLab);
    [super dealloc];
}

@end
