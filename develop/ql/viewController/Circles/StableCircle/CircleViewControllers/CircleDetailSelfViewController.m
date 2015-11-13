//
//  CircleDetailSelfViewController.m
//  ql
//
//  Created by yunlai on 14-7-12.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "CircleDetailSelfViewController.h"

@interface CircleDetailSelfViewController ()

@property(nonatomic,retain) UILabel* circleNameLab;
@property(nonatomic,retain) UILabel* circleIntroLab;

@end

@implementation CircleDetailSelfViewController

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
    
    self.title = @"圈子详情";
    
	// Do any additional setup after loading the view.
    //退出圈子成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitCircleNotify:) name:KNotiQuitCircle object:nil];
    
//    加载开始聊天按钮
    [self createSessionBtn];
}

-(void) createSessionBtn{
    UIButton* btmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    btmBtn.backgroundColor = [UIColor whiteColor];
    if (IOS_VERSION_7) {
       btmBtn.frame = CGRectMake(0, self.view.bounds.size.height - 60 - 64, self.view.bounds.size.width, 60);
    }else {
       btmBtn.frame = CGRectMake(0, self.view.bounds.size.height - 60 - 64 + 20, self.view.bounds.size.width, 60);
    }
   
    [btmBtn setTitle:@"开始聊天" forState:UIControlStateNormal];
    [btmBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"] forState:UIControlStateNormal];
    [btmBtn addTarget:self action:@selector(turnToCircleListView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btmBtn];
}

//跳转到开始聊天
-(void) turnToCircleListView{
    //开始聊天
    // 取出圈子成员中前三个人的头像
    int circle_id = [[self.detailDic objectForKey:@"circle_id"]intValue];
    circle_member_list_model * cmListGeter = [circle_member_list_model new];
    cmListGeter.where = [NSString stringWithFormat:@"circle_id = %d order by created asc",circle_id];
    NSArray * cmlist = [cmListGeter getList];
    NSMutableArray * porMuArr = [NSMutableArray new];
    
    if (cmlist.count > 0) {
        for (int i = 0; i < cmlist.count; i ++) {
            if (i > 2) {
                break;
            }
            NSDictionary * dic = [cmlist objectAtIndex:i];
            [porMuArr addObject:[dic objectForKey:@"portrait"]];
        }
    }
    
    NSString *porArrJson = [porMuArr JSONRepresentation];
    RELEASE_SAFE(porMuArr);
    RELEASE_SAFE(cmListGeter);
    
    // 插入会话列表
    chatmsg_list_model *cListGeter = [[chatmsg_list_model alloc]init];
    NSString *whereStr = [NSString stringWithFormat:@"id = %d and talk_type = %d",circle_id,MessageListTypeCircle];
    cListGeter.where =whereStr;
    NSTimeInterval creatTime = [[NSDate date]timeIntervalSince1970];
    NSArray * clist = [cListGeter getList];
    
    TextData *tData = [[TextData alloc]init];
    NSString *dataJson = [NSString getStrWithMessageDatas:tData,nil];
    RELEASE_SAFE(tData);//add vincent
    
    
    if (clist.count == 0) {
        
        NSDictionary * insertDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:circle_id],@"id",
                                    [NSNumber numberWithInt:MessageListTypeCircle],@"talk_type",
                                    porArrJson,@"icon_path",
                                    [self.detailDic objectForKey:@"name"],@"title",
                                    [NSNumber numberWithInt:creatTime],@"send_time",
                                    dataJson,@"content",
                                    nil];
        [cListGeter insertDB:insertDic];
    }
    RELEASE_SAFE(cListGeter);
    
    NSString * portraitStr = @"ico_group_circle.png";
    NSArray * portraitArr = [NSArray arrayWithObjects:portraitStr,nil];
    NSNumber * user_id = [NSNumber numberWithInt:[[[Global sharedGlobal]user_id]intValue]
                          ];
    NSDictionary * getDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:circle_id],@"sender_id",
                             [NSNumber numberWithInt:0],@"messageSum",
                             [self.detailDic objectForKey:@"name"],@"name",
                             [NSNumber numberWithInt:creatTime],@"time",
                             @"",@"message",
                             portraitArr,@"portrait",
                             [NSNumber numberWithInt:MessageListTypeCircle],@"talk_type",
                             user_id,@"speaker_id",nil];
    
    SessionViewController * cirSession = [[SessionViewController alloc]init];
    cirSession.selectedDic = getDic;
    cirSession.circleContactsList = [self.memberArr mutableCopy];
    
    [self.navigationController pushViewController:cirSession animated:YES];
    RELEASE_SAFE(cirSession);
}

