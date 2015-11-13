//
//  CircleDetailCell.h
//  ql
//
//  Created by yunlai on 14-3-7.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//



#import <UIKit/UIKit.h>

typedef enum {
    CellTypeNomal,
    CellTypeLabel,
    CellTypeImageView,
    CellTypeSwitch,
}CellType;

@interface CircleDetailCell : UITableViewCell
{
    UILabel *_qTextLabel;
    UILabel *_qValueLabel;
    UIImageView *_qIconImage;
    UISwitch *_qSwitch;
}

@property (nonatomic ,retain) UILabel *qTextLabel;
@property (nonatomic ,retain) UILabel *qValueLabel;
@property (nonatomic ,retain) UIImageView *qIconImage;
@property (nonatomic ,retain) UISwitch *qSwitch;
@property (nonatomic ,assign) CellType cellType;

- (void)setCellType:(CellType)cellTypes;

@end
