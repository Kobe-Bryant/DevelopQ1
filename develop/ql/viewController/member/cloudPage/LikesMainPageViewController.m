//
//  LikesMainPageViewController.m
//  ql
//
//  Created by yunlai on 14-2-27.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "LikesMainPageViewController.h"
#import "memberLikesCell.h"
#import "Global.h"
#import "MBProgressHUD.h"
#import "commentView.h"
#import "UIImageView+WebCache.h"
#import "cardDetailViewController.h"
#import "TYDotIndicatorView.h"
#import "YLNullViewReminder.h"

@interface LikesMainPageViewController (){
//    指示器
    MBProgressHUD *_progressHUD;
//    加载框
    TYDotIndicatorView *darkCircleDot;
//    空视图
    YLNullViewReminder *_nullViewReminder;
}

@property (nonatomic , retain) NSMutableArray *likeArr;//赞数据组

@end

@implementation LikesMainPageViewController
@synthesize likeArr = _likeArr;
@synthesize isClick;

#define MAXCOUNT 10

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
    
    _likeArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.title = @"赞";
//    加载主视图
    [self layoutMainView];
    
    //loading
    darkCircleDot = [[TYDotIndicatorView alloc] initWithFrame:CGRectMake(0, 0, KUIScreenWidth, KUIScreenHeight+20) dotStyle:TYDotIndicatorViewStyleCircle dotColor:[UIColor colorWithWhite:0.7 alpha:1.0] dotSize:CGSizeMake(10, 10)];
    darkCircleDot.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.1];
    [darkCircleDot startAnimating];
    [self.view addSubview:darkCircleDot];
//    请求赞数据
    [self accessCarelistService];

}

//加载主视图
- (void)layoutMainView{
    _likeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, self.view.bounds.size.height) style:UITableViewStylePlain];
    _likeTableView.delegate = self;
    _likeTableView.dataSource = self;
    _likeTableView.backgroundColor = [UIColor clearColor];
    _likeTableView.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    if (IOS_VERSION_7) {
        [_likeTableView setSeparatorInset:UIEdgeInsetsZero];
    }else{
        _likeTableView.frame = CGRectMake(0, 0, KUIScreenWidth, self.view.bounds.size.height-44);
    }
    [self.view addSubview:_likeTableView];
    
    // 底部视图
    _footMoreLoadView = [[LoadMoreTableFooterView alloc] init];
    _footMoreLoadView.delegate = self;
    _footMoreLoadView.backgroundColor = [UIColor clearColor];
    
    _likeTableView.tableFooterView = _footMoreLoadView;
    
    _footMoreLoadView.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    _footMoreLoadView.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeLoading{
    [darkCircleDot removeFromSuperview];
    
}

#pragma mark - LoadMoreTableFooterDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.likeArr.count >= MAXCOUNT) {
        [_footMoreLoadView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view{
//    加载更多赞
    [self accessCarelistMoreService];
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.likeArr.count > 0) {
        return self.likeArr.count;
    }else{
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentCell = @"indentCell";
    
    memberLikesCell *cell = [tableView dequeueReusableCellWithIdentifier:indentCell];
    if (nil == cell) {
        cell = [[[memberLikesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentCell]autorelease];
        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    if (self.likeArr.count > 0 ) {
        
        NSURL *imgUrl = [NSURL URLWithString:[[self.likeArr objectAtIndex:indexPath.row]objectForKey:@"portrait"]];
        
        UIImage* placeHolderImg = nil;
        if ([[[self.likeArr objectAtIndex:indexPath.row] objectForKey:@"sex"] intValue] == 1) {
            placeHolderImg = IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME);
        }else{
            placeHolderImg = IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME);
        }
        
        [cell.headView setImageWithURL:imgUrl placeholderImage:placeHolderImg];
//        拼接名字和角色
        cell.userName.text = [NSString stringWithFormat:@"%@  %@",[[self.likeArr objectAtIndex:indexPath.row]objectForKey:@"realname"],[[self.likeArr objectAtIndex:indexPath.row]objectForKey:@"role"]];
        cell.companyL.text = [[self.likeArr objectAtIndex:indexPath.row]objectForKey:@"company_name"];
        
        cell.likeTime.text = [Common makeFriendTime:[[[self.likeArr objectAtIndex:indexPath.row]objectForKey:@"created"] intValue]];
        
        NSString* imagePath = [[self.likeArr objectAtIndex:indexPath.row] objectForKey:@"image_path"];
        
        if (![imagePath isEqualToString:@""] && imagePath.length > 0) {
            cell.thumbnailImage.hidden = NO;
            cell.introLabel.hidden = YES;
            [cell.thumbnailImage setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:IMGREADFILE(@"img_member_default_120.png")];
        }else{
            cell.thumbnailImage.hidden = YES;
            cell.introLabel.hidden = NO;
            cell.introLabel.text = [[self.likeArr objectAtIndex:indexPath.row]objectForKey:@"title"];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary* dic = [self.likeArr objectAtIndex:indexPath.row];
    
    [self accessDynamicDetail:[[dic objectForKey:@"publish_id"] intValue]];
}

-(void) headViewTouch:(int) userId{
    
}

#pragma mark - accessService
//赞数据请求
- (void)accessCarelistService{
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [Global sharedGlobal].user_id,@"user_id",
                                        [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                        nil];
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:MAINPAGE_LIKELIST_COMMAND_ID accessAdress:@"member/carelist.do?param=" delegate:self withParam:nil];
}

//赞数据加载更多
- (void)accessCarelistMoreService{
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [Global sharedGlobal].user_id,@"user_id",
                                        [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                        [[self.likeArr lastObject]objectForKey:@"id"],@"id",
                                        nil];
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:MAINPAGE_LIKELIST_MORE_COMMAND_ID accessAdress:@"member/carelist.do?param=" delegate:self withParam:nil];
}

//动态详情请求
-(void) accessDynamicDetail:(int) publishId{
    NSString* reqUrl = @"member/publishDetail.do?param=";
    NSMutableDictionary* requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:publishId],@"publish_id",
                                       [Global sharedGlobal].user_id,@"user_id",
                                       nil];
    [[NetManager sharedManager] accessService:requestDic data:nil command:DYNAMIC_DETAIL_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
}

