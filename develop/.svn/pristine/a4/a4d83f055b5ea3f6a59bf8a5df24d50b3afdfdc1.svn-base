//
//  CircleDetailOnlySelfViewController.m
//  ql
//
//  Created by yunlai on 14-7-12.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "CircleDetailOnlySelfViewController.h"

@interface CircleDetailOnlySelfViewController ()

@property(nonatomic,retain) UILabel* circleNameLab;
@property(nonatomic,retain) UILabel* circleIntroLab;

@end

@implementation CircleDetailOnlySelfViewController

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
    
    self.tableview.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64);
	// Do any additional setup after loading the view.
    
    //退出圈子成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitCircleNotify:) name:KNotiQuitCircle object:nil];
}

#pragma mark - tableviewdelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            static NSString *DetailCell = @"topCell";
            CircleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailCell];
            if (nil == cell) {
                cell = [[[CircleDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailCell]autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.backgroundView = [[[UIView alloc]initWithFrame:cell.bounds] autorelease];
                cell.backgroundView.backgroundColor = [UIColor whiteColor];
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
                    
                    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(10.f, 10.f, 50.f, 50.f)];
                    [headView setImageWithURL:[NSURL URLWithString:[[self.memberArr firstObject] objectForKey:@"portrait"]] placeholderImage:IMG(DEFAULT_MALE_PORTRAIT_NAME)];
                    headView.layer.cornerRadius = 25;
                    headView.clipsToBounds = YES;
                    [cell.contentView addSubview:headView];
                    RELEASE_SAFE(headView); //add vincent
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

#pragma mark - alertviewdelegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != alertView.cancelButtonIndex) {
        CircleManager * manager = [CircleManager new];
        manager.fatherDelegate = self;
//        [manager dismissCircleWithUserID:[[Global sharedGlobal].user_id longLongValue] andCircleID:[[self.detailDic objectForKey:@"circle_id"] longLongValue]];
        [manager quitCircleWithCircleID:[[self.detailDic objectForKey:@"circle_id"] longLongValue]];
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
                    modifyCtl.circleNames = [self.detailDic objectForKey:@"name"];
                    modifyCtl.detailDictionary = self.detailDic;
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
//修改圈子名称回调
-(void) updateModifyInfo:(NSString *)infoStr{
    self.circleNameLab.text = infoStr;
    NSMutableDictionary* circleInfoDic = [NSMutableDictionary dictionaryWithDictionary:self.detailDic];
    [circleInfoDic removeObjectForKey:@"name"];
    [circleInfoDic setObject:infoStr forKey:@"name"];
    NSDictionary* changeDic = [NSDictionary dictionaryWithDictionary:circleInfoDic];
    self.detailDic = [changeDic mutableCopy];
}

//修改圈子介绍的回调
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
