//
//  aboutMeMsgListViewController.m
//  ql
//
//  Created by yunlai on 14-5-4.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "aboutMeMsgListViewController.h"

#import "UIImageView+WebCache.h"
#import "aboutMeMsgCell.h"

#import "commentView.h"

#import "dynamic_relationme_model.h"

#import "MemberMainViewController.h"
#import "YLNullViewReminder.h"

#import "cardDetailViewController.h"
#import "CRNavigationController.h"

#import "ThemeManager.h"
#import "config.h"
#import "NetManager.h"
#import "Common.h"
#import "Global.h"
#import "UIImageScale.h"

#define MAXCOUNT 7

#define KMeNoneText @"朋友回应你的动态时,会显示在这里"

@interface aboutMeMsgListViewController ()<commentDelegate>{
//    列高组
    NSMutableArray* cellHeightArr;
}

@end

@implementation aboutMeMsgListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _msgArr = [[NSMutableArray alloc] init];
        cellHeightArr = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"@我";
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
    _darkCircleDot = [[TYDotIndicatorView alloc] initWithFrame:CGRectMake(0, 0.f, KUIScreenWidth, KUIScreenHeight) dotStyle:TYDotIndicatorViewStyleCircle dotColor:[UIColor colorWithWhite:1.0 alpha:1.0] dotSize:CGSizeMake(10, 10)];
    _darkCircleDot.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.3];
    [_darkCircleDot startAnimating];
    [self.view addSubview:_darkCircleDot];
    
//    请求@我数据
    [self accessAboutMeMsgList];
    
	// Do any additional setup after loading the view.
}

//初始化列表
-(void) initTable{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = COLOR_LIGHTWEIGHT;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
    if (IOS_VERSION_7) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:_tableView];
    
    _footerView = [[LoadMoreTableFooterView alloc] init];
    _footerView.delegate = self;
    _footerView.backgroundColor = [UIColor clearColor];
    
    _tableView.tableFooterView = _footerView;
    
    _footerView.hidden = YES;
    
    if (_msgArr.count >= MAXCOUNT) {
        _footerView.hidden = NO;
    }
}

//初始化空视图
-(void) initNoneView{
    
    YLNullViewReminder* nullView = [[YLNullViewReminder alloc] initWithFrame:self.view.bounds reminderImage:IMG(@"img_feed_default1.png") reminderTitle:@"朋友回应你的动态时,会显示在这里"];
    [self.view addSubview:nullView];
    RELEASE_SAFE(nullView);
}