//网络请求回调
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
    
    //去掉loading
    [self performSelector:@selector(removeLoading) withObject:nil afterDelay:0];

    
    if (![[resultArray lastObject] isKindOfClass:[NSString class]]) {
       
        switch (commandid) {
            case MAINPAGE_LIKELIST_COMMAND_ID:
            {
    
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   
                    [self.likeArr addObjectsFromArray:[[resultArray objectAtIndex:0]objectForKey:@"cares"]];
    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [_likeTableView reloadData];
                        
                        if (self.likeArr.count ==0) {
                            
                            NSString *sign = @"余亦能高咏，斯人不可闻";
                            _nullViewReminder = [[YLNullViewReminder alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, KUIScreenHeight) reminderImage:[[ThemeManager shareInstance] getThemeImage:@"img_member_default2.png"] reminderTitle:sign];
                            [self.view addSubview:_nullViewReminder];
                        }
                        
                        if (self.likeArr.count >= MAXCOUNT) {
                            _footMoreLoadView.hidden = NO;
                        }
                    });
                });
                
            }break;
                
            case MAINPAGE_LIKELIST_MORE_COMMAND_ID:
            {
                
                [_footMoreLoadView egoRefreshScrollViewDataSourceDidFinishedLoading:_likeTableView];
                
                NSArray *moreArr = [[resultArray objectAtIndex:0]objectForKey:@"cares"];
                
                if (moreArr.count !=0 ) {
                    [self.likeArr addObjectsFromArray:moreArr];
           
                    
                    [_likeTableView reloadData];
                    
                    if (self.likeArr.count >= MAXCOUNT) {
                        _footMoreLoadView.hidden = NO;
                    }
                }else{
                    
                    [Common checkProgressHUD:@"没有更多了" andImage:nil showInView:self.view];
                }
             
                
            }break;
                
            case DYNAMIC_DETAIL_COMMAND_ID:
            {
                if (resultArray.count) {
                    
                    //delete字段0未删除，1已删除
                    int deleteStatus = [[[resultArray firstObject] objectForKey:@"delete"] intValue];
                    if (deleteStatus) {
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"这条动态已被删除" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                        [alert release];
                        return;
                    }
                    
                    cardDetailViewController* cardDetailVC = [[cardDetailViewController alloc] init];
                    int type = [[[resultArray firstObject] objectForKey:@"type"] intValue];
                    
                    CardType cardT;
                    if (type == 0) {
                        cardT = CardImage;
                    }else if (type == 1) {
                        cardT = CardOOXX;
                    }else if (type == 2) {
                        cardT = CardOpenTime;
                    }else if (type == 3) {
                        cardT = CardWantOrHave;
                    }else if (type == 4){
                        cardT = CardWantOrHave;
                    }else if (type == 5){
                        cardT = CardNews;
                    }else if (type == 6) {
                        cardT = CardLabel;
                    }else if (type == 8) {
                        cardT = CardTogether;
                    }else{
                        cardT = CardImage;
                    }
                    cardDetailVC.type = cardT;
                    cardDetailVC.dataDic = [resultArray firstObject];
                    cardDetailVC.detailType = DynamicDetailTypeAll;
                    
                    cardDetailVC.enterFromDYList = NO;
                    
                    [self.navigationController pushViewController:cardDetailVC animated:YES];
                    RELEASE_SAFE(cardDetailVC);
                    
                }else{
                    [Common checkProgressHUD:@"服务器错误.." andImage:nil showInView:self.view];
                }
            }
                break;
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
    RELEASE_SAFE(_likeTableView);
    RELEASE_SAFE(_footMoreLoadView);
    RELEASE_SAFE(_nullViewReminder);
    [super dealloc];
}
@end
