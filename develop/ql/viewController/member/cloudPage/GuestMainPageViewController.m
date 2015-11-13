//
//  GuestMainPageViewController.m
//  ql
//
//  Created by yunlai on 14-2-27.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "GuestMainPageViewController.h"
#import "UIImageView+WebCache.h"
#import "MemberMainViewController.h"
#import "guestCell.h"
#import "MBProgressHUD.h"
#import "Global.h"
#import "TYDotIndicatorView.h"
#import "YLNullViewReminder.h"
#import "CRNavigationController.h"

@interface GuestMainPageViewController ()
{
//   加载更多组件
    LoadMoreTableFooterView *_footMoreLoadView;
//    加载框
    TYDotIndicatorView *_darkCircleDot;
//    空视图页面
    YLNullViewReminder *_nullViewReminder;
}
@property (nonatomic, retain) NSMutableArray *visitArray;   //服务器返回数据
@property (nonatomic, retain) NSMutableArray *keys;         //section值
@property (nonatomic, retain) NSMutableArray *visitTimeArr; //排序后的分组数据
@property (nonatomic, retain) NSMutableDictionary *dateDic; //未排序的分组数据

@end

#define MAXCOUNT 10

@implementation GuestMainPageViewController
@synthesize visitArray = _visitArray;
@synthesize visitTimeArr = _visitTimeArr;
@synthesize keys = _keys;
@synthesize dateDic = _dateDic;
@synthesize isClick;

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
    
    self.title = @"访客";
//    加载主视图
    [self loadMainView];
//    初始化数据
    _visitArray = [[NSMutableArray alloc]initWithCapacity:0];
    _visitTimeArr = [[NSMutableArray alloc]initWithCapacity:0];
    _keys = [[NSMutableArray alloc]initWithCapacity:0];
    _dateDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    //loading
    _darkCircleDot = [[TYDotIndicatorView alloc] initWithFrame:CGRectMake(0, 0, KUIScreenWidth, KUIScreenHeight+20) dotStyle:TYDotIndicatorViewStyleCircle dotColor:[UIColor colorWithWhite:0.7 alpha:1.0] dotSize:CGSizeMake(10, 10)];
    _darkCircleDot.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.1];
    [_darkCircleDot startAnimating];
    [self.view addSubview:_darkCircleDot];
//    请求访客数据
    [self accessVisitlistService];

}
/**
 *  主视图
 */
- (void)loadMainView{
    
    _visitTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, self.view.bounds.size.height) style:UITableViewStylePlain];
    _visitTableView.delegate = self;
    _visitTableView.dataSource = self;
    _visitTableView.showsVerticalScrollIndicator = NO;
    _visitTableView.backgroundColor = [UIColor clearColor];
    _visitTableView.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    if (IOS_VERSION_7) {
        [_visitTableView setSeparatorInset:UIEdgeInsetsZero];
    }else{
        _visitTableView.frame = CGRectMake(0, 0, KUIScreenWidth, self.view.bounds.size.height-44);
    }
    [self.view addSubview:_visitTableView];
    
    // 底部视图
    _footMoreLoadView = [[LoadMoreTableFooterView alloc] init];
    _footMoreLoadView.delegate = self;
    _footMoreLoadView.backgroundColor = [UIColor clearColor];
    
    _visitTableView.showsVerticalScrollIndicator = NO;
    _visitTableView.tableFooterView = _footMoreLoadView;
    
    _footMoreLoadView.hidden = YES;
}

// 获取今天日期
- (NSString *)getCurrDate{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy年MM月dd日"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];

    [dateformatter release];
    
    return locationString;
    
}

// 数据按时间排序分组
- (void)handelWithCreated:(NSMutableArray *)array
{
    //先清空数据
    [self.visitTimeArr removeAllObjects];
    [self.dateDic removeAllObjects];
    [self.keys removeAllObjects];
    
    //遍历
    for (NSDictionary *obj in array)
    {
        NSString *created = [Common makeTime:[[obj objectForKey:@"created"] intValue] withFormat:@"yyyy年MM月dd日"];
        
        if ([created isEqualToString:[self getCurrDate]]) {
            created = @"今天";
        }
        
        NSMutableArray *timeArray = [self.dateDic objectForKey:created];
        if (timeArray == nil)
        {
            NSMutableArray *infoArray = [[NSMutableArray alloc]init];
            
            [infoArray addObject:obj];
            
            [self.dateDic setObject:infoArray forKey:created];
            
        }
        else
        {
            [timeArray addObject:obj];
        }
     
    }
    
    //返回是一个数组  键是不可变的数组
    NSMutableArray *keyArray = [[NSMutableArray alloc] init];
    [keyArray addObjectsFromArray:[[self.dateDic allKeys]
                                   sortedArrayUsingSelector:@selector(compare:)]];
    
    for (int  i = [keyArray count ] - 1 ; i >= 0 ; i--)
    {
        NSString *name = [keyArray objectAtIndex:i];
        [self.keys addObject:name];
    }
    [keyArray release];
    
    //遍历字典
    NSArray *objArray   = [self.dateDic objectsForKeys:self.keys notFoundMarker:@"NOT_FOUND"];
    
    for (int i =0; i < objArray.count; i ++)
    {
        
        NSMutableDictionary *subDic =[NSMutableDictionary dictionaryWithObject:[objArray objectAtIndex:i] forKey:[self.keys objectAtIndex:i]];
        [self.visitTimeArr addObject:subDic];
    }
    
}

