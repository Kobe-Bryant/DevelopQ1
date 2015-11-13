//
//  VerifyMoblieViewController.m
//  ql
//
//  Created by yunlai on 14-2-24.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "VerifyMoblieViewController.h"
#import "SetPassWordViewController.h"
#import "WarmTipsViewController.h"
#import "loginCell.h"

#import "CRNavigationController.h"

#import "UIViewController+NavigationBar.h"

@interface VerifyMoblieViewController () <CustomTextField>
{
    UITableView *_inportTable;
    UIButton *_againSendBtn;
    UITextField *_inputFied;
    
    int num;
}
@property (nonatomic ,retain)UITextField *inuputFied;
@property (nonatomic,retain) UITextField *userNameField;
@property (nonatomic,retain) CustomTextField *authCodeField;
@property (nonatomic,retain) UIButton *againSendBtn;
@end

@implementation VerifyMoblieViewController
@synthesize inuputFied = _inputFied;
@synthesize moblieStr,userNameField,authCodeField,againSendBtn;

#define kleftPadding 20.f
#define kpadding 15.f

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
    
    self.title = @"注册";
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self backBtn];
    
    [self mainView];
    
    //登陆改为红色提示语初始化  add by devin
    _alertHud = [AlertView new];
    _alertHud.hidden = YES;
    [self.view addSubview:_alertHud];
    [_alertHud release];
}

-(void)backBtn{
    //返回按钮  add vincnet
    UIButton *backButton = [self setBackBarButton:nil];
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
}

// 返回 add vincnet
- (void)backTo{
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    
    num = 0;
}

- (void)viewDidDisappear:(BOOL)animated{
    
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
    
}

/**
 *  主界面布局
 */
- (void)mainView{
    
    // 提示语
    UILabel *_tipsLable = [[UILabel alloc]initWithFrame:CGRectMake(kleftPadding , kpadding, KUIScreenWidth - kleftPadding *2, 40)];
    _tipsLable.text = @"请验证您在组织里登记的手机号码";
    _tipsLable.textColor = [UIColor grayColor];
    _tipsLable.font = KQLSystemFont(16);
    _tipsLable.textAlignment = NSTextAlignmentCenter;
    _tipsLable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tipsLable];
    
    // 手机号
    UILabel *_mobileLabel = [[UILabel alloc]initWithFrame:CGRectMake(kleftPadding , CGRectGetMaxY(_tipsLable.frame), KUIScreenWidth - kleftPadding *2, 40)];
    //    _mobileLabel.text = self.moblieStr;
    _mobileLabel.text = [Common phoneNumTypeTurnWith:self.moblieStr];
    //    _mobileLabel.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
    _mobileLabel.textColor = COLOR_GRAY2;
    _mobileLabel.font = KQLSystemFont(18);
    _mobileLabel.textAlignment = NSTextAlignmentCenter;
    _mobileLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_mobileLabel];
    
    _inportTable = [[UITableView alloc]initWithFrame:CGRectMake(0.f, CGRectGetMaxY(_tipsLable.frame)+kpadding * 3 + 15, KUIScreenWidth, 44.f) style:UITableViewStylePlain];
    _inportTable.delegate = self;
    _inportTable.dataSource = self;
    _inportTable.scrollEnabled = NO;
    _inportTable.backgroundColor = [UIColor clearColor];
    _inportTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_inportTable];
    
    RELEASE_SAFE(_tipsLable);
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setFrame:CGRectMake(15.f, CGRectGetMaxY(_inportTable.frame) + 55.f, KUIScreenWidth - 30.f, 40.f)];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    //    [nextBtn setBackgroundColor:[UIColor whiteColor]];
    [nextBtn setBackgroundColor:COLOR_GRAY2];
    //    [nextBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_FONT"] forState:UIControlStateNormal];
    //    [nextBtn setTitleColor:COLOR_FONT forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextTo) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 5;
    nextBtn.tag = 123;
    [nextBtn setUserInteractionEnabled:NO];
    [self.view addSubview:nextBtn];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, KUIScreenHeight - 120.f, 90.f, 30.f)];
    tipLabel.text = @"手机号不对";
    tipLabel.font = KQLSystemFont(13);
    tipLabel.textColor = [UIColor grayColor];
    tipLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipLabel];
    
    RELEASE_SAFE(tipLabel);
    RELEASE_SAFE(_mobileLabel);
    
    //没有邀请码按钮
    UIButton *_errorMoblie = [[UIButton alloc]initWithFrame:CGRectMake(150, KUIScreenHeight - 120.f, 70.f, 30.f)];
    [_errorMoblie setTitle:@"点击这里" forState:UIControlStateNormal];
    //    [_errorMoblie setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_FONT"] forState:UIControlStateNormal];
    [_errorMoblie setTitleColor:COLOR_FONT forState:UIControlStateNormal];
    [_errorMoblie setBackgroundColor:[UIColor clearColor]];
    [_errorMoblie addTarget:self action:@selector(notCodeClick) forControlEvents:UIControlEventTouchUpInside];
    _errorMoblie.titleLabel.font = KQLSystemFont(13);
    [self.view addSubview:_errorMoblie];
}
/**
 *  手机号不对点击事件
 */
