//
//  UserSignModifyViewController.m
//  ql
//
//  Created by yunlai on 14-5-4.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "UserSignModifyViewController.h"
#import "Global.h"
#import "mainpage_userInfo_model.h"

@interface UserSignModifyViewController ()
{
//    签名文本框
    UITextView *_signTextView;
//    内容文本框
    UILabel *countLable;
//    保存按钮
    UIButton *saveButton;
}
@end

@implementation UserSignModifyViewController
@synthesize detailDictionary,titleCtl,content,modifyType;

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
    
    self.title = titleCtl;
    
//    加载主视图
    [self loadMainView];
//    初始化保存按钮
    [self saveBarButton];
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//加载主视图
- (void)loadMainView{
    // 签名
    _signTextView = [[UITextView alloc]initWithFrame:CGRectMake(5.f, 20.f, KUIScreenWidth - 10
                                                                , 90.f)];
    _signTextView.text = self.content;
    _signTextView.font = [UIFont systemFontOfSize:16.0];
    _signTextView.delegate = self;
    [self.view addSubview:_signTextView];
    
    //add by devin 2014.7.8
    countLable =  [[UILabel alloc]initWithFrame:CGRectMake(270, 120, 70, 20)];
    countLable.backgroundColor = [UIColor clearColor];
    countLable.text = [NSString stringWithFormat:@"%d/25",_signTextView.text.length];
    countLable.font = [UIFont systemFontOfSize:16.0];
    [self.view addSubview:countLable];
}

// 初始化保存
- (void)saveBarButton{
    
    [_signTextView resignFirstResponder];
    
    saveButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    
    [saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setFrame:CGRectMake(0 , 5, 40.f, 30.f)];
    [saveButton setTitleColor:COLOR_GRAY2 forState:UIControlStateNormal];
    saveButton.enabled = NO;
    
    UIBarButtonItem  *rightItem = [[UIBarButtonItem  alloc]  initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    RELEASE_SAFE(rightItem);
    
}

#pragma mark - textView
//文本框检测 超过25个字 按钮不可点击
-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString * aString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([aString length] > 25) {
        
        return NO;
    }else if([aString length] <26){
        saveButton.enabled = YES;
        [saveButton setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
        countLable.textColor = [UIColor blackColor];
        countLable.text = [NSString stringWithFormat:@"%d/25",aString.length];
    }
    if ([aString length] == 0) {
        saveButton.enabled = NO;
        [saveButton setTitleColor:COLOR_GRAY2 forState:UIControlStateNormal];

    }
    return YES;
}

#pragma mark - 保存
//字数检测与提示
- (void)saveClick{
    [_signTextView resignFirstResponder];
    if (_signTextView.text.length > 0 && _signTextView.text.length <= 25) {
        [self accessModifyInfoService];
    }else if(_signTextView.text.length > 25){
       [Common checkProgressHUD:@"字数超出限制" andImage:nil showInView:self.view];
    }
    else{
        [Common checkProgressHUD:@"你没填写内容哦~" andImage:nil showInView:self.view];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_signTextView resignFirstResponder];
}

#pragma mark - accessService
//修改签名请求
- (void)accessModifyInfoService{
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [Global sharedGlobal].user_id,@"user_id",
                                        [NSNumber numberWithInt:self.modifyType],@"type",
                                        _signTextView.text,@"information",
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
            }break;
                
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

//修改签名成功 修改个人信息数据库 返回上一层页面
- (void)updateSuccess:(NSMutableArray*)resultArray{
    [_signTextView resignFirstResponder];
    
    //更新数据库数据
    mainpage_userInfo_model *miModel = [[mainpage_userInfo_model alloc] init];
    miModel.where = [NSString stringWithFormat:@"id = %d",[[Global sharedGlobal].user_id intValue]];
    
    NSDictionary *auditDic=[NSDictionary dictionaryWithObjectsAndKeys:_signTextView.text,@"signature", nil];
    
    [miModel updateDB:auditDic];
    
    [miModel release];
    
//    [Common checkProgressHUD:@"修改成功！" andImage:nil showInView:self.view];
    [Common checkProgressHUDShowInAppKeyWindow:@"修改成功！" andImage:KAccessSuccessIMG];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateCircleIntro" object:_signTextView.text];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    RELEASE_SAFE(countLable);
    RELEASE_SAFE(_signTextView);
    [super dealloc];
}

@end
