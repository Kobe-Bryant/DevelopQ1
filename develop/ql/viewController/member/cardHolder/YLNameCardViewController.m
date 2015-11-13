//
//  YLNameCardViewController.m
//  CardHolderDemo
//
//  Created by yunlai on 14-1-15.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "YLNameCardViewController.h"
#import "YLNameCardCell.h"
#import "YLDataObj.h"
#import "common.h"
#import "UIImageScale.h"
#import "PinYinForObjc.h"
#import "HttpRequest.h"
#import <QuartzCore/QuartzCore.h>

@interface YLNameCardViewController ()

@end

@implementation YLNameCardViewController
@synthesize listType = _listType;
@synthesize mainView = _mainView;
@synthesize keyArr,dataDict,searchBar,nameArray,contactDic,indexP;
@synthesize searchCtl = _searchCtl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        nameArray = [[NSMutableArray alloc]initWithCapacity:0];
        
        contactDic = [[NSMutableDictionary alloc] init];
        
        checkIndexArr = [[NSMutableArray alloc]initWithCapacity:0];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.listType == 1) {
        
        self.title = @"名片夹";
        
    }else{
        
        self.title = @"高尔夫球会";
        [self createDownBar];
        
    }
    
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
//    self.view.backgroundColor = COLOR_LIGHTWEIGHT;
    
    [self createView];
    
	[self searchBarInit];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateAdd" object:checkIndexArr];
}

- (void)createView{
   
    _mainView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    _mainView.delegate = self;
    
    _mainView.dataSource = self;
    
    _mainView.backgroundColor = [UIColor clearColor];
 
    _mainView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_mainView];
    
    if (self.listType == 1) {
        _mainView.frame = CGRectMake(0, 0.f, KUIScreenWidth, KUIScreenHeight - 50.f);
    }else{
        _mainView.frame = CGRectMake(0, 0.f, KUIScreenWidth, KUIScreenHeight - 90.f);
    }
    
    // ios7的UITableVIew按字母排序的索引怎么改成背景是透明
    if (IOS_VERSION_7) {
        if ([_mainView respondsToSelector:@selector(setSectionIndexColor:)]) {
            
            _mainView.sectionIndexBackgroundColor = [UIColor clearColor];
            
            _mainView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
            
            // 索引字体颜色
//            _mainView.sectionIndexColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
            _mainView.sectionIndexColor = COLOR_GRAY2;
        }
    }
    
    
    [self getData];
}

- (void)searchBarInit {
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	searchBar.keyboardType = UIKeyboardTypeDefault;
//	searchBar.backgroundColor=[UIColor clearColor];
//	searchBar.translucent=YES;
	searchBar.placeholder=@"搜索";
	searchBar.delegate = self;
    
//    if (IOS_VERSION_7) {
//        searchBar.barTintColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
//    }
    
//    _mainView.tableHeaderView = searchBar;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, KUIScreenWidth, 44.f)];
    _mainView.tableHeaderView = headView;
    [headView addSubview:searchBar];
    RELEASE_SAFE(headView);
    

    //搜索控制器
    _searchCtl = [[UISearchDisplayController alloc]initWithSearchBar:searchBar contentsController:self];
    _searchCtl.active = NO;
    _searchCtl.searchResultsDataSource = self;
    _searchCtl.searchResultsDelegate = self;
    _searchCtl.delegate = self;
    _searchCtl.searchResultsTableView.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
    //IOS7适配
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0){
        
        searchBar.frame = CGRectMake(0.0f, 0.0f, KUIScreenWidth, 48.0f);
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }else{
        
        searchBar.frame = CGRectMake(0.0f, 0.0f, KUIScreenWidth, 44.0f);
        self.searchBar.barStyle=UIBarStyleBlackTranslucent;
        [[self.searchBar.subviews objectAtIndex:0]removeFromSuperview];

    }
        
//    [self.view addSubview:self.searchBar];
}

