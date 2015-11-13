//
//  pwViewController.h
//  ql
//
//  Created by yunlai on 14-4-16.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pwDelegate <NSObject>

-(void) savePw:(NSString*) str;

@end

@interface pwViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,assign) id<pwDelegate> delegate;

@end
