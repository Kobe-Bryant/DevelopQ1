//
//  ToolsMainViewController.m
//  ql
//
//  Created by ChenFeng on 14-1-9.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "ToolsMainViewController.h"
#import "SidebarViewController.h"
#import "privilegeViewController.h"
#import "WarmTipsViewController.h"
#import "scanViewController.h"

#import "chooseOrg_model.h"
#import "tool_tools_model.h"

#import "UIImageView+WebCache.h"

#import "UIButton+WebCache.h"

#import "SessionViewController.h"
#import "browserViewController.h"
#import "toolupdatetime_list_model.h"
#import "config.h"

#import "Global.h"

#import "ThemeManager.h"

#import "NetManager.h"
#import "tool_plug_updatetime_model.h"

#define SECpromptText @"您想要什么工具呢 请在这里吩咐我吧"

#define NONETAG 1000

@interface ToolsMainViewController (){
    NSMutableArray* toolsArr;
    
    NSMutableArray *plugArr; //判断数据库里的时间和返回数据里时间是否相同，放到这个数组里面
    
    BOOL showScan;
    
    MBProgressHUD* mbProgressHUD;
    
}

@property(nonatomic,retain) UITableView* tableView;
@property(nonatomic,retain) UIScrollView* scrollView;

@end

@implementation ToolsMainViewController
@synthesize redPointShow;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        toolsArr = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redPointDisappear) name:@"toolsMainRedPoint" object:nil];
        
        plugArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)redPointDisappear {
    //特权
    UILabel *redLab = (UILabel *)[_scrollView viewWithTag:99];
    redLab.hidden = YES;
    //插入数据库
    toolupdatetime_list_model *toolMod = [[toolupdatetime_list_model alloc]init];
    [toolMod deleteDBdata];//先删除老数据
    for (int i = 0; i < toolsArr.count; i++) {
        NSDictionary *dic = [toolsArr objectAtIndex:i];
        if ([[dic objectForKey:@"plug_type"] intValue] == 2) {
            NSDictionary* update_timeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [dic objectForKey:@"plug_id"],@"plug_id",
                                            [dic objectForKey:@"plug_update_time"],@"plug_update_time",
                                            nil];
            [toolMod insertDB:update_timeDic];
        }
    }
    [toolMod release];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.title = @"商务助手";
    self.view.backgroundColor = COLOR_LIGHTWEIGHT;
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
//    初始化导航条
    [self initNavigationBarBtn];
//    初始化工具视图
    [self initScrollView];
//    请求商务工具数据
    [self accessToolsList];
    
}

//加载主视图
-(void) initScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 60 )];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
//    初始化底部小秘书
    [self initButtomView];
//    填充button
    [self addBtnInScroll];
}

//无数据页面
-(void) addNoneLabView{
    UILabel* noneLab = [[UILabel alloc] init];
    noneLab.tag = NONETAG;
    noneLab.text = @"组织暂未添加商务助手";
    noneLab.frame = CGRectMake(0, 0, self.view.bounds.size.width, _scrollView.bounds.size.height);
    noneLab.center = _scrollView.center;
    noneLab.textAlignment = NSTextAlignmentCenter;
    noneLab.textColor = [UIColor darkTextColor];
    [self.view addSubview:noneLab];
    [noneLab release];
}

