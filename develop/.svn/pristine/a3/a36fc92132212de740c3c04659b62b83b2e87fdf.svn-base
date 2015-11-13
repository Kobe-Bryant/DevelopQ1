//
//  TempCircleDetailViewController.m
//  ql
//
//  Created by yunlai on 14-7-12.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TempCircleDetailViewController.h"

#import "temporary_circle_list_model.h"
#import "temporary_circle_member_list_model.h"

@interface TempCircleDetailViewController ()

@end

@implementation TempCircleDetailViewController

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
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
//    获取临时圈子数据
    [self getCircleDetailData];
//    加载主视图
    [self loadCircleDetailView];
    
}

//获取临时圈子详情和成员信息
-(void) getCircleDetailData{
    self.detailDic = [[NSMutableDictionary alloc] init];
    //读取圈子信息
    [self.detailDic setDictionary:[temporary_circle_list_model getTemporaryCircleListWithTempCircleID:self.circleId]];
    //读取成员信息
    self.memberArr = [temporary_circle_member_list_model getAllMemberFormTempCircle:self.circleId];
}

//加载主视图
-(void) loadCircleDetailView{
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 60 - 64) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    if (IOS_VERSION_7) {
        [_tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    _tableview.showsVerticalScrollIndicator = NO;
    
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableview];
}

#pragma mark - tableviewdelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 20.0;
            break;
        case 1:
            return 50.0;
            break;
        case 2:
            return 20.0;
            break;
        case 3:
            return 20.0;
            break;
        default:
            break;
    }
    return 20.0;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    if (section == 1) {
        label.frame = CGRectMake(10.f, 10.f, 200.f, 30.f);
        label.text = [NSString stringWithFormat: @"  会话人数：(%d/50)",self.memberArr.count];
        label.textColor = COLOR_GRAY2;
        label.font = KQLSystemFont(15);
        
    }else{
        label.frame = CGRectMake(0.f, 0.f, KUIScreenWidth, 20.f);
    }
    return [label autorelease];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 45.0;
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                return 70.0;
            }else{
                return 45.0;
            }
        }
            break;
        case 2:
        {
            return 44.0;
        }
            break;
        case 3:
        {
            return 44.0;
        }
            break;
        default:
            break;
    }
    return 44.0;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    [_memberArr release];
    [_detailDic release];
    [_tableview release];
    [super dealloc];
}

@end