#pragma mark - LoadMore

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [_footerView egoRefreshScrollViewDidScroll:scrollView];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_msgArr.count >= MAXCOUNT) {
        [_footerView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

-(void) loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view{
    [self accessMore];
}

#pragma mark - tableView

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_msgArr.count) {
        return _msgArr.count;
    }else{
        return 1;
    }
    return _msgArr.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_msgArr.count) {
        return [cellHeightArr[indexPath.row] floatValue]>80?[cellHeightArr[indexPath.row] floatValue]:80;
    }else{
        return _tableView.bounds.size.height;
    }
    return 80;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = nil;
    
    if (_msgArr.count) {
        identifier = @"meCell";
    }else{
        identifier = @"noneMeCell";
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        if (_msgArr.count) {
            cell = [[[aboutMeMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
        }else{
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            YLNullViewReminder* nullView = [[YLNullViewReminder alloc] initWithFrame:self.view.bounds reminderImage:[[ThemeManager shareInstance] getThemeImage:@"img_feed_default1.png"] reminderTitle:@"朋友回应你的动态时,会显示在这里"];
            [cell.contentView addSubview:nullView];
            RELEASE_SAFE(nullView);
        }
        
    }else{
        for (UIView* v in cell.contentView.subviews) {
            if ([v isKindOfClass:[UIButton class]]) {
                [v removeFromSuperview];
            }
        }
    }
    
    if (_msgArr.count) {
        NSDictionary* dic = [_msgArr objectAtIndex:indexPath.row];
        
        UIImage* placeHolderImg = nil;
        if ([[dic objectForKey:@"sex"] intValue] == 1) {
            placeHolderImg = IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME);
        }else{
            placeHolderImg = IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME);
        }
        
        [((aboutMeMsgCell*)cell).headImgV setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"portrait"]] placeholderImage:placeHolderImg];
        ((aboutMeMsgCell*)cell).headImgV.tag = [[dic objectForKey:@"user_id"] intValue];
        ((aboutMeMsgCell*)cell).nameLab.text = [dic objectForKey:@"realname"];
        ((aboutMeMsgCell*)cell).nameLab.tag = [[dic objectForKey:@"user_id"] intValue];
        
        ((aboutMeMsgCell*)cell).nameLab.userInteractionEnabled = YES;
        UITapGestureRecognizer* tapOnName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(supHeadViewTouch:)];
        [((aboutMeMsgCell*)cell).nameLab addGestureRecognizer:tapOnName];
        [tapOnName release];
        
        ((aboutMeMsgCell*)cell).headImgV.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(supHeadViewTouch:)];
        [((aboutMeMsgCell*)cell).headImgV addGestureRecognizer:tap];
        [tap release];
        
        NSString* contentStr = nil;
        if ([[dic objectForKey:@"type"] intValue] == 1) {
            //赞
            contentStr = @"赞了";
            ((aboutMeMsgCell*)cell).contentLab.text = contentStr;
            
            //加上'你'的button
            CGRect frame = ((aboutMeMsgCell*)cell).contentLab.frame;
            [((aboutMeMsgCell*)cell).contentView addSubview:[self addUbuttonWith:contentStr frame:frame]];
            
        }else if ([[dic objectForKey:@"type"] intValue] == 2) {
            //回复
            if ([[dic objectForKey:@"parent_comment_id"] intValue] != 0) {
                ((aboutMeMsgCell*)cell).contentLab.text = [NSString stringWithFormat:@"回复: %@",[dic objectForKey:@"content"]];
            } else{
                contentStr = @"评论";
                ((aboutMeMsgCell*)cell).contentLab.text = [NSString stringWithFormat:@"%@ : %@",contentStr,[dic objectForKey:@"content"]];
            }
            
            CGRect conentframe = ((aboutMeMsgCell*)cell).contentLab.frame;
            
            ((aboutMeMsgCell*)cell).contentLab.frame = CGRectMake(conentframe.origin.x, conentframe.origin.y, 200, [cellHeightArr[indexPath.row] floatValue]);
            
        }else if ([[dic objectForKey:@"type"] intValue] == 3) {
            //投票
            if ([[dic objectForKey:@"user_choice"] intValue] == 1) {
                contentStr = @"oo了";
            }else if ([[dic objectForKey:@"user_choice"] intValue] == 2) {
                contentStr = @"xx了";
            }
            
            ((aboutMeMsgCell*)cell).contentLab.text = contentStr;
            
            //加上'你'的button
            CGRect frame = ((aboutMeMsgCell*)cell).contentLab.frame;
            [((aboutMeMsgCell*)cell).contentView addSubview:[self addUbuttonWith:contentStr frame:frame]];
            
        }else{
            ((aboutMeMsgCell*)cell).contentLab.text = nil;
        }
        
        ((aboutMeMsgCell*)cell).timeLab.text = [Common makeFriendTime:[[dic objectForKey:@"created"] intValue]];
        
        if ([dic objectForKey:@"image_path"] && [[dic objectForKey:@"image_path"] length] > 0) {
            [((aboutMeMsgCell*)cell).newsImgV setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"image_path"]] completed:^(UIImage* image,NSError* error,SDImageCacheType SDImageCacheTypeNone){
                if (image) {
                    CGSize size = ((aboutMeMsgCell*)cell).newsImgV.bounds.size;
                    UIImage* newImage = [image imageByScalingAndCroppingForSize:size];
                    ((aboutMeMsgCell*)cell).newsImgV.image = newImage;
                }
            }];
            ((aboutMeMsgCell*)cell).newsImgV.hidden = NO;
            ((aboutMeMsgCell*)cell).titleLab.hidden = YES;
            
        }else{
            ((aboutMeMsgCell*)cell).newsImgV.hidden = YES;
            ((aboutMeMsgCell*)cell).titleLab.text = [dic objectForKey:@"title"];
            ((aboutMeMsgCell*)cell).titleLab.hidden = NO;
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

//添加 你 的可点击按钮，覆盖住文本
-(UIButton*) addUbuttonWith:(NSString*) text frame:(CGRect) frame{
    UIButton* uBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [uBtn setTitle:@"你" forState:UIControlStateNormal];
    [uBtn setTitleColor:[UIColor colorWithRed:0.25 green:0.66 blue:0.90 alpha:1.0] forState:UIControlStateNormal];
    [uBtn addTarget:self action:@selector(uBtnClick) forControlEvents:UIControlEventTouchUpInside];
    uBtn.titleLabel.font = KQLboldSystemFont(15);
    
    CGSize size = [text sizeWithFont:KQLboldSystemFont(15) constrainedToSize:CGSizeMake(200, 60) lineBreakMode:NSLineBreakByWordWrapping];
    uBtn.frame = CGRectMake(frame.origin.x + size.width + 10, frame.origin.y, 20, 20);
    
    return uBtn;
}

//点击 你 跳转
-(void) uBtnClick{
    [self headViewTouch:[[Global sharedGlobal].user_id intValue]];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_msgArr.count) {
        NSDictionary* dic = [_msgArr objectAtIndex:indexPath.row];
        
        [self accessDynamicDetail:[[dic objectForKey:@"relation_id"] intValue]];
        
    }
}

