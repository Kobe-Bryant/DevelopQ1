//
//  choiceCityViewController.m
//  ql
//
//  Created by yunlai on 14-4-12.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "choiceCityViewController.h"

#import "choiceCLCell.h"

@interface choiceCityViewController (){
    NSMutableArray* selectedCitysArr;
}

@property (nonatomic,retain) UITableView *cityTableView;
@property (nonatomic,retain) UITableView *currentTableView;
@property (nonatomic,retain) UISearchBar *searchBar;
@property (nonatomic,retain) UISearchDisplayController *searchDisplay;

@property (nonatomic,retain) NSArray *hotCitys;
@property (nonatomic,retain) NSArray *searchCityList;
@property (nonatomic,retain) NSMutableDictionary *cityDic;
@property (nonatomic,retain) NSArray *keyList;

@property(nonatomic,retain) UILabel* redLab;
@property(nonatomic,retain) UIScrollView* btmScroll;
@property(nonatomic,retain) UILabel* sclLab;

@end

@implementation choiceCityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        selectedCitysArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"指定城市";
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    //初始化导航条
    [self initNavBar];
    
    self.hotCitys = [[NSArray alloc]initWithObjects:@"上海",@"北京",@"广州",@"深圳",@"成都",@"重庆",@"天津",@"杭州",@"南京",@"苏州",@"武汉",@"西安", nil];
    //获取城市数据
    [self getCityData];
    //配置主视图
    [self setup];
    
    if (_cityType == CityTableTypeMutil) {
        //初始化底部多选框
        [self initButtom];
    }else{
        //设置列表单选
        [self initSingleSelectTable];
    }
    
	// Do any additional setup after loading the view.
}

//设置列表单选
-(void) initSingleSelectTable{
    _cityTableView.frame = CGRectMake(0.0, 44, self.view.bounds.size.width, self.view.bounds.size.height - KUpBarHeight - 64);
    _cityTableView.allowsMultipleSelection = NO;
}

//初始化导航条
-(void) initNavBar{
    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 30, 30, 30);
    [leftBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = KQLSystemFont(14);
    [leftBtn addTarget:self action:@selector(leftBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    RELEASE_SAFE(leftItem);
    
    if (_cityType != CityTableTypeMutil) {
        UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(0, 30, 30, 30);
        [rightBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
        rightBtn.backgroundColor = [UIColor clearColor];
        [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        rightBtn.titleLabel.font = KQLSystemFont(14);
        [rightBtn addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
        RELEASE_SAFE(rightItem);
    }
    
}

//主视图
-(void) setup{
    //初始化tableView
	self.cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 44, self.view.bounds.size.width, self.view.bounds.size.height - KUpBarHeight - 64 - 60) style:UITableViewStylePlain];
    _cityTableView.dataSource = self;
    _cityTableView.delegate = self;
    _cityTableView.allowsMultipleSelection = YES;
    _cityTableView.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    if (IOS_VERSION_7) {
        [_cityTableView setSeparatorInset:UIEdgeInsetsZero];
    }
	[self.view addSubview:_cityTableView];
    
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
	letterLabel.textAlignment = NSTextAlignmentLeft;
    letterLabel.tag = 1001;
	[letterView addSubview: letterLabel];
    [letterLabel release];
    
    letterView.tag = 1000;
    letterView.alpha = 0.0;
    [self.view addSubview:letterView];
    [letterView release];
    
    // Create a search bar
    self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, KUpBarHeight)] autorelease];
    _searchBar.placeholder = @"搜索城市";
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.keyboardType = UIKeyboardTypeDefault;
    _searchBar.delegate = self;
//    float version = [[[ UIDevice currentDevice ] systemVersion ] floatValue ];
//    if ([ _searchBar respondsToSelector : @selector (barTintColor)]) {
//        float  iosversion7_1 = 7.1 ;
//        if (version >= iosversion7_1)
//        {  //iOS7.1
//            [[[[ _searchBar . subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
//            [ _searchBar setBackgroundColor :[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
//        }
//        else
//        {
//            //iOS7.0
//            [ _searchBar setBarTintColor :[ UIColor clearColor ]];
//            [ _searchBar setBackgroundColor :[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
//        }}
//    else
//    {
//        //iOS7.0 以下
//        [[ _searchBar.subviews objectAtIndex : 0 ] removeFromSuperview ];
//        [ _searchBar setBackgroundColor :[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
//    }
    
    [self.view addSubview:self.searchBar];
    
    self.searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    _searchDisplay.delegate = self;
    _searchDisplay.searchResultsDataSource = self;
    _searchDisplay.searchResultsDelegate = self;
    
//    //添加搜索插件
//    if (_cityDic.count != 0)
//    {
//        // Create a search bar
//        self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, KUpBarHeight)] autorelease];
//        _searchBar.placeholder = @"搜索城市";
////        _searchBar.backgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"通讯录搜索背景" ofType:@"png"]];
//        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
//        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
//        _searchBar.keyboardType = UIKeyboardTypeDefault;
//        _searchBar.delegate = self;
//        [self.view addSubview:self.searchBar];
//        
//        self.searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
//        _searchDisplay.delegate = self;
//        _searchDisplay.searchResultsDataSource = self;
//        _searchDisplay.searchResultsDelegate = self;
//    }
//    else
//    {
//        [_cityTableView setFrame:CGRectMake( 0.0f , 0.0f , self.view.bounds.size.width , self.view.frame.size.height - 64)];
//    }
    
    // ios7的UITableVIew按字母排序的索引怎么改成背景是透明
    if ([_cityTableView respondsToSelector:@selector(setSectionIndexColor:)]) {
        
        _cityTableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _cityTableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        
        _cityTableView.sectionIndexColor = COLOR_GRAY2;
    }
    
    self.currentTableView = _cityTableView;
}