//在滚动视图中填充部件
-(void) addBtnInScroll{
//    移除无数据页面
    UILabel* lab = (UILabel*)[self.view viewWithTag:NONETAG];
    if (lab == nil) {
        [lab removeFromSuperview];
    }
//    移除工具button
    for (UIView* v in _scrollView.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            [v removeFromSuperview];
        }
    }
    
    for (int i = 0;i < toolsArr.count;i++) {
        NSDictionary* dic = [toolsArr objectAtIndex:i];
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 2;
        //不同情况下布置
        
        int type = [[dic objectForKey:@"plug_type"] intValue];
        UIImage* placeHolderImg = nil;
        switch (type) {
            case 1:
                placeHolderImg = IMG(@"img_tool_scan");
                break;
            case 2:
                placeHolderImg = IMG(@"img_tool_peculiar");
                break;
            case 3:
                placeHolderImg = IMG(@"img_tool_default");
                break;
            default:
                break;
        }
        
        [btn setBackgroundImageWithURL:[NSURL URLWithString:[dic objectForKey:@"plug_image"]] forState:UIControlStateNormal placeholderImage:placeHolderImg];
        
        [btn setTitle:[dic objectForKey:@"plug_name"] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [btn addTarget:self action:@selector(toolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;

        int section = i/2;
        int row = i%2;
        btn.frame = CGRectMake((115 + 35)*row + 20, 15 + (90 + 25)*section, 132, 98);
        btn.tag = [[dic objectForKey:@"plug_type"] intValue];
        btn.tag = i;
        [_scrollView addSubview:btn];
        
        //特权
        if (type == 2) {
            UILabel *warnLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame) - 23, CGRectGetMinY(btn.frame) - 8, 28, 18)];
            warnLab.text = @"NEW";
            if (redPointShow ==TRUE) {
                warnLab.hidden = NO;
            }else {
                warnLab.hidden = YES;
            }
            warnLab.textAlignment = NSTextAlignmentCenter;
            warnLab.font = [UIFont boldSystemFontOfSize:11.0];
            warnLab.textColor = [UIColor whiteColor];
            warnLab.backgroundColor = [UIColor colorWithRed:153/255.0 green:37/255.0 blue:22/255.0 alpha:1];
            warnLab.tag = 99;
            warnLab.backgroundColor = [UIColor redColor];
            warnLab.layer.cornerRadius = 2.0;
            warnLab.layer.masksToBounds = YES;
            [_scrollView addSubview:warnLab];
            [warnLab release];
        }
        
        //插件
        if (type == 3) {
            UILabel *warnLab3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame) - 23, CGRectGetMinY(btn.frame) - 8, 28, 18)];
            warnLab3.text = @"NEW";
            warnLab3.hidden = YES;
            warnLab3.textAlignment = NSTextAlignmentCenter;
            warnLab3.font = [UIFont boldSystemFontOfSize:11.0];
            warnLab3.textColor = [UIColor whiteColor];
            warnLab3.backgroundColor = [UIColor colorWithRed:153/255.0 green:37/255.0 blue:22/255.0 alpha:1];
            warnLab3.tag = i + 100;
            warnLab3.backgroundColor = [UIColor redColor];
            warnLab3.layer.cornerRadius = 2.0;
            warnLab3.layer.masksToBounds = YES;
            
            tool_plug_updatetime_model *plug_model = [[tool_plug_updatetime_model alloc]init];
            NSArray *arr = [plug_model getList];
            NSDictionary *isReadDic = [arr objectAtIndex:i];
            if ([[isReadDic objectForKey:@"isRead"] isEqualToString:@"0"]) {
                warnLab3.hidden = NO;
            }else {
                warnLab3.hidden = YES;
            }
            
            [_scrollView addSubview:warnLab3];
            [warnLab3 release];
  
        }
        
    }
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 160*(toolsArr.count/2)>(self.view.bounds.size.height - 64 - 60)?160*(toolsArr.count/2):(self.view.bounds.size.height - 64 - 60));
}

-(void) initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self initButtomView];
}
//初始化小秘书
-(void) initButtomView{
    UIView* btmView = [[UIView alloc] init];
    if (IOS_VERSION_7) {
        btmView.frame = CGRectMake(20, self.view.bounds.size.height - 64 - 60 - 20, self.view.bounds.size.width - 20*2, 60);
    }else {
        btmView.frame = CGRectMake(20, self.view.bounds.size.height - 64 - 60 , self.view.bounds.size.width - 20*2, 60);
    }
    
    btmView.backgroundColor = [UIColor clearColor];
    btmView.layer.borderColor = [UIColor whiteColor].CGColor;
    btmView.layer.borderWidth = 1.0;
    btmView.layer.cornerRadius = btmView.bounds.size.height/2;
    btmView.clipsToBounds = YES;
    btmView.backgroundColor = [UIColor colorWithRed:149/255.0 green:178/255.0 blue:188/255.0 alpha:1.0];
    [self.view addSubview:btmView];
    
    UIImageView* secImagev = [[UIImageView alloc] init];
    secImagev.frame = CGRectMake(5, 5, btmView.bounds.size.height - 5*2, btmView.bounds.size.height - 5*2);
    [secImagev setImageWithURL:[NSURL URLWithString:[[Global sharedGlobal].secretInfo objectForKey:@"portrait"]] placeholderImage:IMG(@"kf.jpg")];
    secImagev.layer.cornerRadius = secImagev.bounds.size.height/2;
    secImagev.clipsToBounds = YES;
    [btmView addSubview:secImagev];
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(secImagev.frame) + 10, 5, btmView.bounds.size.width - 60 - 30 - 10, btmView.bounds.size.height - 5*2)];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = SECpromptText;
    lab.font = KQLboldSystemFont(14);
    lab.textColor = [UIColor darkGrayColor];
    lab.numberOfLines = 2;
    lab.lineBreakMode = UILineBreakModeWordWrap;
    [btmView addSubview:lab];
    
    [lab release];
    
    UITapGestureRecognizer* tapOnBtm = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTips)];
    [btmView addGestureRecognizer:tapOnBtm];
    [tapOnBtm release];
    
    [secImagev release];
    [btmView release];
}

