//
//  UserInfoModifyViewController.m
//  ql
//
//  Created by yunlai on 14-4-22.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "UserInfoModifyViewController.h"
#import "Global.h"
#import "CustomTextField.h"
#import "userInfoData.h"
#import "mainpage_userInfo_model.h"

@interface UserInfoModifyViewController ()
{
    CustomTextField *_inputField;
}

@end

@implementation UserInfoModifyViewController
@synthesize titleCtl = _titleCtl;
@synthesize content = _content;
@synthesize contentType,modifyType;

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
    
    self.title = self.titleCtl;
//    初始化保存按钮
    [self saveBarButton];
//    加载主视图
    [self mainLoadView];
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
}

//加载主视图
- (void)mainLoadView{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 20.f, KUIScreenWidth, 40.f)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    _inputField = [[CustomTextField alloc]initWithFrame:CGRectMake(10.f, 0.f, KUIScreenWidth-10, 40.f)];
    _inputField.backgroundColor = [UIColor whiteColor];
    _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _inputField.delegate = self;
    [_inputField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    _inputField.placeholder = [NSString stringWithFormat:@"输入%@",self.titleCtl];
    _inputField.text = self.content;
    if (self.modifyType == 5) {
        _inputField.keyboardType = UIKeyboardTypeNumberPad;
    }
    [bgView addSubview:_inputField];
    
    [self.view addSubview:bgView];
    RELEASE_SAFE(bgView);
    
    userInfoData *user = [[userInfoData alloc]init];
    user.realname = _inputField.text;
    
}

// 初始化保存
- (void)saveBarButton{
    [_inputField resignFirstResponder];
    
    UIButton *saveButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    
    [saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setFrame:CGRectMake(0 , 5, 40.f, 30.f)];
    [saveButton setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
    UIBarButtonItem  *rightItem = [[UIBarButtonItem  alloc]  initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    RELEASE_SAFE(rightItem);
    
}

#pragma mark - 保存
- (void)saveClick{
    if (self.modifyType == 6) {
//        邮箱格式检测
        if ([Common validateEmail:_inputField.text]) {
             [self accessModifyInfoService];
        }else{
            [Common checkProgressHUDShowInAppKeyWindow:@"请输入正确的邮箱格式" andImage:nil];
        }
    }else if (self.modifyType == 5) {
        //手机号码检测
        if ([Common phoneNumberChecking:_inputField.text]) {
            [self accessModifyInfoService];
        }else{
            [Common checkProgressHUDShowInAppKeyWindow:@"请输入正确的手机号码" andImage:nil];
        }
    }else{
        [self accessModifyInfoService];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_inputField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//限制输入框手机号码11位数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
 if (textField == _inputField && textField.text.length!=0 &&self.modifyType == 5) {
        if (range.location >= 11){
            
            [Common checkProgressHUD:@"请输入11位的手机号码" andImage:nil showInView:self.view];
            return NO;
        }
    }
    return YES;
}


#pragma mark - accessService
//修改用户信息网络请求
- (void)accessModifyInfoService{
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [Global sharedGlobal].user_id,@"user_id",
                                        [NSNumber numberWithInt:self.modifyType],@"type",
                                        _inputField.text,@"information",
                                        [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                        nil];
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:USERINFO_UPDATE_COMMAND_ID accessAdress:@"member/updateuserinfo.do?param=" delegate:self withParam:nil];
}

//网络请求回调
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
    
    if (![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        
        int resultInt = [[[resultArray objectAtIndex:0] objectForKey:@"ret"]intValue];
        NSLog(@"resultInt=%d",resultInt);
        switch (commandid) {
            case USERINFO_UPDATE_COMMAND_ID:
            {
                if (resultInt == 0) {
                    [self performSelectorOnMainThread:@selector(updateError) withObject:nil waitUntilDone:NO];
                    
                }else if(resultInt == 1){
                    
                    [self performSelectorOnMainThread:@selector(updateSuccess:) withObject:nil waitUntilDone:NO];
                }
            }
                break;
                
            default:
                break;
        }
        
    }else{
        
        UIImage *img = [UIImage imageCwNamed:@"icon_tip_normal.png"];
        
        if ([Common connectedToNetwork]) {
            // 网络繁忙，请重新再试
            [Common checkProgressHUD:@"当前网络不可用，请检查你的网络设置" andImage:img showInView:self.view];
        } else {
            // 当前网络不可用，请重新再试
            [Common checkProgressHUD:KCWNetNOPrompt andImage:img showInView:self.view];
        }
        
    }
}

//修改失败处理
- (void)updateError{
//    [Common checkProgressHUD:@"修改失败！" andImage:nil showInView:self.view];
    [Common checkProgressHUDShowInAppKeyWindow:@"修改失败！" andImage:KAccessFailedIMG];
}

//修改成功处理  更改用户信息数据库  返回上层页面
- (void)updateSuccess:(NSMutableArray*)resultArray{
    [_inputField resignFirstResponder];
    
//    [Common checkProgressHUD:@"修改成功！" andImage:nil showInView:self.view];
    [Common checkProgressHUDShowInAppKeyWindow:@"修改成功！" andImage:KAccessSuccessIMG];
    
    //更新数据库数据
    mainpage_userInfo_model *miModel = [[mainpage_userInfo_model alloc] init];
    miModel.where = [NSString stringWithFormat:@"id = %@",[Global sharedGlobal].user_id];
    
    NSString *keyStr = [self returnArgs:self.modifyType];
    
    NSDictionary *auditDic=[NSDictionary dictionaryWithObjectsAndKeys:_inputField.text,keyStr, nil];
    
    [miModel updateDB:auditDic];
    [miModel release];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//根据不同参数类型返回对应key
- (NSString *)returnArgs:(int)type{
    switch (type) {
        case 1:
        {
            return @"nickname";
        }
            break;
        case 2:
        {
            return @"signature";
        }
            break;
        case 3:
        {
            return @"company_name";
        }
            break;
        case 4:
        {
            return @"company_role";
        }
            break;
        case 5:
        {
            return @"mobile";
        }
            break;
        case 6:
        {
            return @"email";
        }
            break;
        case 7:
        {
            return @"interests";
        }
            break;
        default:
            break;
    }
    return nil;
}

-(void) dealloc{
    [_inputField release];
    [super dealloc];
}

@end
