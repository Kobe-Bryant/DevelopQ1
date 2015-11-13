//
//  SubCollectionCellView.m
//  CommunityAPP
//
//  Created by yunlai on 14-4-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//
#import "SubCollectionCellView.h"
#import "config.h"

@implementation SubCollectionCellView

@synthesize iconImageView;
@synthesize titleNameLabel;
@synthesize companyLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubCollectionCellView];
    }
    return self;
}

-(void) initSubCollectionCellView
{
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:@"img_common_default_male1.png"];
    [iconImageView setFrame:CGRectMake(10, 10, 50, 50)];
    iconImageView.clipsToBounds = YES;
    iconImageView.layer.cornerRadius = 25;
    iconImageView.userInteractionEnabled = YES;
    iconImageView.layer.borderWidth = 1.5;
    iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:iconImageView];
    
        //名称
    titleNameLabel = [[UILabel alloc ]initWithFrame:
                          CGRectMake(iconImageView.frame.size.width+iconImageView.frame.origin.x+8, iconImageView.frame.origin.y+5, 160, 18)];
    titleNameLabel.text = @"俞敏洪";
    titleNameLabel.textAlignment = NSTextAlignmentLeft;
    titleNameLabel.textColor = [UIColor blackColor];
    titleNameLabel.backgroundColor = [UIColor clearColor];
    titleNameLabel.font=[UIFont systemFontOfSize:15];
    [self addSubview:titleNameLabel];
    
    companyLabel = [[UILabel alloc ]initWithFrame:
                     CGRectMake(titleNameLabel.frame.origin.x, titleNameLabel.frame.size.height
                                +titleNameLabel.frame.origin.y+7, 95, 18)];
    companyLabel.text = @"新东方";
    companyLabel.textAlignment = NSTextAlignmentLeft;
    companyLabel.textColor = [UIColor grayColor];
    companyLabel.backgroundColor = [UIColor clearColor];
    companyLabel.font=[UIFont systemFontOfSize:11];
    [self addSubview:companyLabel];
}


- (void)dealloc
{
    [companyLabel release]; companyLabel = nil;
    [iconImageView release]; iconImageView = nil;
    [titleNameLabel release]; titleNameLabel = nil;
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
