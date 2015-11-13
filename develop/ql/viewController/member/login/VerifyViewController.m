//
//  VerifyViewController.m
//  ql
//
//  Created by yunlai on 14-2-22.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "VerifyViewController.h"
#import "VerifyMoblieViewController.h"
#import "UIImageScale.h"
#import "Common.h"
#import "userInfoCell.h"
#import "userInfoClass.h"
#import "UIImageView+WebCache.h"

#import "AcceptInvitationLoginController.h"

#import "UIViewController+NavigationBar.h"

@interface VerifyViewController ()
{
    UITableView *_mainTable;
    UITextField *_mobileField;
}
@end

#define kleftPadding 20.f
#define kpadding 15.f

@implementation VerifyViewController
@synthesize inviteeArray = _inviteeArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _inviteeArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
//    self.view.backgroundColor = COLOR_LIGHTWEIGHT;
    
    self.title = @"邀请函";
    
    NSLog(@"===%@",self.inviteeArray);
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //返回按钮  add vincnet
    UIButton *backButton = [self setBackBarButton:nil];
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    [self setBackBarButtonItem:backButton];
    
    [self mainView];
}

-(void) backTo{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

/**
 *  主界面布局
 */
- (void)mainView{
    
    _mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 40.f, KUIScreenWidth, 226.f) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.scrollEnabled = NO;
    [self.view addSubview:_mainTable];
    
    // 信息
    UILabel* _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, CGRectGetMaxY(_mainTable.frame) + 20, 300.f, 30.f)];
    _topLabel.backgroundColor = [UIColor clearColor];
//    _topLabel.text = @"加入长江商学院广东校友会";
//    add vincent 此处必奔溃
//    _topLabel.text = [NSString stringWithFormat:@"加入%@",[[[self.inviteeArray objectAtIndex:0]objectForKey:@"org_name"]objectForKey:@"name"]];
    _topLabel.text = [NSString stringWithFormat:@"加入  %@",[[self.inviteeArray objectAtIndex:0]objectForKey:@"org_name"]];
    _topLabel.font = KQLSystemFont(15);
    _topLabel.textAlignment = NSTextAlignmentCenter;
    _topLabel.textColor = [UIColor grayColor];
    [self.view addSubview:_topLabel];
    
    UIButton *verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [verifyBtn setFrame:CGRectMake(15.f, CGRectGetMaxY(_mainTable.frame) + 70.f, KUIScreenWidth - 30.f, 40.f)];
    [verifyBtn setTitle:@"接受邀请" forState:UIControlStateNormal];
//    [verifyBtn setBackgroundColor:[UIColor whiteColor]];
    [verifyBtn setBackgroundColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"]];
//    [verifyBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_FONT"] forState:UIControlStateNormal];
//    [verifyBtn setTitleColor:COLOR_FONT forState:UIControlStateNormal];
    [verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [verifyBtn addTarget:self action:@selector(acceptVerify) forControlEvents:UIControlEventTouchUpInside];
    verifyBtn.layer.cornerRadius = 5;
    [self.view addSubview:verifyBtn];
    RELEASE_SAFE(_topLabel);
    
}

/**
 *  下一步点击事件
 */
- (void)nextTo{
    
    [_mobileField resignFirstResponder];
    
    VerifyMoblieViewController *verifyCtl = [[VerifyMoblieViewController alloc]init];
    verifyCtl.moblieStr = _mobileField.text;
    [self.navigationController pushViewController:verifyCtl animated:YES];
    RELEASE_SAFE(verifyCtl);
    
}

// 接受邀请
- (void)acceptVerify{
    if (_type == 1) {
        VerifyMoblieViewController *verifyCtl = [[VerifyMoblieViewController alloc]init];
        verifyCtl.moblieStr = [[self.inviteeArray objectAtIndex:0]objectForKey:@"mobile"];
        [self.navigationController pushViewController:verifyCtl animated:YES];
        RELEASE_SAFE(verifyCtl);
    }else if (_type == 2) {
        AcceptInvitationLoginController *accepCtl = [[AcceptInvitationLoginController alloc]init];
        
        accepCtl.mobiles = [[self.inviteeArray lastObject] objectForKey:@"mobile"];
        accepCtl.userName = [[self.inviteeArray lastObject] objectForKey:@"invitee_name"];
        
        [self.navigationController pushViewController:accepCtl animated:YES];
        RELEASE_SAFE(accepCtl);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_mobileField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 提示框
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


#pragma mark - UITextFieldDelegate
//限制输入框手机号码11位数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _mobileField) {
        if (range.location >= 14){
            [self checkProgressHUD:@"请输入11位的手机号码" andImage:nil];
            return NO;
        }
        return YES;
    }
    return YES;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.f;
    }else{
        return 50.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, 50.f)];