//移除加载框
- (void)removeLoading{
    [_darkCircleDot removeFromSuperview];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LoadMoreTableFooterDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.visitArray.count >= MAXCOUNT) {
        [_footMoreLoadView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view{
//    加载更多
    [self accessVisitlistMoreService];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.visitTimeArr.count > 0) {
        NSString *keyTime = [self.keys objectAtIndex:section];
        
        NSArray *arr = [[self.visitTimeArr objectAtIndex:section]objectForKey:keyTime];
        
        return arr.count;
        
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.keys.count > 0) {
        return self.keys.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, 20.f)];
    timeL.text = [NSString stringWithFormat:@"\t%@",[self.keys objectAtIndex:section]];
    timeL.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
    timeL.font = KQLSystemFont(12);
    timeL.backgroundColor = [UIColor colorWithPatternImage:[[ThemeManager shareInstance] getThemeImage:@"under_bar.png"]];
    return [timeL autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    static NSString *CellIdentifier = @"guestCell";
    guestCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[guestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSString *keyTime = [self.keys objectAtIndex:indexPath.section];
    
    NSArray *arr = [[self.visitTimeArr objectAtIndex:indexPath.section]objectForKey:keyTime];
    
    NSURL *imgUrl = [NSURL URLWithString:[[arr objectAtIndex:indexPath.row] objectForKey:@"portrait"]];
    
    UIImage* placeHolderImg = nil;
    if ([[[arr objectAtIndex:indexPath.row] objectForKey:@"sex"] intValue] == 1) {
        placeHolderImg = IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME);
    }else{
        placeHolderImg = IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME);
    }
    
    [cell.headView setImageWithURL:imgUrl placeholderImage:placeHolderImg];
    
    NSString *userN = [[arr objectAtIndex:indexPath.row] objectForKey:@"realname"];
    cell.userName.text = [NSString stringWithFormat:@"%@  %@",userN,[[arr objectAtIndex:indexPath.row] objectForKey:@"role"]];
    
    cell.companyL.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"company_name"];
    cell.timeL.text = [Common makeTime:[[[arr objectAtIndex:indexPath.row] objectForKey:@"created"] intValue] withFormat:@"HH:mm"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *keyTime = [self.keys objectAtIndex:indexPath.section];
    
    NSArray *arr = [[self.visitTimeArr objectAtIndex:indexPath.section]objectForKey:keyTime];
    
    MemberMainViewController *memberMainView = [[MemberMainViewController  alloc] init];
    memberMainView.pushType = PushTypesButtom;
//    memberMainView.accessType = AccessTypeLookOther;
    memberMainView.lookId = [[[arr objectAtIndex:indexPath.row] objectForKey:@"user_id"] intValue];
    if (memberMainView.lookId == [[Global sharedGlobal].user_id longLongValue] ) {
        memberMainView.accessType = AccessTypeSelf;
    }else{
        memberMainView.accessType = AccessTypeLookOther;
    }
    CRNavigationController * nav = [[CRNavigationController alloc]initWithRootViewController:memberMainView];
    [self.navigationController presentModalViewController:nav animated:YES];
    RELEASE_SAFE(nav);
    RELEASE_SAFE(memberMainView);
    
}

#pragma mark - accessService
//访客数据请求
- (void)accessVisitlistService{
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [Global sharedGlobal].user_id,@"user_id",
                                        [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                        nil];
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:MAINPAGE_VISITLIST_COMMAND_ID accessAdress:@"member/visitlist.do?param=" delegate:self withParam:nil];
}
//加载更多访客请求
- (void)accessVisitlistMoreService{
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [Global sharedGlobal].user_id,@"user_id",
                                        [[self.visitArray lastObject] objectForKey:@"id"],@"id",
                                        [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                        nil];
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:MAINPAGE_VISITLIST_MORE_COMMAND_ID accessAdress:@"member/visitlist.do?param=" delegate:self withParam:nil];
}

//网络请求回调
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
    
    [self performSelector:@selector(removeLoading) withObject:nil afterDelay:0];

    if (![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        NSLog(@"==%@",resultArray);
        
        switch (commandid) {
            case MAINPAGE_VISITLIST_COMMAND_ID:
            {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    
                    [self.visitArray addObjectsFromArray:[[resultArray objectAtIndex:0]objectForKey:@"visitors"]];
                    
                    //解析分组数据
                    [self handelWithCreated:self.visitArray];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [_visitTableView reloadData];
                        
                        if (self.visitArray.count ==0) {
                            NSString *sign = @"人独在，如今翘首盼君来";
                            
                            _nullViewReminder = [[YLNullViewReminder alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, KUIScreenHeight) reminderImage:[[ThemeManager shareInstance] getThemeImage:@"img_member_default1.png"] reminderTitle:sign];
                            [self.view addSubview:_nullViewReminder];
                            
                        }
                        
                        if (self.visitArray.count >= MAXCOUNT) {
                            _footMoreLoadView.hidden = NO;
                        }
                    });
                });
                
            }break;
                
            case MAINPAGE_VISITLIST_MORE_COMMAND_ID:
            {
                
                [_footMoreLoadView egoRefreshScrollViewDataSourceDidFinishedLoading:_visitTableView];
                
                NSArray *moreArr = [[resultArray objectAtIndex:0]objectForKey:@"visitors"];
                
                if (moreArr.count !=0 ) {
                    [self.visitArray addObjectsFromArray:moreArr];
                    
                    //解析分组数据
                    [self handelWithCreated:self.visitArray];
                    
                    [_visitTableView reloadData];
                    
                    if (self.visitArray.count >= MAXCOUNT) {
                        _footMoreLoadView.hidden = NO;
                    }
                }else{
                    
                    [Common checkProgressHUD:@"没有更多了" andImage:nil showInView:self.view];
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

- (void)dealloc
{
    RELEASE_SAFE(_visitTableView);
    RELEASE_SAFE(_nullViewReminder);
    RELEASE_SAFE(_footMoreLoadView);
    
    [super dealloc];
}
@end
