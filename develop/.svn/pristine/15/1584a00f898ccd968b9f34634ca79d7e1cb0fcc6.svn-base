//
//  CircleDetailCell.m
//  ql
//
//  Created by yunlai on 14-3-7.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "CircleDetailCell.h"

#define kMargin 15.f
#define kTopMargin 5.f

@implementation CircleDetailCell

@synthesize qIconImage = _qIconImage;
@synthesize qSwitch = _qSwitch;
@synthesize qTextLabel = _qTextLabel;
@synthesize qValueLabel = _qValueLabel;
@synthesize cellType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
  
        _qTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMargin, kTopMargin,100.f, 30.f)];
        _qTextLabel.font = KQLboldSystemFont(15);
        _qTextLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_qTextLabel];
        
        _qValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, kTopMargin,200.f, 30.f)];
        _qValueLabel.backgroundColor = [UIColor clearColor];
//        _qValueLabel.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
        _qValueLabel.textColor = COLOR_GRAY2;
        _qValueLabel.font = KQLSystemFont(15);
        _qValueLabel.textAlignment = NSTextAlignmentRight;
        _qValueLabel.numberOfLines = 0;
        _qValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_qValueLabel];
        
        _qIconImage = [[UIImageView alloc]initWithFrame:CGRectMake(KUIScreenWidth - 60.f, kTopMargin, 30.f, 30.f)];
        _qIconImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_qIconImage];
        
        _qSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(KUIScreenWidth - 80.f, kTopMargin, 80.f, 30.f)];
        _qSwitch.on = YES;
        [self.contentView addSubview:_qSwitch];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, 1.f)];
        line.backgroundColor = RGBACOLOR(242, 244, 246, 1);
        [self.contentView addSubview:line];
        RELEASE_SAFE(line);
    }
    return self;
}

- (void)dealloc
{
    RELEASE_SAFE(_qSwitch);
    RELEASE_SAFE(_qTextLabel);
    RELEASE_SAFE(_qIconImage);
    RELEASE_SAFE(_qValueLabel);
    [super dealloc];
}

- (void)setCellType:(CellType)cellTypes{
    switch (cellTypes) {
        case CellTypeNomal:
        {
            _qIconImage.hidden = YES;
            _qSwitch.hidden = YES;
            _qValueLabel.hidden = YES;
        
        }
            break;
            
        case CellTypeLabel:
        {
            _qIconImage.hidden = YES;
            _qSwitch.hidden = YES;
            _qValueLabel.hidden = NO;
      
        }
            break;
        case CellTypeImageView:
        {
            _qIconImage.hidden = NO;
            _qSwitch.hidden = YES;
            _qValueLabel.hidden = YES;
            
        }
            break;
        case CellTypeSwitch:
        {
            _qIconImage.hidden = YES;
            _qSwitch.hidden = NO;
            _qValueLabel.hidden = YES;

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