// 得到数据
- (void)getData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
        
        // 根据数据首字母排列数据
        self.dataDict = [YLDataObj accordingFirstLetterGetTips];
        
        [self.dataDict removeObjectForKey:@""];
        
        self.keyArr = [[self.dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        // 获取所有名字
        for (int i =0; i<self.keyArr.count; i++) {
            [self.nameArray addObjectsFromArray:[self.dataDict objectForKey:[self.keyArr objectAtIndex:i]]];
        }
        
        
        NSLog(@"keyArr====%@====%@",self.keyArr,self.nameArray);

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_mainView reloadData];
            
        });
        
        [pool release];
    });
}
//下Bar
- (void)createDownBar{
    
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, KUIScreenHeight - 90, KUIScreenWidth, 50)];
    downView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    _addScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 5, 240, 40)];
    [downView addSubview:_addScrollView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateScrollAdd:) name:@"updateAdd" object:checkIndexArr];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateScrollRemove:) name:@"updateRemove" object:checkIndexArr];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.layer.cornerRadius = 5;
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_confirmBtn setFrame:CGRectMake(CGRectGetMaxX(_addScrollView.frame)+15, 10, 50, 30)];
    [_confirmBtn setBackgroundColor:COLOR_CONTROL];
    [_confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
    [downView addSubview:_confirmBtn];
    
    _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, -5, 20, 20)];
    _numLabel.backgroundColor = [UIColor redColor];
    _numLabel.layer.cornerRadius = 10;
    _numLabel.layer.masksToBounds = YES;
    _numLabel.textColor = [UIColor whiteColor];
    _numLabel.font = [UIFont systemFontOfSize:13];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:downView];
    [downView release];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.searchBar resignFirstResponder];
}

