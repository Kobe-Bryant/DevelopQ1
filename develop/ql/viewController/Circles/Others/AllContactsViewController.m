//
//  AllContactsViewController.m
//  ql
//
//  Created by yunlai on 14-3-11.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "AllContactsViewController.h"
#import "YLNameCardCell.h"
#import "mobileContactsCell.h"
#import "relevancyMobileCell.h"
#import "Common.h"
#import "PinYinForObjc.h"
#import "NSString+TKUtilities.h"
#import "UIImage+TKUtilities.h"
#import "org_list_model.h"
#import "YLDataObj.h"

@interface AllContactsViewController ()

@end

@implementation AllContactsViewController
@synthesize searchBar = _searchBar;
@synthesize searchDisplayCtl = _searchDisplayCtl;
@synthesize dataDict;

bool isSelect = YES;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
        self.title = @"全部联系人";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _userNames = [[NSMutableArray alloc]initWithCapacity:0];
    _namelists = [[NSMutableArray alloc]initWithCapacity:0];
    _contactList = [[NSMutableArray alloc]initWithCapacity:0];
    _moblieLists = [[NSMutableArray alloc]initWithCapacity:0];
    _allContacts = [[NSMutableArray alloc]initWithCapacity:0];
    
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, 320.f, 568.f) style:UITableViewStylePlain];
    _listTableView.dataSource = self;
    _listTableView.delegate = self;
    _listTableView.separatorColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_AUXILIARY"];
    if (IOS_VERSION_7) {
        [_listTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:_listTableView];
    
    // ios7的UITableVIew按字母排序的索引怎么改成背景是透明
    if ([_listTableView respondsToSelector:@selector(setSectionIndexColor:)]) {
        
        _listTableView.sectionIndexBackgroundColor = [UIColor clearColor];
        
        // 索引字体颜色
//        _listTableView.sectionIndexColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY2"];
        _listTableView.sectionIndexColor = COLOR_GRAY2;
    }
    
    [self searchBarInit];
    
    NSMutableArray *dataArr = [NSMutableArray arrayWithObjects:@"陈恒",@"刘海",@"张达",@"武陟神",@"沈万山",@"小怪",@"杜甫",@"ellan",@"allen",@"杨威",@"小弟",@"谌天",@"古雷",@"晁都",@"达文西",@"鹏鹏",@"李华",@"迪迪",@"牛逼", nil];
    
    [self parseData:dataArr];
    
    //数据库中读取
    org_list_model *addressMod = [[org_list_model alloc]init];
    addressMod.where =  [NSString stringWithFormat:@"position = %d",1];
    _namelists = [[addressMod getList]mutableCopy];
    RELEASE_SAFE(addressMod);
    
    NSLog(@"_namelists===%@",_namelists);
    if (_namelists.count !=0) {
        // 把数据库中数据导入
        for (int i =0; i < _namelists.count; i++) {
            
            [_moblieLists addObject:[[_namelists objectAtIndex:i] objectForKey:@"name"]];
            
        }
        
        [self parseData:_moblieLists];
    }
    
}

/**
 *  搜索框
 */
- (void)searchBarInit {
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.frame = CGRectMake(0.0f, 0.f, KUIScreenWidth, 44.0f);
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	_searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_searchBar.keyboardType = UIKeyboardTypeDefault;
	_searchBar.backgroundColor=[UIColor clearColor];
	_searchBar.translucent=YES;
	_searchBar.placeholder=@"搜索";
	_searchBar.delegate = self;
    
//    if (IOS_VERSION_7) {
//        _searchBar.barTintColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
//    }
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
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, KUIScreenWidth, 44.f)];
    _listTableView.tableHeaderView = headView;
    [headView addSubview:_searchBar];
    RELEASE_SAFE(headView);

    
    //搜索控制器
    _searchDisplayCtl = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayCtl.active = NO;
    _searchDisplayCtl.searchResultsDataSource = self;
    _searchDisplayCtl.searchResultsDelegate = self;
    _searchDisplayCtl.delegate = self;
    _searchDisplayCtl.searchResultsTableView.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
}


