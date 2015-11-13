//
//  choicelinkmanViewController.m
//  ql
//
//  Created by yunlai on 14-4-3.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "choicelinkmanViewController.h"

#import "PinYinForObjc.h"
#import "YLDataObj.h"
#import "choiceLMCell.h"
#import "Common.h"
#import "UIImageView+WebCache.h"
#import "circle_contacts_model.h"
#import "MemberMainViewController.h"
#import "CircleMainViewController.h"
#import "SessionCircleChooseViewController.h"

#define CMimageMargin 5.0f
#define kButtonViewTag 999
#define MaxMemberLimite 50

@interface choicelinkmanViewController (){
    //已选member组
    NSMutableArray* _selectedArr;
    CGSize _imageSize;
    //已选indexPaths组
    NSMutableArray* _selectedIndexPaths;
    //已选名字组
    NSMutableArray* _selectedNames;
    //所有的indexPaths组
    NSMutableArray* allIndexPaths;
}

@property(nonatomic,retain) UILabel* redLab;//已选红色数字标记
@property(nonatomic,retain) UIScrollView* btmScroll;//底部选择图片的scroll
@property(nonatomic,retain) UIView* buttomView;//底部view

@property (nonatomic , retain) NSArray *keyArr;//所有的key组（名字首字母）
@property (nonatomic , retain) NSMutableDictionary *dataDict;//所有的数据字典

@end

@implementation choicelinkmanViewController
@synthesize accessType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _memberArr = [[NSMutableArray alloc] init];
        _selectedArr = [[NSMutableArray alloc] init];
        _selectedIndexPaths = [[NSMutableArray alloc] init];
        _selectedNames = [[NSMutableArray alloc] init];
        
        _searchResultArr = [[NSMutableArray alloc] init];
        
        allIndexPaths = [[NSMutableArray alloc] init];
        _searchSelectIndexPaths = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    //初始化导航条
    [self initNavgateBar];
    //初始化主视图
    [self initMainview];
    //初始化底部选择框
    [self initButtomView];
    //读取数据
    [self getData];
    
    //chenfeng 5.8 add
    if (self.accessType == AccessPageTypeAddMemberList) {
        self.navigationItem.title = @"邀请新成员";
    }else if (self.accessType == AccessPageTypeChoiceMember){
        self.navigationItem.title = @"指定对象";
    }else if (self.accessType == AccessPageTypeChat) {
        self.navigationItem.title = @"开始新聊天";
    }
}