-(void) initButtom{
    UIView* buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 60 - 64, self.view.bounds.size.width, 60)];
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
-(void)sureButtonClick{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(didSelectedCity:)]) {
        [_delegate didSelectedCity:selectedCitysArr];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//获取城市数据
-(void)getCityData
{
    // 根据城市首字母排列数据
//    self.cityDic = [CityDataObject accordingFirstLetterGetCity];
    [_cityDic removeObjectForKey:@""];
    
    self.keyList = [[_cityDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

//搜索
-(void)searchWithText:(NSString *)text
{
    NSMutableArray *searchResultList = [NSMutableArray array];
    for (NSString *str in _hotCitys)
    {
        NSRange range = [str rangeOfString:text];
        if(range.length > 0)
        {
            [searchResultList addObject:str];
        }
    }
    NSArray *keys = _cityDic.allKeys;
    for (int i = 0; i < keys.count; i++)
    {
        NSArray *array = [_cityDic objectForKey:[keys objectAtIndex:i]];
        for (NSString *str in array)
        {
            NSRange range = [str rangeOfString:text];
            if(range.length > 0)
            {
                [searchResultList addObject:str];
            }
        }
    }
    
    self.searchCityList = searchResultList;
}

#pragma mark -UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.searchDisplay.searchResultsTableView)
    {
        return 1;
    }
    else
    {
        return _keyList.count + 2;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplay.searchResultsTableView)
    {
        return nil;
    }
    else
    {
        if(section > 1)
        {
            NSString *key = [_keyList objectAtIndex:section - 2];
            return key;
        }
        else
        {
            return nil;
        }
    }
}


-(void) leftBtnCLick{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(cancelCTClick)]) {
        [_delegate cancelCTClick];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 返回header视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == self.searchDisplay.searchResultsTableView)
    {
        return nil;
    }
    else
    {
        UIView *view = nil;
        if(section == 0)
        {
//            view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 40.0f)];
//            view.backgroundColor = kColorRGB(246.0f / 255.0f, 246.0f / 255.0f, 246.0f / 255.0f, 1.0);
//            
//            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getCurrentCity)];
//            
//            NSString *currentCity = nil;
//            if (![CLLocationManager locationServicesEnabled]
//                || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [[Global sharedGlobal].currCity isEqualToString:@"暂时无法获取到位置"])
//            {
//                currentCity = @"无法定位当前城市,请稍候再试";
//                [view removeGestureRecognizer:tapGesture];
//            }
//            else
//            {
//                currentCity = [Global sharedGlobal].currCity;
//                [view addGestureRecognizer:tapGesture];
//            }
//            [tapGesture release];
//            
//            UIFont *font = [UIFont systemFontOfSize:15.0f];
//            CGSize textSize = [currentCity sizeWithFont:font];
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 0.f, textSize.width, view.bounds.size.height)];
//            label.font = font;
//            label.backgroundColor = [UIColor clearColor];
//            label.textColor = [UIColor blackColor];
//            label.text = currentCity;
//            [view addSubview:label];
//            [label release];
//            
//            //图片
//            UIImage *locImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"eatShow_address_icon" ofType:@"png"]];
//            UIImageView *locImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15.0 + textSize.width, (40.0f - locImage.size.height) / 2.0f, locImage.size.width,locImage.size.height)];
//            locImageView.image = locImage;
//            [view addSubview:locImageView];
//            [locImageView release];
            
            view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 25.0f)];
            view.backgroundColor = kColorRGB(224.0f / 255.0f, 224.0f / 255.0f, 224.0f / 255.0f, 1.0);
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 0.f, view.bounds.size.width - 20.0f, view.bounds.size.height)];
            label.font = [UIFont systemFontOfSize:14.0f];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];
            label.text = @"定位城市";
            [view addSubview:label];
            [label release];
            
        }
        else if (section == 1)
        {
            view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 25.0f)];
            view.backgroundColor = kColorRGB(224.0f / 255.0f, 224.0f / 255.0f, 224.0f / 255.0f, 1.0);
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 0.f, view.bounds.size.width - 20.0f, view.bounds.size.height)];
            label.font = [UIFont systemFontOfSize:14.0f];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];
            label.text = @"热门城市";
            [view addSubview:label];
            [label release];
        }
        return view;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == self.searchDisplay.searchResultsTableView)
    {
        return 0.0f;
    }
    else
    {
        if(section == 0)
        {
            return 25.0f;
        }
        else if(section == 1)
        {
            return 25.0f;
        }
        else
        {
            return 20.0f;
        }
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplay.searchResultsTableView)
    {
        return nil;
    }
    else
    {
        NSMutableArray *array = [NSMutableArray arrayWithArray:_keyList];
        [array insertObject:@"热门" atIndex:0];
        return array;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplay.searchResultsTableView)
    {
        return _searchCityList.count;
    }
    else
    {
        if(section == 0)
        {
            return 1;
        }
        else if (section == 1)
        {
            return _hotCitys.count;
        }
        else
        {
            NSString *key = [_keyList objectAtIndex:section - 2];
            NSArray *memberSectionArray = [_cityDic objectForKey:key];
            
            return memberSectionArray.count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(tableView == self.searchDisplay.searchResultsTableView)
    {
        //记录
        return 50.0f;
    }
    else
    {
        //没有记录
        return 45.0f;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    UIView *letterView = [self.view viewWithTag:1000];
    UILabel *letterLabel = (UILabel *)[letterView viewWithTag:1001];
	letterView.alpha = 1.0;
	letterLabel.text = title;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	letterView.alpha = 0.0;
	[UIView commitAnimations];
	
	return (NSInteger)[_keyList indexOfObject:title] + 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"";
	choiceCLCell *cell = nil;
    
    NSArray *memberSectionArray = nil;
    
    if(tableView == self.searchDisplay.searchResultsTableView)
    {
        if (_searchCityList != nil && _searchCityList.count > 0)
        {
            //记录
            cellIdentifier = @"listCell";
            memberSectionArray = _searchCityList;
        }
        else
        {
            //没有记录
            cellIdentifier = @"noneCell";
            memberSectionArray = nil;
        }
    }
    else
    {
        cellIdentifier = @"listCell";
        if (indexPath.section == 0) {
            memberSectionArray = [NSArray arrayWithObject:@"深圳 "];
        }
        else if(indexPath.section == 1)
        {
            memberSectionArray = _hotCitys;
        }
        else
        {
            NSString *key = [_keyList objectAtIndex:indexPath.section - 2];
            memberSectionArray = [_cityDic objectForKey:key];
        }
    }
	
	cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[[choiceCLCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    
    if(tableView == self.searchDisplay.searchResultsTableView)
    {
        if(_searchCityList != nil && _searchCityList.count == 0)
        {
            UILabel *noneLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 300, 30)];
            noneLabel.tag = 201;
            [noneLabel setFont:[UIFont systemFontOfSize:12.0f]];
            noneLabel.textColor = [UIColor colorWithRed:0.3 green: 0.3 blue: 0.3 alpha:1.0];
            noneLabel.text = @"没找到相关记录！";
            noneLabel.textAlignment = UITextAlignmentCenter;
            noneLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:noneLabel];
            [noneLabel release];
        }
        else
        {
            cell.circleName.text = [memberSectionArray objectAtIndex:indexPath.row];
        }
    }
    else
    {
        cell.circleName.text = [memberSectionArray objectAtIndex:indexPath.row];
    }
    
    cell.circleName.textColor = [UIColor darkGrayColor];
    cell.circleName.textAlignment = UITextAlignmentLeft;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectText = nil;
    if(tableView == self.searchDisplay.searchResultsTableView)
    {
        selectText = [_searchCityList objectAtIndex:indexPath.row];
    }
    else
    {
        if (indexPath.section == 0) {
            selectText = @"深圳 ";
        }
        else if(indexPath.section == 1)
        {
            selectText = [_hotCitys objectAtIndex:indexPath.row];
        }
        else if(indexPath.section > 1)
        {
            NSArray *array = [_cityDic objectForKey:[_keyList objectAtIndex:indexPath.section - 2]];
            selectText = [array objectAtIndex:indexPath.row];
        }
        
        if (_cityType == CityTableTypeSingle) {
            [selectedCitysArr removeAllObjects];
            [selectedCitysArr addObject:selectText];
        }else if (_cityType == CityTableTypeMutil) {
            [selectedCitysArr addObject:selectText];
            [self layButtomLabel];
        }
        
    }
    
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *selectText = nil;
    if(tableView == self.searchDisplay.searchResultsTableView)
    {
        selectText = [_searchCityList objectAtIndex:indexPath.row];
    }
    else
    {
        if (indexPath.section == 0) {
            selectText = @"深圳 ";
        }
        else if(indexPath.section == 1)
        {
            selectText = [_hotCitys objectAtIndex:indexPath.row];
        }
        else if(indexPath.section > 1)
        {
            NSArray *array = [_cityDic objectForKey:[_keyList objectAtIndex:indexPath.section - 2]];
            selectText = [array objectAtIndex:indexPath.row];
        }
        
        [selectedCitysArr removeObject:selectText];
        
        [self layButtomLabel];
        
    }
}

-(void) layButtomLabel{
    
    for (UIView* v in _btmScroll.subviews) {
        [v removeFromSuperview];
    }
    
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    [arr addObjectsFromArray:selectedCitysArr];
    NSString* str = nil;
    
    UIImageView* addImgV = [[UIImageView alloc] initWithImage:[[ThemeManager shareInstance] getThemeImage:@"bg_group_dotted_square.png"]];
    addImgV.frame = CGRectMake(5, 5, 30, 30);
    [_btmScroll addSubview:addImgV];
    RELEASE_SAFE(addImgV);
    
    CGFloat offx = 50;
    
    for (int i = 0; i < arr.count; i++) {
        str = [arr objectAtIndex:(arr.count - 1 - i)];
        
        CGSize size = [str sizeWithFont:KQLboldSystemFont(13) constrainedToSize:CGSizeMake(100, 40) lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel* lab = [[UILabel alloc] init];
        lab.textAlignment = UITextAlignmentCenter;
        lab.textColor = [UIColor whiteColor];
        lab.text = str;
        lab.frame = CGRectMake(offx, 5, size.width + 20, 30);
        lab.backgroundColor = [UIColor darkGrayColor];
        lab.layer.cornerRadius = 5.0;
        
        offx += 5 + size.width + 20;
        
        [_btmScroll addSubview:lab];
        RELEASE_SAFE(lab);
        
    }
    
    RELEASE_SAFE(arr);
    
    _btmScroll.contentSize = CGSizeMake(offx + 60, _btmScroll.bounds.size.height);
    [_btmScroll setContentOffset:CGPointMake(5, 0) animated:YES];
    
    _redLab.text = [NSString stringWithFormat:@"%d",selectedCitysArr.count];
    if ([_redLab.text isEqualToString:@"0"]) {
        _redLab.hidden = YES;
    }else{
        _redLab.hidden = NO;
    }
}

-(void) addStringInSclLab{
//    NSString* str = nil;
//    NSMutableArray* arr = [[NSMutableArray alloc] init];
//    [arr addObjectsFromArray:selectedCitysArr];
//    for (NSString* s in arr) {
//        if (str == nil) {
//            str = s;
//        }else{
//            str = [NSString stringWithFormat:@"%@,%@",str,s];
//        }
//    }
//    _sclLab.text = str;
}

#pragma mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.currentTableView = self.searchDisplay.searchResultsTableView;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
}

#pragma mark UISearchDisplayController
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self searchWithText:searchString];
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    
    [self searchWithText:[_searchDisplay.searchBar text]];
    
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    self.currentTableView = _cityTableView;
    self.searchCityList = nil;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
	//end do any thing...
}

-(void)dealloc
{
    self.cityTableView = nil; [_cityTableView release];
    self.currentTableView = nil; [_currentTableView release];
    self.searchBar = nil; [_searchBar release];
    self.searchDisplay = nil; [_searchDisplay release];
    
    self.hotCitys = nil; [_hotCitys release];
    self.searchCityList = nil; [_searchCityList release];
    self.cityDic = nil; [_cityDic release];
    self.keyList = nil; [_keyList release];
    
    [super dealloc];
}

@end
