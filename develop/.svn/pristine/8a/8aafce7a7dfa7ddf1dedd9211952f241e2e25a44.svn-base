//
//  welcomeViewController.m
//  ql
//
//  Created by yunlai on 14-6-24.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "welcomeViewController.h"
#import "UIImageView+WebCache.h"
#import "Global.h"
#import "ThemeManager.h"
#import "config.h"
#import "NetManager.h"

@interface welcomeViewController (){
    UIImageView* welcomeImageV;
    UILabel* userNameLab;
    UILabel* welcomeContentLab;
    UILabel* invitationName;
    
    UIButton* enterBtn;
}
@property (nonatomic, retain) NSMutableDictionary *imageDic;

@end

@implementation welcomeViewController
@synthesize imageDic = _imageDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _imageDic = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
    [self initMainView];
    
    [self addDataInUI];
	// Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void) addDataInUI{
    [welcomeImageV setImageWithURL:[_orgDataDic objectForKey:@"wel_pic"] placeholderImage:IMG(@"default_600")];
    userNameLab.text = [NSString stringWithFormat:@"%@ :",[[Global sharedGlobal].userInfo objectForKey:@"realname"]];
    welcomeContentLab.text = [_orgDataDic objectForKey:@"wel_content"];
    invitationName.text = [_orgDataDic objectForKey:@"wel_luokuan"];
    [enterBtn setTitle:[_orgDataDic objectForKey:@"wel_btn"] forState:UIControlStateNormal];
}

-(void) initMainView{
    welcomeImageV = [[UIImageView alloc] init];
    if (isIPhone5) {
        welcomeImageV.frame = CGRectMake(10, 50, 300, 300);
    }else{
        welcomeImageV.frame = CGRectMake(10, 19+[Global judgementIOS7:0], 300, 280);
    }
    welcomeImageV.layer.cornerRadius = 5.0;
    welcomeImageV.clipsToBounds = YES;
    [self.view addSubview:welcomeImageV];
    
    userNameLab = [[UILabel alloc] init];
    if (isIPhone5) {
        userNameLab.frame = CGRectMake(15, CGRectGetMaxY(welcomeImageV.frame) + 20, self.view.bounds.size.width - 15*2, 20);
    }else{
        userNameLab.frame = CGRectMake(15, CGRectGetMaxY(welcomeImageV.frame) + 7, self.view.bounds.size.width - 15*2, 20);
    }
    userNameLab.backgroundColor = [UIColor clearColor];
    userNameLab.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
    userNameLab.font = KQLboldSystemFont(14);
    [self.view addSubview:userNameLab];
    
    welcomeContentLab = [[UILabel alloc] init];
    welcomeContentLab.frame = CGRectMake(45, CGRectGetMaxY(userNameLab.frame), self.view.bounds.size.width - 60, 40);
    welcomeContentLab.backgroundColor = [UIColor clearColor];
    welcomeContentLab.textColor = userNameLab.textColor;
    welcomeContentLab.font = KQLboldSystemFont(14);
    welcomeContentLab.numberOfLines = 2;
    welcomeContentLab.lineBreakMode = UILineBreakModeWordWrap;
    [self.view addSubview:welcomeContentLab];
    
    invitationName = [[UILabel alloc] init];
    invitationName.frame = CGRectMake(0, CGRectGetMaxY(welcomeContentLab.frame), self.view.bounds.size.width - 15, 20);
    invitationName.backgroundColor = [UIColor clearColor];
    invitationName.textColor = userNameLab.textColor;
    invitationName.textAlignment = UITextAlignmentRight;
    invitationName.font = KQLboldSystemFont(14);
    [self.view addSubview:invitationName];
    
    [self initButtomView];
}

