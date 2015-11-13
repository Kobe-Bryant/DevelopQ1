//
//  PXAlertView.h
//  PXAlertViewDemo
//
//  Created by Alex Jarvis on 25/09/2013.
//  Copyright (c) 2013 Panaxiom Ltd. All rights reserved.
//

@import UIKit;
@class PXAlertView;

@protocol PXAlertDelegate <NSObject>

- (void)alertViews:(PXAlertView *)alertView clickedButtonAtIndex:(UIButton *)buttonIndexs;

@end

@interface PXAlertView : UIView
{
   __unsafe_unretained id<PXAlertDelegate>delegate;
}
@property (nonatomic, assign) id<PXAlertDelegate>delegate;

@property (nonatomic, getter = isVisible) BOOL visible;

+ (PXAlertView *)showAlertWithTitle:(NSString *)title;

+ (PXAlertView *)showAlertWithTitle:(NSString *)title
                            message:(NSString *)message;

+ (PXAlertView *)showAlertWithTitle:(NSString *)title
                            message:(NSString *)message
                         completion:(void(^) (BOOL cancelled))completion;

+ (PXAlertView *)showAlertWithTitle:(NSString *)title
                            message:(NSString *)message
                        cancelTitle:(NSString *)cancelTitle
                         completion:(void(^) (BOOL cancelled))completion;

+ (PXAlertView *)showAlertWithTitle:(NSString *)title
                            message:(NSString *)message
                        cancelTitle:(NSString *)cancelTitle
                         otherTitle:(NSString *)otherTitle
                         completion:(void(^) (BOOL cancelled))completion;

+ (PXAlertView *)showAlertWithTitle:(NSString *)title
                            message:(NSString *)message
                        cancelTitle:(NSString *)cancelTitle
                         otherTitle:(NSString *)otherTitle
                        contentView:(UIView *)view
                      alertDelegate:(id<PXAlertDelegate>)delegate
                         completion:(void(^) (BOOL cancelled))completion;

@end


