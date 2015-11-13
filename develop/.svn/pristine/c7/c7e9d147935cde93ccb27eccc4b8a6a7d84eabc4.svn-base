//
//  groupCell.m
//  ql
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "groupCell.h"
#import "UIImageScale.h"

#define kleftPadding 15.f
#define kpadding 10.f
#define smallHeight 20.f

@implementation groupCell

@synthesize headView = _headView;
@synthesize clubName = _clubName;
@synthesize numLabel = _numLabel;
@synthesize markLabel = _markLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headView = [[UIImageView alloc]initWithFrame:CGRectMake(kpadding, 5.f, 50, 50)];
        _headView.userInteractionEnabled = YES;
        _headView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_headView];
        
        _markLabel = [[UILabel alloc]initWithFrame:CGRectMake(kpadding + 35.f, kpadding + 2, 20, 20)];
        _markLabel.backgroundColor = [UIColor redColor];
        _markLabel.textColor = [UIColor whiteColor];
        _markLabel.layer.cornerRadius = 10;
        _markLabel.clipsToBounds = YES;
        _markLabel.textAlignment = NSTextAlignmentCenter;
        _markLabel.hidden = YES;
        [self.contentView addSubview:_markLabel];
        
        _clubName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_headView.frame) + kleftPadding, kpadding - 3, 160, 30)];
        _clubName.textColor = [UIColor blackColor];
        _clubName.backgroundColor = [UIColor clearColor];
        _clubName.font = KQLSystemFont(16);
        [self.contentView addSubview:_clubName];
        
        
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_headView.frame) + kleftPadding, CGRectGetMaxY(_clubName.frame) - kpadding, 200, 30)];
        _numLabel.backgroundColor = [UIColor clearColor];
//        _numLabel.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY"];
        _numLabel.textColor = COLOR_GRAY;
        _numLabel.font = KQLSystemFont(13);
        _numLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_numLabel];
        
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
    RELEASE_SAFE(_headView);
    RELEASE_SAFE(_markLabel);
    RELEASE_SAFE(_clubName);
    RELEASE_SAFE(_numLabel);
    [super dealloc];
}

- (void)typesetHead:(NSInteger)index andImages:(NSArray *)imgsArray{
    for (int i =0; i < index; i++) {
        CGRect rect;
        if (index == 2) {
            rect = CGRectMake(25 * i, kleftPadding, smallHeight, smallHeight);
        }else if (index == 3){
            if (i == 0) {
                rect = CGRectMake(13.f, 3.f, smallHeight, smallHeight);
            }else{
                rect = CGRectMake(25 * (i-1), 25.f, smallHeight, smallHeight);
            }
            
        }else if (index >= 4){
            if (i <= 1) {
                rect = CGRectMake(24 * i , 3.f, smallHeight, smallHeight);
            }else{
                rect = CGRectMake(24 * (i-2), 25.f, smallHeight, smallHeight);
            }
        }
        
        UIImageView *smallView = [[UIImageView alloc]initWithFrame:rect];
        smallView.backgroundColor = [UIColor grayColor];
        smallView.layer.cornerRadius = 10;
        smallView.clipsToBounds = YES;
        NSString *imgStrs = [NSString stringWithFormat:@"%@",[imgsArray objectAtIndex:i]];
        UIImage *bgImage = [UIImage imageCwNamed:imgStrs];
        smallView.image = bgImage;
        [_headView addSubview:smallView];
        RELEASE_SAFE(smallView);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