- (void)notCodeClick{
    WarmTipsViewController *tipCtl = [[WarmTipsViewController alloc]init];
    tipCtl.tipsString = @"你好！欢迎使用长江商学院广东校友会。此APP仅限内部成员交流，如果您是会员，还没有邀请码，请联系工作人员获取。你可以拨打号码 400-3568-456 咨询";
    tipCtl.ttype = NoAcoutTips;
    
    CRNavigationController* crnv = [[CRNavigationController alloc] initWithRootViewController:tipCtl];
    
    [self presentViewController:crnv animated:YES completion:nil];
    RELEASE_SAFE(crnv);
    RELEASE_SAFE(tipCtl);
}

//提示语
-(void)alertShow:(NSString *)text{
    _alertHud.lable.text = text;
    CGSize lableSize = [_alertHud.lable.text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    _alertHud.lable.frame = CGRectMake(18, 0, lableSize.width, 20);
    _alertHud.frame = CGRectMake((320-lableSize.width-15)/2,  CGRectGetMaxY(_inportTable.frame) + 20.f, lableSize.width+18, 20);
    _alertHud.backgroundColor = [UIColor clearColor];
    _alertHud.hidden = NO;
    [self performSelector:@selector(delay) withObject:self afterDelay:1];
}
-(void)delay{
    _alertHud.hidden = YES;
}

/**
 *  下一步点击事件
 */
- (void)nextTo{
    [self.userNameField resignFirstResponder];
    [self.authCodeField resignFirstResponder];
    
    if (self.authCodeField.text.length == 0) {
        [self alertShow:@"请输入正确的验证码"];
        // [Common checkProgressHUD:@"请输入正确的验证码" andImage:nil showInView:self.view];
    }else{
        [self accessVerifyCodeService];
    }
    
}

/**
 *  重发验证码
 */
- (void)sendClick:(UIButton *)sender{
    
    
    [self.againSendBtn setUserInteractionEnabled:NO];
    
    //发送验证码网络请求
    [self accessAuthCodeService];
    
    num=30;
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateAuthCode) userInfo:nil repeats:YES];
    
}

/**
 *  重发验证码点击
 */
- (void)updateAuthCode{
    
    
    NSString *titles=[NSString stringWithFormat:@"重新获取( %d )",num];
    
    [self.againSendBtn setTitle:titles forState:UIControlStateNormal];
    
    if (num==0) {
        [self.againSendBtn setUserInteractionEnabled:YES];
        
        if (_timer) {
            [_timer invalidate];
            _timer=nil;
        }
        
        [self.againSendBtn  setTitle:@"重新获取" forState:UIControlStateNormal];
    }
    --num;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.userNameField resignFirstResponder];
    [self.authCodeField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

//限制输入框手机号码11位数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UIButton *btn  = (UIButton *)[self.view viewWithTag:123];
    if (range.location == 5) {
        
        btn.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
        [btn setUserInteractionEnabled:YES];
    }
    
    if (range.location <= 5 && self.inuputFied.text.length == 6) {
        btn.userInteractionEnabled = NO;
        btn.backgroundColor = COLOR_GRAY2;
    }
    
    if (range.location >= 6){
        return NO;
    }else{
        return YES;
    }
    return YES;
}


#pragma mark - CustomTextFeildDelegate