// 下bar确定
- (void)confirmClick{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Are you OK?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

// 下bar滑动的头像点击
- (void)headButton:(UIButton *)sender{
    
    NSString *indexPaths = [NSString stringWithFormat:@"%d",sender.tag];
    
    NSString *section;
    NSString *row;
    // 超过10个section以上的判断
    switch (indexPaths.length) {
        case 3:
        {
            section = [indexPaths substringToIndex:2];
            row = [indexPaths substringFromIndex:2];
        }
            break;
        case 4:
        {
            section = [indexPaths substringToIndex:3];
            row = [indexPaths substringFromIndex:3];
        }
            break;
        default:
        {
            section = [indexPaths substringToIndex:1];
            row = [indexPaths substringFromIndex:1];
        }
            break;
    }
    // 选中某个section中的某个row 滚动到选中那行
    [_mainView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[row intValue] inSection:[section intValue]] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

// 下bar添加头像
- (void)updateScrollAdd:(NSNotification *)sender{
    
    NSLog(@"add:%@",[sender object]);
    NSArray *arr = [sender object];
    
    if (arr.count>0) {//添加人数显示
        _numLabel.text = [NSString stringWithFormat:@"%d",[arr count]];
        [_confirmBtn addSubview:_numLabel];
    }
    
    for (int i = 0; i < arr.count; i++) {
        NSString *strs = [arr objectAtIndex:i];
        NSString *section;
        NSString *row;
   
        switch (strs.length) {
            case 3:
            {
                section = [strs substringToIndex:2];
                row = [strs substringFromIndex:2];
            }
                break;
            case 4:
            {
                section = [strs substringToIndex:3];
                row = [strs substringFromIndex:3];
            }
                break;
            default:
            {
                section = [strs substringToIndex:1];
                row = [strs substringFromIndex:1];
            }
                break;
        }
        
        NSLog(@"%@==%@",section,row);
        
        NSArray *arr = [self.dataDict objectForKey:[self.keyArr objectAtIndex:[section intValue]]];
        //把名字和图片索引分开
        NSArray *arry = [[arr objectAtIndex:[row intValue]]componentsSeparatedByString:@","];
        
        UIButton *imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [imgButton setFrame:CGRectMake(5 + i * 40, 0, 35, 35)];
        imgButton.layer.cornerRadius = 18;
        imgButton.layer.masksToBounds = YES;
        [imgButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",[[arry objectAtIndex:1]intValue]]] forState:UIControlStateNormal];
        
        // 把section和row和一起作为按钮的tag
        int sectionRow = [[NSString stringWithFormat:@"%@%@",section,row]intValue];
        [imgButton setTag:sectionRow];
        [imgButton addTarget:self action:@selector(headButton:) forControlEvents:UIControlEventTouchUpInside];
        [_addScrollView addSubview:imgButton];
        
        _addScrollView.contentSize = CGSizeMake(i * 40 + 40,0);
        
        if (i>5) {//超过6个人，是下Bar滚动
            [_addScrollView setContentOffset:CGPointMake((i-6)*40+40, 0) animated:NO];
        }

    }
    
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5+arr.count*40, 0, 35, 35)];
    imgView.layer.cornerRadius = 18;
    imgView.layer.masksToBounds = YES;

    imgView.image = [[ThemeManager shareInstance] getThemeImage:@"bg_group_dotted_box.png"];

    imgView.backgroundColor = [UIColor clearColor];
    [_addScrollView addSubview:imgView];
    _addScrollView.contentSize = CGSizeMake(arr.count*40,0);
    RELEASE_SAFE(imgView);
}

- (void)updateScrollRemove:(NSNotification *)sender{
    
    NSArray *arr = [sender object];
    
    if (arr.count>0) {
        
        _numLabel.text = [NSString stringWithFormat:@"%d",[arr count]];
        [_confirmBtn addSubview:_numLabel];
        
    }else{
        
        [_numLabel removeFromSuperview];
    }
    
    NSArray *views = _addScrollView.subviews;
    for(UIImageView * view in views)
    {
        [view removeFromSuperview];
    }
    
    NSLog(@"removew%@",arr);
    for (int i = 0; i < arr.count; i++) {
        
        NSString *strs = [arr objectAtIndex:i];
        NSString *section;
        NSString *row;
        
        switch (strs.length) {
            case 3:
            {
                section = [strs substringToIndex:2];
                row = [strs substringFromIndex:2];
            }
                break;
            case 4:
            {
                section = [strs substringToIndex:3];
                row = [strs substringFromIndex:3];
            }
                break;
            default:
            {
                section = [strs substringToIndex:1];
                row = [strs substringFromIndex:1];
            }
                break;
        }
        
        NSLog(@"%@==%@",section,row);
      
        NSArray *arr = [self.dataDict objectForKey:[self.keyArr objectAtIndex:[section intValue]]];
        //把名字和图片索引分开
        NSArray *arry = [[arr objectAtIndex:[row intValue]]componentsSeparatedByString:@","];

        
        UIButton *imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [imgButton setFrame:CGRectMake(5 + i * 40, 0, 35, 35)];
        imgButton.layer.cornerRadius = 18;
        imgButton.layer.masksToBounds = YES;
        [imgButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",[[arry objectAtIndex:1]intValue]]] forState:UIControlStateNormal];
        
        // 把section和row和一起作为按钮的tag
        int sectionRow = [[NSString stringWithFormat:@"%@%@",section,row]intValue];
        [imgButton setTag:sectionRow];
        [imgButton addTarget:self action:@selector(headButton:) forControlEvents:UIControlEventTouchUpInside];
        [_addScrollView addSubview:imgButton];


        _addScrollView.contentSize = CGSizeMake(i*40+40,0);
        
        if (i>5) {//超过6个人，是下Bar滚动
            [_addScrollView setContentOffset:CGPointMake((i-6)*40+40, 0) animated:NO];
        }
  
    }
    
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5+arr.count*40, 0, 35, 35)];
    imgView.layer.cornerRadius = 18;
    imgView.layer.masksToBounds = YES;
    
    imgView.image = [[ThemeManager shareInstance] getThemeImage:@"bg_group_dotted_box.png"];
    
    imgView.backgroundColor = [UIColor clearColor];
    [_addScrollView addSubview:imgView];
    _addScrollView.contentSize = CGSizeMake(arr.count*40,0);
    RELEASE_SAFE(imgView);
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchCtl.searchResultsTableView) {
        
        return 1;
        
    }else{
        
        return self.keyArr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     if (tableView == self.searchCtl.searchResultsTableView) {
         
         return _searchResults.count;
         
     }else{
         if ([self.searchBar.text length] <= 0) {
             
             NSArray *arr = [self.dataDict objectForKey:[self.keyArr objectAtIndex:section]];
             return arr.count;
             
         } else {
             
             if (self.nameArray.count !=0) {
                 
                 return [self.nameArray count];
                 
             }else{
                 
                 return 1;
                 
             }
             
         }
     }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cellId";
    
    YLNameCardCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (nil == cell) {
        
        cell = [[[YLNameCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId]autorelease];
        cell.backgroundColor = [UIColor clearColor];
    }
    
//    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
//    cell.selectedBackgroundView.backgroundColor = COLOR_CONTROL;
    
    if (self.listType == 1) {//名片列表
        
        cell.checkIcon.frame = CGRectMake(5, 5, 0, 15);
        
    }else{//添加圈子联系人列表
        
        cell.checkIcon.frame = CGRectMake(10, 20, 20, 20);
        
    }
    
    cell.headImage.frame = CGRectMake(10+CGRectGetMaxX(cell.checkIcon.frame), 10, 40, 40);
    cell.nameLabel.frame = CGRectMake(10+CGRectGetMaxX(cell.headImage.frame), 15, 200, 30);
    
    NSString *str = [NSString stringWithFormat:@"%d%d",indexPath.section,indexPath.row];
    
    if ([checkIndexArr indexOfObject:str] == NSNotFound) {
        
//        cell.checkIcon.image = IMGREADFILE(@"btn_group_select.png");
        cell.checkIcon.image = [[ThemeManager shareInstance] getThemeImage:@"btn_group_select.png"];
        
    } else {
        
        cell.checkIcon.image = [[ThemeManager shareInstance] getThemeImage:@"btn_group_select_blue.png"];
    }
    
    
    if ([self.searchBar.text length] <= 0) {
        
        NSArray *arr = [self.dataDict objectForKey:[self.keyArr objectAtIndex:indexPath.section]];
        
        //把名字和图片索引分开
        NSArray *arry = [[arr objectAtIndex:indexPath.row]componentsSeparatedByString:@","];
        
        cell.nameLabel.text = [arry objectAtIndex:0];
        
        cell.headImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",[[arry objectAtIndex:1]intValue]]];
        
        return cell;
    }

    if (self.nameArray.count == 0) {
        
        cell.headImage.image = [UIImage imageNamed:@""];
        cell.nameLabel.text = @"没有搜索到你要的结果";
        
    }else{
        
        cell.checkIcon.hidden = YES;
        cell.nameLabel.text = _searchResults[indexPath.row];
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 30.f;
//}

// 返回header视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, 320, 40.f)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10.f, -5.f, 320-20.f, 30.f)];
    
    label.backgroundColor = [UIColor clearColor];
    
    label.textColor = [UIColor grayColor];
    
    label.font = [UIFont systemFontOfSize:14];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    [arr addObjectsFromArray:self.keyArr];
    
     if ([self.searchBar.text length] <= 0) {
         for (int i =0; i<arr.count; i++) {
             label.text = [NSString stringWithFormat:@"%@",[arr objectAtIndex:section]];
         }
     }else{
         label.text = @"搜索结果";
     }
    
    [view addSubview:label];
    
    view.backgroundColor = RGBACOLOR(37, 41, 45, 1);//[UIColor colorWithRed:232.f/255.f green:234.f/255.f blue:239.f/255.f alpha:1.f];
    
    [label release], label = nil;
    
    return [view autorelease];
}
// 返回section的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"1";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [NSString stringWithFormat:@"%d%d",indexPath.section,indexPath.row];

    if (tableView == self.searchCtl.searchResultsTableView) {
        
        
    }else{
        [self.searchBar resignFirstResponder];
        
        YLNameCardCell *cell = (YLNameCardCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if ([checkIndexArr indexOfObject:str] == NSNotFound) {
            
            [checkIndexArr addObject:str];
            
            cell.checkIcon.image = [[ThemeManager shareInstance] getThemeImage:@"btn_group_select_blue.png"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateAdd" object:checkIndexArr];
            
        } else {
            
            [checkIndexArr removeObject:str];
            
//            cell.checkIcon.image = IMGREADFILE(@"btn_group_select.png");
            cell.checkIcon.image = [[ThemeManager shareInstance] getThemeImage:@"btn_group_select.png"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateRemove" object:checkIndexArr];
        }
        
    }
    
}

// 返回索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
   
    if ([self.searchBar.text length] <= 0) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        [arr addObjectsFromArray:self.keyArr];
        
        return arr;
    }else{
        return nil;
    }
    
}

- (void)dealloc
{
    [nameArray release];
    [checkIndexArr release];
    [contactDic release];
    [_numLabel release];
    [_addScrollView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UISearchBarDelegate

-(void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
//    if (IOS_VERSION_7) {
//        controller.searchBar.barTintColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
//    }
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    UISearchBar *searchBars = self.searchCtl.searchBar;
    
    if (IOS_VERSION_7) {
        searchBars.barTintColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBAR"];
    }
    
    [searchBars setShowsCancelButton:YES animated:NO];
    
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

- (void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    _searchResults = [[NSMutableArray alloc]init];
    
    if (self.searchBar.text.length > 0 && ![Common isIncludeChineseInString:self.searchBar.text]) {
        
        for (int i=0; i<nameArray.count; i++) {
            
            // 判断NSString中的字符是否为中文
            if ([Common isIncludeChineseInString:nameArray[i]]) {
                
                // 转换为拼音
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:nameArray[i]];
                
                // 搜索是否在转换后拼音中
                NSRange titleResult=[tempPinYinStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length>0) {
                    
                    [_searchResults addObject:nameArray[i]];
                    
                }
                
                // 转换为拼音的首字母
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:nameArray[i]];
                
                // 搜索是否在范围中
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleHeadResult.length>0) {
                    [_searchResults addObject:nameArray[i]];
                }

                
            }
            else {
                
                NSRange titleResult=[nameArray[i] rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length>0) {
                    [_searchResults addObject:nameArray[i]];
                }
            }
        }
    } else if (self.searchBar.text.length>0 && [Common isIncludeChineseInString:self.searchBar.text]) {
        
        for (NSString *tempStr in nameArray) {
            
            NSRange titleResult=[tempStr rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
            
            if (titleResult.length>0) {
                [_searchResults addObject:tempStr];
            }
            
        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    if ([_searchResults count] == 0) {
        
        UITableView *tableView1 = self.searchCtl.searchResultsTableView;
        
        for( UIView *subview in tableView1.subviews ) {
            
            if([subview isKindOfClass:[UILabel class]]) {
                
                UILabel *lbl = (UILabel*)subview; // sv changed to subview.
                
                lbl.text = @"没有你要搜索的结果";
                
            }
        }
    }
    // Return YES to cause the search result table view to be reloaded.
    return YES;
    
}


#pragma mark - accessService

- (void)accessService{
    
    NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        
                                        nil];
	
	[[NetManager sharedManager]accessService:jsontestDic data:nil command:MEMBER_INVITED_COMMAND_ID accessAdress:@"" delegate:self withParam:nil];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
    
    if (![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        
        int resultInt = [[[resultArray objectAtIndex:0] objectForKey:@"ret"]intValue];
        NSLog(@"resultInt=%d",resultInt);
        switch (commandid) {
            case MEMBER_INVITED_COMMAND_ID:
            {
                if (resultInt == 0) {
                    [self performSelectorOnMainThread:@selector(getCodeError) withObject:nil waitUntilDone:NO];
                    
                }else if(resultInt == 1){
                    
                    [self performSelectorOnMainThread:@selector(getCodeSuccess) withObject:nil waitUntilDone:NO];
                }
            }break;
                
            default:
                break;
        }
        
    }else{
        
        UIImage *img = [UIImage imageCwNamed:@"icon_tip_normal.png"];
        
        if ([Common connectedToNetwork]) {
            // 网络繁忙，请重新再试
            [Common checkProgressHUD:@"当前网络不可用，请检查你的网络设置" andImage:img showInView:self.view];
        } else {
            // 当前网络不可用，请重新再试
            
            [Common checkProgressHUD:KCWNetNOPrompt andImage:img showInView:self.view];
        }
        
    }
}

- (void)getCodeError{
    
}


- (void)getCodeSuccess{
    
}



@end
