//
//  YLNameCardCell.h
//  CardHolderDemo
//
//  Created by yunlai on 14-1-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLNameCardCell : UITableViewCell
{
    UIImageView *_checkIcon;
    UIImageView *_headImage;
    UILabel *_nameLabel;
}
@property(nonatomic ,retain) UIImageView *checkIcon;
@property(nonatomic ,retain) UIImageView *headImage;
@property(nonatomic ,retain) UILabel *nameLabel;
@end