//添加选择圈子按钮
- (UIButton *)loadCircleSelectButton
{
    UIButton * circleSelectButton = [UIButton new];
    circleSelectButton.frame = CGRectMake(0, 44, KUIScreenWidth, 60);
    circleSelectButton.backgroundColor = [UIColor clearColor];
    [circleSelectButton addTarget:self action:@selector(turnToGroupAndCircleSelectView) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage * circleIconImg = [UIImage imageCwNamed:@"ico_group_circle.png"];
    UIImageView * circleIcon = [[UIImageView alloc]initWithImage:circleIconImg];
    circleIcon.frame = CGRectMake(20, CGRectGetHeight(circleSelectButton.bounds)/2 - 25, 50, 50);
    [circleIcon sizeToFit];
    [circleSelectButton addSubview:circleIcon];
    
    UIImage * arrowImg = [UIImage imageCwNamed:@"ico_group_arrow.png"];
    UIImageView * arrowView = [[UIImageView alloc]initWithImage:arrowImg];
    [arrowView sizeToFit];
    arrowView.frame = CGRectMake(KUIScreenWidth - CGRectGetWidth(arrowView.bounds) - 10, CGRectGetHeight(circleSelectButton.bounds)/2 - CGRectGetHeight(arrowView.bounds)/2, CGRectGetWidth(arrowView.bounds), CGRectGetHeight(arrowView.bounds));
    [circleSelectButton addSubview:arrowView];
    RELEASE_SAFE(arrowView);//add vincent
    
    UILabel * indexLable = [UILabel new];
    indexLable.frame = CGRectMake(CGRectGetWidth(circleSelectButton.bounds)/2 - 100, CGRectGetHeight(circleSelectButton.bounds)/2 - 40, 200, 80);
    indexLable.backgroundColor = [UIColor clearColor];
//    indexLable.textColor = [UIColor blackColor];
    indexLable.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
    indexLable.font = KQLSystemFont(14);
    indexLable.text = @"选择已有圈子";
    indexLable.textAlignment = NSTextAlignmentCenter;
    [circleSelectButton addSubview:indexLable];
    
    RELEASE_SAFE(circleIcon);
    RELEASE_SAFE(indexLable);
    return circleSelectButton;
}

#pragma mark - 选择已有圈子
- (void)turnToGroupAndCircleSelectView
{
    SessionCircleChooseViewController *circleChoose = [[SessionCircleChooseViewController alloc] init];
    [self.navigationController pushViewController:circleChoose animated:YES];
    
    RELEASE_SAFE(circleChoose);
}

-(void) initNavgateBar{
    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    leftBtn.frame = CGRectMake(0, 30, 44, 44);
    //    [leftBtn setTitleColor:[UIColor colorWithRed:0.12 green:0.55 blue:0.89 alpha:1.0] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    RELEASE_SAFE(leftItem);
}

#pragma mark - leftButtonClick
-(void) leftButtonClick{
    //chenfeng 5.8 add
    if (self.accessType == AccessPageTypeAddMemberList) {
//        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else if (self.accessType == AccessPageTypeChoiceMember || self.accessType == AccessPageTypeChat){
        if (_delegate != nil && [_delegate respondsToSelector:@selector(cancelLMClick)]) {
            [_delegate cancelLMClick];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

-(void) initMainview{
    
    //当为可以发起会话列表时弹出发起会话列表框
    int heigh = 0;
    int orignY = 0;
    
    heigh = self.view.bounds.size.height - 60;
    
    //searchBar
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    _searchBar.delegate = self;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	_searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_searchBar.backgroundColor=[UIColor clearColor];
	_searchBar.translucent=YES;
	_searchBar.placeholder=@"搜索";
    
    //tableview
    if (IOS_VERSION_7) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, orignY, self.view.bounds.size.width,heigh) style:UITableViewStylePlain];
    }else {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, orignY, self.view.bounds.size.width,heigh - 45) style:UITableViewStylePlain];
    }
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.allowsMultipleSelection = YES;
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    if (IOS_VERSION_7) {
        [_tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:_tableview];
    
    // ios7的UITableVIew按字母排序的索引怎么改成背景是透明
    if ([_tableview respondsToSelector:@selector(setSectionIndexBackgroundColor:)]) {
        
        _tableview.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableview.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        
        _tableview.sectionIndexColor = COLOR_GRAY2;
    }
    
    UIButton * circleButton = nil;
    int headViewHight = 44.f;
    
    // 获取是否发起会话key
    if (_isStartChat) {
        circleButton = [self loadCircleSelectButton];
//        headViewHight = headViewHight + circleButton.frame.size.height; //add vincent
    }
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, KUIScreenWidth, headViewHight)];
    _tableview.tableHeaderView = headView;
    [headView addSubview:_searchBar];
    //    if (circleButton != nil) { //add vincent

//        [headView addSubview:circleButton];
//        RELEASE_SAFE(circleButton);
//    }
    RELEASE_SAFE(headView);
    
    //搜索控制器
    _searchCtl = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _searchCtl.active = NO;
    _searchCtl.searchResultsDataSource = self;
    _searchCtl.searchResultsDelegate = self;
    _searchCtl.delegate = self;
    _searchCtl.searchResultsTableView.allowsMultipleSelection = YES;
    _searchCtl.searchResultsTableView.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
    if (IOS_VERSION_7) {
        [_searchCtl.searchResultsTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    //    _searchCtl.searchResultsTableView.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
    
    //添加字母显示
    UIView *letterView = [[UIView alloc] initWithFrame:CGRectMake( (self.view.frame.size.width / 2) - 40 , ([UIScreen mainScreen].bounds.size.height / 2) - 80.0f , 80.0f , 80.0f)];
    
    UIImageView *letterBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 0.0f , 0.0f , 80.0f , 80.0f)];
    UIImage *backImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"eatShow_selectCity_icon" ofType:@"png"]];
    letterBackImageView.image = backImage;
    [backImage release];
    [letterView addSubview:letterBackImageView];
    [letterBackImageView release];
    
    UILabel *letterLabel = [[UILabel alloc] initWithFrame: CGRectMake( 20.0f , 20.0f  , 40.0f , 40.0f)];
	letterLabel.textColor = [UIColor whiteColor];
	letterLabel.backgroundColor = [UIColor clearColor];
	letterLabel.font = [UIFont systemFontOfSize: 38];
	letterLabel.textAlignment = NSTextAlignmentCenter;
    letterLabel.tag = 1001;
	[letterView addSubview: letterLabel];
    [letterLabel release];
    
    letterView.tag = 1000;
    letterView.alpha = 0.0;
    [self.view addSubview:letterView];
    [letterView release];
}