-(void) initButtomView{
    UIView* buttomView = [[UIView alloc] init];
    if (isIPhone5) {
        buttomView.frame = CGRectMake(0, self.view.bounds.size.height - 90, self.view.bounds.size.width, 90);
    }else{
        buttomView.frame = CGRectMake(0, self.view.bounds.size.height - 70, self.view.bounds.size.width, 70);
    }
    buttomView.backgroundColor = [UIColor colorWithPatternImage:[[ThemeManager shareInstance] getThemeImage:@"under_bar.png"]];
    [self.view addSubview:buttomView];
    
    enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (isIPhone5) {
        enterBtn.frame = CGRectMake(20, 20, 280, 50);
    }else{
        enterBtn.frame = CGRectMake(20, 13, 280, 44);
    }
    enterBtn.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
    enterBtn.titleLabel.font = KQLboldSystemFont(14);
    [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [enterBtn addTarget:self action:@selector(enterToMain) forControlEvents:UIControlEventTouchUpInside];
    
    [buttomView addSubview:enterBtn];
    
    RELEASE_SAFE(buttomView);
}

-(void) enterToMain{
    
    [self changeScreenImage]; //登陆成功后请求闪屏图片并缓存
    [self accessContentModifyNotice]; //内容跟新通知
    
    [ThemeManager shareInstance].themeName = [[NSUserDefaults standardUserDefaults] stringForKey:kThemeName];
    if (IOS_VERSION_7) {
        [[UINavigationBar appearance] setBarTintColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBAR"]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification object:nil];

    //    booky
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstIntoApp"];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiUpdateLeftbarMark object:nil];
    }];
    
}

//闪屏网络请求
-(void) changeScreenImage{
    NSString* reqUrl = @"image/screenImage.do?param=";
    NSMutableDictionary* requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [Global sharedGlobal].org_id,@"org_id",
                                       [UIScreen mainScreen].bounds.size.width,@"width",
                                       [UIScreen mainScreen].bounds.size.height,@"height",
                                       @"0",@"ts",
                                       nil];

    [[NetManager sharedManager] accessService:requestDic data:nil command:CHANGE_SCREENIMAGE_ID accessAdress:reqUrl delegate:self withParam:nil];
}

//内容跟新通知
- (void)accessContentModifyNotice {
    NSString* reqUrl = @"notify/refresh.do?param=";
    
    NSMutableDictionary* requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [Global sharedGlobal].org_id, @"org_id",
                                       [Global sharedGlobal].user_id,@"user_id",
                                       nil];
    [[NetManager sharedManager] accessService:requestDic data:nil command:CONTENT_MODIFY_NOTICE_ID accessAdress:reqUrl delegate:self withParam:nil];
}

//请求回调
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver {
    if (![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        switch (commandid) {
            case CONTENT_MODIFY_NOTICE_ID: //内容更新需求
            {
                NSDictionary * paramDic = [resultArray lastObject];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"contentModifyNotice" object:paramDic];
            }
                break;
            case CHANGE_SCREENIMAGE_ID:
            {
                // 判断是否有网络
                NSDictionary * resultDic = [resultArray firstObject];
                if (resultDic) {
                    int resultInt = [[resultDic objectForKey:@"rcode"] intValue];
                    if (resultInt) {
                        //线程加载图片，以免界面卡死
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            NSString *path = [resultDic objectForKey:@"pic_url"];
                            
                            if (path.length == 0) {
                                return ;
                            }
                            
                            //此处首先指定了图片存取路径（默认写到应用程序沙盒中）
                            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                            
                            //取出图片名
                            NSArray* arr = [path componentsSeparatedByString:@"/"];
                            NSString* imgName = [arr lastObject];
                            
                            //并给文件起个文件名，以url作为图片名
                            NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:imgName];
                            
                            BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
                            if (blHave) {
                                
                            }else{
                                NSURL *url = [NSURL URLWithString:path];
                                NSData *data = [NSData dataWithContentsOfURL:url]; //url 转化为data格式
                                
                                //此处的方法是将图片写到Documents文件中
                                BOOL writeSuccess = [data writeToFile:uniquePath atomically:YES];
                                NSLog(@"--write:%d--",writeSuccess);
                            }
                            //保存图片地址
                            [[NSUserDefaults standardUserDefaults] setValue:imgName forKey:@"ScreenImageUrl"];

                            //保存个性化闪屏的ts
                            [[NSUserDefaults standardUserDefaults] setValue:[resultDic objectForKey:@"ts"] forKey:@"ScreenImageUrlTS"];
                        });
                    }else {
                        NSLog(@"网络请求数据失败");
                    }
                }else {
                    NSLog(@"服务器数据为空");
                }
            }
        break;
        default:
            break;
    }
}
}

-(void) dealloc{
    RELEASE_SAFE(_orgDataDic);
    RELEASE_SAFE(welcomeImageV);
    RELEASE_SAFE(welcomeContentLab);
    RELEASE_SAFE(userNameLab);
    RELEASE_SAFE(welcomeContentLab);
    RELEASE_SAFE(invitationName);
    [super dealloc];
}

@end