#pragma mark - tableviewdelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            static NSString *DetailCell = @"topCell";
            CircleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailCell];
            if (nil == cell) {
                cell = [[[CircleDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailCell]autorelease];
                cell.backgroundView = [[[UIView alloc]initWithFrame:cell.bounds] autorelease];
                cell.backgroundView.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                if (indexPath.row == 2) {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            }
            
            if (indexPath.row == 0) {
                cell.qTextLabel.text = @"圈子名称";
                cell.qValueLabel.text = [self.detailDic objectForKey:@"name"];
                self.circleNameLab = cell.qValueLabel;
                [cell setCellType:CellTypeLabel];
                
            }else if (indexPath.row == 1){
                
                cell.qTextLabel.text = @"介绍";
                cell.qValueLabel.text =  [self.detailDic objectForKey:@"content"];
                
                NSString* introduceStr = [self.detailDic objectForKey:@"content"];
                CGSize size = [introduceStr sizeWithFont:KQLSystemFont(15) constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                cell.qValueLabel.frame = CGRectMake(cell.qValueLabel.frame.origin.x, 5.0,cell.qValueLabel.frame.size.width, size.height > 30.0?size.height + 30 : 30.0);
                cell.qValueLabel.textAlignment = NSTextAlignmentLeft;
                
                if (size.width < 200) {
                    cell.qValueLabel.textAlignment = NSTextAlignmentRight;
                }
                
                if (size.height > 30.0) {
                    cell.qTextLabel.frame = CGRectMake(cell.qTextLabel.frame.origin.x, 5.0, 100, cell.qValueLabel.frame.size.height + 15);
                }
                
                self.circleIntroLab = cell.qValueLabel;
                [cell setCellType:CellTypeLabel];
                
            }
            else if (indexPath.row == 2){
                
                cell.qTextLabel.text = @"创建人";
                
                cell.qValueLabel.text = [self.detailDic objectForKey:@"creater_name"];
                
                [cell setCellType:CellTypeLabel];
                
            }else{
                
                cell.qTextLabel.text = @"二维码";
                cell.qIconImage.image = IMGREADFILE(@"icon_code_default.png");
                [cell setCellType:CellTypeImageView];
            }
            
            return cell;
        }
            break;
        case 1:
        {
            static NSString *midCell = @"midCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:midCell];
            if (nil == cell) {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:midCell]autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.backgroundView = [[[UIView alloc]initWithFrame:cell.bounds] autorelease];
                cell.backgroundView.backgroundColor = [UIColor whiteColor];
                if(IOS_VERSION_7){
                    [self.tableview setSeparatorInset:UIEdgeInsetsZero];
                }
                UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, 1.f)];
                line.backgroundColor = RGBACOLOR(242, 244, 246, 1);
                [cell addSubview:line];
                RELEASE_SAFE(line);
            }
            switch (indexPath.row) {
                case 0:
                {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    for (int i = 0; i<self.memberArr.count; i++) {
                        if (i >= 4) {
                            break;
                        }
                        
                        NSDictionary* dic = self.memberArr[i];
                        UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(10.f + 60*i, 10.f, 50.f, 50.f)];
                        [headView setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"portrait"]] placeholderImage:IMG(DEFAULT_MALE_PORTRAIT_NAME)];
                        headView.layer.cornerRadius = 25;
                        headView.clipsToBounds = YES;
                        [cell.contentView addSubview:headView];
                        RELEASE_SAFE(headView); //add vincent
                    }
                    
                }
                    break;
                case 1:
                {
                    cell.textLabel.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    cell.textLabel.font = KQLSystemFont(15);
                    
                    if (self.memberArr.count >= 50) {
                        cell.textLabel.text = @"成员已满";
                        cell.userInteractionEnabled = NO;
                    } else {
                        cell.textLabel.text = @"添加成员";
                    }
                    
                }
                    break;
                default:
                    break;
            }
            
            return cell;
        }
            break;
        case 2:
        {
            //新消息通知开关
            static NSString *bottomCell = @"buttomCell";
            CircleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:bottomCell];
            if (nil == cell) {
                cell = [[[CircleDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bottomCell]autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundView = [[[UIView alloc]initWithFrame:cell.bounds] autorelease];
                cell.backgroundView.backgroundColor = [UIColor whiteColor];
            }
            cell.qTextLabel.text = @"新消息通知";
            [cell.qSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            
            int switch_status = [[self.detailDic objectForKey:@"msg_switch"] intValue];
            [cell.qSwitch setOn:switch_status==1?YES:NO];
            
            [cell setCellType:CellTypeSwitch];
            
            return cell;
        }
            break;
        case 3:
        {
            //解散圈子
            static NSString* disCell = @"dissolveCell";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:disCell];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:disCell] autorelease];
            }
            UIButton *dissolve = [UIButton buttonWithType:UIButtonTypeCustom];
            [dissolve setFrame:CGRectMake(10.f, 0.f, KUIScreenWidth - 20.f, 40.f)];
