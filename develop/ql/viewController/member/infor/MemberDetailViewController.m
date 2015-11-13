//
//  MemberDetailViewController.m
//  ql
//
//  Created by yunlai on 14-2-26.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "MemberDetailViewController.h"
#import "cloudTopCell.h"
#import "cloudUserInfoCell.h"
#import "cloudIhaveCell.h"
#import "cloudCompanyInfoCell.h"
#import "GuestMainPageViewController.h"
#import "LikesMainPageViewController.h"
#import "CompanyInfoViewController.h"
#import "SidebarViewController.h"
#import "PersonInfoViewController.h"
#import "memberInfoCell.h"
#import "companyInfoCell.h"
#import "UIScrollView+UITouch.h"
#import "MemberInfoViewController.h"
#import "config.h"
#import "ThemeManager.h"
#import "MemberTopView.h"

@interface MemberDetailViewController ()
{
    NSArray *_infoArray;
}
@end

#define DETAIL_CELL_HIGHT 90

@implementation MemberDetailViewController
@synthesize enterType;

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
//    记载主视图
    [self loadMainView];
//    加载导航条右bar
    [self rightBarButton];
//    加载back按钮
    [self backBarBtn];
    
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
    backButton.frame = CGRectMake(10.f, 20.f, 44.f, 44.f);
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
    
    if (self.pushType == PushTypeButtom) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }else{
        if (![[SidebarViewController share]sideBarShowing]) {
            [[SidebarViewController share]moveAnimationWithDirection:SideBarShowDirectionLeft duration:0.15];
        }else{
            [[SidebarViewController share]moveAnimationWithDirection:SideBarShowDirectionNone duration:0.15];
        }
    }
}

/**
 *  主视图
 */
