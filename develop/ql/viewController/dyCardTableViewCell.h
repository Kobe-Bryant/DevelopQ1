//
//  dyCardTableViewCell.h
//  ql
//
//  Created by yunlai on 14-6-6.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    TableViewCellCardTypeImage = 0,
    TableViewCellCardTypeLable,
    TableViewCellCardTypeOOXX,
    TableViewCellCardTypeOpenTime,
    TableViewCellCardTypeSecretary,
    TableViewCellCardTypeNews
}TableViewCellCardType;

@interface dyCardTableViewCell : UITableViewCell{
    UIView* contrainView;
}

@property(nonatomic,retain) NSDictionary* dataDic;
@property(nonatomic,assign) TableViewCellCardType cardType;

@end
