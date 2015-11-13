//
//  MyQrCodeViewController.h
//  ql
//
//  Created by yunlai on 14-2-26.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyQrCodeViewController : UIViewController
{
    BOOL _isSaved;
}

@property (nonatomic ,retain) NSString *infoStr;

@end
