//
//  UpdatePassWordController1.m
//  ql
//
//  Created by yunlai on 14-4-26.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "UpdatePassWordController1.h"
#import "UpdatepwdViewController.h"
#import "config.h"
#import "UIImageScale.h"
#import "userInfoClass.h"
#import "CustomTextField.h"
#import "ThemeManager.h"
#import "UIViewController+NavigationBar.h"

@interface UpdatePassWordController1 ()
{
    UITableView *_inportTable;
    UITextField *_inputFied;
    UIButton *_nextButton;
    UILabel* phoneTips;
}
@property (nonatomic, retain) UITextField *inputFied;
@end

#define kMargin 15.f

@implementation UpdatePassWordController1
@synthesize inputFied = _inputFied;

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
	self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
//    self.view.backgroundColor = COLOR_LIGHTWEIGHT;
    
    self.title = @"重置密码";
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self mainView];
}


- (void)backTo{
    
    [self.navigationController popViewControllerAnimated:NO];

}

/**
 *  主界面布局
 */
- (void)mainView{
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20.f, KUIScreenWidth - 20.f, 30.f)];
    tipLabel.text = @"请输入您在组织里登记的手机号码";
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.font = KQLSystemFont(13);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor grayColor];
    [self.view addSubview:tipLabel];
    
    _inportTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tipLabel.frame) + 5, KUIScreenWidth, 44) style:UITableViewStylePlain];
    _inportTable.delegate = self;
    _inportTable.dataSource = self;
    _inportTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _inportTable.scrollEnabled = NO;
    [self.view addSubview:_inportTable];
    
    // 下一步
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setBackgroundColor:COLOR_GRAY2];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(nextTo) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton setFrame:CGRectMake(kMargin, CGRectGetMaxY(_inportTable.frame) + 40.f, KUIScreenWidth - kMargin * 2, 40.f)];
    _nextButton.layer.cornerRadius = 6;
    _nextButton.enabled = NO;
    
    [self.view addSubview:_nextButton];
    
    RELEASE_SAFE(tipLabel);
    
//    //自定义返回按钮 add vincent 没有添加返回的自定义
//    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
//    backButton.backgroundColor = [UIColor clearColor];
//    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
//    UIImage* image = [[ThemeManager shareInstance] getThemeImage:@"ico_common_return.png"];
//    [backButton setImage:image forState:UIControlStateNormal];
//    backButton.frame = CGRectMake(0, 0,image.size.width, image.size.height);
//    UIBarButtonItem  *backItem = [[UIBarButtonItem  alloc]  initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backItem;
//    //    RELEASE_SAFE(image);
//    
//    if (IOS_VERSION_7) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
//    }
//    RELEASE_SAFE(backItem);
    
//    //自定义返回按钮  add vincnet
    UIButton *backButton = [self setBackBarButton:nil];
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
}

/**
 *  下一步点击事件
 */
- (void)nextTo{
    [_inputFied resignFirstResponder];
    
    if (self.inputFied.text.length == 0) {
        [Common checkProgressHUD:@"请输入正确的手机号码" andImage:nil showInView:self.view];
    }else{
        
        [self accessVerifyService];
        
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.inputFied resignFirstResponder];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    
    CustomTextField *inputField = [[CustomTextField alloc]initWithFrame:CGRectMake(10, 0, KUIScreenWidth - 15, 45.f)];
    inputField.placeholder = @" 手机号码";
    inputField.backgroundColor = [UIColor clearColor];
    inputField.keyboardType = UIKeyboardTypeNumberPad;
    inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputField.delegate = self;
    self.inputFied = inputField;
    RELEASE_SAFE(inputField);
    [cell.contentView addSubview:self.inputFied];
    cell.backgroundColor =  [UIColor whiteColor];
    
    UILabel *tips = [[UILabel alloc]initWithFrame:CGRectMake(170.f, 7.f, 140.f, 30)];
    tips.text = @"咦，手机号码无效呢";
    //    tips.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
    tips.textColor = COLOR_GRAY2;
    tips.font = KQLSystemFont(15);
    phoneTips = tips;
    phoneTips.hidden = YES;
    [cell.contentView addSubview:phoneTips];
    RELEASE_SAFE(tips);
    
    if (IOS_VERSION_7) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    return cell;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location == 0) {
        self.inputFied.frame = CGRectMake(10, 0, KUIScreenWidth - 15, 45.f);
        phoneTips.hidden = YES;
    }
    
    if (range.location == 10) {
//        [_nextButton setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_FONT"] forState:UIControlStateNormal];
//        [_nextButton setTitleColor:COLOR_FONT forState:UIControlStateNormal];
        _nextButton.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
        [_nextButton setEnabled:YES];
//        [self accessVerifyService];
    }
    
    if (range.location <= 10 && self.inputFied.text.length == 11){
//        [_nextButton setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"] forState:UIControlStateNormal];
//        [_nextButton setTitleColor:COLOR_GRAY2 forState:UIControlStateNormal];
        _nextButton.backgroundColor = COLOR_GRAY2;
        [_nextButton setEnabled:NO];
    }
    if (range.location > 10) {
        return NO;
    }else{
        return YES;
    }
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    _nextButton.backgroundColor = COLOR_GRAY2;
    [_nextButton setEnabled:NO];
    self.inputFied.frame = CGRectMake(10, 0, KUIScreenWidth - 15, 45.f);
    phoneTips.hidden = YES;
    
    return YES;
}

