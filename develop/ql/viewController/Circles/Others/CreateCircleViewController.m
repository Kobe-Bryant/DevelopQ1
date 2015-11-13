//
//  CreateCircleViewController.m
//  ql
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "CreateCircleViewController.h"
#import "circle_member_list_model.h"
#import "login_info_model.h"
#import "circle_list_model.h"
#import "CircleManager.h"
#import "CustomInsetTextView.h"

#import "CircleDetailSuccessViewController.h"

#define kMargin 15.f
#define kTopMargin 5.f

#define defaultNameNotifyStr         @"输入圈子名称"
#define defaultIntroduceNotifyStr    @"输入介绍文字"

@interface CreateCircleViewController () <FatherCircleManagerDelegate>
{
    UITextView *_circleName;
    UITextView *_circleIntroduce;
    
    UIButton *_createBtn;
    
    UILabel *_intro;
    
    NSMutableDictionary *_dataDictionary;
}
@property (nonatomic ,retain)MBProgressHUD *mbProgressHUD;
@end

@implementation CreateCircleViewController
@synthesize delegate,mbProgressHUD;

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
    self.view.backgroundColor = COLOR_LIGHTWEIGHT;
    self.title = @"创建私人圈子";
    
    _dataDictionary = [[NSMutableDictionary alloc]init];
    
    if (IOS_VERSION_7) {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        self.navigationController.navigationBar.translucent = NO;
    }
    
//    CGFloat kTopHeight;
//    kTopHeight = 25.f;
//    
//    UIView *nameView = [[UIView alloc]initWithFrame:CGRectMake(0.f, kTopHeight, KUIScreenWidth, 40.f)];
//    nameView.backgroundColor = [UIColor whiteColor];
//    nameView.layer.borderColor = RGBACOLOR(213, 216, 225, 1).CGColor;
//    nameView.layer.borderWidth = 1;
//    [self.view addSubview:nameView];
//    
    // 圈子名称
    _circleName = [[CustomInsetTextView alloc]initWithFrame:CGRectMake(0, 25.f, KUIScreenWidth , 40.f)];
    _circleName.backgroundColor = [UIColor whiteColor];
    _circleName.text  = defaultNameNotifyStr;
    _circleName.textColor = RGBACOLOR(195, 195, 202, 1);
    _circleName.layer.borderColor = RGBACOLOR(213, 216, 225, 1).CGColor;
    _circleName.layer.borderWidth = 1;
    _circleName.font = KQLboldSystemFont(15);
    _circleName.delegate = self;
    [self.view addSubview:_circleName];
    
    UIView *introView = [[UIView alloc]initWithFrame:CGRectMake(0.f, CGRectGetMaxY(_circleName.frame) + kMargin + 10.f, KUIScreenWidth, 100.f)];
    introView.layer.borderColor = RGBACOLOR(213, 216, 225, 1).CGColor;
    introView.layer.borderWidth = 1;
    introView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:introView];
    
    // 圈子介绍
    _circleIntroduce = [[CustomInsetTextView alloc]initWithFrame:CGRectMake(0, kTopMargin, KUIScreenWidth - 30.f, 90.f)];
    _circleIntroduce.delegate = self;
    _circleIntroduce.font = KQLboldSystemFont(15);
    _circleIntroduce.text = defaultIntroduceNotifyStr;
    _circleIntroduce.textColor = RGBACOLOR(195, 195, 202, 1);
    [introView addSubview:_circleIntroduce];
    
    _createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_createBtn setTitle:@"确认创建" forState:UIControlStateNormal];
    [_createBtn setBackgroundColor:COLOR_GRAY2];
    [_createBtn addTarget:self action:@selector(createClick) forControlEvents:UIControlEventTouchUpInside];
    [_createBtn setFrame:CGRectMake(kMargin, CGRectGetMaxY(introView.frame) + 30.f, KUIScreenWidth - kMargin * 2, 40.f)];
    [_createBtn setEnabled:NO];
    _createBtn.layer.cornerRadius = 6;
    [self.view addSubview:_createBtn];
    
    UILabel *tips = [[UILabel alloc]initWithFrame:CGRectMake(kMargin * 2, CGRectGetMaxY(_createBtn.frame) + 40.f, KUIScreenWidth - kMargin * 4, 60.f)];
    tips.numberOfLines = 2;
    tips.textColor = COLOR_GRAY;
    tips.font = KQLSystemFont(14);
    tips.backgroundColor = [UIColor clearColor];
    tips.text = [NSString stringWithFormat:@"每个人最多可创建%d个圈子哦，你还可以创建%d个圈子",CREATECIRCLEMAX,CREATECIRCLEMAX - [self createdCircleNum]];
    [self.view addSubview:tips];
    tips.hidden = YES;
    
    RELEASE_SAFE(tips);
    RELEASE_SAFE(introView);
    
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    //返回按钮
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    backButton.titleLabel.font = KQLboldSystemFont(14);
    
    [backButton setFrame:CGRectMake(20 , 30, 44.f, 44.f)];
    if (IOS_VERSION_7) {
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    }
    UIBarButtonItem  *backItem = [[UIBarButtonItem  alloc]  initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    RELEASE_SAFE(backItem);
}

