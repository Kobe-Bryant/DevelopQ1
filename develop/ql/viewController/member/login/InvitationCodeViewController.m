//
//  InvitationCodeViewController.m
//  ql
//
//  Created by yunlai on 14-2-22.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "InvitationCodeViewController.h"
#import "WarmTipsViewController.h"
#import "VerifyViewController.h"
#import "CRNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "AcceptInvitationLoginController.h"
#import "Common.h"
#import "config.h"
#import "UIImageScale.h"
#import "userInfoClass.h"
#import "CustomTextField.h"
#import "UIViewController+NavigationBar.h"

@interface InvitationCodeViewController () <CustomTextField>
{
    UITableView *_inportTable;
    UIButton *_notCodeBtn;
    UITextField *_inputFied;
    UIButton *_nextButton;
}
@property (nonatomic, retain) UITextField *inputFied;
@property (nonatomic, retain) UILabel *tips;

@property (nonatomic, retain) NSMutableArray *returnArray;//验证邀请码返回的数据类型  add vincent
@property (nonatomic, retain) NSString *inputFiedStr; //textFieldl里面的字符
@end

#define kMargin 15.f

@implementation InvitationCodeViewController
@synthesize inputFied = _inputFied;
@synthesize tips = _tips;

@synthesize returnArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    self.title = @"注册";
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self creteaRightButton];
    [self mainView];
}

/**
 *  导航栏右边按钮
 */
- (void)creteaRightButton{
    //返回按钮  add vincnet
    UIButton *backButton = [self setBackBarButton:@"取消"];
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
}

- (void)backTo{
    [self.navigationController popViewControllerAnimated:NO];
}

/**
 *  主界面布局
 */
- (void)mainView{
    
    _inportTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, KUIScreenWidth, 44) style:UITableViewStylePlain];
    _inportTable.delegate = self;
    _inportTable.dataSource = self;
    _inportTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _inportTable.scrollEnabled = NO;
    [self.view addSubview:_inportTable];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, KUIScreenHeight - 120.f, 90.f, 30.f)];
    tipLabel.text = @"没有邀请码";
    tipLabel.font = KQLSystemFont(13);
    tipLabel.textColor = [UIColor grayColor];
    tipLabel.backgroundColor = [UIColor clearColor];//add vincent ios6
    [self.view addSubview:tipLabel];
    RELEASE_SAFE(tipLabel);
    
    //没有邀请码按钮
    _notCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(150, KUIScreenHeight - 120.f, 70.f, 30.f)];
    [_notCodeBtn setTitle:@"点击这里" forState:UIControlStateNormal];
    [_notCodeBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"] forState:UIControlStateNormal];
    [_notCodeBtn setBackgroundColor:[UIColor clearColor]];
    [_notCodeBtn addTarget:self action:@selector(notCodeClick) forControlEvents:UIControlEventTouchUpInside];
    _notCodeBtn.titleLabel.font = KQLSystemFont(13);
    [self.view addSubview:_notCodeBtn];
    
    // 下一步
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setBackgroundColor:COLOR_GRAY2];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(nextTo) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton setFrame:CGRectMake(kMargin, CGRectGetMaxY(_inportTable.frame) + 50.f, KUIScreenWidth - kMargin * 2, 40.f)];
    [_nextButton setEnabled:NO];
    _nextButton.layer.cornerRadius = 6;
    [self.view addSubview:_nextButton];
}

/**
 *  下一步点击事件
 */
- (void)nextTo{
    [_inputFied resignFirstResponder];
    // add vincent
    int resultInt = [[[self.returnArray objectAtIndex:0] objectForKey:@"ret"]intValue];
    if(resultInt == 1){
        
        [self performSelectorOnMainThread:@selector(getCodeSuccess:) withObject:self.returnArray waitUntilDone:NO];
        
    }else if(resultInt  == 2){

        [self performSelectorOnMainThread:@selector(alreadyRegister:) withObject:self.returnArray waitUntilDone:NO];
        
    }
}

/**
 *  没有邀请码点击事件
 */