//跳转小秘书
-(void) showTips{
    WarmTipsViewController* tipsVC = [[WarmTipsViewController alloc] init];
    tipsVC.tipsString = SECpromptText;
    tipsVC.ttype = PriTips;
    [self.navigationController pushViewController:tipsVC animated:YES];
    RELEASE_SAFE(tipsVC);//add vincent
    
}

/**
 *  实例化导航栏按钮
 */
- (void)initNavigationBarBtn{
    //返回按钮
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [[ThemeManager shareInstance] getThemeImage:@"ico_common_header.png"];
    [backButton setImage:image forState:UIControlStateNormal];
    backButton.frame = CGRectMake(20 , 30, 44.f, 44.f);
    if (IOS_VERSION_7) {
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    }
    UIBarButtonItem  *backItem = [[UIBarButtonItem  alloc]  initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    RELEASE_SAFE(backItem);
    
}

#pragma mark - event Method
/**
 *  返回事件
 */
- (void)backTo{
    if (![[SidebarViewController share]sideBarShowing]) {
        [[SidebarViewController share]moveAnimationWithDirection:SideBarShowDirectionLeft duration:0.15];
    }else{
        [[SidebarViewController share]moveAnimationWithDirection:SideBarShowDirectionNone duration:0.15];
    }
}

#pragma mark - tableview

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return toolsArr.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = @"toolCell";
    UITableViewCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView* bgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, self.view.bounds.size.width - 5*2, 110 - 10)];
        bgV.tag = 2000 + indexPath.row;
        [cell.contentView addSubview:bgV];
        [bgV release];
        
        UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, self.view.bounds.size.width - 5*2, 110 - 10)];
        lab.backgroundColor = [UIColor clearColor];
        lab.tag = 1000 + indexPath.row;
        lab.font = KQLboldSystemFont(20);
        lab.textAlignment = UITextAlignmentCenter;
        lab.textColor = [UIColor whiteColor];
        lab.numberOfLines = 0;
        lab.lineBreakMode = UILineBreakModeWordWrap;
        [cell.contentView addSubview:lab];
        
        RELEASE_SAFE(lab);
        
    }
    
    NSDictionary* dic = [toolsArr objectAtIndex:indexPath.row];
    
    UILabel* lab = (UILabel*)[cell.contentView viewWithTag:(1000 + indexPath.row)];
    
    lab.text = [dic objectForKey:@"tool_name"];
    
    UIImageView* imgv = (UIImageView*)[cell.contentView viewWithTag:(2000 + indexPath.row)];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShowScan"]) {
        if (toolsArr.count == 1) {
            imgv.image = IMG(@"img_tool_scan");
        }else{
            if (indexPath.row == toolsArr.count - 1) {
                imgv.image = IMG(@"img_tool_scan");
            }else{
                [imgv setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"tool_image"]] placeholderImage:IMG(@"img_tool_peculiar")];
            }
        }
    }else{
        [imgv setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"tool_image"]] placeholderImage:IMG(@"img_tool_peculiar")];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"++tool:%d++",indexPath.row);
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShowScan"]) {
        if (toolsArr.count == 1) {
            scanViewController *scanView = [[scanViewController alloc]init];
            [self.navigationController pushViewController:scanView animated:YES];
            RELEASE_SAFE(scanView);
        }else{
            if (indexPath.row == toolsArr.count - 1) {
                scanViewController *scanView = [[scanViewController alloc]init];
                [self.navigationController pushViewController:scanView animated:YES];
                RELEASE_SAFE(scanView);
                
            }else{
                privilegeViewController* privilegeVC = [[privilegeViewController alloc] init];
                privilegeVC.titleStr = [[toolsArr objectAtIndex:indexPath.row] objectForKey:@"tool_name"];
                [self.navigationController pushViewController:privilegeVC animated:YES];
                RELEASE_SAFE(privilegeVC);
            }
        }
    }else{
        privilegeViewController* privilegeVC = [[privilegeViewController alloc] init];
        privilegeVC.titleStr = [[toolsArr objectAtIndex:indexPath.row] objectForKey:@"tool_name"];
        [self.navigationController pushViewController:privilegeVC animated:YES];
        RELEASE_SAFE(privilegeVC);
    }
    
}

