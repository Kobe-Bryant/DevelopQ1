//
//  memberLikesCell.h
//  ql
//
//  Created by yunlai on 14-4-16.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    cellTypeThumbImage,
    cellTypeIntroLabel,
}cellTypeSytle;

@interface memberLikesCell : UITableViewCell
{
    UIImageView *_headView;     //头像
    UILabel *_userName;         //用户名
    UILabel *_professional;     //职务
    UILabel *_companyL;         //公司名
    UILabel *_likeTime;         //时间
    
    UIImageView *_thumbnailImage;//缩略图
    UILabel *_introLabel;       //缩略文
}

@property (nonatomic ,retain) UIImageView *headView;
@property (nonatomic ,retain) UILabel *userName;
@property (nonatomic ,retain) UILabel *professional;
@property (nonatomic ,retain) UILabel *companyL;
@property (nonatomic ,retain) UILabel *likeTime;
@property (nonatomic ,retain) UIImageView *thumbnailImage;
@property (nonatomic ,retain) UILabel *introLabel;

- (void)setCellTypeShow:(cellTypeSytle)cellType;

@end
