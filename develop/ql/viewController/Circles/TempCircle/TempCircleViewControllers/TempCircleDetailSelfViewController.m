//
//  TempCircleDetailSelfViewController.m
//  ql
//
//  Created by yunlai on 14-7-12.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TempCircleDetailSelfViewController.h"

@interface TempCircleDetailSelfViewController ()<ModifyInfoDelegate>

@property(nonatomic,retain) UILabel* circleNameLab;

@end

@implementation TempCircleDetailSelfViewController

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
    
    self.title = @"会话详情";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitTempCircleNotify:) name:KNotiQuitTempCircle object:nil];
	// Do any additional setup after loading the view.
//    创建保存为圈子按钮
    [self createSaveBtn];
}

//创建保存为圈子按钮（暂未使用）
-(void) createSaveBtn{
    UIButton* btmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    btmBtn.backgroundColor = [UIColor whiteColor];
    btmBtn.frame = CGRectMake(0, self.view.bounds.size.height - 60 - 64, self.view.bounds.size.width, 60);
    [btmBtn setTitle:@"保存为圈子" forState:UIControlStateNormal];
    [btmBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"] forState:UIControlStateNormal];
    [btmBtn addTarget:self action:@selector(saveToCircle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btmBtn];
    
    btmBtn.hidden = YES;
}

#pragma mark - 保存为圈子
-(void) saveToCircle{
    //保存为圈子
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
                cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
                cell.backgroundView.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                if (indexPath.row == 1) {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            }
            
            if (indexPath.row == 0) {
                cell.qTextLabel.text = @"会话名称";
                cell.qValueLabel.text = [self.detailDic objectForKey:@"name"];
                self.circleNameLab = cell.qValueLabel;
                
                [cell setCellType:CellTypeLabel];
                
            }else if (indexPath.row == 1){
                
                cell.qTextLabel.text = @"创建人";
                
                cell.qValueLabel.text = [self.detailDic objectForKey:@"creater_name"];
                
                [cell setCellType:CellTypeLabel];
                
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
                cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
                cell.backgroundView.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
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
            }
            cell.qTextLabel.text = @"新消息通知";
            [cell.qSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell setCellType:CellTypeSwitch];
            
            int switch_status = [[self.detailDic objectForKey:@"msg_switch"] intValue];
            [cell.qSwitch setOn:switch_status==1?YES:NO];
            
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
//            [dissolve setTitle:@"解  散" forState:UIControlStateNormal];
            [dissolve setTitle:@"删除并退出" forState:UIControlStateNormal];
            dissolve.titleLabel.font = KQLSystemFont(15);
            dissolve.layer.borderColor = [UIColor redColor].CGColor;
            dissolve.layer.borderWidth = 1;
            dissolve.layer.cornerRadius = 5;
            [dissolve addTarget:self action:@selector(dismissTempCircle) forControlEvents:UIControlEventTouchUpInside];
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
                         [NSNumber numberWithLongLong:self.circleId],@"temp_circle_id",
                         [NSNumber numberWithInt:swhStatus],@"msg_switch",
                         nil];
    [temporary_circle_list_model insertOrUpdateDictionaryIntoTempCirlceList:dic];
}

#pragma mark - 删除并退出会话
- (void)dismissTempCircle{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除并退出这个会话么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

#pragma mark - alertviewdelegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != alertView.cancelButtonIndex) {
        NSNumber * circleIDNum = [self.detailDic objectForKey:@"temp_circle_id"];
        
        TemporaryCircleManager * manager = [TemporaryCircleManager new];
        manager.fatherDelegate = self;
        manager.tempCircleID = circleIDNum.longLongValue;
        [manager quitTempCircleWithCircleID:circleIDNum.longLongValue];
    }
}

//退出临时圈子通知处理
-(void) quitTempCircleNotify:(NSNotification*) notify{
    
    NSDictionary * resultDic = [notify object];
    
    int rcode = [[resultDic objectForKey:@"rcode"]intValue];
    if (rcode == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
//        [Common checkProgressHUD:@"退出圈子失败" andImage:nil showInView:self.view];
        [Common checkProgressHUDShowInAppKeyWindow:@"退出圈子失败" andImage:KAccessSuccessIMG];
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
                    modifyCtl.delegate = self;
                    modifyCtl.detailDictionary = self.detailDic;
                    modifyCtl.circleType = 1;
                    [self.navigationController pushViewController:modifyCtl animated:YES];
                    RELEASE_SAFE(modifyCtl);
                }
                    break;
                case 1:
                {
                    //创建人
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
                    circleMemListVC.circleId = [[self.detailDic objectForKey:@"temp_circle_id"] longLongValue];
                    circleMemListVC.circleName = [self.detailDic objectForKey:@"name"];
                    circleMemListVC.enterFromDetail = YES;
                    circleMemListVC.circleType = TemporaryCircle;
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
    
    TemporaryCircleManager* tempManager = [TemporaryCircleManager new];
    tempManager.tempCircleID = [[self.detailDic objectForKey:@"temp_circle_id"] longLongValue];
    tempManager.memberArr = selectMember;
    tempManager.tempdelegate = self;
    tempManager.memberArr = selectMember;
    [tempManager addMemberFromMemberArr];
}

#pragma mark - addMemberSuccess
-(void) addMemberSuccessWithSender:(id)sender CircleID:(long long)circleID{
    [self getCircleDetailData];
    [self.tableview reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(addMemberReload)]) {
        [self.delegate addMemberReload];
    }
    RELEASE_SAFE(sender);
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    [super dealloc];
}

@end