//点赞头像跳转
-(void) supHeadViewTouch:(UIGestureRecognizer*)ges{
    UIImageView* imgV = (UIImageView*)ges.view;
    
    MemberMainViewController* memberVC = [[MemberMainViewController alloc] init];
    memberVC.lookId = imgV.tag;
    if (memberVC.lookId == [[Global sharedGlobal].user_id longLongValue] ) {
        memberVC.accessType = AccessTypeSelf;
    }else{
        memberVC.accessType = AccessTypeLookOther;
    }
//    memberVC.accessType = AccessTypeLookOther;
    memberVC.pushType = PushTypesButtom;
    
    CRNavigationController * nav = [[CRNavigationController alloc]initWithRootViewController:memberVC];
    [self.navigationController presentModalViewController:nav animated:YES];
    RELEASE_SAFE(nav);
    RELEASE_SAFE(memberVC);
}

//@我网络请求
-(void) accessAboutMeMsgList{
    NSString* reqUrl = @"publish/relationme.do?param=";
    NSMutableDictionary* requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                                       [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                       nil];
    [[NetManager sharedManager] accessService:requestDic data:nil command:DYNAMIC_ABOUTMEMSGLIST_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
}

//加载更多请求
-(void) accessMore{
    NSString* reqUrl = @"publish/relationme.do?param=";
    NSMutableDictionary* requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                                       [NSNumber numberWithInt:[[[_msgArr lastObject] objectForKey:@"id"] intValue]],@"id",
                                       [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                       nil];
    [[NetManager sharedManager] accessService:requestDic data:nil command:DYNAMIC_ABOUTMEMSGLIST_MORE_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
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
    
    [_darkCircleDot removeFromSuperview];
    
    if (resultArray) {
        if (![[resultArray lastObject] isKindOfClass:[NSString class]]) {
            switch (commandid) {
                case DYNAMIC_ABOUTMEMSGLIST_COMMAND_ID:
                {
                    [_msgArr removeAllObjects];
                    [_msgArr addObjectsFromArray:resultArray];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        for (NSDictionary* dic in _msgArr) {
                            CGFloat height = 30 + [TQRichTextView getRechTextViewHeightWithText:[NSString stringWithFormat:@"   %@",[dic objectForKey:@"content"]] viewWidth:180 font:KQLboldSystemFont(15) lineSpacing:1.5];
                            [cellHeightArr addObject:[NSNumber numberWithFloat:height]];
                        }
                        
                        [self initTable];
                        if (_msgArr.count >= MAXCOUNT) {
                            _footerView.hidden = NO;
                        }
                        
                    });
                    
                }
                    break;
                case DYNAMIC_ABOUTMEMSGLIST_MORE_COMMAND_ID:
                {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_footerView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];


                        if (resultArray.count != 0) {
                            [cellHeightArr removeAllObjects];
                            
                            [_msgArr addObjectsFromArray:resultArray];
                            
                            for (NSDictionary* dic in _msgArr) {
                                CGFloat height = 30 + [TQRichTextView getRechTextViewHeightWithText:[dic objectForKey:@"content"] viewWidth:200 font:KQLboldSystemFont(15) lineSpacing:1.5];
                                [cellHeightArr addObject:[NSNumber numberWithFloat:height]];
                            }
                            
                            [_tableView reloadData];
                            
                            if (_msgArr.count >= MAXCOUNT) {
                                _footerView.hidden = NO;
                            }
                        }else{
                            [Common checkProgressHUD:@"没有更多了" andImage:nil showInView:self.view];
                        }
                        
                    });
                }
                    break;
                    
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
            
        }
    }
}

#pragma mark - commentDelegate
-(void) headViewTouch:(int)userId{
    MemberMainViewController* memberVC = [[MemberMainViewController alloc] init];
    memberVC.lookId = userId;
    if (memberVC.lookId == [[Global sharedGlobal].user_id longLongValue] ) {
        memberVC.accessType = AccessTypeSelf;
    }else{
        memberVC.accessType = AccessTypeLookOther;
    }
//    memberVC.accessType = AccessTypeLookOther;
    memberVC.pushType = PushTypesButtom;
    
    CRNavigationController * nav = [[CRNavigationController alloc]initWithRootViewController:memberVC];
    [self.navigationController presentModalViewController:nav animated:YES];
    RELEASE_SAFE(nav);
    RELEASE_SAFE(memberVC);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    RELEASE_SAFE(cellHeightArr);
    RELEASE_SAFE(_darkCircleDot);
    RELEASE_SAFE(progress);
    RELEASE_SAFE(_footerView);
    RELEASE_SAFE(_tableView);
    RELEASE_SAFE(_msgArr);
    [super dealloc];
}

@end