//            [dissolve setTitle:@"解散圈子" forState:UIControlStateNormal];
            [dissolve setTitle:@"删除并退出圈子" forState:UIControlStateNormal];
            dissolve.titleLabel.font = KQLSystemFont(15);
            dissolve.layer.borderColor = [UIColor redColor].CGColor;
            dissolve.layer.borderWidth = 1;
            dissolve.layer.cornerRadius = 5;
            [dissolve addTarget:self action:@selector(dismissCircle) forControlEvents:UIControlEventTouchUpInside];
            [dissolve setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            cell.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:dissolve];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - 新消息通知
// 新消息是否通知
- (void)switchAction:(UISwitch *)swh{
//    更改数据库字段
    int swhStatus = swh.on?1:0;
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithLongLong:self.circleId],@"circle_id",
                         [NSNumber numberWithInt:swhStatus],@"msg_switch",
                         nil];
    [circle_list_model insertOrUpdateDictionaryIntoCirlceList:dic];
}

#pragma mark - 解散圈子
- (void)dismissCircle{
//    NSLog(@"解散");
//    
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要解散这个圈子么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alert show];
    NSLog(@"删除并退出");
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除并退出这个圈子么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
}

#pragma mark - alertview
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != alertView.cancelButtonIndex) {
        CircleManager * manager = [CircleManager new];
        manager.fatherDelegate = self;
//        [manager dismissCircleWithUserID:[[Global sharedGlobal].user_id longLongValue] andCircleID:[[self.detailDic objectForKey:@"circle_id"] longLongValue]];
        [manager quitCircleWithCircleID:[[self.detailDic objectForKey:@"circle_id"] longLongValue]];
    }
}

//退出圈子通知处理
-(void) quitCircleNotify:(NSNotification*) notify{
    NSDictionary* responseDic = notify.object;
    int rcode = [[responseDic objectForKey:@"rcode"] intValue];
    if (rcode == 0) {
        //在圈子列表中删除该圈子
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        //        [Common checkProgressHUD:@"退出圈子失败" andImage:nil showInView:self.view];
        [Common checkProgressHUDShowInAppKeyWindow:@"退出圈子失败" andImage:KAccessFailedIMG];
    }
}

