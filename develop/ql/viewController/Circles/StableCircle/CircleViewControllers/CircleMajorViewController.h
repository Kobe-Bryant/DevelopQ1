//
//  CircleMajorViewController.h
//  ql
//
//  Created by Dream on 14-8-19.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kBackStyleNormal,
    kBackStyleMessage,
}kBackStyle;

@interface CircleMajorViewController : UIViewController


@property (nonatomic , assign) kBackStyle backStyle;

@end
