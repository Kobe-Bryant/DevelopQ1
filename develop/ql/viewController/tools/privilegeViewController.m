//
//  privilegeViewController.m
//  ql
//
//  Created by yunlai on 14-4-22.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "privilegeViewController.h"
#import "Common.h"

#import "priDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "WarmTipsViewController.h"
#import "tool_privilege_model.h"
#import "SessionViewController.h"
#import "tool_privilege_updatetime_model.h"

@interface privilegeViewController (){
//    背景图组
    NSArray* secImgArr;
//    标签图组
    NSArray* tagArr;
//    特权对象组
    NSMutableArray* priArr;
    
}

@property(nonatomic,retain) UITableView* tableView;
@property(nonatomic,retain) UIImageView* bgImgV;

@end

@implementation privilegeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        priArr = [[NSMutableArray alloc] init];
        
        secImgArr = [[NSArray alloc] initWithObjects:
                     @"bg_tool_blue",
                     @"bg_tool_orange",
                     @"bg_tool_oray",
                     nil];
        tagArr = [[NSArray alloc] initWithObjects:
                     @"ico_tool_discount",
                     @"img_tool_free",
                     @"ico_tool_card",
                     nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = _titleStr;
    self.view.backgroundColor = COLOR_LIGHTWEIGHT;
    
    [self backBar];
    
    tool_privilege_model* priMod = [[tool_privilege_model alloc] init];
    [priArr addObjectsFromArray:[priMod getList]];
    [priMod release];
//    初始化主视图
    [self initMain];
//    请求特权
    [self accessPrivilegeList];
    
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

-(void) initMain{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, KUIScreenHeight - 144 ) style:UITableViewStylePlain];
    _tableView.backgroundColor = COLOR_LIGHTWEIGHT;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIView* headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];

    _bgImgV = [[UIImageView alloc] init];
    NSString* imagePath = [[NSUserDefaults standardUserDefaults] objectForKey:@"privilegeBigImageBG"];
    if (imagePath.length != 0) {
        [_bgImgV setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:IMG(@"default_600")];
    }
    
    _bgImgV.frame = CGRectMake(0, 0, headV.bounds.size.width, headV.bounds.size.height);
    [headV addSubview:_bgImgV];
    
    UIImageView* userImgV = [[UIImageView alloc] init];
    [userImgV setImageWithURL:[NSURL URLWithString:[[Global sharedGlobal].userInfo objectForKey:@"portrait"]] placeholderImage:IMG(DEFAULT_MALE_PORTRAIT_NAME)];
    userImgV.frame = CGRectMake(15, headV.bounds.size.height - 25 - 50, 50, 50);
    userImgV.layer.cornerRadius = userImgV.bounds.size.height/2;
    [userImgV.layer setMasksToBounds:YES];
    [headV addSubview:userImgV];
    
    UILabel* nameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImgV.frame) + 15, CGRectGetMinY(userImgV.frame) + 10, 100, 15)];
    nameLab.text = [[Global sharedGlobal].userInfo objectForKey:@"realname"];
    nameLab.textColor = [UIColor blackColor];
    nameLab.textAlignment = UITextAlignmentLeft;
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.font = KQLboldSystemFont(14);
    [headV addSubview:nameLab];
    
    UILabel* positionLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImgV.frame) + 15, CGRectGetMaxY(nameLab.frame), 100, 15)];
    positionLab.text = [[Global sharedGlobal].userInfo objectForKey:@"role"];
    positionLab.textColor = [UIColor blackColor];
    positionLab.textAlignment = UITextAlignmentLeft;
    positionLab.backgroundColor = [UIColor clearColor];
    positionLab.font = KQLboldSystemFont(14);
    [headV addSubview:positionLab];
    
    RELEASE_SAFE(positionLab);
    RELEASE_SAFE(nameLab);
    RELEASE_SAFE(userImgV);
    
    _tableView.tableHeaderView = headV;
    RELEASE_SAFE(headV);
    
    
    UIView* btmView = [[UIView alloc] init];
    if (IOS_VERSION_7) {
        btmView.frame = CGRectMake(20, self.view.bounds.size.height - 64 - 60 - 20, self.view.bounds.size.width - 20*2, 60);
    } else {
        btmView.frame = CGRectMake(20, self.view.bounds.size.height - 64 - 60, self.view.bounds.size.width - 20*2, 60);
    }
    
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
    lab.text = @"还想要什么特权？吩咐小秘书";
    lab.font = KQLboldSystemFont(14);
    lab.textColor = [UIColor darkGrayColor];
    lab.numberOfLines = 2;
    lab.lineBreakMode = UILineBreakModeWordWrap;
    [btmView addSubview:lab];
    
    [lab release];
    
    UITapGestureRecognizer* tapOnBtm = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SECClick)];
    [btmView addGestureRecognizer:tapOnBtm];
    [tapOnBtm release];
    
    [secImagev release];
    [btmView release];
    
}
#pragma mark - 小秘书
//小秘书
-(void) SECClick{
    WarmTipsViewController* tipsVC = [[WarmTipsViewController alloc] init];
    tipsVC.ttype = ToolTips;
    tipsVC.tipsString = @"还想要什么特权？吩咐小秘书";
    [self.navigationController pushViewController:tipsVC animated:YES];
    [tipsVC release];
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return priArr.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = @"Pcell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        UIImageView* bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
        UIImage* img = IMG(@"img_tool_shadow");
        bgV.image = [img stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        cell.backgroundView = bgV;
        RELEASE_SAFE(bgV);
        
        UIImageView* secImgV = [[UIImageView alloc] init];
        if (IOS_VERSION_7) {
            secImgV.frame = CGRectMake(10, 15, 300, 45);
        }else{
            secImgV.frame = CGRectMake(0, 15, 300, 45);
        }
        secImgV.tag = 1000;
        [cell.contentView addSubview:secImgV];
        
        UIImageView* tagV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(secImgV.frame) + 5, CGRectGetMinY(secImgV.frame) + 5, 35, 35)];
        tagV.tag = 2000;
        [cell.contentView addSubview:tagV];
        
        UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tagV.frame) + 5, CGRectGetMinY(tagV.frame), secImgV.bounds.size.width - 60, tagV.bounds.size.height)];
        lab.font = KQLboldSystemFont(15);
        lab.textColor = [UIColor whiteColor];
        lab.backgroundColor = [UIColor clearColor];
        lab.tag = 3000;
        [cell.contentView addSubview:lab];
        
        //访客红点提示
        UILabel *redPoint = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        redPoint.text = @"●";
        redPoint.hidden = YES;
        redPoint.textColor = [UIColor redColor];
        redPoint.tag = 4000;
        redPoint.font = KQLSystemFont(20);
        redPoint.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:redPoint];
        
        RELEASE_SAFE(lab);
        RELEASE_SAFE(tagV);
        RELEASE_SAFE(bgV);
        RELEASE_SAFE(redPoint);
        RELEASE_SAFE(secImgV);
        
    }
    
    NSDictionary* dic = [priArr objectAtIndex:indexPath.row];
    
    UILabel* lab = (UILabel*)[cell.contentView viewWithTag:3000];
    lab.text = [dic objectForKey:@"title"];
    
    UILabel *redPointLab = (UILabel *)[cell.contentView viewWithTag:4000];
    tool_privilege_updatetime_model *tool_updateMod = [[tool_privilege_updatetime_model alloc]init];
    NSArray *arr = [tool_updateMod getList];
    NSDictionary *isReadDic = [arr objectAtIndex:indexPath.row];
    if ([[isReadDic objectForKey:@"isRead"] isEqualToString:@"0"]) {
        redPointLab.hidden = NO;
    }else {
        redPointLab.hidden = YES;
    }
    
    UIImageView* secImgv = (UIImageView*)[cell.contentView viewWithTag:1000];
    secImgv.image = IMG(secImgArr[indexPath.row%3]);
    
    UIImageView* tagv = (UIImageView*)[cell.contentView viewWithTag:2000];
    tagv.image = IMG(tagArr[indexPath.row%3]);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [tool_updateMod release];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //点击则将红点消失
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *redLab = (UILabel *)[cell viewWithTag:4000];
    redLab.hidden = YES;
    
    //把最新的更新时间插入到数据库
    NSDictionary* dic = [priArr objectAtIndex:indexPath.row];
    NSInteger update_id = [[dic objectForKey:@"id"] intValue];
    tool_privilege_updatetime_model *tool_updateMod = [[tool_privilege_updatetime_model alloc]init];
    NSDictionary* updatetimeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [dic objectForKey:@"id"],@"id",
                                   [dic objectForKey:@"update_time"],@"update_time",
                                   [NSString stringWithFormat:@"1"],@"isRead",
                                   nil];
    tool_updateMod.where = [NSString stringWithFormat:@"id = %d",update_id];
    [tool_updateMod updateDB:updatetimeDic];
    
    
    tool_updateMod.where = [NSString stringWithFormat:@"isRead = 0"];
    NSArray *isReadArr = [tool_updateMod getList];
    if (![isReadArr count]) {
        
        //上一页显示小红点
        [[NSNotificationCenter defaultCenter] postNotificationName:@"toolsMainRedPoint" object:self userInfo:nil];
    }
    
    
    [tool_updateMod release];