-(int) createdCircleNum{
    circle_list_model* circleMod = [[circle_list_model alloc] init];
    circleMod.where = [NSString stringWithFormat:@"creater_id = %@",[Global sharedGlobal].user_id];
    NSArray* createdCircleArr = [circleMod getList];
    
    RELEASE_SAFE(circleMod);
    return createdCircleArr.count;
}

- (void)backTo{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  确认创建
 */
- (void)createClick{
    
    [self resingResponder];
    
    login_info_model *userInfo = [[login_info_model alloc]init];
    NSArray *userArr = [userInfo getList];
    
    [_dataDictionary setObject:[[userArr lastObject] objectForKey:@"realname"] forKey:@"creater_name"];
    if (_circleName.text.length == 0 && _circleIntroduce.text.length ==0) {
        
        [Common checkProgressHUD:@"请输入圈子名称和介绍" andImage:nil showInView:APPKEYWINDOW];
    }else{
        [_dataDictionary setObject:_circleName.text forKey:@"name"];
        [_dataDictionary setObject:_circleIntroduce.text forKey:@"content"];
        MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
        progressHUDTmp.center = CGPointMake(self.view.center.x, self.view.center.y);
        self.mbProgressHUD = progressHUDTmp;
        [progressHUDTmp release];
        self.mbProgressHUD.labelText = @"正在创建中...";
        [self.view addSubview:self.mbProgressHUD];
        [self.mbProgressHUD show:YES];
        CircleManager * circleManager = [CircleManager new];
        circleManager.fatherDelegate = self;
        [circleManager createCircleWithCircleName:_circleName.text andCircleContent:_circleIntroduce.text];
    }
    RELEASE_SAFE(userInfo);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self resingResponder];
}

- (void)resingResponder{
    
    [_circleName resignFirstResponder];
    
    [_circleIntroduce resignFirstResponder];
}

- (void)removeProgressHud{
    [self.mbProgressHUD hide:YES];
    [self.mbProgressHUD removeFromSuperViewOnHide];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextViewDelegate
-(BOOL) textFieldShouldClear:(UITextField *)textField{
    [_createBtn setBackgroundColor:COLOR_GRAY2];
    [_createBtn setEnabled:NO];
    
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView isEqual:_circleName] && [textView.text isEqualToString:defaultNameNotifyStr]) {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
    
    if ([textView isEqual:_circleIntroduce] && [textView.text isEqualToString:defaultIntroduceNotifyStr]) {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString * nametext = [_circleName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * introduceText = [_circleIntroduce.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([nametext isEqualToString:defaultNameNotifyStr]) {
        nametext = @"";
    }
    
    if ([introduceText isEqualToString:defaultIntroduceNotifyStr]) {
        introduceText = @"";
    }
    
    if (introduceText.length > 0 && nametext.length > 0){
        [_createBtn setBackgroundColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"]];
        [_createBtn setEnabled:YES];
        
    }
    if(introduceText.length == 0 || nametext.length == 0){
        [_createBtn setBackgroundColor:COLOR_GRAY2];
        [_createBtn setEnabled:NO];
    }
    
    if (introduceText.length > 70) {
//        _circleIntroduce.text = [introduceText substringToIndex:70];
        [_circleIntroduce resignFirstResponder];
        [Common checkProgressHUD:@"请输入少于70字符的介绍" andImage:nil showInView:APPKEYWINDOW];
        
        [_createBtn setBackgroundColor:COLOR_GRAY2];
        [_createBtn setEnabled:NO];
    }
    
    if (nametext.length > 20) {
//        _circleName.text = [nametext substringToIndex:20];
        [_circleName resignFirstResponder];
        [Common checkProgressHUDShowInAppKeyWindow:@"请输入少于20字符的名称" andImage:nil];
        [_createBtn setBackgroundColor:COLOR_GRAY2];
        [_createBtn setEnabled:NO];
    }
}

#pragma mark - FatherCircleManagerDelegate

- (void)createCircleSucess:(FatherCircleManager *)sender andCircleID:(long long)circleID
{
    [self.mbProgressHUD hide:YES];
    
    [self.delegate createCircleSuccess];

    CircleDetailSuccessViewController* detail = [[CircleDetailSuccessViewController alloc] init];
    detail.circleId = circleID;
    
    [self.navigationController pushViewController:detail animated:YES];
    
    RELEASE_SAFE(detail);
    RELEASE_SAFE(sender);
}

- (void)dealloc
{
    RELEASE_SAFE(_dataDictionary);
    RELEASE_SAFE(_circleIntroduce);
    RELEASE_SAFE(_circleName);
    RELEASE_SAFE(_intro);
    [super dealloc];
}

@end
