//
//  ModifyIntroduceViewController.m
//  ql
//
//  Created by yunlai on 14-4-21.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "ModifyIntroduceViewController.h"
#import "CustomInsetTextView.h"

@interface ModifyIntroduceViewController ()
{
    UITextView *_circleIntroduce;
}
@end

@implementation ModifyIntroduceViewController
@synthesize detailDictionary;

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
    self.title = @"圈子介绍";
    
    [self loadMainView];
    [self saveBarButton];
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMainView{
    // 圈子介绍
    _circleIntroduce = [[CustomInsetTextView alloc]initWithFrame:CGRectMake(0.f, 20.f, KUIScreenWidth, 180.f)];
    _circleIntroduce.text = [self.detailDictionary objectForKey:@"content"];
    _circleIntroduce.delegate = self;
    _circleIntroduce.font = KQLSystemFont(17);
    _circleIntroduce.layer.borderColor = RGBACOLOR(213, 216, 225, 1).CGColor;
    _circleIntroduce.layer.borderWidth = 1.f;
    [self.view addSubview:_circleIntroduce];
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
    [_circleIntroduce resignFirstResponder];
    
    if (_circleIntroduce.text.length > 0 && _circleIntroduce.text.length < 71) {
        [self accessModifyCircleIntroService];
    }else if (_circleIntroduce.text.length == 0) {
//        [Common checkProgressHUD:@"你没填写内容哦~" andImage:nil showInView:self.view];
        [Common checkProgressHUDShowInAppKeyWindow:@"你没填写内容哦~" andImage:nil];
    }else{
//        [Common checkProgressHUD:@"请输入少于70字符的介绍" andImage:nil showInView:self.view];
        [Common checkProgressHUDShowInAppKeyWindow:@"请输入少于70字符的介绍" andImage:nil];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_circleIntroduce resignFirstResponder];
}

- (void)dealloc
{
    RELEASE_SAFE(_circleIntroduce);
    [super dealloc];
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

#pragma mark - accessService

- (void)accessModifyCircleIntroService{
    
    NSNumber * circleIDNum = [self.detailDictionary objectForKey:@"circle_id"];
    NSNumber * circleName = [self.detailDictionary objectForKey:@"name"];
    NSString * linkStr = linkStr = @"circle/updatecircle.do?param=";
    
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        circleIDNum,@"circle_id",
                                        circleName,@"name",
                                        _circleIntroduce.text,@"content",
                                        nil];
	
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
    [_circleIntroduce resignFirstResponder];
//    [Common checkProgressHUD:@"修改成功！" andImage:nil showInView:self.view];
    [Common checkProgressHUDShowInAppKeyWindow:@"修改成功！" andImage:KAccessSuccessIMG];
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateCircleIntro" object:_circleIntroduce.text];
    [self.delegate modifyIntroduceSuccessWithNewIntroduce:_circleIntroduce.text];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