#pragma mark - CircleManagerDelegate

- (void)dismissCircleSuccess:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    RELEASE_SAFE(sender);
}

- (void)removeMemberSucess:(id)sender
{
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //圈子名称
                    ModifyCircleNameViewController *modifyCtl = [[ModifyCircleNameViewController alloc]init];
                    modifyCtl.detailDictionary = self.detailDic;
                    modifyCtl.circleNames = [self.detailDic objectForKey:@"name"];
                    modifyCtl.delegate = self;
                    [self.navigationController pushViewController:modifyCtl animated:YES];
                    RELEASE_SAFE(modifyCtl);
                }
                    break;
                case 1:
                {
                    //圈子介绍
                    ModifyIntroduceViewController *introCtl = [[ModifyIntroduceViewController alloc]init];
                    introCtl.detailDictionary = self.detailDic;
                    introCtl.delegate = self;
                    [self.navigationController pushViewController:introCtl animated:YES];
                    RELEASE_SAFE(introCtl);
                }
                    break;
                    
                case 2:
                {
                    //创建人
                }
                    break;
                    
                case 3:
                {
                    //二维码
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //成员
                    CircleMemberList* circleMemListVC = [[CircleMemberList alloc] init];
                    circleMemListVC.circleId = [[self.detailDic objectForKey:@"circle_id"] longLongValue];
                    circleMemListVC.circleName = [self.detailDic objectForKey:@"name"];
                    circleMemListVC.enterFromDetail = YES;
                    circleMemListVC.circleType = StableCircle;
                    [self.navigationController pushViewController:circleMemListVC animated:YES];
                    
                    RELEASE_SAFE(circleMemListVC);
                }
                    break;
                case 1:
                {
                    //邀请新成员
                    choicelinkmanViewController* addMemberCtl = [[choicelinkmanViewController alloc] init];
                    addMemberCtl.delegate = self;
                    addMemberCtl.accessType = AccessPageTypeAddMemberList;
                    addMemberCtl.invitedArr = self.memberArr;
                    
                    CRNavigationController* crna = [[CRNavigationController alloc] initWithRootViewController:addMemberCtl];
                    [self presentViewController:crna animated:YES completion:nil];
                    
                    RELEASE_SAFE(addMemberCtl);
                    RELEASE_SAFE(crna);
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - choiceLMDelegate
// 邀请成员加入圈子
- (void)sureAddMember:(NSArray *)selectMember{
    NSLog(@"selectMember==%@",selectMember);
    
    [CircleManager inviteOtherJoinCircleWithCircleDic:self.detailDic andOthers:selectMember];
}

#pragma mark - modifyCircleName
-(void) updateModifyInfo:(NSString *)infoStr{
    self.circleNameLab.text = infoStr;
    NSMutableDictionary* circleInfoDic = [NSMutableDictionary dictionaryWithDictionary:self.detailDic];
    [circleInfoDic removeObjectForKey:@"name"];
    [circleInfoDic setObject:infoStr forKey:@"name"];
    NSDictionary* changeDic = [NSDictionary dictionaryWithDictionary:circleInfoDic];
    self.detailDic = [changeDic mutableCopy];
}

-(void) modifyIntroduceSuccessWithNewIntroduce:(NSString *)introduce{
    self.circleIntroLab.text = introduce;
    NSMutableDictionary* circleInfoDic = [NSMutableDictionary dictionaryWithDictionary:self.detailDic];
    [circleInfoDic removeObjectForKey:@"content"];
    [circleInfoDic setObject:introduce forKey:@"content"];
    NSDictionary* changeDic = [NSDictionary dictionaryWithDictionary:circleInfoDic];
    self.detailDic = [changeDic mutableCopy];
    
    [self.tableview reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    [super dealloc];
}

@end
