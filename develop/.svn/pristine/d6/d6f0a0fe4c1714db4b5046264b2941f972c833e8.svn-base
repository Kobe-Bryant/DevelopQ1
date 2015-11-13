//
//  UpdatepwdViewController.m
//  cw
//
//  Created by yunlai on 13-8-29.
//
//

#import "UpdatepwdViewController.h"
#import "MBProgressHUD.h"
#import "RegexKitLite.h"
#import "Common.h"
#import "Global.h"
#import "loginCell.h"
#import "SetPassWordViewController.h"
#import "UIImageScale.h"
#import "NSString+DES.h"

@interface UpdatepwdViewController ()


@end

@implementation UpdatepwdViewController
@synthesize userName = _userName;
@synthesize userPwd = _userPwd;
@synthesize authCode = _authCode;
@synthesize againSendBtn = _againSendBtn;
@synthesize delegate,userArr;

#define kleftPadding 25.f
#define kpadding 15.f

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
    UILabel *_tipsLable = [[UILabel alloc]initWithFrame:CGRectMake(kpadding , kpadding, KUIScreenWidth - kleftPadding *2, 40)];
    NSString *name = [[self.userArr lastObject]objectForKey:@"realname"];
    NSString *sex;
    if ([[[self.userArr lastObject]objectForKey:@"realname"] intValue] == 0) {
        sex = @"先生";
    }else{
        sex = @"女士";
    }
    _tipsLable.text = [NSString stringWithFormat:@"%@%@，你好!",name,sex];
    _tipsLable.textColor = [UIColor grayColor];
    _tipsLable.font = KQLSystemFont(15);
    _tipsLable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tipsLable];
    
    _inportTable = [[UITableView alloc]initWithFrame:CGRectMake(0.f, CGRectGetMaxY(_tipsLable.frame)+kpadding - 8, KUIScreenWidth, 100.f) style:UITableViewStylePlain];
    _inportTable.delegate = self;
    _inportTable.dataSource = self;
    _inportTable.scrollEnabled = NO;
    _inportTable.backgroundColor = [UIColor clearColor];
    _inportTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_inportTable];
    
    RELEASE_SAFE(_tipsLable);
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setFrame:CGRectMake(15.f, CGRectGetMaxY(_inportTable.frame) + 60.f, KUIScreenWidth - 30.f, 40.f)];
    [sendBtn setTitle:@"发 送" forState:UIControlStateNormal];
//    [sendBtn setBackgroundColor:[UIColor whiteColor]];
    [sendBtn setBackgroundColor:COLOR_GRAY2];
//    [sendBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_FONT"] forState:UIControlStateNormal];
//    [sendBtn setTitleColor:COLOR_FONT forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnTo) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.layer.cornerRadius = 5;
    sendBtn.tag = 100;
    sendBtn.enabled = NO;
    
    [self.view addSubview:sendBtn];
    
    //改为红色提示语 初始化  add by devin
    _alertHud = [AlertView new];
    _alertHud.hidden = YES;
    [self.view addSubview:_alertHud];
    [_alertHud release];
    
}