- (void)notCodeClick
{
    WarmTipsViewController *tipCtl = [[WarmTipsViewController alloc]init];
    tipCtl.ttype = NoAcoutTips;
    CRNavigationController * nav = [[CRNavigationController alloc]initWithRootViewController:tipCtl];
    [self.navigationController presentModalViewController:nav animated:YES];
    RELEASE_SAFE(tipCtl);
    RELEASE_SAFE(nav);
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
    inputField.placeholder = @" 输入邀请码";
    inputField.backgroundColor = [UIColor clearColor];
    inputField.keyboardType = UIKeyboardTypeNumberPad;
    inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputField.customDelegate = self;
    inputField.delegate = self;
    self.inputFied = inputField;
    RELEASE_SAFE(inputField);
    [cell.contentView addSubview:self.inputFied];
    cell.backgroundColor = [UIColor whiteColor];
    [self.inputFied becomeFirstResponder];

    
    UILabel *tips = [[UILabel alloc]initWithFrame:CGRectMake(190.f, 7.f, 120.f, 30)];
    tips.text = @"咦，邀请码无效呢";
    tips.textColor = COLOR_GRAY2;
    tips.font = KQLSystemFont(15);
    self.tips = tips;
    self.tips.hidden = YES;
    [cell.contentView addSubview:self.tips];
    RELEASE_SAFE(tips);
    
    if (IOS_VERSION_7) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    return cell;
}

#pragma mark - UITextFiledDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    self.inputFiedStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if (range.location == 0) {
        self.inputFied.frame = CGRectMake(10, 0, KUIScreenWidth - 15, 45.f);
        self.tips.hidden = YES;
    }
    if (range.location == 5) {
        if (![string isEqualToString:@""]) {
            [self accessInviteCodeService];
        }
    }
    
    if (range.location <= 5 || self.inputFiedStr.length >= 6){
        _nextButton.backgroundColor = COLOR_GRAY2;
        [_nextButton setEnabled:NO];
    }
    
    if (range.location > 5) {
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    _nextButton.backgroundColor = COLOR_GRAY2;
    [_nextButton setEnabled:NO];
    
    self.inputFied.frame = CGRectMake(10, 0, KUIScreenWidth - 15, 45.f);
    self.tips.hidden = YES;
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.inputFiedStr = textField.text;
    if (self.inputFiedStr.length == 0) {
        self.inputFied.frame = CGRectMake(10, 0, KUIScreenWidth - 15, 45.f);
        self.tips.hidden = YES;
    }
    return YES;
}

#pragma mark - CustomTextFieldDelegate
- (void)customTextFieldPaste
{
    self.inputFiedStr = self.inputFied.text;
    if (self.inputFiedStr.length == 6) {
        [self accessInviteCodeService];
        [self.inputFied resignFirstResponder];
    } else if (self.inputFiedStr.length >6) {
        self.inputFiedStr = [self.inputFiedStr substringToIndex:6];
        self.inputFied.text = self.inputFiedStr;
        [self accessInviteCodeService];
        [self.inputFied resignFirstResponder];
    }
}

#pragma mark - accessService

- (void)accessInviteCodeService{
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        self.inputFiedStr,@"invite_code",
                                        nil];
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:MEMBER_INVITED_COMMAND_ID accessAdress:@"member/vidateinfo.do?param=" delegate:self withParam:nil];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
    
    if (![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        
        int resultInt = [[[resultArray objectAtIndex:0] objectForKey:@"ret"]intValue];
        NSLog(@"resultInt=%d",resultInt);
//        add vincent
        self.returnArray = resultArray;
        switch (commandid) {
            case MEMBER_INVITED_COMMAND_ID:
            {
                if (resultInt == 0) {
                    [self performSelectorOnMainThread:@selector(getCodeError) withObject:nil waitUntilDone:NO];
                    
                }else{
                    _nextButton.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
                    _nextButton.enabled = YES;
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

- (void)getCodeError{
     self.inputFied.frame = CGRectMake(10, 0, KUIScreenWidth - 135, 45.f);
     self.tips.hidden = NO;
}

- (void)alreadyRegister:(NSMutableArray*)resultArray{
    VerifyViewController *ver = [[VerifyViewController alloc]init];
    ver.inviteeArray = [resultArray mutableCopy];
    //booky 623
    ver.type = 2;
    
    [self.navigationController pushViewController:ver animated:YES];
    RELEASE_SAFE(ver);
}
- (void)getCodeSuccess:(NSMutableArray*)resultArray{
    
//    if (_nextButton.enabled) {
        VerifyViewController *ver = [[VerifyViewController alloc]init];
        ver.inviteeArray = [resultArray mutableCopy];
        //booky 623
        ver.type = 1;
        
        [self.navigationController pushViewController:ver animated:YES];
        RELEASE_SAFE(ver);
//    }
    _nextButton.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
    [_nextButton setEnabled:YES];
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
    RELEASE_SAFE(_inportTable);
    RELEASE_SAFE(_notCodeBtn);
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