-(void) initButtomView{
    
    CGFloat buttomHeight;
    if (self.accessType == AccessPageTypeAddMemberList) {
        buttomHeight = self.view.bounds.size.height - 60;
    }else{
        buttomHeight = self.view.bounds.size.height - 60;
    }
    if (IOS_VERSION_7) {   //add by devin
        _buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, buttomHeight, self.view.bounds.size.width, 60)];
    }else {
       _buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, buttomHeight -45 , self.view.bounds.size.width, 60)];
    }
    
//    _buttomView.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    _buttomView.backgroundColor = [UIColor colorWithPatternImage:[[ThemeManager shareInstance] getThemeImage:@"under_bar.png"]];
    _buttomView.tag = kButtonViewTag;
    [self.view addSubview:_buttomView];
    
    _btmScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, 240, 40)];
    _btmScroll.showsHorizontalScrollIndicator = YES;
    _btmScroll.showsVerticalScrollIndicator = NO;
    _btmScroll.delegate = self;
    [_buttomView addSubview:_btmScroll];
    
    UIImageView* addImgV = [[UIImageView alloc] initWithImage:[[ThemeManager shareInstance] getThemeImage:@"bg_group_dotted_box.png"]];
    addImgV.frame = CGRectMake(5, 0, 40, 40);
    [_btmScroll addSubview:addImgV];
    RELEASE_SAFE(addImgV);
    
    _imageSize = CGSizeMake(40, 40);
    
    UIButton* sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    sureBtn.backgroundColor = [UIColor colorWithRed:0.12 green:0.55 blue:0.89 alpha:1.0];
    sureBtn.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
    sureBtn.frame = CGRectMake(CGRectGetMaxX(_btmScroll.frame) + 10, CGRectGetMinY(_btmScroll.frame) + 5, 50, 35);
    
    if (self.accessType == AccessPageTypeAddMemberList) {
        [sureBtn setTitle:@"邀请" forState:UIControlStateNormal];
    }else{
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
    sureBtn.titleLabel.font = KQLboldSystemFont(14);
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 5.0;
    [sureBtn addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_buttomView addSubview:sureBtn];
    
    _redLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sureBtn.frame) - 10, CGRectGetMinY(_btmScroll.frame), 20, 20)];
    _redLab.backgroundColor = [UIColor colorWithRed:0.96 green:0.30 blue:0.33 alpha:1.0];
    _redLab.textAlignment = NSTextAlignmentCenter;
    _redLab.textColor = [UIColor whiteColor];
    _redLab.font = [UIFont systemFontOfSize:13];
    _redLab.layer.cornerRadius = _redLab.bounds.size.height/2;
    [_redLab.layer setMasksToBounds:YES];
    [_buttomView addSubview:_redLab];
    
    _redLab.hidden = YES;
    
}

//计算出每一个objc在table中得indexPath，保存allIndexPaths数组
-(void) getAllIndexPathsInTable{
    for (int i = 0; i < self.keyArr.count; i++) {
        NSArray* arr = [_dataDict objectForKey:[self.keyArr objectAtIndex:i]];
        for (int j = 0; j < arr.count; j++) {
            [allIndexPaths addObject:[NSIndexPath indexPathForRow:j inSection:i]];
        }
    }
}

- (void)insertAllMember{
    [self.dataDict enumerateKeysAndObjectsUsingBlock:^(id key, NSArray * obj, BOOL *stop) {
        for (NSDictionary * memeber in obj) {
            [_selectedArr addObject:memeber];
            [_selectedNames addObject:[memeber objectForKey:@"realname"]];
            [_selectedIndexPaths addObject:[NSString stringWithFormat:@"%d%d",0,0]];
        }
    }];
    
    [self layoutBtmScroll];
}

