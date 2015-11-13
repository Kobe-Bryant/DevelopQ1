//
//  choiceCircleViewController.m
//  ql
//
//  Created by yunlai on 14-4-4.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "choiceCircleViewController.h"

#import "choiceCLCell.h"

#import "Common.h"
#import "org_list_model.h"
#import "circle_list_model.h"

@interface choiceCircleViewController (){
    NSMutableDictionary* _circlesDic;
    NSMutableArray* _selectedCLArr;
    NSMutableArray* _selectedORGArr;
    NSMutableDictionary* _selectedDic;
    NSMutableArray* _theKeys;
    NSMutableArray* _selectedArr;
}

@property(nonatomic,retain) UILabel* redLab;
@property(nonatomic,retain) UITableView* tableivew;
@property(nonatomic,retain) UIScrollView* btmScroll;
@property(nonatomic,retain) UILabel* sclLab;

@end

@implementation choiceCircleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _selectedArr = [[NSMutableArray alloc] init];
        _selectedCLArr = [[NSMutableArray alloc] init];
        _selectedORGArr = [[NSMutableArray alloc] init];
        _selectedDic = [[NSMutableDictionary alloc] init];
        
        _circlesDic = [[NSMutableDictionary alloc] init];
        
        _theKeys = [[NSMutableArray alloc] initWithObjects:
                    @"私人圈子", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"指定圈子";
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    //获取圈子列表
    [self accessService];
    //初始化导航条
    [self initNavBar];
    //初始化列表
    [self initTable];
    //初始化底部视图
    [self initButtom];

	// Do any additional setup after loading the view.
}

//初始化导航条
-(void) initNavBar{
    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 30, 40, 30);
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    RELEASE_SAFE(leftItem);
}

#pragma mark - 取消
-(void) leftButtonClick{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(cancelCLClick)]) {
        [_delegate cancelCLClick];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//初始化列表
-(void) initTable{
    if (IOS_VERSION_7) {
        _tableivew = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 60) style:UITableViewStylePlain];
    }else {
        _tableivew = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 105) style:UITableViewStylePlain];
    }
    
    _tableivew.delegate = self;
    _tableivew.dataSource = self;
    _tableivew.allowsMultipleSelection = YES;
    _tableivew.backgroundColor = [UIColor clearColor];
    _tableivew.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    
    if (IOS_VERSION_7) {
        [_tableivew setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:_tableivew];
}

//初始化底部选中
-(void) initButtom{
    UIView* buttomView = [[UIView alloc] init];
    if (IOS_VERSION_7) {
        buttomView.frame = CGRectMake(0, self.view.bounds.size.height - 60, self.view.bounds.size.width, 60);
    }else {
        buttomView.frame = CGRectMake(0, self.view.bounds.size.height - 105, self.view.bounds.size.width, 60);
    }
    
    buttomView.backgroundColor = [UIColor colorWithPatternImage:[[ThemeManager shareInstance] getThemeImage:@"under_bar.png"]];
    [self.view addSubview:buttomView];
    
    _btmScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, 240, 40)];
    _btmScroll.showsHorizontalScrollIndicator = YES;
    _btmScroll.showsVerticalScrollIndicator = NO;
    _btmScroll.delegate = self;
    [buttomView addSubview:_btmScroll];
    
    UIImageView* addImgV = [[UIImageView alloc] initWithImage:[[ThemeManager shareInstance] getThemeImage:@"bg_group_dotted_square.png"]];
    addImgV.frame = CGRectMake(5, 5, 30, 30);
    [_btmScroll addSubview:addImgV];
    RELEASE_SAFE(addImgV);
    
    UIButton* sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
    sureBtn.frame = CGRectMake(CGRectGetMaxX(_btmScroll.frame) + 10, CGRectGetMinY(_btmScroll.frame) + 5, 50, 30);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = KQLboldSystemFont(14);
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 5;
    [sureBtn addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:sureBtn];
    
    _redLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sureBtn.frame) - 10, CGRectGetMinY(_btmScroll.frame), 20, 20)];
    _redLab.backgroundColor = [UIColor colorWithRed:0.96 green:0.30 blue:0.33 alpha:1.0];
    _redLab.textAlignment = NSTextAlignmentCenter;
    _redLab.textColor = [UIColor whiteColor];
    _redLab.font = [UIFont systemFontOfSize:13];
    _redLab.layer.cornerRadius = _redLab.bounds.size.height/2;
    [_redLab.layer setMasksToBounds:YES];
    [buttomView addSubview:_redLab];
    
    _redLab.hidden = YES;
    
    RELEASE_SAFE(buttomView);
}