- (void)loadMainView{
    
    _topView = [[MemberTopView alloc] initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, 220.f) userName:@"吴则飞" visitor:@"236" likes:@"1588" delegate:self];
    [self.view addSubview:_topView];
    
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, KUIScreenHeight) style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.showsVerticalScrollIndicator = NO;
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    if (IOS_VERSION_7) {
        [_mainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    _mainTableView.tag = 1000;
    
    _mainTableView.tableHeaderView = _topView;
    
    [self.view addSubview:_mainTableView];
    
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, KUIScreenHeight) style:UITableViewStylePlain];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.showsVerticalScrollIndicator = NO;
    _leftTableView.backgroundColor = [UIColor clearColor];
    _leftTableView.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    if (IOS_VERSION_7) {
        [_leftTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    _leftTableView.tag = 1001;
    
    _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(KUIScreenWidth, 0.f, KUIScreenWidth, KUIScreenHeight) style:UITableViewStylePlain];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.showsVerticalScrollIndicator = NO;
    _rightTableView.backgroundColor = [UIColor redColor];
    _rightTableView.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    if (IOS_VERSION_7) {
        [_rightTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    _rightTableView.tag = 1002;
    
}

/**
 *  分享
 */
- (void)rightBarButton{
    
    UIButton *shareButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    shareButton.backgroundColor = [UIColor clearColor];
    
    [shareButton addTarget:self action:@selector(shareTo) forControlEvents:UIControlEventTouchUpInside];

    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(320 - 60 , 30, 60.f, 30.f);
    
    [self.view addSubview:shareButton];
}

#pragma mark - event Method

- (void)shareTo{
    PersonInfoViewController *personCtl = [[PersonInfoViewController alloc]init];
    [self.navigationController pushViewController:personCtl animated:YES];
    RELEASE_SAFE(personCtl);
}

#pragma mark - MemberTopViewDelegate
- (void)topViewHeadClick{
    NSLog(@"topViewHeadClick");
    
    MemberInfoViewController *infoCtl = [[MemberInfoViewController alloc]init];
    [self.navigationController pushViewController:infoCtl animated:YES];
    RELEASE_SAFE(infoCtl);
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1001) {
        if (indexPath.row == 0) {
            return 44.f;
        }
        else if (indexPath.row == 1 || indexPath.row == 2) {
            return 70.f;
        }else{
            return 44.f;
        }
    }else if(tableView.tag == 1002){
        if (indexPath.row == 0) {
            return 44.f;
        }
        else{
            return 70.f;
        }
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 1000) {
        UIView *headSection = [[UIView alloc]init];
    
        UIButton *userInfo = [UIButton buttonWithType:UIButtonTypeCustom];
        [userInfo setTitle:@"个人信息" forState:UIControlStateNormal];
        [userInfo setFrame:CGRectMake(0.f, 0.f, KUIScreenWidth / 2, 40.f)];
        [userInfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [headSection addSubview:userInfo];
        
        UIButton *companyInfo = [UIButton buttonWithType:UIButtonTypeCustom];
        [companyInfo setFrame:CGRectMake(KUIScreenWidth / 2, 0.f, KUIScreenWidth / 2, 40.f)];
        [companyInfo setTitle:@"企业信息" forState:UIControlStateNormal];
        [companyInfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [headSection addSubview:companyInfo];
        
        return headSection;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 1000) {
        return 40.f;
    }else{
        return 0.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (tableView.tag) {
        case 1000:
        {
           
            static NSString *mainCell = @"mainCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainCell];
            
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainCell] autorelease];
                
            }
            cell.textLabel.text = @"个人信息";
            return cell;
            
        }
            break;
            
        case 1001:
        {
            if (indexPath.row == 0) {
                static NSString *CellIdentifier = @"CellIdentifier";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                    
                }
                cell.textLabel.text = @"个人信息";
                return cell;
            }else if(indexPath.row == 1){
                static NSString *CellIdentifier = @"Cell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                
                UIView *timeV = [[UIView alloc]initWithFrame:CGRectMake(5., 5.f, 60.f, 60.f)];
                timeV.backgroundColor = COLOR_CONTROL;
                timeV.layer.cornerRadius = 5;
                [cell.contentView addSubview:timeV];
                
                UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(70.f, 5.f, 220.f, 60.f)];
                msgLabel.text = @"我来了，深圳的朋友过来搞起";
                [cell.contentView addSubview:msgLabel];
                
                RELEASE_SAFE(timeV);
                RELEASE_SAFE(msgLabel);
                
                return cell;
        }
        }
            break;
        case 1002:
        {
            if (indexPath.row == 0) {
                static NSString *CellIdentifier = @"CellIdentifier";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                    
                }
                cell.textLabel.text = @"公司信息";
                return cell;
            }else if(indexPath.row == 1){
                static NSString *CellIdentifier = @"Cell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                
                UIView *timeV = [[UIView alloc]initWithFrame:CGRectMake(5., 5.f, 60.f, 60.f)];
                timeV.backgroundColor = COLOR_CONTROL;
                timeV.layer.cornerRadius = 5;
                [cell.contentView addSubview:timeV];
                RELEASE_SAFE(timeV);//add vincent
                
                UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(70.f, 5.f, 220.f, 60.f)];
                msgLabel.text = @"私人商务飞机";
                [cell.contentView addSubview:msgLabel];
                RELEASE_SAFE(msgLabel);//add vincent
                
                return cell;
            }else{
                static NSString *CellIdentifier = @"infoCell";
                companyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[[companyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                
                switch (indexPath.row) {
                    case 2:
                    {
                        cell.companyInfo.text = @"公司";
                    }
                        break;
                    case 3:
                    {
                        cell.companyInfo.text = @"手机";
                    }
                        break;
                    case 4:
                    {
                        cell.companyInfo.text = @"邮箱";
                    }
                        break;
                    case 5:
                    {
                        cell.companyInfo.text = @"兴趣";
                    }
                        break;
                    default:
                        break;
                }
                
                cell.timeInfo.text = @"2014-4-14";
                
                return cell;
                
            }
            return nil;
        }
            break;
            
        default:
            break;
        }
    
     return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc
{
    RELEASE_SAFE(_leftTableView);
    RELEASE_SAFE(_rightTableView);
    [super dealloc];
}

@end