#pragma mark - 确定
-(void) sureButtonClick{
    // 5.8 chenfeng add
    if (self.accessType == AccessPageTypeAddMemberList) {
        if (_delegate != nil && [_delegate respondsToSelector:@selector(sureAddMember:)]) {
            [_delegate sureAddMember:_selectedArr];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"inviteJoinSuccess" object:nil];
        
    }else if (self.accessType == AccessPageTypeChoiceMember || self.accessType == AccessPageTypeChat){
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(sureLMClick:)]) {
            [_delegate sureLMClick:_selectedArr];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//布局选中的滚动条 移除所有的，再重新添加
-(void) layoutBtmScroll{
    for (UIView* v in _btmScroll.subviews) {
        [v removeFromSuperview];
    }
    
    for (int i = _selectedArr.count - 1; i >= 0; i--) {
        
        //        NSArray* arr = [_selectedArr objectAtIndex:i];
        NSDictionary* dic = [_selectedArr objectAtIndex:i];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CMimageMargin + (CMimageMargin + _imageSize.width) * (_selectedArr.count - 1 - i) + _imageSize.width + CMimageMargin, 0, _imageSize.width, _imageSize.height)];
        
        NSURL *urlStr = [NSURL URLWithString:[dic objectForKey:@"portrait"]];
        
        if ([[dic objectForKey:@"sex"] intValue] == 1) {
            
            [imageView setImageWithURL:urlStr placeholderImage:IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME)];
        }else{
            [imageView setImageWithURL:urlStr placeholderImage:IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME)];
        }
        imageView.tag = i;
        
        imageView.layer.cornerRadius = imageView.bounds.size.width/2;
        [imageView.layer setMasksToBounds:YES];
        imageView.userInteractionEnabled = YES;
        [_btmScroll addSubview:imageView];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userHeadTap:)];
        [imageView addGestureRecognizer:tap];
        RELEASE_SAFE(tap);
        
        RELEASE_SAFE(imageView);
    }
    
    UIImageView* addImgV = [[UIImageView alloc] initWithImage:[[ThemeManager shareInstance] getThemeImage:@"bg_group_dotted_box.png"]];
    addImgV.frame = CGRectMake(5, 0, 40, 40);
    [_btmScroll addSubview:addImgV];
    RELEASE_SAFE(addImgV);
    
    _btmScroll.contentSize = CGSizeMake(CMimageMargin * (_selectedArr.count + 1 + 1) + (_selectedArr.count + 1) * _imageSize.width, _imageSize.height);
    if (_btmScroll.contentSize.width >= _btmScroll.bounds.size.width) {
        //        [_btmScroll setContentOffset:CGPointMake(_btmScroll.contentSize.width - _btmScroll.bounds.size.width, 0) animated:YES];
        [_btmScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    _redLab.text = [NSString stringWithFormat:@"%d",_selectedNames.count];
    if ([_redLab.text isEqualToString:@"0"]) {
        _redLab.hidden = YES;
    }else{
        _redLab.hidden = NO;
    }
}

//点击底部选择的用户头像  列表对应滑到相应位置
-(void) userHeadTap:(UITapGestureRecognizer*) tap{
    UIImageView* imgv = (UIImageView*)tap.view;
    NSIndexPath* indexPath = [_selectedIndexPaths objectAtIndex:imgv.tag];
    
    NSLog(@"--%d,%d--",indexPath.section,indexPath.row);
    [_tableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

// 得到数据
- (void)getData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL isLimitNoActivated = NO;
        if (self.accessType == AccessPageTypeChoiceMember || self.accessType == AccessPageTypeAddMemberList || self.accessType == AccessPageTypeChat) {
            isLimitNoActivated = YES;
        }
        
        // 根据数据首字母排列数据 该方法中读取了联系人列表
        self.dataDict = [YLDataObj LMaccordingFirstLetterGetTipsWithOutSelf:isLimitNoActivated];
        
        self.keyArr = [[[self.dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)]mutableCopy];
        
        // 获取所有名字
        for (int i =0; i<self.keyArr.count; i++) {
            [_memberArr addObjectsFromArray:[self.dataDict objectForKey:[self.keyArr objectAtIndex:i]]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableview reloadData];
            
        });
        
        [self getAllIndexPathsInTable];
    });
}