#pragma mark - 确定
-(void) sureButtonClick{
    NSLog(@"--Circle sure--");
    if (_delegate != nil && [_delegate respondsToSelector:@selector(sureCircleClick:)]) {
        
        [_selectedDic setObject:_selectedCLArr forKey:@"circles"];
        [_selectedDic setObject:_selectedORGArr forKey:@"orgs"];
        
        [_delegate sureCircleClick:_selectedDic];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableview

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return _circlesDic.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_circlesDic objectForKey:[_theKeys objectAtIndex:section]] count];
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_theKeys objectAtIndex:section];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    // 添加自定义section视图
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, 60.f)];
    [sectionView setBackgroundColor:[UIColor colorWithPatternImage:[[ThemeManager shareInstance] getThemeImage:@"under_bar.png"]]];
    
    UIImageView *iconV = [[UIImageView alloc]initWithFrame:CGRectMake(15.f, 10.f, 40.f, 40.f)];
    iconV.layer.cornerRadius = 20;
    iconV.clipsToBounds = YES;
    
    [sectionView addSubview:iconV];
    
    // 提示语
    UILabel *tips = [[UILabel alloc]initWithFrame:CGRectMake(65.f, 15.f, KUIScreenWidth, 30.f)];
    tips.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
    tips.backgroundColor = [UIColor clearColor];
    tips.font = KQLboldSystemFont(16);
    
    if (section == 0) {
        
        iconV.image = [[ThemeManager shareInstance] getThemeImage:@"ico_group_logo.png"];
        tips.text = [_theKeys objectAtIndex:section];
    }else{
        iconV.image = IMGREADFILE(@"ico_group_circle.png");
        tips.text = [_theKeys objectAtIndex:section];
    }
    
    [sectionView addSubview:tips];
    RELEASE_SAFE(tips);
    RELEASE_SAFE(iconV);
    
    return [sectionView autorelease];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = @"choiceCLCell";
    choiceCLCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[choiceCLCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    NSArray* cirs = [_circlesDic objectForKey:[_theKeys objectAtIndex:indexPath.section]];
    if (cirs.count) {
        cell.circleName.text = [cirs[indexPath.row] objectForKey:@"name"];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray* cirs = [_circlesDic objectForKey:[_theKeys objectAtIndex:indexPath.section]];
    if (indexPath.section == 0) {
        [_selectedORGArr addObject:cirs[indexPath.row]];
    }else{
        [_selectedCLArr addObject:cirs[indexPath.row]];
    }
    
    [_selectedArr addObject:cirs[indexPath.row]];
    
    [self layButtomLabel];
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray* cirs = [_circlesDic objectForKey:[_theKeys objectAtIndex:indexPath.section]];
    if (indexPath.section == 0) {
        [_selectedORGArr removeObject:cirs[indexPath.row]];
    }else{
        [_selectedCLArr removeObject:cirs[indexPath.row]];
    }
    
    [_selectedArr removeObject:cirs[indexPath.row]];
    
    [self layButtomLabel];
}

//布局底部
-(void) layButtomLabel{
    
    for (UIView* v in _btmScroll.subviews) {
        [v removeFromSuperview];
    }
    
    NSString* str = nil;
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    [arr addObjectsFromArray:_selectedArr];
    
    UIImageView* addImgV = [[UIImageView alloc] initWithImage:[[ThemeManager shareInstance] getThemeImage:@"bg_group_dotted_square.png"]];
    addImgV.frame = CGRectMake(5, 5, 30, 30);
    [_btmScroll addSubview:addImgV];
    RELEASE_SAFE(addImgV);
    
    CGFloat offx = 50;
    
    for (int i = 0; i < arr.count; i++) {
        str = [[arr objectAtIndex:(arr.count - 1 - i)] objectForKey:@"name"];
        
        CGSize size = [str sizeWithFont:KQLboldSystemFont(13) constrainedToSize:CGSizeMake(200, 40) lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel* lab = [[UILabel alloc] init];
        lab.textAlignment = UITextAlignmentCenter;
        lab.textColor = [UIColor whiteColor];
        lab.text = str;
        lab.frame = CGRectMake(offx, 5, size.width + 40, 30);
        lab.backgroundColor = [UIColor darkGrayColor];
        lab.layer.cornerRadius = 5.0;
        
        [_btmScroll addSubview:lab];
        RELEASE_SAFE(lab);
        
        offx += 5 + size.width + 40;
    }
    
    RELEASE_SAFE(arr);
    
    _btmScroll.contentSize = CGSizeMake(offx + 60, _btmScroll.bounds.size.height);
    [_btmScroll setContentOffset:CGPointMake(5, 0) animated:YES];
    
    _redLab.text = [NSString stringWithFormat:@"%d",_selectedArr.count];
    if ([_redLab.text isEqualToString:@"0"]) {
        _redLab.hidden = YES;
    }else{
        _redLab.hidden = NO;
    }
}

-(void) addStringInSclLab{
    NSString* str = nil;
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    [arr addObjectsFromArray:_selectedCLArr];
    [arr addObjectsFromArray:_selectedORGArr];
    for (NSDictionary* s in arr) {
        if (str == nil) {
            str = [s objectForKey:@"name"];
        }else{
            str = [NSString stringWithFormat:@"%@,%@",str,s];
        }
    }
    _sclLab.text = str;
}

- (void)accessService{
    
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                                        [NSNumber numberWithInt:0],@"circle_ver",
                                        [NSNumber numberWithInt:0],@"org_ver",
                                        [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                        nil];
	
	[[NetManager sharedManager] accessService:jsontestDic data:nil command:GROUP_LIST_COMMAND_ID accessAdress:@"addressbook.do?param=" delegate:self withParam:nil];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish:%@",resultArray);
    
    switch (commandid) {
        case GROUP_LIST_COMMAND_ID:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
//                org_list_model *orgMod = [[org_list_model alloc]init];
                NSMutableArray* arr = [org_list_model getAllOrgWithMemberIsnotNone];
                NSString* key = [[[org_list_model oneOrgMember] firstObject] objectForKey:@"name"];
//                [arr removeObjectAtIndex:0];
                
                [_theKeys insertObject:key atIndex:0];
                [_circlesDic setObject:arr forKey:key];
                
//                circle_list_model *circleMod = [[circle_list_model alloc]init];
//                circleMod.where = @"name != ''";
//                [_circlesDic setObject:[circleMod getList] forKey:@"私人圈子"];
                
//                RELEASE_SAFE(orgMod);
//                RELEASE_SAFE(circleMod);
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [_tableivew reloadData];
                    
                });
            });
            
        }break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    RELEASE_SAFE(_selectedArr);
    RELEASE_SAFE(_selectedDic);
    RELEASE_SAFE(_theKeys);
    RELEASE_SAFE(_selectedORGArr);
    RELEASE_SAFE(_circlesDic);
    RELEASE_SAFE(_selectedCLArr);
    RELEASE_SAFE(_tableivew);
    RELEASE_SAFE(_redLab);
    RELEASE_SAFE(_sclLab);
    RELEASE_SAFE(_btmScroll);
    [super dealloc];
}

@end
