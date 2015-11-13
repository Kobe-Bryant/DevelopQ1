//
//  choiceCLCell.m
//  ql
//
//  Created by yunlai on 14-4-4.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "choiceCLCell.h"

@implementation choiceCLCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIView* v = [[UIView alloc] initWithFrame:self.bounds];
        v.backgroundColor = [UIColor clearColor];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 59.5f, KUIScreenWidth, 0.5)];
        line.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
        [v addSubview:line];
        RELEASE_SAFE(line);
        
        [self setSelectedBackgroundView:v];
        RELEASE_SAFE(v);
        
        [self setup];
    }
    return self;
}

-(void) setup{
    _selectImgV = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, (60-20)/2, 20, 20)];
    _selectImgV.image = [[ThemeManager shareInstance] getThemeImage:@"btn_group_select.png"];
    _selectImgV.highlightedImage = [[ThemeManager shareInstance] getThemeImage:@"btn_group_select_blue.png"];
    [self.contentView addSubview:_selectImgV];
    
    _circleName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selectImgV.frame) + 15, CGRectGetMinY(_selectImgV.frame), 200, 15)];
    _circleName.textAlignment = UITextAlignmentLeft;
    _circleName.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
    _circleName.font = [UIFont systemFontOfSize:15];
    _circleName.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_circleName];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