#pragma mark - buttonClick
-(void) toolBtnClick:(UIButton*) sender{
    
    NSDictionary* dic = [toolsArr objectAtIndex:sender.tag];
    int type = [[dic objectForKey:@"plug_type"] intValue];
    switch (type) {
        case 1:
        {
            //扫一扫
            BOOL canShowCamera;
            if (IOS_VERSION_7) {
                canShowCamera = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            }else{
                canShowCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
            }
            if (canShowCamera) {
                scanViewController *scanView = [[scanViewController alloc]init];
                [self.navigationController pushViewController:scanView animated:YES];
                RELEASE_SAFE(scanView);
            }else{
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"未允许使用相机" message:@"请在“设置”->“隐私”->“相机”中确认“云圈”是否为开启状态！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
            
        }
            break;
        case 2:
        {
            [self redPointDisappear]; //点击红点消失
            privilegeViewController* privilegeVC = [[privilegeViewController alloc] init];
            privilegeVC.titleStr = [dic objectForKey:@"plug_name"];
            [self.navigationController pushViewController:privilegeVC animated:YES];
            RELEASE_SAFE(privilegeVC);

        }
            break;
        case 3:
        {
            //插件
            UILabel *warn3 = (UILabel *)[self.view viewWithTag:100 + sender.tag];
            warn3.hidden = YES;
            
            //把最新的更新时间插入到数据库
            tool_plug_updatetime_model *plug_model = [[tool_plug_updatetime_model alloc]init];
            NSDictionary *idDic = [toolsArr objectAtIndex:sender.tag];
            
            NSDictionary* updatetimeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [idDic objectForKey:@"plug_id"],@"plug_id",
                                           [idDic objectForKey:@"plug_update_time"],@"plug_update_time",
                                           [NSString stringWithFormat:@"1"],@"isRead",
                                           nil];
            plug_model.where = [NSString stringWithFormat:@"plug_id = %ld",(long)[[idDic objectForKey:@"plug_id"] integerValue]];
            [plug_model updateDB:updatetimeDic];
            [plug_model release];
            
            browserViewController* browserVC = [[browserViewController alloc] init];
            browserVC.url = [NSString stringWithFormat:@"%@?user_id=%lld&org_id=%lld",[dic objectForKey:@"plug_url"],[[Global sharedGlobal].user_id longLongValue],[[Global sharedGlobal].org_id longLongValue]];
//            browserVC.url = [NSString stringWithFormat:@"http://192.168.1.148/wkplug/tpl/index?user_id=497"];
            browserVC.webTitle = [dic objectForKey:@"plug_name"];
            [self.navigationController pushViewController:browserVC animated:YES];
            RELEASE_SAFE(browserVC);
        }
            break;
        default:
            break;
    }
    
    //最后一个红点消失，通知侧边栏页面红点也消失
    tool_plug_updatetime_model *plug_model = [[tool_plug_updatetime_model alloc]init];
    plug_model.where = [NSString stringWithFormat:@"isRead = 0"];
    NSArray *isReadArr = [plug_model getList];
    if ((![isReadArr count]) && redPointShow == FALSE) {
        //上一页不显示小红点
        [[NSNotificationCenter defaultCenter] postNotificationName:@"toolsMainRedPoint" object:self userInfo:nil];
    }
    
}

//请求商务工具数据
-(void) accessToolsList{
    [self showProgressHud];
    
    NSString* reqUrl = @"member/tool.do?param=";
    NSMutableDictionary* requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                       nil];
    [[NetManager sharedManager] accessService:requestDic data:nil command:TOOL_LIST_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
}