#pragma mark - accessService

- (void)accessVerifyService{
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        self.inputFied.text,@"mobile",
                                        nil];
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:VALIDATE_MOBILE_COMMAND_ID accessAdress:@"member/validatemobile.do?param=" delegate:self withParam:nil];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
    if (![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        
        int resultInt = [[[resultArray objectAtIndex:0] objectForKey:@"ret"]intValue];
        NSLog(@"resultInt=%d",resultInt);
        switch (commandid) {
            case VALIDATE_MOBILE_COMMAND_ID:
            {
                if (resultInt == 0) {
                    [self performSelectorOnMainThread:@selector(verifyError) withObject:nil waitUntilDone:NO];
                    
                }else if(resultInt == 1){
                    
                    [self performSelectorOnMainThread:@selector(verifySuccess:) withObject:resultArray waitUntilDone:NO];
                }
            }break;
                
            default:
                break;
        }
        
    }else{
        
        UIImage *img = [UIImage imageCwNamed:@"icon_tip_normal.png"];
        
        if ([Common connectedToNetwork]) {
            // 网络繁忙，请重新再试
            [self checkProgressHUD:@"当前网络不可用，请检查你的网络设置" andImage:img];
        } else {
            // 当前网络不可用，请重新再试
            
            [self checkProgressHUD:KCWNetNOPrompt andImage:img];
        }
        
    }
}

- (void)verifyError{
//    [self checkProgressHUD:@"手机号不正确" andImage:nil];
    self.inputFied.frame = CGRectMake(10, 0, KUIScreenWidth - 155, 45.f);
    phoneTips.hidden = NO;
    
}


- (void)verifySuccess:(NSArray *)arr{
    if (_nextButton.enabled) {
        UpdatepwdViewController *updateCtl = [[UpdatepwdViewController alloc]init];
        updateCtl.moblieStr = self.inputFied.text;
        updateCtl.userArr = [arr mutableCopy];
        [self.navigationController pushViewController:updateCtl animated:YES];
        RELEASE_SAFE(updateCtl);
    }
    _nextButton.enabled = YES;
    _nextButton.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
}


- (void)checkProgressHUD:(NSString *)value andImage:(UIImage *)img{
    
    MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
    progressHUDTmp.center=CGPointMake(self.view.center.x, self.view.center.y+120);
    progressHUDTmp.customView= [[[UIImageView alloc] initWithImage:img] autorelease];
    progressHUDTmp.mode = MBProgressHUDModeCustomView;
    progressHUDTmp.labelText = value;
    [self.view addSubview:progressHUDTmp];
    [self.view bringSubviewToFront:progressHUDTmp];
    [progressHUDTmp show:YES];
    [progressHUDTmp hide:YES afterDelay:1];
    RELEASE_SAFE(progressHUDTmp);
    
}

- (void)dealloc
{
    RELEASE_SAFE(phoneTips);
    RELEASE_SAFE(_inportTable);
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
