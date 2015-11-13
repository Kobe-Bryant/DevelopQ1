//
//  SubCollectionCellView.m
//  CommunityAPP
//
//  Created by yunlai on 14-4-20.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface SubCollectionCellView : UIView
{
    UIImageView *iconImageView;//icon 图片
    UILabel *titleNameLabel;//姓名
    UILabel *companyLabel; //公司名字
    
}

@property(retain,nonatomic) UIImageView *iconImageView;
@property(retain,nonatomic) UILabel *titleNameLabel;
@property(retain,nonatomic) UILabel *companyLabel;

-(void)initSubCollectionCellView;

@end
