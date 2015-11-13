//
//  CRNavigationController.m
//  CRNavigationControllerExample
//
//  Created by Corey Roberts on 9/24/13.
//  Copyright (c) 2013 SpacePyro Inc. All rights reserved.
//

#import "CRNavigationController.h"
#import "CRNavigationBar.h"
#import "ThemeManager.h"

@interface CRNavigationController ()

@end

@implementation CRNavigationController

- (id)init {
    self = [super initWithNavigationBarClass:[UINavigationBar class] toolbarClass:nil];
    if(self) {
//        UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
//        backButton.backgroundColor = [UIColor whiteColor];
//        [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
//        backButton.frame = CGRectMake(10, 0, 60, 30);
//        [backButton setTitle:@"back" forState:UIControlStateNormal];
//        UIBarButtonItem  *backItem = [[UIBarButtonItem  alloc]  initWithCustomView:backButton];
//        self.navigationItem.leftBarButtonItem = backItem;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    DLog(@"NavigationFrame %@",self.view);
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 1) {
        UIImage *image = [[ThemeManager shareInstance] getThemeImage:@"ico_common_return.png"];
        
        UIButton *barbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        barbutton.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
        
        if (IOS_VERSION_7) {
            barbutton.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
        }
        
        [barbutton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
        [barbutton setImage:image forState:UIControlStateNormal];
        UIImage *img = [[UIImage alloc ]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_click" ofType:@"png"]];
        [barbutton setImage:img forState:UIControlStateHighlighted];
        [img release], img = nil;
        UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:barbutton];
        viewController.navigationItem.leftBarButtonItem = barBtnItem;
        [barBtnItem release], barBtnItem = nil;
        
    }
}


- (void)backTo
{
    [self popViewControllerAnimated:YES];
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithNavigationBarClass:[UINavigationBar class] toolbarClass:nil];
    if(self) {
        self.viewControllers = @[rootViewController];
    }
    
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc{
    LOG_RELESE_SELF;
    [super dealloc];
}

@end
