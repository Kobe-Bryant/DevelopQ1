//
//  dialogView.h
//  jw
//
//  Created by 云来ios－04 on 13-12-19.
//
//

#import <UIKit/UIKit.h>

@class dialogView;
@protocol dialogViewDelegate <NSObject>

@optional
-(UIView *)viewForShow;
-(BOOL)backgroundShouldTouchCancel;
-(void)buttonDidSelectAtIndex:(NSInteger)index;

@end

@interface dialogView : UIView

@property (nonatomic,assign) id<dialogViewDelegate> delegate;

-(void)showWithAnimation:(BOOL)animation;

-(void)hideAfterDelay:(NSTimeInterval)interval animation:(BOOL)animation;

//成功的提示
-(void)dialogSuccessWithText:(NSString *)text animation:(BOOL)animation;

//弹出提示框
-(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate buttonTitles:(NSArray *)titles;

//发送等待效果
-(void)showWaitingView;

-(void)showSingleText:(NSString *)text;

//升级的弹出框提示
-(void)showUpgradeViewWithLevel:(int)level animation:(BOOL)animation;

@end
