//
//  msgSetViewController.m
//  ql
//
//  Created by yunlai on 14-4-16.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "msgSetViewController.h"

#import "Common.h"

@interface msgSetViewController (){
//    静态cell组
    NSMutableArray* cells;
//    cell下的文本
    NSArray* footStrArr;
}

@property(nonatomic,retain) UITableView* tableView;

@end

@implementation msgSetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        cells = [[NSMutableArray alloc] init];
        footStrArr = [[NSArray alloc] initWithObjects:
                      @"关闭后,有朋友发来消息时,不再提示",
                      @"关闭后,有朋友回复你发表的动态时,不再提示",
                      @"关闭后,有朋友发我有我要的消息时,不再提示",
                      @"关闭后,有朋友和你同时有空时,不再提示",
                      @"关闭后,有朋友更新企业动态时,不再提示",
                      nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息提醒设置";
    self.view.backgroundColor = COLOR_LIGHTWEIGHT;
//    初始化返回
    [self backBar];
//    初始化静态cell
    [self initCells];
//    初始化列表
    [self initTable];
    
	// Do any additional setup after loading the view.
}

/**
 *  返回按钮
 */
- (void)backBar{
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [[ThemeManager shareInstance] getThemeImage:@"ico_common_return.png"];
    [backButton setImage:image forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0,image.size.width, image.size.height);
    UIBarButtonItem  *backItem = [[UIBarButtonItem  alloc]  initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    }
    RELEASE_SAFE(backItem);
}

-(void) backTo{
    [self.navigationController popViewControllerAnimated:YES];
}

//加载静态cell组
-(void) initCells{
    //初始化静态cells
    UITableViewCell* pwCell = [[[UITableViewCell alloc] init] autorelease];
    pwCell.textLabel.text = @"聊天消息提醒";
    pwCell.tag = 100;
    pwCell.accessoryView = [self createSwitch:100];
    [cells addObject:pwCell];
    
    UITableViewCell* publicCell = [[[UITableViewCell alloc] init] autorelease];
    publicCell.textLabel.text = @"动态更新提醒";
    publicCell.tag = 101;
    publicCell.accessoryView = [self createSwitch:101];
    [cells addObject:publicCell];

    UITableViewCell* iWantCell = [[[UITableViewCell alloc] init] autorelease];
    iWantCell.textLabel.text = @"我有我要提醒";
    iWantCell.tag = 102;
    iWantCell.accessoryView = [self createSwitch:102];
    [cells addObject:iWantCell];

    UITableViewCell* openTimeCell = [[[UITableViewCell alloc] init] autorelease];
    openTimeCell.textLabel.text = @"开放时间提醒";
    openTimeCell.tag = 103;
    openTimeCell.accessoryView = [self createSwitch:103];
    [cells addObject:openTimeCell];

    UITableViewCell* companyCell = [[[UITableViewCell alloc] init] autorelease];
    companyCell.textLabel.text = @"企业动态更新提醒";
    companyCell.tag = 104;
    companyCell.accessoryView = [self createSwitch:104];
    [cells addObject:companyCell];
}

//创建各cell上的开关 并对开关状态初始化
-(UISwitch*) createSwitch:(int) tag{
    UISwitch* s = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    if ([s respondsToSelector:@selector(setOnTintColor:)]) {
        [s setOnTintColor:[UIColor colorWithRed:0.12 green:0.55 blue:0.89 alpha:1.0]];
    }
    [s addTarget:self action:@selector(switchTouch:) forControlEvents:UIControlEventTouchUpInside];
    s.tag = tag;
    
    switch (tag) {
        case 100:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"talkMsg"]) {
                NSLog(@"++1++");
                [s setOn:YES];
            }else{
                [s setOn:NO];
            }
            break;
        case 101:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"publicMsg"]) {
                NSLog(@"++2++");
                [s setOn:YES];
            }else{
                [s setOn:NO];
            }
            break;
        case 102:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"iWantMsg"]) {
                NSLog(@"++3++");
                [s setOn:YES];
            }else{
                [s setOn:NO];
            }
            break;
        case 103:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"openTimeMsg"]) {
                NSLog(@"++4++");
                [s setOn:YES];
            }else{
                [s setOn:NO];
            }
            break;
        case 104:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"companyMsg"]) {
                NSLog(@"++5++");
                [s setOn:YES];
            }else{
                [s setOn:NO];
            }
            break;
        default:
            break;
    }
    return s;
}

//开关响应 发送请求 存储状态
-(void) switchTouch:(UISwitch*) s{
    
    [self accessMSgSet:(s.tag - 100 + 1) status:s.on?1:0];
    
    switch (s.tag) {
        case 100:
            [[NSUserDefaults standardUserDefaults] setBool:s.on forKey:@"talkMsg"];
            break;
        case 101:
            [[NSUserDefaults standardUserDefaults] setBool:s.on forKey:@"publicMsg"];
            break;
        case 102:
            [[NSUserDefaults standardUserDefaults] setBool:s.on forKey:@"iWantMsg"];
            break;
        case 103:
            [[NSUserDefaults standardUserDefaults] setBool:s.on forKey:@"openTimeMsg"];
            break;
        case 104:
            [[NSUserDefaults standardUserDefaults] setBool:s.on forKey:@"companyMsg"];
            break;
        default:
            break;
    }
}

//加载列表
-(void) initTable{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorColor = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return cells.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell = [cells objectAtIndex:indexPath.section];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20.0f;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 38.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *__view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 40.0f)];
    [__view setBackgroundColor:[UIColor colorWithRed:232/255.0 green:237/255.0 blue:240/255.0 alpha:1]];
    return __view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *__view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 38.0f)];
    [__view setBackgroundColor:[UIColor colorWithRed:232/255.0 green:237/255.0 blue:240/255.0 alpha:1]];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 300, 20)];
    lable.backgroundColor = [UIColor clearColor];
    lable.text = [footStrArr objectAtIndex:section];
    lable.font = [UIFont systemFontOfSize:13.0];
    lable.textColor = [UIColor lightGrayColor];
    [__view addSubview:lable];
    [lable release];
    return __view;
}

//开关状态请求
-(void) accessMSgSet:(int) type status:(int) status{
    NSString* reqUrl = @"member/setting.do?param=";
    
    NSMutableDictionary* requestDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                       [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                                       [NSNumber numberWithInt:type],@"type",
                                       [NSNumber numberWithInt:status],@"status",
                                       nil];
    
    [[NetManager sharedManager] accessService:requestDic data:nil command:SET_MSGSET_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
    
    RELEASE_SAFE(requestDic);//add vincent
}

//网络请求回调
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
    NSLog(@"==resultArray:%@==",resultArray);
    switch (commandid) {
        case SET_MSGSET_COMMAND_ID:
        {
            //do something
            if (resultArray && ![[resultArray lastObject] isKindOfClass:[NSString class]]) {
                if ([[[resultArray lastObject] objectForKey:@"ret"] intValue] == 1) {
                    
                }
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    [cells release];
    [footStrArr release];
    [_tableView release];
    [super dealloc];
}

@end
