//
//  CircleDetailSuccessViewController.m
//  ql
//
//  Created by yunlai on 14-7-12.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "CircleDetailSuccessViewController.h"

@interface CircleDetailSuccessViewController (){
    
}

@property(nonatomic,retain) UILabel* circleNameLab;
@property(nonatomic,retain) UILabel* circleIntroLab;

@end

@implementation CircleDetailSuccessViewController

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
    
    self.title = @"创建圈子";
//    创建成功UI
    [self createSuccessReminder];
//    创建底部完成的view
    [self createButtomSuccessView];
//    初始化导航条
    [self initNavigateBar];
	// Do any additional setup after loading the view.
}

//创建圈子无返回
-(void) initNavigateBar{
    UIImage * returnImg = [[ThemeManager shareInstance] getThemeImage:@"ico_common_return.png"];
    UIButton * leftBackButton = [UIButton new];
    [leftBackButton setImage:returnImg forState:UIControlStateNormal];
    [leftBackButton sizeToFit];
    [leftBackButton addTarget:self action:@selector(turnToCircleListView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc]initWithCustomView:leftBackButton];
    self.navigationItem.leftBarButtonItem = barItem;
    
    //创建的时候没有返回
    leftBackButton.hidden = YES;
}

//底部完成按钮
-(void) createButtomSuccessView{
    UIButton* btmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    btmBtn.backgroundColor = [UIColor whiteColor];
    if (IOS_VERSION_7) {
        btmBtn.frame = CGRectMake(0, self.view.bounds.size.height - 60 - 64, self.view.bounds.size.width, 60);
    }else {
        btmBtn.frame = CGRectMake(0, self.view.bounds.size.height - 60 - 64 +20, self.view.bounds.size.width, 60);
    }
    [btmBtn setTitle:@"完   成" forState:UIControlStateNormal];
    [btmBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"] forState:UIControlStateNormal];
    [btmBtn addTarget:self action:@selector(turnToCircleListView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btmBtn];
}

//跳转圈子列表页面
- (void)turnToCircleListView{
    
    [self dismissModalViewControllerAnimated:YES];
}

//创建成功
- (void)createSuccessReminder{
    UIView *bgReminder = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, 55.f)];
    
    UIImageView *iconV = [[UIImageView alloc]initWithFrame:CGRectMake(110.f, 15.f, 20.f, 20.f)];
    iconV.image = [[ThemeManager shareInstance] getThemeImage:@"ico_landing_correct.png"];
    
    [bgReminder addSubview:iconV];
    
    UILabel *remiderT = [[UILabel alloc]init];
    remiderT.frame = CGRectMake(135.f, 10.f, 120.f, 30.f);
    remiderT.text = @"创建成功";
    remiderT.backgroundColor = [UIColor clearColor];
    remiderT.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
    
    [bgReminder addSubview:remiderT];
    
    self.tableview.tableHeaderView = bgReminder;
    
    RELEASE_SAFE(remiderT);
    RELEASE_SAFE(iconV);
    RELEASE_SAFE(bgReminder);
}

#pragma mark - tableviewdelegate
//重载父类实现
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
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
        default:
            break;
    }
    return nil;
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
                    modifyCtl.circleNames = [self.detailDic objectForKey:@"name"];
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
// 邀请成员加入圈子回调
- (void)sureAddMember:(NSArray *)selectMember{
    NSLog(@"selectMember==%@",selectMember);
    
    [CircleManager inviteOtherJoinCircleWithCircleDic:self.detailDic andOthers:selectMember];
}

#pragma mark - modifyCircleName
//修改圈子名称
-(void) updateModifyInfo:(NSString *)infoStr{
    self.circleIntroLab.text = infoStr;
    NSMutableDictionary* circleInfoDic = [NSMutableDictionary dictionaryWithDictionary:self.detailDic];
    [circleInfoDic removeObjectForKey:@"name"];
    [circleInfoDic setObject:self.circleIntroLab.text forKey:@"name"];
    NSDictionary* changeDic = [NSDictionary dictionaryWithDictionary:circleInfoDic];
    self.detailDic = [changeDic mutableCopy];
}

//修改圈子介绍
-(void) modifyIntroduceSuccessWithNewIntroduce:(NSString *)introduce{
    self.circleIntroLab.text = introduce;
    NSMutableDictionary* circleInfoDic = [NSMutableDictionary dictionaryWithDictionary:self.detailDic];
    [circleInfoDic removeObjectForKey:@"content"];
    [circleInfoDic setObject:self.circleIntroLab.text forKey:@"content"];
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
