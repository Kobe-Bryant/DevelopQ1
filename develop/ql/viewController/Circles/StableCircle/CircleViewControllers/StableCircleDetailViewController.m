//
//  CircleDetailViewController.m
//  ql
//
//  Created by yunlai on 14-7-12.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "StableCircleDetailViewController.h"

#import "circle_list_model.h"
#import "circle_member_list_model.h"

@interface StableCircleDetailViewController ()


@end

@implementation StableCircleDetailViewController

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
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
//    获取圈子详情数据
    [self getCircleDetailData];
//    加载视图
    [self loadCircleDetailView];
    
	// Do any additional setup after loading the view.
}

//获取圈子详情数据、成员数据
-(void) getCircleDetailData{
    self.detailDic = [[NSMutableDictionary alloc] init];
    //读取圈子信息
    circle_list_model* circleMod = [[circle_list_model alloc] init];
    circleMod.where = [NSString stringWithFormat:@"circle_id = %lld",self.circleId];
    [self.detailDic setDictionary:[[circleMod getList] firstObject]];
    [circleMod release];
    
    //读取成员信息
    circle_member_list_model* circleMemMod = [[circle_member_list_model alloc] init];
    circleMemMod.where = [NSString stringWithFormat:@"circle_id = %lld",self.circleId];
    self.memberArr = [[NSArray alloc] initWithArray:[circleMemMod getList]];
    [circleMemMod release];
    
    NSLog(@"--detail:%@\nmember:%@--",self.detailDic,self.memberArr);
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
            return 3;
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
        label.text = [NSString stringWithFormat: @"  圈子人数：(%d/50)",self.memberArr.count];
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
        {
            if (indexPath.row == 1) {
                //动态获取圈子介绍文本的高度
                NSString* introduceStr = [self.detailDic objectForKey:@"content"];
                CGSize size = [introduceStr sizeWithFont:KQLSystemFont(15) constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                return size.height > 30.0?size.height + 45: 45.0;
            }else{
                return 45.0;
            }
            
        }
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
