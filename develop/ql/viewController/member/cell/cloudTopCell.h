//
//  cloudTopCell.h
//  ql
//
//  Created by yunlai on 14-2-27.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cloudTopCell : UITableViewCell
{
    UIImageView *_bgImageView;
    UIImageView *_headView;
    UILabel *_visitorLabel;
    UILabel *_likeLabel;
    UIButton *_visitorBtn;
    UIButton *_likesBtn;
}

@property (nonatomic ,retain) UIImageView *bgImageView;
@property (nonatomic ,retain) UIImageView *headView;
@property (nonatomic ,retain) UILabel *visitorLabel;
@property (nonatomic ,retain) UILabel *likeLabel;
@property (nonatomic ,retain) UIButton *visitorBtn;
@property (nonatomic ,retain) UIButton *likesBtn;
@end
