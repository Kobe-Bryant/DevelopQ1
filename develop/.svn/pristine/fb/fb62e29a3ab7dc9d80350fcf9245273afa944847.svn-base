//
//  choiceCityViewController.h
//  ql
//
//  Created by yunlai on 14-4-12.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    CityTableTypeSingle = 1,
    CityTableTypeMutil = 0
}CityTableType;

@protocol choiceCityDelegate <NSObject>

@optional
-(void) didSelectedCity:(NSArray *)cityName;
-(void) cancelCTClick;

@end

@interface choiceCityViewController : UIViewController<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate>

@property(assign,nonatomic) id<choiceCityDelegate> delegate;
//选择城市类型，单选和双选
@property(assign,nonatomic) CityTableType cityType;

@end
