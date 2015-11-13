//
//  personCell.h
//  ql
//
//  Created by yunlai on 14-4-10.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CellTypeNomal,
    CellTypeNameLabel,
    CellTypeHeadImageView,
    CellTypeIocnImageView,
}CellType;

typedef enum {
    CellShowTypeLeft,
    CellShowTypeRight,
}CellShowType;


@interface personCell : UITableViewCell
{
    UILabel *_tipsNameL;
    UIImageView *_headImgV;
    UIImageView *_iconImgV;
    UILabel *_txtLabel;
}

@property (nonatomic ,retain) UILabel *tipsNameL;
@property (nonatomic ,retain) UIImageView *headImgV;
@property (nonatomic ,retain) UIImageView *iconImgV;
@property (nonatomic ,retain) UILabel *txtLabel;
@property (nonatomic ,assign) CellType cellType;
@property (nonatomic ,assign) CellShowType showType;

- (void)setCellType:(CellType)cellTypes;

- (void)setCellShowType:(CellShowType)type;
@end
