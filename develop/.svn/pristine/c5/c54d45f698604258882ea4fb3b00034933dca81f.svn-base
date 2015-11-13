//
//  SubCollectionsCell.m
//  CommunityAPP
//
//  Created by yunlai on 14-4-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "SubCollectionsCell.h"
#import "Global.h"

#define RMarginX 0
#define RMarginY 0
@implementation SubCollectionsCell

@synthesize cellView1=_cellView1;
@synthesize cellView2=_cellView2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubCollectionsCell];
    }
    return self;
}
-(void)initSubCollectionsCell
{
    NSInteger width = 320/2;
    _cellView1 = [[SubCollectionCellView alloc] initWithFrame:CGRectMake(0*width + RMarginX, RMarginY, width - 2*RMarginX, 155 - 2*RMarginY)];
    [self.contentView addSubview:_cellView1];
 
    _cellView2 = [[SubCollectionCellView alloc] initWithFrame:CGRectMake(1*width + RMarginX, RMarginY, width - 2*RMarginX, 155 - 2*RMarginY)];
    _cellView2.clipsToBounds = YES;
    [self.contentView addSubview:_cellView2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dealloc
{
    [_cellView1 release];
    [_cellView2 release];
    [super dealloc];
}

@end
