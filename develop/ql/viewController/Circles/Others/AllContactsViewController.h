//
//  AllContactsViewController.h
//  ql
//
//  Created by yunlai on 14-3-11.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "YLAddressBook.h"

@interface AllContactsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    UITableView *_listTableView;
    NSMutableArray *_allContacts;
    NSMutableArray *_contactKeys;
    NSMutableArray *_userNames;
    
    UISearchBar *_searchBar;
    
    UISearchDisplayController *_searchDisplayCtl;
    
    CGFloat CtlHeight;
    
    NSMutableArray *_searchResults; // 搜索出的数据
    NSMutableArray *_namelists;     // 通讯录所有的数据库数据
    NSMutableArray *_moblieLists;   // 手机通讯录联系人
    NSMutableArray *_contactList;   // 所有联系人
}
@property (nonatomic , retain) NSMutableDictionary *dataDict;
@property (nonatomic , retain) UISearchBar *searchBar;
@property (nonatomic , retain) UISearchDisplayController *searchDisplayCtl;

@end
