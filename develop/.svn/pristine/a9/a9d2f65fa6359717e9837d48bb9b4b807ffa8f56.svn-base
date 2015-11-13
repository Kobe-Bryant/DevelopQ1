//
//  PersonInfoViewController.m
//  ql
//
//  Created by yunlai on 14-4-10.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "personCell.h"

@interface PersonInfoViewController ()
{
    UITableView *_listTableView;
}
@end

@implementation PersonInfoViewController

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
    
    self.title = @"个人信息";
    
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
//    self.view.backgroundColor = COLOR_LIGHTWEIGHT;
    
    [self rightBarButton];
    
    [self mainViewList];
}

- (void)rightBarButton{
    
    UIButton *saveButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    saveButton.backgroundColor = [UIColor grayColor];
    
    [saveButton addTarget:self action:@selector(saveTo) forControlEvents:UIControlEventTouchUpInside];
    
//    UIImage *image = [[UIImage alloc ]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return" ofType:@"png"]];
    UIImage *image = [[ThemeManager shareInstance] getThemeImage:@"ico_common_return.png"];
    [saveButton setImage:image forState:UIControlStateNormal];
    saveButton.frame = CGRectMake(0, 0, 30.f, 30.f);
//    RELEASE_SAFE(image);
    
    UIBarButtonItem  *backItem = [[UIBarButtonItem  alloc]  initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = backItem;
    RELEASE_SAFE(backItem);
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
}
- (void)mainViewList{
    
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, KUIScreenWidth, 300.f) style:UITableViewStylePlain];
    _listTableView.dataSource = self;
    _listTableView.delegate = self;
    _listTableView.scrollEnabled = NO;
    _listTableView.backgroundColor = [UIColor clearColor];
    _listTableView.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    if (IOS_VERSION_7) {
        [_listTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:_listTableView];
    
}

// 保存
- (void)saveTo{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

// 每个section有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"userInfoCell";
    personCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[personCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.tipsNameL.text = @"公司名称";
            cell.txtLabel.text = @"云来网络";
            
        }
            break;
        case 1:
        {
            cell.tipsNameL.text = @"职位";
            cell.txtLabel.text = @"董事长";
          
        }
            break;
        case 2:
        {
            cell.tipsNameL.text = @"手机";
            cell.txtLabel.text = @"186-7034-8470";
          
        }
            break;
        case 3:
        {
            cell.tipsNameL.text = @"邮箱";
            cell.txtLabel.text = @"cf12651951@163.com";
        }
            break;
        case 4:
        {
            cell.tipsNameL.text = @"兴趣爱好";
            cell.txtLabel.text = @"高尔夫，跑步，旅游";
        }
            break;
        default:
            break;
    }
    
    return cell;
    
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
