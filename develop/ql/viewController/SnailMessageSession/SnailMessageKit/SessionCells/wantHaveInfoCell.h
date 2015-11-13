//
//  wantHaveInfoCell.h
//  ql
//
//  Created by yunlai on 14-6-18.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wantHaveInfoCell : UITableViewCell{
    UIImageView* whImageV;
}

@property(nonatomic,retain) UIView* contentV;
@property(nonatomic,retain) UILabel* contentLab;
@property(nonatomic,retain) UILabel* timeLab;
@property(nonatomic,assign) int type;//1表示我有，2表示我要

@property(nonatomic,retain) UILabel *titleLabel;

+ (float)caculateCellHeighFrom:(NSDictionary *)messageDic;

- (void)freshWithInfoDic:(NSDictionary *)messageDic;
@end