//    //把最新的更新时间插入到数据库
//    NSDictionary* dic = [priArr objectAtIndex:indexPath.row];
//    NSInteger update_id = [[dic objectForKey:@"id"] intValue];
//    tool_privilege_updatetime_model *tool_updateMod = [[tool_privilege_updatetime_model alloc]init];
//    NSDictionary* updatetimeDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   [dic objectForKey:@"id"],@"id",
//                                   [dic objectForKey:@"update_time"],@"update_time",
//                                   [NSString stringWithFormat:@"1"],@"isRead",
//                                   nil];
//    tool_updateMod.where = [NSString stringWithFormat:@"id = %d",update_id];
//    [tool_updateMod updateDB:updatetimeDic];
//    
//    
//    tool_updateMod.where = [NSString stringWithFormat:@"isRead = 0"];
//    NSArray *isReadArr = [tool_updateMod getList];
//    if (![isReadArr count]) {
//        //上一页不显示小红点
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"toolsMainRedPoint" object:self userInfo:nil];
//    }
//    
//    [tool_updateMod release];
    
    priDetailViewController* detailV = [[priDetailViewController alloc] init];
    detailV.pdDataDic = dic;
    detailV.titleStr = _titleStr;
    [self.navigationController pushViewController:detailV animated:YES];
    [detailV release];
}

