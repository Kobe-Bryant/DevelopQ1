//
//  ModifyCircleNameViewController.m
//  ql
//
//  Created by yunlai on 14-3-20.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "ModifyCircleNameViewController.h"

#import "circle_list_model.h"
#import "temporary_circle_list_model.h"

@interface ModifyCircleNameViewController ()
{
    UITextField *_circleName;
}
@end

@implementation ModifyCircleNameViewController
@synthesize circleNames,detailDictionary,delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
//    self.view.backgroundColor = COLOR_LIGHTWEIGHT;
    
    self.title = @"圈子名称";
    
    [self saveBarButton];
 
    [self mainLoadView];
  
}

- (void)mainLoadView{
    UIView* fieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, KUIScreenWidth, 40)];
    fieldView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:fieldView];
    
    _circleName = [[UITextField alloc]initWithFrame:CGRectMake(15.f, 0.f, KUIScreenWidth - 15*2, 40.f)];
    _circleName.backgroundColor = [UIColor clearColor];
    _circleName.clearButtonMode = UITextFieldViewModeWhileEditing;
    _circleName.delegate = self;
    _circleName.placeholder = @" 输入圈子名称";
    _circleName.text = [self.detailDictionary objectForKey:@"name"];
    [fieldView addSubview:_circleName];
    
//    [self.view addSubview:_circleName];
    
    RELEASE_SAFE(fieldView);
}

// 保存
- (void)saveBarButton{
    
    UIButton *saveButton = [UIButton  buttonWithType:UIButtonTypeCustom];

    [saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setFrame:CGRectMake(0 , 5, 40.f, 30.f)];
    [saveButton setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
    UIBarButtonItem  *rightItem = [[UIBarButtonItem  alloc]  initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    RELEASE_SAFE(rightItem);
    
}

- (void)saveClick{
    if (_circleName.text.length > 0 && _circleName.text.length < 21) {
        [self accessModifyCircleNameService];
    }else if (_circleName.text.length == 0) {
//        [Common checkProgressHUD:@"你没填写内容哦~" andImage:nil showInView:self.view];
        [Common checkProgressHUDShowInAppKeyWindow:@"你没填写内容哦~" andImage:nil];
    }else{
//        [Common checkProgressHUD:@"请输入少于20字符的名称" andImage:nil showInView:self.view];
        [Common checkProgressHUDShowInAppKeyWindow:@"请输入少于20字符的名称" andImage:nil];
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_circleName resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - accessService

- (void)accessModifyCircleNameService{
    NSString* circleName = _circleName.text;
    NSString* linkStr = nil;
    
    NSMutableDictionary *jsontestDic = nil;
    
    if (_circleType == 1) {
        linkStr = @"tempcircle/update.do?param=";
        
        jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       [self.detailDictionary objectForKey:@"temp_circle_id"],@"temp_circle_id",
                       circleName,@"temp_circle_name",
                       [Global sharedGlobal].user_id,@"user_id",
                       nil];
        
    } else {
        linkStr = @"circle/updatecircle.do?param=";
        
        jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       [self.detailDictionary objectForKey:@"circle_id"],@"circle_id",
                       circleName,@"name",
                       nil];
        
    }
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:CIRCLE_NAME_COMMAND_ID accessAdress:linkStr delegate:self withParam:nil];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
    
    if (![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        
        int resultInt = [[[resultArray objectAtIndex:0] objectForKey:@"ret"]intValue];
        NSLog(@"resultInt=%d",resultInt);
        switch (commandid) {
            case CIRCLE_NAME_COMMAND_ID:
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

- (void)updateError{
//    [Common checkProgressHUD:@"修改失败！" andImage:nil showInView:self.view];
    [Common checkProgressHUDShowInAppKeyWindow:@"修改失败！" andImage:KAccessFailedIMG];
}


- (void)updateSuccess:(NSMutableArray*)resultArray{
    [_circleName resignFirstResponder];
    
    //修改数据库
    [self updateCircleDB];
    
//    [Common checkProgressHUD:@"修改成功！" andImage:nil showInView:self.view];
    [Common checkProgressHUDShowInAppKeyWindow:@"修改成功！" andImage:KAccessSuccessIMG];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateModifyInfo:)]) {
        [self.delegate performSelector:@selector(updateModifyInfo:) withObject:_circleName.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateCircleName" object:_circleName.text];
    
}

//更新数据库
-(void) updateCircleDB{
    if (_circleType == 1) {
        //临时圈子
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [self.detailDictionary objectForKey:@"temp_circle_id"],@"temp_circle_id",
                             _circleName.text,@"name",
                             nil];
        [temporary_circle_list_model insertOrUpdateDictionaryIntoTempCirlceList:dic];
    }else{
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [self.detailDictionary objectForKey:@"circle_id"],@"circle_id",
                             _circleName.text,@"name",
                             nil];
        [circle_list_model insertOrUpdateDictionaryIntoCirlceList:dic];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