#pragma mark - tableview

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView != _searchCtl.searchResultsTableView) {
        return self.keyArr.count;
    }else{
        return 1;
    }
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView != _searchCtl.searchResultsTableView) {
        NSArray *arr = [self.dataDict objectForKey:[self.keyArr objectAtIndex:section]];
        return  arr.count;
    }
    return _searchResultArr.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView != _searchCtl.searchResultsTableView) {
        return [self.keyArr objectAtIndex:section];
    }
    return nil;
}

// 返回header视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KUIScreenWidth, 40.f)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10.f, -5.f,KUIScreenWidth, 30.f)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor =  [[ThemeManager shareInstance] getColorWithName:@"COLOR_LISTTXT"];
//    label.textColor = COLOR_GRAY2;
    label.font = [UIFont systemFontOfSize:14];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    [arr addObjectsFromArray:self.keyArr];
    
    if ([_searchBar.text length] <= 0) {
        
        for (int i =0; i<arr.count; i++) {
            
            label.text = [NSString stringWithFormat:@"%@",[arr objectAtIndex:section]];
            
        }
    }else{
        label.text = @"搜索结果";
    }
    [view addSubview:label];
    
    //    view.backgroundColor = RGBACOLOR(38, 41, 45, 1);
    view.backgroundColor = [UIColor colorWithPatternImage:[[ThemeManager shareInstance] getThemeImage:@"under_bar.png"]];
    
    [label release], label = nil;
    
    return [view autorelease];
}

// 返回索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView != _searchCtl.searchResultsTableView) {
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        
        [arr addObjectsFromArray:self.keyArr];
        
        return arr;
    }else{
        return nil;
    }
}