// 得到数据
- (void)parseData:(NSMutableArray *)userDatas
{
    NSLog(@"userDatas==%@",userDatas);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [_contactList addObjectsFromArray:userDatas];
        
        // 根据数据首字母排列数据
        self.dataDict = [YLDataObj accordingFirstLetterGetTips:_contactList];
        
        
        _contactKeys = [[[self.dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)]mutableCopy];
        
        
        // 获取所有名字
        for (int i =0; i<_contactKeys.count; i++) {
            [_allContacts addObjectsFromArray:[self.dataDict objectForKey:[_contactKeys objectAtIndex:i]]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_listTableView reloadData];
            
        });
        
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.searchDisplayCtl.searchResultsTableView) {
        return 1;
    }else{
        return _contactKeys.count + 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayCtl.searchResultsTableView) {
        
        return _searchResults.count;
        
    }else{
        if (section == 0) {
            return 1;
        }
        else if(section == 1){
            return 3;
        }
        else{
            NSArray *arr = [self.dataDict objectForKey:[_contactKeys objectAtIndex:section-2]];
            return  arr.count;
        }
    }
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //搜索结果列表
    if (tableView == self.searchDisplayCtl.searchResultsTableView) {
        
        static NSString *searchCell = @"searchCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCell];
    
        if (nil == cell) {
            
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCell]autorelease];
            
            cell.backgroundColor = [UIColor clearColor];
        }
        
        cell.textLabel.text = _searchResults[indexPath.row];
        
        return cell;
        
    }else{
        // 关联手机通讯录
        if (indexPath.section == 0) {
            
            static NSString *firstCell = @"firstCell";
            
            relevancyMobileCell *cell = [tableView dequeueReusableCellWithIdentifier:firstCell];
            
            if (nil == cell) {
                
                cell = [[[relevancyMobileCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstCell]autorelease];
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }
            cell.iconView.image = [UIImage imageNamed:@"share_txcircle_store"];

            cell.tipsLabel.text = @"关联手机通讯录";
            cell.detailLabel.text = @"可以让你更方便地查找联系人";
            
            return cell;
        }else{
            
            static NSString *contactsCell = @"contactsCell";
            
            mobileContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:contactsCell];
            
            if (nil == cell) {
                cell = [[[mobileContactsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contactsCell]autorelease];
            }
        
            
            // 收藏
            if (indexPath.section == 1) {
                
                cell.nameLabel.text = @"收藏的联系人";
                cell.headImage.image = [UIImage imageNamed:@"22.jpg"];
                
            }else{
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
                    NSArray *arr = [self.dataDict objectForKey:[_contactKeys objectAtIndex:indexPath.section - 2]];
                    //把名字和图片索引分开
            
                    NSArray *arry = [[arr objectAtIndex:indexPath.row]componentsSeparatedByString:@","];
                    
                    [_userNames addObjectsFromArray:arry];
                   
                    NSLog(@"------%@",_userNames);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        cell.nameLabel.text = [arry objectAtIndex:0];
            
//                        cell.headImage.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_GRAY"];
                        cell.headImage.backgroundColor = COLOR_GRAY;
                        
                        if (indexPath.row % 2 == 0 && isSelect) {
                            
                            cell.contentView.backgroundColor = COLOR_CONTROL;
                            
                            [self performSelector:@selector(updateBg:) withObject:cell afterDelay:2];
                        }
                        
                    });
                });
            }
           
            
            return cell;
        }

    }
    
}

- (void)updateBg:(mobileContactsCell *)cell{
    cell.contentView.backgroundColor = [UIColor clearColor];
    isSelect =NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.searchDisplayCtl.searchResultsTableView) {
       
    }else{
        if (indexPath.section == 0) {
            
            relevancyMobileCell *cell = (relevancyMobileCell*)[tableView cellForRowAtIndexPath:indexPath];
            cell.tipsLabel.text = @"正在导入中····";
            cell.detailTextLabel.hidden = YES;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                
                [self readAddressBook];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                [_listTableView reloadData];
                    
                    if (_namelists.count ==0) {
                    
                    // 把数据库中数据导入
                    for (int i =0; i < _namelists.count; i++) {
                        
                        [_moblieLists addObject:[[_namelists objectAtIndex:i] objectForKey:@"name"]];
                        
                    }
                    
                        [self parseData:_moblieLists];
                        
                    }else{
                        cell.detailTextLabel.hidden = YES;
                        cell.tipsLabel.text = [NSString stringWithFormat:@"成功导入%d个联系人",_namelists.count];
                    }
                
                });
            });
            
            
        }else{
            
            
            
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 25;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"收藏";
    }else if(section !=0 && section != 1){
        return [_contactKeys objectAtIndex:section - 2];
    }
    return nil;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    [arr addObjectsFromArray:_contactKeys];
    [arr insertObject:@"★" atIndex:0];
    return arr;

}


#pragma mark - UISearchBarDelegate