//网络请求回调
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
    [self removeProgressHud];
    
    if (![[resultArray firstObject] isKindOfClass:[NSString class]]) {
        switch (commandid) {
            case TOOL_LIST_COMMAND_ID:
            {
                //----------------------组织特权更新时间表-------------------------------
                toolupdatetime_list_model *toolMod = [[toolupdatetime_list_model alloc]init];
                
                NSArray* toolModArr = [toolMod getList];
                if (toolModArr.count == 0) {
                    //不显示红点
                    redPointShow = FALSE;
                }else{
                    for (NSDictionary* dic in resultArray) {
                        if ([[dic objectForKey:@"plug_type"] intValue] == 2){
                        NSString *plug_update_time = [[dic objectForKey:@"plug_update_time"] stringValue];
                        NSString* plug_idStr = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"plug_id"] intValue]];
                        
                        toolMod.where = [NSString stringWithFormat:@"plug_id = %@ and plug_update_time = %@",plug_idStr,plug_update_time];
                        NSArray* updateTimeArr = [toolMod getList];
                        if (updateTimeArr.count == 0) {
                            //显示红点
                            redPointShow = TRUE;
                        }else{
                            // 不显示红点
                            redPointShow = FALSE;
                        }
                      }
                    }
                }
                
                //---------------------------组织插件更新时间---------------------------------------
                tool_plug_updatetime_model *plug_model = [[tool_plug_updatetime_model alloc]init];
                for (NSDictionary *plugDic in resultArray) {
                    if ([[plugDic objectForKey:@"plug_type"] intValue] == 3){
                       NSDictionary* updatetimeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [plugDic objectForKey:@"plug_id"],@"plug_id",
                                                   [plugDic objectForKey:@"plug_update_time"],@"plug_update_time",
                                                   [NSString stringWithFormat:@"0"],@"isRead",
                                                   nil];
                      //0 表示未读 1表示已读。
                        NSInteger idInt = [[plugDic objectForKey:@"plug_id"] integerValue];
                        NSString *update_timeStr = [plugDic objectForKey:@"plug_update_time"];
                        plug_model.where = [NSString stringWithFormat:@"plug_id = %ld and plug_update_time = %@",(long)idInt,update_timeStr];
                        NSArray *insertArray = [plug_model getList];
                        if (insertArray && [insertArray count]) {
                          
                        } else {
                      //是新数据则插入表中 （只对最新的（id不同）数据处理了）
                           [plug_model insertDB:updatetimeDic];
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"toolsMainRedPointAppear" object:self userInfo:nil];
                        }
                    }
                    
                }
                //删除条件
                NSString* deleteWhere = nil;
                
                //删除不是最新的数据
                for (NSDictionary* dic in resultArray) {
                    if (deleteWhere == nil) {
                        deleteWhere = [NSString stringWithFormat:@"plug_id != %d",[[dic objectForKey:@"plug_id"] intValue]];
                    }else{
                        deleteWhere = [deleteWhere stringByAppendingFormat:@" and plug_id != %d",[[dic objectForKey:@"plug_id"] intValue]];
                    }
                }
                plug_model.where = deleteWhere;
                [plug_model deleteDBdata];
                
                [plug_model release];
                
                
                [toolsArr removeAllObjects];
                [toolsArr addObjectsFromArray:resultArray];
                
               // 无数据时，展示空页面
                if (toolsArr.count == 0) {
                    [self addNoneLabView];
                }
                // 填充数据
                [self addBtnInScroll];
                
            }
                break;
            default:
                break;
        }
        
    }else{
        [Common checkProgressHUD:@"网络连接失败" andImage:nil showInView:self.view];
    }
}

//指示框
-(void) showProgressHud{
    if (mbProgressHUD == nil) {
        mbProgressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        mbProgressHUD.labelText = @"云端同步中";
        mbProgressHUD.mode = MBProgressHUDModeCustomView;
        [self.view addSubview:mbProgressHUD];
    }
    
    [mbProgressHUD show:YES];
}

- (void)removeProgressHud{
    [mbProgressHUD hide:YES];
    [mbProgressHUD removeFromSuperViewOnHide];
}

-(void) dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [mbProgressHUD release];
    RELEASE_SAFE(_scrollView);
    RELEASE_SAFE(toolsArr);
    RELEASE_SAFE(plugArr);
    [_tableView release];
    [super dealloc];
}

@end
