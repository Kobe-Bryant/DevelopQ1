//
//  dyCardTableViewCell.h
//  ql
//
//  Created by yunlai on 14-6-6.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    TableViewCellCardTypeImage = 0,//图片类型
    TableViewCellCardTypeLable,//文字类型
    TableViewCellCardTypeOOXX,//ooxx类型
    TableViewCellCardTypeOpenTime,//开放时间类型
    TableViewCellCardTypeSecretary,//小秘书类型
    TableViewCellCardTypeNews,//组织新闻类型
    TableViewCellCardTypeTogether//聚聚类型
}TableViewCellCardType;

@interface dyCardTableViewCell : UITableViewCell{
    //卡片容器view
    UIView* contrainView;
}

//卡片数据
@property(nonatomic,retain) NSDictionary* dataDic;
//卡片类型
@property(nonatomic,assign) TableViewCellCardType cardType;

@end
