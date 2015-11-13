//
//  IdentityViewController.m
//  ql
//
//  Created by yunlai on 14-3-31.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "IdentityViewController.h"
#import "MBProgressHUD.h"
#import "userInfoCell.h"
#import "UpdatepwdViewController.h"
#import "ThemeManager.h"
#import "config.h"

#define kleftPadding 30.f
#define kpadding 15.f

@interface IdentityViewController ()
{
    UITableView *_tableView;
    UITextField *_pwdField;
    UIScrollView *_scrollViewC;
    MBProgressHUD *mbProgressHUD;
}

@property (nonatomic,retain) UITextField *pwdField;
@property (nonatomic,retain) MBProgressHUD *mbProgressHUD;

@end

@implementation IdentityViewController
@synthesize pwdField = _pwdField;
@synthesize mbProgressHUD;

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
    self.title = @"确认身份";
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
//    self.view.backgroundColor = COLOR_LIGHTWEIGHT;
    
    [self loadMianView];

}

- (void)loadMianView{
    
    _scrollViewC = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollViewC.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollViewC];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchsScrollView)];
    [_scrollViewC addGestureRecognizer:tap];
    RELEASE_SAFE(tap);
    
    // 提示语
    UILabel *_tipsLable = [[UILabel alloc]initWithFrame:CGRectMake(kleftPadding , kleftPadding, KUIScreenWidth - kleftPadding *2, 40)];
    _tipsLable.text = @"王石先生，欢迎回来";
//    _tipsLable.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
    _tipsLable.textColor = COLOR_GRAY2;
    _tipsLable.font = KQLSystemFont(14);
    _tipsLable.numberOfLines = 2;
    _tipsLable.backgroundColor = [UIColor clearColor];
    [_scrollViewC addSubview:_tipsLable];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, CGRectGetMaxY(_tipsLable.frame), KUIScreenWidth, 170.f)style:UITableViewStylePlain];
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    if (IOS_VERSION_7) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [_scrollViewC addSubview:_tableView];
    
    RELEASE_SAFE(_tipsLable);
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // 登录按钮
    UIButton *_loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(kleftPadding, CGRectGetMaxY(_tableView.frame) + kleftPadding, KUIScreenWidth - kleftPadding *2, 40.f)];
    [_loginBtn setTitle:@"登    录" forState:UIControlStateNormal];
    _loginBtn.layer.cornerRadius = 3;
//    [_loginBtn setBackgroundColor:[UIColor whiteColor]];
    [_loginBtn setBackgroundColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"]];
//    [_loginBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_FONT"] forState:UIControlStateNormal];
//    [_loginBtn setTitleColor:COLOR_FONT forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (_loginBtn.state == UIControlStateHighlighted) {
        [_loginBtn setBackgroundColor:[UIColor colorWithRed:50/255.0 green:96/255.0 blue:188/255.0 alpha:1]];
    }
    [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollViewC addSubview:_loginBtn];
    
    // 忘记密码
    UIButton *_forgetPwd = [[UIButton alloc]initWithFrame:CGRectMake(kleftPadding, CGRectGetMaxY(_loginBtn.frame) + kleftPadding, 80, 25)];
    [_forgetPwd setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetPwd setBackgroundColor:[UIColor clearColor]];
//    [_forgetPwd setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_FONT"] forState:UIControlStateNormal];
    [_forgetPwd setTitleColor:COLOR_FONT forState:UIControlStateNormal];
    _forgetPwd.titleLabel.font = KQLSystemFont(15);
    [_forgetPwd addTarget:self action:@selector(forgetPwdClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollViewC addSubview:_forgetPwd];
    
}

/**
 *  忘记密码
 */
- (void)forgetPwdClick{
    UpdatepwdViewController *updatePwd = [[UpdatepwdViewController alloc]init];
    [self.navigationController pushViewController:updatePwd animated:YES];
    RELEASE_SAFE(updatePwd);
    
}

/**
 *  登录
 */
- (void)loginAction
{
    [self resigns];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchsScrollView{
    [self resigns];
}

- (void)dealloc
{
    RELEASE_SAFE(_tableView);
    RELEASE_SAFE(_pwdField);
    RELEASE_SAFE(_scrollViewC);
    [super dealloc];
}
// 隐藏键盘
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self resigns];
}

// 放弃第一响应者
- (void)resigns{
    [self.pwdField resignFirstResponder];
}

#pragma mark Responding to keyboard events
// 键盘将要显示
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];

    // 键盘显示需要的时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // 需要用的键盘显示的时间，这个时间段来做_bgView的frame的改变，实现动画
    [UIView animateWithDuration:animationDuration animations:^{
        _scrollViewC.frame = CGRectMake(0.f, - 35.f , KUIScreenWidth, self.view.bounds.size.height);
    }];
}

// 键盘将要隐藏
- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    // 键盘显示需要的时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // 需要用的键盘隐藏的时间，这个时间段来做_bgView的frame的改变，实现动画
    [UIView animateWithDuration:1*animationDuration animations:^{
        _scrollViewC.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    // 键盘将要显示的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    // 键盘将要隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    return YES;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80.f;
    }else{
        return 40.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            static NSString *CellIdentifier = @"CellIdentifier";
            userInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[[userInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            }
            
            cell.usernameLabel.text = @"张德华";
            cell.userPosition.text = @"EMBA2007届";
            
            cell.backgroundColor = [UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            return cell;
        }
            break;
            
        case 1:
        {
            
            static NSString *IdentifierCell = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdentifierCell];
            
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IdentifierCell] autorelease];
            }
            
            UITextField *nameText = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, KUIScreenWidth - 10.f, 40)];
            self.pwdField = nameText;
            self.pwdField.placeholder = @" 密码";
            self.pwdField.delegate=self;
            self.pwdField.tag = 2;
            self.pwdField.font = [UIFont systemFontOfSize:18];
            self.pwdField.keyboardType = UIKeyboardTypeDefault;
            [self.pwdField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [self.pwdField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [cell.contentView addSubview:self.pwdField];
            RELEASE_SAFE(nameText);
            
          
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 41.f, KUIScreenWidth, 1.f)];
            line.backgroundColor = RGBACOLOR(207, 209, 215, 1);
            [cell.contentView addSubview:line];
            RELEASE_SAFE(line);
            
            return cell;
            
        }
            break;
            
        default:
            break;
    }
    
    
    return nil;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, 20.f)];
//    bgView.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    bgView.backgroundColor = COLOR_LIGHTWEIGHT;
    
    return [bgView autorelease];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