//请求特权
-(void) accessPrivilegeList{
    NSString* reqUrl = @"privilegelist.do?param=";
    
    NSMutableDictionary* requestDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                    [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                                    
                                                    nil];;
    
    [[NetManager sharedManager] accessService:requestDic data:nil command:TOOL_PRIVILEGELIST_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
    
    RELEASE_SAFE(requestDic);//add vincent
}

//请求回调
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
    NSLog(@"==resultArray:%@==",resultArray);
    if (resultArray && ![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        
        switch (commandid) {
            case TOOL_PRIVILEGELIST_COMMAND_ID:
            {
                tool_privilege_updatetime_model *tool_updateMod = [[tool_privilege_updatetime_model alloc]init];
                for (NSDictionary *dic in resultArray) {
                    NSDictionary* updatetimeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [dic objectForKey:@"id"],@"id",
                                                   [dic objectForKey:@"update_time"],@"update_time",
                                                   [NSString stringWithFormat:@"0"],@"isRead",
                                                   nil];
                    //0 表示未读 1表示已读。
                    [tool_updateMod insertDB:updatetimeDic];
                }
                [tool_updateMod release];
                
                //do something
                [priArr removeAllObjects];
                [priArr addObjectsFromArray:resultArray];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (![resultArray count]) {
                        //返回新特权为0
                        
                    }else{
                        tool_privilege_updatetime_model *tool_updateMod = [[tool_privilege_updatetime_model alloc]init];
                        for (NSDictionary *dic in resultArray) {
                            
                            NSDictionary* updatetimeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [dic objectForKey:@"id"],@"id",
                                                           [dic objectForKey:@"update_time"],@"update_time",
                                                           [NSString stringWithFormat:@"0"],@"isRead",
                                                           nil];
                            //0 表示未读 1表示已读。
                            NSInteger idInt = [[dic objectForKey:@"id"] integerValue];
                            NSString *update_timeStr = [dic objectForKey:@"update_time"];
                            
                            tool_updateMod.where = [NSString stringWithFormat:@"id = %d and update_time = %@",idInt,update_timeStr];
                            NSArray *array = [tool_updateMod getList];
                            if (array && [array count]) {
                                //数据没有更新不做处理（这里没有对id相同 update_time不同数据做处理）
                            } else {
                                //是新数据则插入表中 （只对最新的（id不同）数据处理了）
                                [tool_updateMod insertDB:updatetimeDic];
                            }
                        }
                        [tool_updateMod release];
                        
                        //do something
                        [priArr removeAllObjects];
                        [priArr addObjectsFromArray:resultArray];
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            NSString* imagePath = [[NSUserDefaults standardUserDefaults] objectForKey:@"privilegeBigImageBG"];
                            if (imagePath.length != 0) {
                                [_bgImgV setImageWithURL:[NSURL URLWithString:imagePath]];
                            }
                            
                            [_tableView reloadData];
                        });
                    }
                });
                
            }
                break;
                
            default:
                break;
        }
    }else{
        [Common checkProgressHUD:@"数据异常" andImage:nil showInView:self.view];
    }
}

-(void) backTo{
    //点击则将红点消失
    UILabel *redLab = (UILabel *)[self.view viewWithTag:4000];
    redLab.hidden = YES;
    
    //把最新的更新时间插入到数据库
    tool_privilege_updatetime_model *tool_updateMod = [[tool_privilege_updatetime_model alloc]init];
    
    [tool_updateMod deleteDBdata];
    
    for (NSDictionary *dic in priArr) {
        NSDictionary* updatetimeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [dic objectForKey:@"id"],@"id",
                                       [dic objectForKey:@"update_time"],@"update_time",
                                       [NSString stringWithFormat:@"1"],@"isRead",
                                       nil];
        [tool_updateMod insertDB:updatetimeDic];
    }
    [tool_updateMod release];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) dealloc{
    [_bgImgV release];
    [priArr release];
    [tagArr release];
    [secImgArr release];
    [_tableView release];
    [super dealloc];
}

@end
