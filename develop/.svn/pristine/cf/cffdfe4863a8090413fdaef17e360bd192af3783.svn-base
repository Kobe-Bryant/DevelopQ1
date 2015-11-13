//
//  DyListViewController.m
//  ql
//
//  Created by yunlai on 14-4-1.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "DyListViewController.h"

#import "SidebarViewController.h"
#import "TalkingMainViewController.h"

@interface DyListViewController ()

@end

@implementation DyListViewController

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
    
    self.navigationItem.title = @"写一写";
    
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    self.view.alpha = 0.5;
    
    [self backBarBtn];
    
    [self rightBarButton];
    
    [self setupViews];
	// Do any additional setup after loading the view.
}

-(void) setupViews{
    UIButton* imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [imageBtn setFrame:CGRectMake(70, self.view.bounds.size.height/2 - 120, 80, 80)];
    imageBtn.tag = 100;
    imageBtn.backgroundColor = [UIColor redColor];
    [imageBtn setTitle:@"图文" forState:UIControlStateNormal];
    [imageBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageBtn];
    imageBtn.layer.cornerRadius = imageBtn.bounds.size.width/2;
    
    UILabel* imageLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageBtn.frame), CGRectGetMaxY(imageBtn.frame), imageBtn.bounds.size.width, 20)];
    imageLab.text = @"图文";
    imageLab.textColor = [UIColor whiteColor];
    imageLab.textAlignment = NSTextAlignmentCenter;
    imageLab.font = KQLboldSystemFont(14);
    [self.view addSubview:imageLab];
     RELEASE_SAFE(imageLab);//add vincent
    
    UIButton* OOXXBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [OOXXBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [OOXXBtn setFrame:CGRectMake(CGRectGetMaxX(imageBtn.frame) + 20, CGRectGetMinY(imageBtn.frame), 80, 80)];
    OOXXBtn.tag = 101;
    OOXXBtn.backgroundColor = [UIColor greenColor];
    [OOXXBtn setTitle:@"OOXX" forState:UIControlStateNormal];
    [OOXXBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:OOXXBtn];
    OOXXBtn.layer.cornerRadius = imageBtn.bounds.size.width/2;
    
    UILabel* OOXXLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(OOXXBtn.frame), CGRectGetMaxY(OOXXBtn.frame), OOXXBtn.bounds.size.width, 20)];
    OOXXLab.text = @"OOXX";
    OOXXLab.textColor = [UIColor whiteColor];
    OOXXLab.textAlignment = NSTextAlignmentCenter;
    OOXXLab.font = KQLboldSystemFont(14);
    [self.view addSubview:OOXXLab];
     RELEASE_SAFE(OOXXLab);//add vincent
    
    UIButton* publicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [publicBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [publicBtn setFrame:CGRectMake(CGRectGetMinX(imageBtn.frame), CGRectGetMaxY(imageBtn.frame) + 40, 80, 80)];
    publicBtn.tag = 102;
    publicBtn.backgroundColor = [UIColor blueColor];
    [publicBtn setTitle:@"开放时间" forState:UIControlStateNormal];
    [publicBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publicBtn];
    publicBtn.layer.cornerRadius = publicBtn.bounds.size.width/2;
    
    UILabel* publicLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(publicBtn.frame), CGRectGetMaxY(publicBtn.frame), publicBtn.bounds.size.width, 20)];
    publicLab.text = @"开放时间";
    publicLab.textColor = [UIColor whiteColor];
    publicLab.textAlignment = NSTextAlignmentCenter;
    publicLab.font = KQLboldSystemFont(14);
    [self.view addSubview:publicLab];
    RELEASE_SAFE(publicLab);//add vincent
    
    UIButton* wantBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wantBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [wantBtn setFrame:CGRectMake(CGRectGetMaxX(imageBtn.frame) + 20, CGRectGetMaxY(imageBtn.frame) + 40, 80, 80)];
    wantBtn.tag = 103;
    wantBtn.backgroundColor = [UIColor yellowColor];
    [wantBtn setTitle:@"我有我要" forState:UIControlStateNormal];
    [wantBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wantBtn];
    wantBtn.layer.cornerRadius = wantBtn.bounds.size.width/2;
    
    UILabel* wantLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(wantBtn.frame), CGRectGetMaxY(wantBtn.frame), wantBtn.bounds.size.width, 20)];
    wantLab.text = @"我有我要";
    wantLab.textColor = [UIColor whiteColor];
    wantLab.textAlignment = NSTextAlignmentCenter;
    wantLab.font = KQLboldSystemFont(14);
    [self.view addSubview:wantLab];
    RELEASE_SAFE(wantLab);//add vincent
}

-(void) btnClick:(UIButton*) btn{
    switch (btn.tag) {
        case 100:
        {
            //发布图文
            TalkingMainViewController* talkVC = [[TalkingMainViewController alloc] init];
            [self.navigationController pushViewController:talkVC animated:YES];
            RELEASE_SAFE(talkVC);
        }
            break;
        case 101:
        {
            //发布OOXX
        }
            break;
        case 102:
        {
            //发布开放时间
        }
            break;
        case 103:
        {
            //发布我有我要
        }
            break;
        default:
            break;
    }
}

/**
 *  返回按钮
 */
- (void)backBarBtn{
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [[UIImage alloc ]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"QRPositionRound" ofType:@"png"]];
    [backButton setImage:image forState:UIControlStateNormal];
    backButton.frame = CGRectMake(20 , 30, 30.f, 30.f);
    RELEASE_SAFE(image);
    UIBarButtonItem  *backItem = [[UIBarButtonItem  alloc]  initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    RELEASE_SAFE(backItem);
}

#pragma mark - event Method
/**
 *  返回事件
 */
- (void)backTo{
    
    if (![[SidebarViewController share]sideBarShowing]) {
        [[SidebarViewController share]moveAnimationWithDirection:SideBarShowDirectionLeft duration:0.15];
    }else{
        [[SidebarViewController share]moveAnimationWithDirection:SideBarShowDirectionNone duration:0.15];
    }
}

/**
 * 上部菜单
 */

- (void)rightBarButton{
    
    UIButton *rightButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [[UIImage alloc ]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"QRPositionRound" ofType:@"png"]];
    [rightButton setImage:image forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(25 , 7, 30.f, 30.f);
    RELEASE_SAFE(image);
    
    UIBarButtonItem  *rightItem = [[UIBarButtonItem  alloc]  initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    RELEASE_SAFE(rightItem);
    
}

-(void) rightBtnClick{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
