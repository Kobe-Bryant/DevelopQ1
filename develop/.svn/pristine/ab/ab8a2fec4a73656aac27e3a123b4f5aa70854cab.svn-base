//
//  MyQrCodeViewController.m
//  ql
//
//  Created by yunlai on 14-2-26.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "MyQrCodeViewController.h"

@interface MyQrCodeViewController ()

@end

@implementation MyQrCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = COLOR_BG_VIEW;
    
    self.navigationItem.title = @"我的二维码";
    
    [self rightBarButton];
}

/**
 *  分享
 */
- (void)rightBarButton{
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor grayColor];
    [backButton addTarget:self action:@selector(shareTo) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [[UIImage alloc ]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return" ofType:@"png"]];
    [backButton setImage:image forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 30.f, 30.f);
    RELEASE_SAFE(image);
    UIBarButtonItem  *backItem = [[UIBarButtonItem  alloc]  initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = backItem;
    RELEASE_SAFE(backItem);
}

- (void)shareTo{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
