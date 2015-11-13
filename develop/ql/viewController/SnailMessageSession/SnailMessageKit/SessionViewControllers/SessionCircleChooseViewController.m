//
//  SessionCircleChooseViewController.m
//  ql
//
//  Created by LazySnail on 14-7-4.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "SessionCircleChooseViewController.h"
#import "circle_list_model.h"
#import "circle_member_list_model.h"
#import "chatmsg_list_model.h"
#import "SessionViewController.h"

#define circleListCellHight 60

@interface SessionCircleChooseViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray * circleList;
@property (nonatomic, retain) UITableView * circleTable;

@end

@implementation SessionCircleChooseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.circleList = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置布局
    [self setUp];
    //加载圈子信息
    [self loadCircleList];
    //加载圈子列表
    [self loadCircleListTable];
}

- (void)setUp
{
    self.title = @"选择一个圈子开始聊天";
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
}

- (void)loadCircleList
{
    NSMutableArray * allCircles = [circle_list_model getInstanceList];
    for (NSDictionary * circleDic in allCircles) {
        NSNumber * userSumNum = [circleDic objectForKey:@"user_sum"];
        int userSum = userSumNum.intValue;
        if (userSum > 1) {
            [self.circleList addObject:circleDic];
        }
    }
}

- (void)loadCircleListTable
{
    if (self.circleList.count == 0) {
        UILabel * remind =  [[UILabel alloc]initWithFrame:CGRectMake(KUIScreenWidth/2 - 100, KUIScreenHeight/2 - 50, 200, 100)];
        remind.font = KQLboldSystemFont(14);
        remind.numberOfLines = 0;
        remind.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
        remind.text = @"您还没有加入一个人数超过两人的圈子,请邀请别人加入你的圈子,或者加入别人的圈子";
        [self.view addSubview:remind];
    } else {
        
        // 配置主Table
        self.circleTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KUIScreenWidth, KUIScreenHeight) style:UITableViewStylePlain];
        self.circleTable.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
        self.circleTable.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
        self.circleTable.showsVerticalScrollIndicator = NO;
        self.circleTable.dataSource = self;
        self.circleTable.delegate = self;
        
        //iOS 7 鼓励界面向NavigationBar内扩展 不一样的奇特体验 所以得屏蔽掉
        if (IOS_VERSION_7) {
            [self.circleTable setSeparatorInset:UIEdgeInsetsZero];
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
        [self.view addSubview:self.circleTable];
    }
}

#pragma mark - UITableViewDataScource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.circleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * circleDic = [self.circleList objectAtIndex:indexPath.row];
    NSString * circleCellIdentify = @"circleCellIdentify";
    UITableViewCell * cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:circleCellIdentify];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:circleCellIdentify]autorelease];
    }
    cell.textLabel.text = [circleDic objectForKey:@"name"];
    cell.textLabel.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - UITableViewDelegate

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return circleListCellHight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"select circle %@",[self.circleList objectAtIndex:indexPath.row]);
    
    NSDictionary * tcircleDic = [self.circleList objectAtIndex:indexPath.row];
    
    //获取所选择圈子的成员列表
    NSMutableArray * memberArr = [circle_member_list_model getAllMemberWithCircle:[[tcircleDic objectForKey:@"circle_id"] longLongValue]];
    
    //开启一个圈子聊天窗口
    NSDictionary * sessionNeedDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [tcircleDic objectForKey:@"circle_id"],@"sender_id",
                                     [tcircleDic objectForKey:@"name"],@"name",
                                     [NSNumber numberWithInt:MessageListTypeCircle],@"talk_type",nil];
    SessionViewController * session = [[SessionViewController alloc]init];
    session.selectedDic = sessionNeedDic;
    session.circleContactsList = memberArr;
    
    NSDictionary * nameAndPorArr = [Common generatePortraitNameDicJsonStrWithContactArr:session.circleContactsList];
    NSArray * portraitArr = [nameAndPorArr objectForKey:@"icon_path"];
    
    NSDictionary * recordDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                [tcircleDic objectForKey:@"circle_id"],@"id",
                                [NSNumber numberWithInt:MessageListTypeCircle],@"talk_type",
                                portraitArr,@"icon_path",
                                [tcircleDic objectForKey:@"name"],@"title",
                                nil];
    BOOL isSuccess =  [chatmsg_list_model insertOrUpdateRecordWithDic:recordDic];
    if (!isSuccess) {
        [Common checkProgressHUD:@"发起会话产生列表失败" andImage:nil showInView:APPKEYWINDOW];
    }
    
    [self.navigationController pushViewController:session animated:YES];
    RELEASE_SAFE(session);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Dealloc

- (void)dealloc
{
    LOG_RELESE_SELF;
    [super dealloc];
}

@end
