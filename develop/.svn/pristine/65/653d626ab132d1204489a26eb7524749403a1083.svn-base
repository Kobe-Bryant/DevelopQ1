//
//  circlelistCell.m
//  ql
//
//  Created by yunlai on 14-4-3.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "circlelistCell.h"

#define kleftPadding 15.f
#define kpadding 10.f
#define smallHeight 20.f

@implementation CirclelistCell
//@synthesize headView = _headView;
@synthesize clubName = _clubName;
@synthesize markLabel = _markLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 图标
//        _headView = [[UIImageView alloc]initWithFrame:CGRectMake(kleftPadding, kpadding, 40, 40)];
//        _headView.layer.cornerRadius = 20;
//        _headView.clipsToBounds = YES;
//        _headView.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:_headView];
        
        // 消息标记
        _markLabel = [[UILabel alloc]initWithFrame:CGRectMake(kpadding, 25.f, 10, 10)];
        _markLabel.backgroundColor = [UIColor redColor];
        _markLabel.layer.cornerRadius = 5;
        _markLabel.clipsToBounds = YES;
        _markLabel.hidden = YES;
        [self.contentView addSubview:_markLabel];
        
        // 组织或圈子名称
        _clubName = [[UILabel alloc]initWithFrame:CGRectMake(kleftPadding * 2 - 10.f, kleftPadding, 160, 30)];
        _clubName.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
//        _clubName.textColor = COLOR_GRAY2;
        _clubName.backgroundColor = [UIColor clearColor];
        _clubName.font = KQLSystemFont(16);
        [self.contentView addSubview:_clubName];

        // 分割线
//        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 59.f, KUIScreenWidth, 1.5f)];
//        line.backgroundColor = RGBACOLOR(46, 50, 56, 0.9);
//        [self.contentView addSubview:line];
//        RELEASE_SAFE(line);
    }
    return self;
}

- (void)dealloc
{
//    RELEASE_SAFE(_headView);
    RELEASE_SAFE(_markLabel);
    RELEASE_SAFE(_clubName);
    [super dealloc];
}

- (void)isHaveMessageAlert:(int)isHave circleName:(NSString *)name{
    //动态计算字符串宽度
    CGSize titleSize = [name sizeWithFont:KQLSystemFont(15) constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    
    if (isHave) {
        _markLabel.hidden = NO;
        _clubName.frame = CGRectMake(kleftPadding * 2 - kpadding, kleftPadding, titleSize.width+ 10.f, 30);
        _markLabel.frame = CGRectMake(kleftPadding + 15.f + titleSize.width, 25.f, 10, 10);
        
    }else{
        
        _markLabel.hidden = YES;
        _clubName.frame = CGRectMake( kleftPadding * 2 - kpadding, kleftPadding, titleSize.width+ 10.f, 30);
        
    }
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
