//
//  CompanyInfoViewController.m
//  ql
//
//  Created by yunlai on 14-2-27.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "CompanyInfoViewController.h"
#import "aboutCompanyCell.h"
#import "SGActionView.h"
#import "UIImageScale.h"

@interface CompanyInfoViewController ()

@end

@implementation CompanyInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
//    self.view.backgroundColor = COLOR_LIGHTWEIGHT;
   
    [self loadMainView];
    
    [self backBarBtn];
    
    [self rightBarButton];
    
    
}

/**
 *  主视图
 */
- (void)loadMainView{
    
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, KUIScreenHeight - 24.f) style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.showsVerticalScrollIndicator = NO;
    _mainTableView.scrollEnabled = NO;
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mainTableView];
    
    UIButton *contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactBtn setTitle:@"联系我们" forState:UIControlStateNormal];
    [contactBtn setTitleColor:COLOR_GRAY2 forState:UIControlStateNormal];
    [contactBtn setBackgroundColor:[UIColor whiteColor]];
    [contactBtn addTarget:self action:@selector(contactClick) forControlEvents:UIControlEventTouchUpInside];
    [contactBtn setFrame:CGRectMake(0.f, KUIScreenHeight - 25.f, KUIScreenWidth, 45.f)];
    contactBtn.titleLabel.font = KQLSystemFont(15);
    [self.view addSubview:contactBtn];
    
}


/**
 *  返回按钮
 */
- (void)backBarBtn{
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [[UIImage alloc ]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return" ofType:@"png"]];
    [backButton setImage:image forState:UIControlStateNormal];
    if (IOS_VERSION_7) {
        backButton.frame = CGRectMake(20 , 20, 40.f, 40.f);
    }else{
        backButton.frame = CGRectMake(20 , 30, 30.f, 30.f);
    }
    RELEASE_SAFE(image);
    [self.view addSubview:backButton];
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

/**
 *  返回事件
 */
- (void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  联系我们
 */
- (void)contactClick{
    
}

/**
 *  分享
 */
- (void)rightBarButton{
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor grayColor];
    [backButton addTarget:self action:@selector(shareTo) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [[UIImage alloc ]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return" ofType:@"png"]];
    [backButton setImage:image forState:UIControlStateNormal];
    CGFloat heightPadding;
    if (IOS_VERSION_7) {
        heightPadding = 20.f;
    }else{
        heightPadding = 30.f;
    }
    backButton.frame = CGRectMake(320 - 50 , heightPadding, 30.f, 30.f);
    RELEASE_SAFE(image);
    [self.view addSubview:backButton];
}


#pragma mark - event Method
/**
 *  分享弹窗
 */
- (void)shareTo{
//    PopShareView *shareView = [PopShareView defaultExample];
//    [shareView showPopupView:self.navigationController delegate:self shareType:ShareTypeAll];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ShareAPIActionDelegate
// 分享内容
//- (NSDictionary *)shareApiActionReturnValue
//{
//    
//    NSString *shareUrlStr = CLIENT_SHARE_LINK;
//    
//    NSString *title=@"您身边的私密生活";
//    NSString *contents=[NSString stringWithFormat:@"我正在使用一款非常不错的应用「云信」，您身边的私密圈子，享受全新的生活方式，赶快来体验吧！%@",shareUrlStr];
//    
//    UIImage  *pic=[UIImage imageCwNamed:@"share_txweibo_store.png"];
//    
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                          contents, ShareContent,
//                          title, ShareTitle,
//                          pic, ShareImage,
//                          shareUrlStr, ShareUrl,
//                          nil];
//    
//    return dict;
//}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 160.f;
    }else{
        return 360.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    switch (indexPath.section) {
        case 0:
        {
            static NSString *CellIdentifier = @"companyInfoTopCell";
            companyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[[companyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            }
            cell.companyInfo.text = @"长江商学院";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:
        {
            static NSString *CellIdentifier = @"aboutComCell";
            aboutCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[[aboutCompanyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textView.text = @"长江商学院以培养新一代优秀企业家为己任，并致力于创建全球新一代商学院，现有工商管理硕士（MBA）、在职金融MBA（FMBA）、高级工商管理硕士（EMBA）、工商管理博士（DBA）和高层管理教育（EE）等五个主要项目，长江商学院也是中国唯一一所实行“教授治校”的商学院。长江商学院以培养新一代优秀企业家为己任，并致力于创建全球新一代商学院，现有工商管理硕士（MBA）、在职金融MBA（FMBA）、高级工商管理硕士（EMBA）、工商管理博士（DBA）和高层管理教育（EE）等五个主要项目，长江商学院也是中国唯一一所实行“教授治校”的商学院。长江商学院以培养新一代优秀企业家为己任，并致力于创建全球新一代商学院，现有工商管理硕士（MBA）、在职金融MBA（FMBA）、高级工商管理硕士（EMBA）、工商管理博士（DBA）和高层管理教育（EE）等五个主要项目，长江商学院也是中国唯一一所实行“教授治校”的商学院。";
            
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}
@end