//    bgView.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    bgView.backgroundColor = COLOR_LIGHTWEIGHT;
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(45.f, -16.f, 1.3, 78.f)];
    line.backgroundColor = COLOR_CONTROL;
    [bgView addSubview:line];
    
    UIImageView *inviteImg = [[UIImageView alloc]initWithFrame:CGRectMake(30.f, 10.f, 30, 30.f)];
//    inviteImg.image = IMGREADFILE(@"img_landing_invitation.png");
    inviteImg.image = [[ThemeManager shareInstance] getThemeImage:@"img_landing_invitation.png"];
    inviteImg.layer.cornerRadius = 15;
    inviteImg.clipsToBounds = YES;
    [bgView addSubview:inviteImg];
    RELEASE_SAFE(inviteImg);
    
    return [bgView autorelease];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    userInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[userInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
   if (self.inviteeArray.count!=0) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            NSString *invitorName = [[self.inviteeArray objectAtIndex:0]objectForKey:@"invitor_name"];
            NSString *inviteeName = [[self.inviteeArray objectAtIndex:0]objectForKey:@"invitee_name"];
        
//        add  vincent
//            NSString *orgNameInvitor = [[[self.inviteeArray objectAtIndex:0]objectForKey:@"invitor_org"]objectForKey:@"name"];
            NSString *orgNameInvitee = [[[self.inviteeArray objectAtIndex:0]objectForKey:@"invitee_org"]objectForKey:@"name"];
        
            userInfoClass *info = [[userInfoClass alloc]init];
            info.userName = invitorName;
            info.userOrgId = [[[self.inviteeArray objectAtIndex:0]objectForKey:@"invitor_org"]objectForKey:@"org_id"];
             NSLog(@"info==%@",info.userOrgId);
        
            //保存org_id
            [Global sharedGlobal].org_id = [[[self.inviteeArray objectAtIndex:0]objectForKey:@"invitor_org"]objectForKey:@"org_id"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            switch (indexPath.section) {
                case 0:
                {
                    //邀请人信息
//                    cell.usernameLabel.text = invitorName;
                    cell.usernameLabel.text = [[self.inviteeArray objectAtIndex:0]objectForKey:@"invitor_name"];//booky,组织邀请只居中显示大组织名称
                    CGRect frame = cell.usernameLabel.frame;
                    cell.usernameLabel.frame = CGRectMake(frame.origin.x, 30, 200, 30);
//                    cell.userPosition.text = orgNameInvitor; //        add  vincent
                    NSURL *urlImg = [NSURL URLWithString:[[self.inviteeArray objectAtIndex:0]objectForKey:@"invitor_portrait"]];
                    [cell.headView setImageWithURL:urlImg placeholderImage:IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME)];
                    
                }
                    break;
                case 1:
                {
                    //被邀请人信息
                    cell.usernameLabel.text = inviteeName;
                    cell.userPosition.text = orgNameInvitee;
//                    cell.headView.image = IMGREADFILE(@"img_landing_you.png");
                    cell.headView.image = [[ThemeManager shareInstance] getThemeImage:@"img_landing_you.png"];
                }
                    break;
                default:
                    break;
            }
           
        });
    });
   }
    
    cell.backgroundColor = [UIColor whiteColor];
   
    if (IOS_VERSION_7) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)dealloc
{
    RELEASE_SAFE(_mainTable);
    RELEASE_SAFE(_mobileField);
    [super dealloc];
}


@end
