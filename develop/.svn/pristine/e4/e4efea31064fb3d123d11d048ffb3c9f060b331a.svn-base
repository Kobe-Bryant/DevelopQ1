//
//  ModifyCircleNameViewController.h
//  ql
//
//  Created by yunlai on 14-3-20.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpRequest.h"

@protocol ModifyInfoDelegate <NSObject>

- (void)updateModifyInfo:(NSString *)infoStr;

@end

@interface ModifyCircleNameViewController : UIViewController<UITextFieldDelegate,HttpRequestDelegate>
{
    id<ModifyInfoDelegate> delegate;
}
@property (nonatomic, retain) NSString *circleNames;
@property (nonatomic, retain) NSDictionary *detailDictionary;
@property (nonatomic, assign) id<ModifyInfoDelegate> delegate;
//0是固定圈子，1是临时圈子
@property(nonatomic,assign) int circleType;

@end

