//
//  ModifyIntroduceViewController.h
//  ql
//
//  Created by yunlai on 14-4-21.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpRequest.h"

@protocol ModifyIntroduceViewControllerDelegate <NSObject>

- (void)modifyIntroduceSuccessWithNewIntroduce:(NSString *)introduce;

@end

@interface ModifyIntroduceViewController : UIViewController<UITextViewDelegate,HttpRequestDelegate>
@property (nonatomic, retain) NSDictionary *detailDictionary;

@property (nonatomic, assign) id <ModifyIntroduceViewControllerDelegate> delegate;

@end
