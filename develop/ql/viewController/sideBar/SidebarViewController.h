//
//  SidebarViewController.h
//  ql
//
//  Created by ChenFeng on 14-1-9.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SidebarSelectedDelegate.h"
#import "HttpRequest.h"

// snail 0429
@interface SidebarViewController : UIViewController <SidebarSelectedDelegate,UINavigationControllerDelegate,HttpRequestDelegate,UIGestureRecognizerDelegate>
{
    BOOL sideBarShowing;
}

@property (assign, nonatomic) BOOL sideBarShowing;
+ (id)share;
-(void) backToFirstLoginState;
- (void)moveAnimationWithDirection:(SideBarShowDirection)direction duration:(float)duration;
@end