-(NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (tableView == _searchCtl.searchResultsTableView) {
        return 0;
    }
    
    UIView *letterView = [self.view viewWithTag:1000];
    UILabel *letterLabel = (UILabel *)[letterView viewWithTag:1001];
	letterView.alpha = 1.0;
	letterLabel.text = title;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	letterView.alpha = 0.0;
	[UIView commitAnimations];
    
    return index;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = @"choiceLMCell";
    choiceLMCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[choiceLMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
//    移除重用的选中图，重置cell可点状态
    for (UIView* v in cell.contentView.subviews) {
        if (v.tag == 10000) {
            [v removeFromSuperview];
        }
    }
    cell.userInteractionEnabled = YES;
    
    if (tableView != _searchCtl.searchResultsTableView) {
        
        NSArray *arr = [self.dataDict objectForKey:[self.keyArr objectAtIndex:indexPath.section]];
        
        NSDictionary* dic = [arr objectAtIndex:indexPath.row];
        
        cell.userNameLab.text = [NSString stringWithFormat:@"%@  %@",[dic objectForKey:@"realname"],[dic objectForKey:@"role"]];
        cell.company_nameLab.text = [dic objectForKey:@"company_name"];
        
        NSURL* urlStr = [NSURL URLWithString:[dic objectForKey:@"portrait"]];
        
        if ([[dic objectForKey:@"sex"] intValue] == 1) {
            
            [cell.userHearV setImageWithURL:urlStr placeholderImage:IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME)];
        }else{
            [cell.userHearV setImageWithURL:urlStr placeholderImage:IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME)];
        }
        
//         已经在圈子里面的人不可以再邀请
        if (self.invitedArr.count) {
            for (NSDictionary* memDic in self.invitedArr) {
                if ([[dic objectForKey:@"user_id"] intValue] == [[memDic objectForKey:@"user_id"] intValue]) {
                    
                    UIImageView* invitedImgV = [[UIImageView alloc] init];
                    invitedImgV.frame = cell.selectImgV.frame;
                    invitedImgV.image = IMGREADFILE(@"btn_group_select_gray.png");
                    invitedImgV.tag = 10000;
                    [cell.contentView addSubview:invitedImgV];
                    [invitedImgV release];
                    
                    cell.userInteractionEnabled = NO;
                }
            }
        }
        
//         用户自己默认选中并且不可选
        if ([[dic objectForKey:@"user_id"] intValue] == [[Global sharedGlobal].user_id intValue]) {
            UIImageView* invitedImgV = [[UIImageView alloc] init];
            invitedImgV.frame = cell.selectImgV.frame;
            invitedImgV.image = IMGREADFILE(@"btn_group_select_gray.png");
            invitedImgV.tag = 10000;
            [cell.contentView addSubview:invitedImgV];
            [invitedImgV release];
            
            cell.userInteractionEnabled = NO;
        }
    }else{
        //搜索结果列表
        NSDictionary* dic = [_searchResultArr objectAtIndex:indexPath.row];
//        [cell hiddenSelectImgv];
        
        cell.userNameLab.text = [dic objectForKey:@"realname"];
        cell.company_nameLab.text = [dic objectForKey:@"company_name"];
        
        NSURL* urlStr = [NSURL URLWithString:[dic objectForKey:@"portrait"]];
        UIImage* placeHolderImg = nil;
        if ([[dic objectForKey:@"sex"] intValue] == 1) {
            placeHolderImg = IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME);
        }else{
            placeHolderImg = IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME);
        }
        
        [cell.userHearV setImageWithURL:urlStr placeholderImage:placeHolderImg];
        
        NSLog(@"_searchResultArr%@",_searchResultArr);
        
        if ([_selectedIndexPaths containsObject:[_searchSelectIndexPaths objectAtIndex:indexPath.row]]) {
            cell.selected = YES;
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        
//         已经在圈子里面的人不可以再邀请
        if (self.invitedArr.count) {
            for (NSDictionary* memDic in self.invitedArr) {
                if ([[dic objectForKey:@"user_id"] intValue] == [[memDic objectForKey:@"user_id"] intValue]) {
                    
                    UIImageView* invitedImgV = [[UIImageView alloc] init];
                    invitedImgV.frame = cell.selectImgV.frame;
                    invitedImgV.image = IMGREADFILE(@"btn_group_select_gray.png");
                    invitedImgV.tag = 10000;
                    [cell.contentView addSubview:invitedImgV];
                    [invitedImgV release];
                    
                    cell.userInteractionEnabled = NO;
                }
            }
        }
        
//         用户自己默认选中并且不可选
        if ([[dic objectForKey:@"user_id"] intValue] == [[Global sharedGlobal].user_id intValue]) {
            
            UIImageView* invitedImgV = [[UIImageView alloc] init];
            invitedImgV.frame = cell.selectImgV.frame;
            invitedImgV.image = IMGREADFILE(@"btn_group_select_gray.png");
            invitedImgV.tag = 10000;
            [cell.contentView addSubview:invitedImgV];
            [invitedImgV release];
            
            cell.userInteractionEnabled = NO;
        }
        
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

//正选加进数组
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_selectedArr.count + self.invitedArr.count >= MaxMemberLimite) {
        UIAlertView * maxMemberLimite = [[UIAlertView alloc]initWithTitle:@"人数已满" message:@"圈子人员数已达上限50人" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [maxMemberLimite show];
        RELEASE_SAFE(maxMemberLimite);
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    if (tableView != _searchCtl.searchResultsTableView) {
        NSLog(@"+++Table+++");
        [_selectedArr removeAllObjects];
        [_selectedIndexPaths removeAllObjects];
        [_selectedNames removeAllObjects];
        
        NSArray* indexs = [tableView indexPathsForSelectedRows];
        for (NSIndexPath* index in indexs) {
            NSArray *arr = [self.dataDict objectForKey:[self.keyArr objectAtIndex:index.section]];
            
            NSDictionary* dic = [arr objectAtIndex:index.row];
            
            [_selectedArr addObject:dic];
            
            [_selectedNames addObject:[dic objectForKey:@"realname"]];
            
            [_selectedIndexPaths addObject:index];
            
            [self layoutBtmScroll];
        }
    }else if (self.isStartChat) {
        
        NSDictionary * dic = [_searchResultArr objectAtIndex:indexPath.row];
        [_selectedArr addObject:dic];
        [_selectedNames addObject:[dic objectForKey:@"realname"]];
        
        [_selectedIndexPaths addObject:[_searchSelectIndexPaths objectAtIndex:indexPath.row]];
        [self layoutBtmScroll];
        
    }
    else  {
        NSLog(@"+++searchResultTable+++");
        NSDictionary * dic = [_searchResultArr objectAtIndex:indexPath.row];
        [_selectedArr addObject:dic];
        [_selectedNames addObject:[dic objectForKey:@"realname"]];
        
        [_selectedIndexPaths addObject:[_searchSelectIndexPaths objectAtIndex:indexPath.row]];
        [self layoutBtmScroll];
    }
    
}

//反选移出数组
-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _searchCtl.searchResultsTableView) {
        
        if (self.isStartChat){
            NSDictionary *dic = [_searchResultArr objectAtIndex:indexPath.row];
            
            [_selectedArr removeObject:dic];
            
            [_selectedNames removeObject:[dic objectForKey:@"realname"]];
            
            [_selectedIndexPaths removeObject:[_searchSelectIndexPaths objectAtIndex:indexPath.row]];
            
            [self layoutBtmScroll];
        }else{
            NSDictionary *dic = [_searchResultArr objectAtIndex:indexPath.row];
            
            [_selectedArr removeObject:dic];
            
            [_selectedNames removeObject:[dic objectForKey:@"realname"]];
            
            [_selectedIndexPaths removeObject:[_searchSelectIndexPaths objectAtIndex:indexPath.row]];
            
            [self layoutBtmScroll];
        }
    }else{
        NSArray *arr = [self.dataDict objectForKey:[self.keyArr objectAtIndex:indexPath.section]];
        NSDictionary* dic = [arr objectAtIndex:indexPath.row];
        
        [_selectedArr removeObject:dic];
        
        [_selectedNames removeObject:[dic objectForKey:@"realname"]];
        
        [_selectedIndexPaths removeObject:indexPath];
        
        [self layoutBtmScroll];
    }
    
}

