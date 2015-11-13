//
//  relevancyMobileCell.h
//  ql
//
//  Created by yunlai on 14-3-19.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface relevancyMobileCell : UITableViewCell
{
    UIImageView *_iconView;
    UILabel *_tipsLabel;
    UILabel *_detailLabel;
}

@property (nonatomic,retain) UIImageView *iconView;
@property (nonatomic,retain) UILabel *tipsLabel;
@property (nonatomic,retain) UILabel *detailLabel;

@end