//提示语
-(void)alertShow:(NSString *)text{
    _alertHud.lable.text = text;
    CGSize lableSize = [_alertHud.lable.text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    _alertHud.lable.frame = CGRectMake(18, 0, lableSize.width+2, 20);
    _alertHud.frame = CGRectMake((320-lableSize.width-15)/2, CGRectGetMaxY(_inportTable.frame) + 20.f, lableSize.width+18, 20);
    _alertHud.backgroundColor = [UIColor clearColor];
    _alertHud.hidden = NO;
    [self performSelector:@selector(delay) withObject:self afterDelay:1];
}

//延迟两秒后提示语消失
-(void)delay{
    _alertHud.hidden = YES;
}

/**
 *  下一步点击事件
 */
- (void)sendBtnTo{
    [self.userName resignFirstResponder];
    [self.authCode resignFirstResponder];
    
    if (self.authCode.text.length == 0) {
       // [Common checkProgressHUD:@"请输入正确的验证码" andImage:nil showInView:self.view];
        [self alertShow:@"请输入正确的验证码"]; //add by devin
        
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
        
        [self.againSendBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    }
    --num;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.authCode resignFirstResponder];
    [self.userName resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

//限制输入框手机号码11位数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UIButton* sendBtn = (UIButton*)[self.view viewWithTag:100];
    if (range.location == 5) {
        sendBtn.enabled = YES;
        sendBtn.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
    }
    
    if (range.location <= 5 && self.authCode.text.length == 6) {
        sendBtn.enabled = NO;
        sendBtn.backgroundColor = COLOR_GRAY2;
    }
    
    if (range.location > 5){
        return NO;
    }else{
        return YES;
    }
    
    return YES;
}

-(BOOL) textFieldShouldClear:(UITextField *)textField{
    UIButton* sendBtn = (UIButton*)[self.view viewWithTag:100];
    sendBtn.enabled = NO;
    sendBtn.backgroundColor = COLOR_GRAY2;
    
    return YES;
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    loginCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[loginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            self.userName = cell.loginField;
            self.userName.delegate=self;
            self.userName.tag = 1;
            self.userName.text = self.moblieStr;

            self.userName.enabled = NO;
            [cell setCellStyleIcon:YES hiddenAll:NO];
            cell.rightIcon.image = IMGREADFILE(@"ico_landing_correct.png");
        }
            break;
        case 1:
        {
            self.authCode = cell.loginField;
            self.authCode.placeholder = @" 输入验证码";
            self.authCode.delegate=self;
            self.authCode.tag = 2;
            self.authCode.keyboardType = UIKeyboardTypeNumberPad;
    
            self.againSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.againSendBtn.frame = CGRectMake(KUIScreenWidth - 140.f, 8.f, 150, 30.f);
            self.againSendBtn.titleLabel.font = KQLSystemFont(16);
//            [self.againSendBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_FONT"] forState:UIControlStateNormal];
            [self.againSendBtn setTitleColor:COLOR_FONT forState:UIControlStateNormal];
            [self.againSendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            
            [cell.contentView addSubview:self.againSendBtn];
           
            
            [self.againSendBtn addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell setCellStyleIcon:NO hiddenAll:NO];
        }
            break;
        default:
            break;
    }
     [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    
    
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
                                        self.authCode.text,@"identify_code",
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
                }else{
                    [self performSelectorOnMainThread:@selector(verifyCodeInvalid) withObject:nil waitUntilDone:NO];
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
            [self alertShow:@"当前网络不可用，请检查你的网络设置"]; // add by devin 换成这个提示语;
        } else {
            // 当前网络不可用，请重新再试
           // [Common checkProgressHUD:KCWNetNOPrompt andImage:img showInView:self.view];
            [self alertShow:KCWNetNOPrompt]; // add by devin 换成这个提示语;
        }
        
    }
}

- (void)getCodeError{
   // [Common checkProgressHUD:@"获取验证码失败！" andImage:nil showInView:self.view];
    [self alertShow:@"获取验证码失败!"]; // add by devin 换成这个提示语;
}


- (void)getCodeSuccess{
    //[Common checkProgressHUD:@"获取验证码成功！" andImage:nil showInView:self.view];
    [self alertShow:@"获取验证码成功!"]; // add by devin 换成这个提示语;
}
-(void)verifyCodeInvalid{
    [self alertShow:@"验证码无效!"]; // add by devin 换成这个提示语;
}

- (void)verifyCodeError{
    //[Common checkProgressHUD:@"出错" andImage:nil showInView:self.view];
    [self alertShow:@"验证码无效，请重新输入"]; // add by devin 换成这个提示语;
    
}

- (void)verifyCodeSuccess{
    
    SetPassWordViewController *setPwd = [[SetPassWordViewController alloc]init];
    setPwd.moblieStrPwd = self.moblieStr;
    setPwd.typeV = SetPasswordViewTypeUpdate;
    [self.navigationController pushViewController:setPwd animated:YES];
    RELEASE_SAFE(setPwd);
}

@end