#pragma mark - searDisplay

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    UITableView *tableView1 = controller.searchResultsTableView;
    tableView1.frame = CGRectMake(0, 0, KUIScreenWidth, KUIScreenHeight);
    
    [controller.searchContentsController.view addSubview:[self.view viewWithTag:kButtonViewTag]];
    if ([_searchResultArr count] == 0) {
        
        
        for( UIView *subview in tableView1.subviews ) {
            
            if([subview isKindOfClass:[UILabel class]]) {
                
                UILabel *lbl = (UILabel*)subview; // sv changed to subview.
                
                lbl.text = [NSString stringWithFormat:@"没有找到\"%@\"相关的联系人",_searchBar.text];
                
            }
        }
    }
    // Return YES to cause the search result table view to be reloaded.
    
    return YES;
    
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    UISearchBar *searchBar = controller.searchBar;
    
    [searchBar setShowsCancelButton:YES animated:NO];
    
    // 改变cannel按钮的文字 ios 5.0, 6.0
    for (UIView *subView in searchBar.subviews)
    {
        // 获得UINavigationButton按钮，也就是Cancel按钮对象，并修改此按钮的各项属性
        if ([subView isKindOfClass:[UIButton class]]) {
            
            UIButton *cannelButton = (UIButton*)subView;
            
            [cannelButton setTitle:@"取消" forState:UIControlStateNormal];
            break;
        }
    }
    
    // 改变cannel按钮的文字,7.0
    UIView *subView0 = searchBar.subviews[0]; // IOS7.0中searchBar组成复杂点
    
    if (IOS_VERSION_7) {
        
        for (UIView *subView in subView0.subviews)
        {
            // 获得UINavigationButton按钮，也就是Cancel按钮对象，并修改此按钮的各项属性
            if ([subView isKindOfClass:[UIButton class]]) {
                
                UIButton *cannelButton = (UIButton*)subView;
                [cannelButton setTitle:@"取消"forState:UIControlStateNormal];
                
                break;
            }
        }
    }
}

#define SearchPlaceHolderBtnTag 9999