-(void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
//    if (IOS_VERSION_7) {
//        controller.searchBar.barTintColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
//    }
    
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    UISearchBar *searchBar = self.searchDisplayCtl.searchBar;
    
//    if (IOS_VERSION_7) {
//        searchBar.barTintColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBAR"];
//    }
    
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

- (void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    _searchResults = [[NSMutableArray alloc]init];
    
  
    if (self.searchBar.text.length > 0 && ![Common isIncludeChineseInString:self.searchBar.text]) {
        
        for (int i=0; i<_userNames.count; i++) {
            
            // 判断NSString中的字符是否为中文
            if ([Common isIncludeChineseInString:_userNames[i]]) {
                
                // 转换为拼音
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:_userNames[i]];
                
                // 搜索是否在转换后拼音中
                NSRange titleResult=[tempPinYinStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length>0) {
                    
                    [_searchResults addObject:_userNames[i]];
                    
                }
                
                // 转换为拼音的首字母
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:_userNames[i]];
                
                // 搜索是否在范围中
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleHeadResult.length>0) {
                    [_searchResults addObject:_userNames[i]];
                }
                
            }
            else {
                
                NSRange titleResult=[_userNames[i] rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length>0) {
                    [_searchResults addObject:_userNames[i]];
                }
            }
        }
    } else if (self.searchBar.text.length>0 && [Common isIncludeChineseInString:self.searchBar.text]) {
        
        for (NSString *tempStr in _userNames) {
            
            NSRange titleResult=[tempStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
            
            if (titleResult.length>0) {
                [_searchResults addObject:tempStr];
            }
            
        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    if ([_searchResults count] == 0) {
        
        UITableView *tableView1 = self.searchDisplayCtl.searchResultsTableView;
        
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

#pragma mark - AddressBook

- (void)readAddressBook{
   
    // Create addressbook data model
    NSMutableArray *addressBookTemp = [NSMutableArray array];
    
    ABAddressBookRef addressBooks = nil;
    
    //自iOS6.0后获取通讯录列表需要询问用户，经过用户同意后才可以获取通讯录用户列表。而且ABAddressBookRef的初始化工作也由ABAddressBookCreate函数转变为ABAddressBookCreateWithOptions函数。下面代码是兼容之前版本的获取通讯录用户列表方法。
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
    }
    else
    {
        addressBooks = ABAddressBookCreate();
    }
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    
    for (NSInteger i = 0; i < nPeople; i++)
    {
        YLAddressBook *addressBook = [[YLAddressBook alloc] init];
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        CFStringRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFStringRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
 
        NSString *nameString = (NSString *)abName;
        NSString *lastNameString = (NSString *)abLastName;

    
        if ((id)abFullName != nil) {
            nameString = (NSString *)abFullName;

        } else {
            if ((id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];

            }
        }
        
        //插入数据库
        org_list_model *addressMod = [[org_list_model alloc] init];
        
        addressMod.where = nil;
        
        NSDictionary *cardDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%d",i],@"id",
                                 nameString,@"name",
                                 @"1",@"position",
                                 nil];
        
        addressMod.where = [NSString stringWithFormat:@"id = %d",i];
        
        NSMutableArray *cardArray = [addressMod getList];
        
        if ([cardArray count] > 0)
        {
            [addressMod updateDB:cardDic];
        }
        else
        {
            [addressMod insertDB:cardDic];
        }
        
        RELEASE_SAFE(addressMod);
        
        
        addressBook.name = nameString;
        addressBook.recordID = (int)ABRecordGetRecordID(person);
        addressBook.rowSelected = NO;
        
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        addressBook.tel = [(NSString*)value telephoneWithReformat];
                        break;
                    }
                    case 1: {// Email
                        addressBook.email = (NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        
        [addressBookTemp addObject:addressBook];
        [addressBook release];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    if (allPeople !=nil && addressBooks !=nil) {
        CFRelease(allPeople);
        CFRelease(addressBooks);
    }
    
    
    // Sort data
//    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
//    for (YLAddressBook *addressBook in addressBookTemp) {
//        NSInteger sect = [theCollation sectionForObject:addressBook
//                                collationStringSelector:@selector(name)];
//        addressBook.sectionNumber = sect;
//    }
//    
//    NSInteger highSection = [[theCollation sectionTitles] count];
//    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
//    for (int i=0; i<=highSection; i++) {
//        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
//        [sectionArrays addObject:sectionArray];
//    }
//    
//    for (YLAddressBook *addressBook in addressBookTemp) {
//        [(NSMutableArray *)[sectionArrays objectAtIndex:addressBook.sectionNumber] addObject:addressBook];
//    }
//    
//    for (NSMutableArray *sectionArray in sectionArrays) {
//        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
//        [namelists addObject:sortedSection];
//    }
    
//    NSLog(@"_namelists1111==%@",_namelists);
}


@end