- (void)customTextFieldPaste
{
    UIButton *btn  = (UIButton *)[self.view viewWithTag:123];
    if (self.authCodeField.text.length == 6) {
        btn.userInteractionEnabled = YES;
        btn.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
    } else if (self.authCodeField.text.length > 6){
        self.authCodeField.text = [self.authCodeField.text substringToIndex:6];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    loginCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[loginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    
    self.authCodeField = (CustomTextField *)cell.loginField;
    self.authCodeField.placeholder = @" 输入验证码";
    self.authCodeField.delegate=self;
    self.authCodeField.customDelegate = self;
    self.authCodeField.tag = 2;
    self.authCodeField.keyboardType = UIKeyboardTypeNumberPad;
    self.authCodeField.backgroundColor = [UIColor clearColor];
    [cell setCellStyleIcon:NO hiddenAll:NO];
    
    self.againSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.againSendBtn.frame = CGRectMake(KUIScreenWidth - 140.f, 8.f, 150, 30.f);
    self.againSendBtn.titleLabel.font = KQLSystemFont(16);
    [self.againSendBtn setTitleColor:COLOR_FONT forState:UIControlStateNormal];
    [self.againSendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [cell.contentView addSubview:self.againSendBtn];
    
    [self.againSendBtn addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)dealloc
{
    RELEASE_SAFE(_inportTable);
    
    [_timer invalidate];
    _timer=nil;
    
    [super dealloc];
}

#pragma mark - accessService

// 获取验证码
- (void)accessAuthCodeService{
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:1],@"type",
                                        self.moblieStr,@"mobile",
                                        nil];
    
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:MEMBER_AUTHCODE_COMMAND_ID accessAdress:@"member/sendauthcode.do?param=" delegate:self withParam:nil];
}

// 验证手机号码和验证码
- (void)accessVerifyCodeService{
    
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        self.moblieStr,@"mobile",
                                        self.authCodeField.text,@"identify_code",
                                        nil];
    
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:MEMBER_VERIFY_CODE_COMMAND_ID accessAdress:@"member/identifycode.do?param=" delegate:self withParam:nil];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish!");
    
    if (![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        
        int resultInt = [[[resultArray objectAtIndex:0] objectForKey:@"ret"]intValue];
        NSLog(@"resultInt=%d",resultInt);
        switch (commandid) {
            case MEMBER_INVITED_COMMAND_ID:
            {
                if (resultInt == 0) {
                    [self performSelectorOnMainThread:@selector(getCodeError) withObject:nil waitUntilDone:NO];
                    
                }else if(resultInt == 1){
                    
                    [self performSelectorOnMainThread:@selector(getCodeSuccess) withObject:nil waitUntilDone:NO];
                }
            }break;
                
            case MEMBER_VERIFY_CODE_COMMAND_ID:
            {
                if (resultInt == 0) {
                    [self performSelectorOnMainThread:@selector(verifyCodeError) withObject:nil waitUntilDone:NO];
                    
                }else if(resultInt == 1){
                    
                    [self performSelectorOnMainThread:@selector(verifyCodeSuccess) withObject:nil waitUntilDone:NO];
                }else if(resultInt == 2){
                    
                    [self performSelectorOnMainThread:@selector(verifyCode) withObject:nil waitUntilDone:NO];
                }
            }break;
            default:
                break;
        }
    }else{
        // UIImage *img = [UIImage imageCwNamed:@"icon_tip_normal.png"];
        
        if ([Common connectedToNetwork]) {
            // 网络繁忙，请重新再试
            // [Common checkProgressHUD:@"当前网络不可用，请检查你的网络设置" andImage:nil showInView:self.view];
            [self alertShow:@"当前网络不可用，请检查你的网络设置"];
        } else {
            // 当前网络不可用，请重新再试
            // [Common checkProgressHUD:KCWNetNOPrompt andImage:img showInView:self.view];
            [self alertShow:KCWNetNOPrompt];
        }
    }
}

- (void)getCodeError{
    //[Common checkProgressHUD:@"获取验证码失败！" andImage:nil showInView:self.view];
    [self alertShow:@"获取验证码失败"];
}


- (void)getCodeSuccess{
    //[Common checkProgressHUD:@"获取验证码成功！" andImage:nil showInView:self.view];
    [self alertShow:@"获取验证码成功"];
}

- (void)verifyCode{
    //[Common checkProgressHUD:@"验证码不正确" andImage:nil showInView:self.view];
    [self alertShow:@"验证码不正确"];
}

- (void)verifyCodeError{
    // [Common checkProgressHUD:@"出错" andImage:nil showInView:self.view];
    [self alertShow:@"出错"];
}

- (void)verifyCodeSuccess{
    
    SetPassWordViewController *setPwd = [[SetPassWordViewController alloc]init];
    setPwd.moblieStrPwd = self.moblieStr;
    setPwd.typeV = SetPasswordViewTypeRegister;
    [self.navigationController pushViewController:setPwd animated:YES];
    RELEASE_SAFE(setPwd);
}
@end