//重置底部联系人scrollView
- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView{
    UIButton* btn = (UIButton*)[controller.searchResultsTableView viewWithTag:SearchPlaceHolderBtnTag];
    [btn removeFromSuperview];
    
    for (NSIndexPath* indexPath in allIndexPaths) {
        UITableViewCell* cell = [_tableview cellForRowAtIndexPath:indexPath];
        
        [_tableview deselectRowAtIndexPath:indexPath animated:YES];
        
        if ([_selectedIndexPaths containsObject:indexPath]) {
            
            [cell setSelected:YES animated:YES];
            
            [_tableview selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

-(void) searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
//    [self addPlaceBtnAfterSearch];
}

-(void) afterSearchHideKeyBoard{
    [_searchBar resignFirstResponder];
    UIButton* btn = (UIButton*)[_searchCtl.searchResultsTableView viewWithTag:SearchPlaceHolderBtnTag];
    [btn removeFromSuperview];
}

-(void) addPlaceBtnAfterSearch{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, KUIScreenWidth, KUIScreenHeight - 216);
    btn.tag = SearchPlaceHolderBtnTag;
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(afterSearchHideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [_searchCtl.searchResultsTableView addSubview:btn];
}

-(BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self addPlaceBtnAfterSearch];
    return YES;
}

-(BOOL) searchBarShouldEndEditing:(UISearchBar *)searchBar{
    UIButton* btn = (UIButton*)[_searchCtl.searchResultsTableView viewWithTag:SearchPlaceHolderBtnTag];
    [btn removeFromSuperview];
    
    return YES;
}

-(void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    _searchBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);
}
#pragma mark - search

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self doSearch];
}
//执行搜索方法
-(void) doSearch{
    [_searchResultArr removeAllObjects];
    [_searchSelectIndexPaths removeAllObjects];
    
    NSArray *allContactsArr = [NSArray arrayWithArray:_memberArr];
    
    NSMutableArray* allContactAndCompanyArr = [NSMutableArray arrayWithCapacity:allContactsArr.count];
    
    for (NSDictionary* dic in allContactsArr) {
        NSString* str = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"realname"],[dic objectForKey:@"company_name"]];
        [allContactAndCompanyArr addObject:str];
    }
    
    if (_searchBar.text.length > 0 && ![Common isIncludeChineseInString:_searchBar.text]) {
        
        for (int i=0; i<allContactAndCompanyArr.count; i++) {
            
            // 判断NSString中的字符是否为中文
            if ([Common isIncludeChineseInString:allContactAndCompanyArr[i]]) {
                
                // 转换为拼音
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:allContactAndCompanyArr[i]];
                
                // 搜索是否在转换后拼音中
                NSRange titleResult=[tempPinYinStr rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length>0) {
                    
                    [_searchResultArr addObject:allContactsArr[i]];
                    [_searchSelectIndexPaths addObject:allIndexPaths[i]];
                    
                }else{
                    // 转换为拼音的首字母
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:allContactAndCompanyArr[i]];
                    
                    // 搜索是否在范围中
                    NSRange titleHeadResult = [tempPinYinHeadStr rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
                    
                    if (titleHeadResult.length>0) {
                        [_searchResultArr addObject:allContactsArr[i]];
                        [_searchSelectIndexPaths addObject:allIndexPaths[i]];
                    }
                }
                
            }
            else {
                
                NSRange titleResult=[allContactAndCompanyArr[i] rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length>0) {
                    [_searchResultArr addObject:allContactsArr[i]];
                    [_searchSelectIndexPaths addObject:allIndexPaths[i]];
                }
            }
        }
    } else if (_searchBar.text.length>0&&[Common isIncludeChineseInString:_searchBar.text]) {
        
        for (int i=0; i<allContactsArr.count; i++) {
            NSString *tempStr = allContactAndCompanyArr[i];
            
            NSRange titleResult=[tempStr rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
            
            if (titleResult.length>0) {
                [_searchResultArr addObject:[allContactsArr objectAtIndex:i]];
                [_searchSelectIndexPaths addObject:[allIndexPaths objectAtIndex:i]];
            }
        }
    }
    [_searchCtl.searchResultsTableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    RELEASE_SAFE(_buttomView);
    RELEASE_SAFE(_searchCtl);
    RELEASE_SAFE(_tableview);
    RELEASE_SAFE(_searchBar);
    RELEASE_SAFE(_memberArr);
    RELEASE_SAFE(_searchResultArr);
    RELEASE_SAFE(_redLab);
    RELEASE_SAFE(_keyArr);
    RELEASE_SAFE(_dataDict);
    RELEASE_SAFE(_selectedNames);
    RELEASE_SAFE(allIndexPaths);
    RELEASE_SAFE(_selectedIndexPaths);
    RELEASE_SAFE(_selectedArr);
    [super dealloc];
}

@end
