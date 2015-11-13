//
//  mobileContactsCell.h
//  ql
//
//  Created by yunlai on 14-3-19.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mobileContactsCell : UITableViewCell
{
    UIImageView *_checkIcon;
    UIImageView *_headImage;
    UILabel *_nameLabel;
}
@property(nonatomic ,retain) UIImageView *checkIcon;
@property(nonatomic ,retain) UIImageView *headImage;
@property(nonatomic ,retain) UILabel *nameLabel;
@end
