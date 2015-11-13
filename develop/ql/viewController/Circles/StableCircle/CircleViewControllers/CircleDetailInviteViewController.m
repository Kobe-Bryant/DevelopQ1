//
//  CircleDetailInviteViewController.m
//  ql
//
//  Created by yunlai on 14-7-16.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "CircleDetailInviteViewController.h"

@interface CircleDetailInviteViewController ()

@end

@implementation CircleDetailInviteViewController

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
	// Do any additional setup after loading the view.
}

#pragma mark - tableviewdelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 1;
            break;
        default:
            break;
    }
    return 0;
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
                if (indexPath.row == 0 || indexPath.row == 1) {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            }
            
            if (indexPath.row == 0) {
                cell.qTextLabel.text = @"圈子名称";
                cell.qValueLabel.text = [self.detailDic objectForKey:@"name"];
                
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
                }
                    break;
                case 1:
                {
                    //圈子介绍
                }
                    break;
                    
                case 2:
                {
                    //创建人
                    MemberMainViewController *memberMainView = [[MemberMainViewController  alloc] init];
                    memberMainView.pushType = PushTypesButtom;
//                    memberMainView.accessType = AccessTypeLookOther;
                    memberMainView.lookId = [[self.detailDic objectForKey:@"creater_id"] intValue];
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
                default:
                    break;
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

@end
