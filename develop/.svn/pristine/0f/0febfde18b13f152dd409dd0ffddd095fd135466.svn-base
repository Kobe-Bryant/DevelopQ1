//
//  assignRangeViewController.m
//  ql
//
//  Created by yunlai on 14-4-3.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "assignRangeViewController.h"
#import "choicelinkmanViewController.h"
#import "CRNavigationController.h"
#import "choiceCircleViewController.h"
#import "choiceCityViewController.h"

#import "Common.h"
#import "MBProgressHUD.h"

#import "dynamic_commonUseCircle_model.h"
#import "dynamic_commonUseCity_model.h"
#import "dynamic_commonUseLinkman_model.h"

#import "SDImageCache.h"
#import "UIImageScale.h"

#import "upLoadPicManager.h"

#import "org_list_model.h"

@interface assignRangeViewController ()<choiceCircleDelegate,choiceLMDelegate,choiceCityDelegate>{
    int see_type;//可见类型
    MBProgressHUD* hud;//指示器
    
    BOOL hideCircle;
}

@property(nonatomic,retain) UITableView* tableview;
@property(nonatomic,retain) NSMutableDictionary* commonUserArr;//常用的范围字典

@property(nonatomic,retain) NSMutableArray* selectedLMArr;//选择的联系人数组
@property(nonatomic,retain) NSMutableArray* selectedCLArr;//选择的圈子数组
@property(nonatomic,retain) NSMutableArray* selectedORGArr;//选择的组织数组
@property(nonatomic,retain) NSMutableArray* selectedCTArr;//选择的城市数组
@property(nonatomic,retain) NSMutableArray* commonUseKeys;//常用的范围key数组

@end

@implementation assignRangeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _commonUseKeys = [[NSMutableArray alloc] init];
        _commonUserArr = [[NSMutableDictionary alloc] init];
        _selectedLMArr = [[NSMutableArray alloc] init];
        _selectedCLArr = [[NSMutableArray alloc] init];
        _selectedORGArr = [[NSMutableArray alloc] init];
        _selectedCTArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    see_type = [[NSUserDefaults standardUserDefaults] integerForKey:@"dy_see_type"];
    //上次选择联系人，则默认选择上次选的联系人
    if (see_type == 1) {
        see_type = 4;
    }else if (see_type == 2) {
        see_type = 5;
    }
    
    hideCircle = [org_list_model isOnlyOneOrg];
    
    if (hideCircle) {
        see_type = 0;
    }
    
    self.navigationItem.title = @"可见范围";
//    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    self.view.backgroundColor = COLOR_LIGHTWEIGHT;
    
    [self initNavigateBar];
    
    [self getCommonRange];
    
    [self createTable];
	// Do any additional setup after loading the view.
}

//获取常选范围
-(void) getCommonRange{
    //查询圈子，type:1圈子，2组织
    dynamic_commonUseCircle_model* cMod = [[dynamic_commonUseCircle_model alloc] init];
    NSArray* clArr = [cMod getList];
    if (clArr.count) {
        [_commonUserArr setObject:[clArr firstObject] forKey:@"circle"];
        [_commonUseKeys addObject:@"circle"];
    }
    
    [cMod release];
    
    dynamic_commonUseLinkman_model* lMod = [[dynamic_commonUseLinkman_model alloc] init];
    NSArray* lkArr = [lMod getList];
    if (lkArr.count) {
        [_commonUserArr setObject:[lkArr firstObject] forKey:@"linkman"];
        [_commonUseKeys addObject:@"linkman"];
    }
    
    [lMod release];
    
    dynamic_commonUseCity_model* ctMod = [[dynamic_commonUseCity_model alloc] init];
    NSArray* ctArr = [ctMod getList];
    if (ctArr.count) {
        [_commonUserArr setObject:[ctArr firstObject] forKey:@"city"];
        [_commonUseKeys addObject:@"city"];
    }
    
    [ctMod release];
}

-(void) createButtomView{
    UIView* btmView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 60, self.view.bounds.size.width, 60)];
    [self.view addSubview:btmView];
    
    UIButton* publicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publicBtn.frame = CGRectMake(0, 0, btmView.bounds.size.width, btmView.bounds.size.height);
    publicBtn.backgroundColor = [UIColor blackColor];
    [publicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [publicBtn addTarget:self action:@selector(publicButtonClick) forControlEvents:UIControlEventTouchUpInside];
    publicBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btmView addSubview:publicBtn];
    RELEASE_SAFE(btmView);
}

#pragma mark - 发布点击
-(void) publicButtonClick{
    [self showProgress];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self accessPublishNews];
    });
}

//初始化导航按钮
-(void) initNavigateBar{
    
    UIButton* nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.backgroundColor = [UIColor clearColor];
    [nextBtn addTarget:self action:@selector(publicButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitle:@"发布" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = KQLboldSystemFont(14);
    [nextBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
    nextBtn.frame = CGRectMake(0, 30, 30, 30);
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:nextBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    RELEASE_SAFE(rightItem);
}

#pragma mark - back
-(void) leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//创建列表
-(void) createTable{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableview];
}

#pragma mark - tableview
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if (_commonUserArr.count == 0) {
        return 1;
    }
    if (hideCircle) {
        return 1;
    }
    
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return _commonUserArr.count;
        
    }
    if (hideCircle) {
        return 1;
    }
    
//    return 3;
    return 2;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *__view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 30.0f)] autorelease];
    [__view setBackgroundColor:COLOR_LIGHTWEIGHT];
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 15)];
    titleLable.font = [UIFont systemFontOfSize:15.0];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.textColor = [UIColor blackColor];
    [__view addSubview:titleLable];
    switch (section) {
        case 0:
            titleLable.text = @"可见范围";
            break;
        case 1:
            titleLable.text = @"常选范围";
            break;
        default:
            break;
    }

    [titleLable release];
    return __view;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = @"rangeCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    CGFloat cellHeight = 50;
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        
        UIImageView* deSelectImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, cell.bounds.size.width - 10*2, cellHeight - 5)];
//        UIImage* normolImg = IMG(@"btn_feed_option");
//        UIImage* hilightImg = IMG(@"btn_feed_option_sel");
        UIImage* normolImg = [[ThemeManager shareInstance] getThemeImage:@"btn_feed_option.png"];
        UIImage* hilightImg = [[ThemeManager shareInstance] getThemeImage:@"btn_feed_option_sel.png"];
        deSelectImgV.image = [normolImg stretchableImageWithLeftCapWidth:50 topCapHeight:0];
        deSelectImgV.highlightedImage = [hilightImg stretchableImageWithLeftCapWidth:50 topCapHeight:0];
        [cell.contentView addSubview:deSelectImgV];
        
        UILabel* contentLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(deSelectImgV.frame) + 50, 5, cell.bounds.size.width - 10*2 - (CGRectGetMinX(deSelectImgV.frame) + 50) - 50, cellHeight - 5*2)];
        contentLab.backgroundColor = [UIColor whiteColor];
        contentLab.font = [UIFont systemFontOfSize:15];
        contentLab.textColor = [UIColor blackColor];
        if (indexPath.section == 1) {
//            contentLab.text = _commonUserArr[indexPath.row];
            NSString* key = [_commonUseKeys objectAtIndex:indexPath.row];
            NSString* nameKey = nil;
            if ([key isEqualToString:@"circle"]) {
//                nameKey = @"circle_name";
                NSString* circle_names = [[_commonUserArr objectForKey:key] objectForKey:@"circle_names"];
                if (circle_names != nil && circle_names.length > 0) {
                    contentLab.text = [NSString stringWithFormat:@"%@,%@",circle_names,[[_commonUserArr objectForKey:key] objectForKey:@"org_names"]];
                }else{
                    contentLab.text = [NSString stringWithFormat:@"%@",[[_commonUserArr objectForKey:key] objectForKey:@"org_names"]];
                }
                
            }else if ([key isEqualToString:@"linkman"]) {
                nameKey = @"realnames";
                contentLab.text = [[_commonUserArr objectForKey:key] objectForKey:nameKey];
            }else{
                nameKey = @"name";
                contentLab.text = [[_commonUserArr objectForKey:key] objectForKey:nameKey];
            }
//            contentLab.text = [[_commonUserArr objectForKey:key] objectForKey:nameKey];
            
        }
        contentLab.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:contentLab];
        
        if (indexPath.section == 0) {
            UIImageView* rightCellImgV = [[UIImageView alloc] init];
            UIImage* rightImg = nil;
            if (indexPath.row == 1) {
                rightImg = IMG(@"btn_feed_drop");
            }
            if (indexPath.row == 2) {
                rightImg = IMG(@"btn_feed_add");
            }
            rightCellImgV.frame = CGRectMake(CGRectGetMaxX(deSelectImgV.frame) - 20 - rightImg.size.width, (cellHeight - rightImg.size.height)/2, rightImg.size.width, rightImg.size.height);
            rightCellImgV.image = rightImg;
            [cell.contentView addSubview:rightCellImgV];
            
            RELEASE_SAFE(rightCellImgV);
        }
        
        RELEASE_SAFE(deSelectImgV);
        RELEASE_SAFE(contentLab);
    }
    
    for (UIView* v in cell.contentView.subviews) {
        
        if (indexPath.row == 0 && indexPath.section == 0) {
            if (see_type == 0) {
                if ([v isKindOfClass:[UIImageView class]]) {
                    UIImageView* imgV = (UIImageView*)v;
                    imgV.highlighted = YES;
                }
            }
            
            if ([v isKindOfClass:[UILabel class]]) {
                UILabel* lab = (UILabel*)v;
                lab.text = @"全部成员";
            }
        }
        
        if (indexPath.row == 1 && indexPath.section == 0) {
            if ([v isKindOfClass:[UILabel class]]) {
                UILabel* lab = (UILabel*)v;
                lab.text = @"指定圈子";
            }
        }
        
        if (see_type == 4 || see_type == 1) {
            if (indexPath.section) {
                if (indexPath.row == 0) {
                    if ([v isKindOfClass:[UIImageView class]]) {
                        UIImageView* imgV = (UIImageView*)v;
                        imgV.highlighted = YES;
                    }
                }
            }
        }
        
        if (see_type == 5 || see_type == 2) {
            if (indexPath.section > 0) {
                if ([[_commonUseKeys objectAtIndex:indexPath.row] isEqualToString:@"linkman"]) {
                    if ([v isKindOfClass:[UIImageView class]]) {
                        UIImageView* imgV = (UIImageView*)v;
                        imgV.highlighted = YES;
                    }
                }
            }
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            see_type = 0;
        }else if (indexPath.row == 1){
            //指定联系人、指定圈子
//            UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"指定圈子",@"指定联系人", nil];
//            [sheet showInView:self.view];
            //圈子
            choiceCircleViewController* circleVC = [[choiceCircleViewController alloc] init];
            circleVC.delegate = self;
            CRNavigationController* crnav
            = [[CRNavigationController alloc] initWithRootViewController:circleVC];
            [self presentViewController:crnav animated:YES completion:nil];
            
            RELEASE_SAFE(crnav);
            RELEASE_SAFE(circleVC);
            
            //联系人
//            choicelinkmanViewController* linkMVC = [[choicelinkmanViewController alloc] init];
//            linkMVC.delegate = self;
//            linkMVC.accessType = AccessPageTypeChoiceMember;
//            CRNavigationController* crnav = [[CRNavigationController alloc] initWithRootViewController:linkMVC];
//            [self presentViewController:crnav animated:YES completion:nil];
//            
//            RELEASE_SAFE(crnav);
//            RELEASE_SAFE(linkMVC);

        }else{
            //指定地点
//            choiceCityViewController* choiceCtVC = [[choiceCityViewController alloc] init];
//            choiceCtVC.delegate = self;
//            choiceCtVC.cityType = CityTableTypeMutil;
//            CRNavigationController* crnav = [[CRNavigationController alloc] initWithRootViewController:choiceCtVC];
//            [self presentViewController:crnav animated:YES completion:nil];
//            RELEASE_SAFE(crnav);
//            RELEASE_SAFE(choiceCtVC);
        }
    }else{
        NSString* key = [_commonUseKeys objectAtIndex:indexPath.row];
        if ([key isEqualToString:@"circle"]) {
            see_type = 4;
        }else if ([key isEqualToString:@"linkman"]) {
            see_type = 5;
        }else{
            see_type = 6;
        }
    }
    
    NSArray* cells = [tableView visibleCells];
    for (UITableViewCell* cell in cells) {
        for (UIView* vv in cell.contentView.subviews) {
            if ([vv isKindOfClass:[UIImageView class]]) {
                UIImageView* imgv = (UIImageView*)vv;
                imgv.highlighted = NO;
            }
        }
    }
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    for (UIView* v in cell.contentView.subviews) {
        UIImageView* imgv = (UIImageView*)v;
        imgv.highlighted = YES;
    }
}

//设置为全选
-(void) selectAllToSee{
//    see_type = 0;
    
    NSArray* cells = [_tableview visibleCells];
    for (UITableViewCell* cell in cells) {
        for (UIView* vv in cell.contentView.subviews) {
            if ([vv isKindOfClass:[UIImageView class]]) {
                UIImageView* imgv = (UIImageView*)vv;
                imgv.highlighted = NO;
            }
        }
    }
    
    int row = 0;
    int section = 0;
    if (see_type == 0) {
        row = 0;
        section = 0;
    }else if (see_type == 1) {
        row = 1;
        section = 0;
    }else if (see_type == 4) {
        row = 0;
        section = 1;
    }
    
    UITableViewCell* cell = [_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    for (UIView* v in cell.contentView.subviews) {
        UIImageView* imgv = (UIImageView*)v;
        imgv.highlighted = YES;
    }
}

#pragma mark - actionSheet

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (buttonIndex == 0) {
            //圈子
            choiceCircleViewController* circleVC = [[choiceCircleViewController alloc] init];
            circleVC.delegate = self;
            CRNavigationController* crnav
            = [[CRNavigationController alloc] initWithRootViewController:circleVC];
            [self presentViewController:crnav animated:YES completion:nil];
            
            RELEASE_SAFE(crnav);
            RELEASE_SAFE(circleVC);
        }else{
            //联系人
            choicelinkmanViewController* linkMVC = [[choicelinkmanViewController alloc] init];
            linkMVC.delegate = self;
            linkMVC.accessType = AccessPageTypeChoiceMember;
            CRNavigationController* crnav = [[CRNavigationController alloc] initWithRootViewController:linkMVC];
            [self presentViewController:crnav animated:YES completion:nil];
            
            RELEASE_SAFE(crnav);
            RELEASE_SAFE(linkMVC);
        }
    }else{
        [self selectAllToSee];
    }
}

#pragma mark - cancelClick
//取消选择，跳回默认
-(void) cancelCTClick{
    [self selectAllToSee];
}

-(void) cancelCLClick{
    [self selectAllToSee];
}

-(void) cancelLMClick{
    [self selectAllToSee];
}

#pragma mark - choiceCity
//选择城市回调
-(void) didSelectedCity:(NSArray *)cityName{
    if (cityName && cityName.count > 0) {
        
        see_type = 3;
        
        [_selectedCTArr removeAllObjects];
        [_selectedCTArr addObjectsFromArray:cityName];
        
        NSLog(@"--citys:%@--",cityName);
        
        NSString* str = nil;
        int i = 0;
        for (NSString* s in _selectedCTArr) {
            i++;
            if (str == nil) {
                str = s;
            }else{
                if (i > 3) {
                    str = [NSString stringWithFormat:@"%@ 等%d个城市",str,_selectedCTArr.count];
                    break;
                }
                str = [NSString stringWithFormat:@"%@,%@",str,s];
            }
        }
        
        UITableViewCell* circleCell = [_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        for (UIView* v in circleCell.contentView.subviews) {
            if ([v isKindOfClass:[UILabel class]]) {
                UILabel* lab = (UILabel*)v;
                lab.text = str;
            }
        }
        
        //保存常用城市
        dynamic_commonUseCity_model* comCityMod = [[dynamic_commonUseCity_model alloc] init];
        for (NSString* s in _selectedCTArr) {
            comCityMod.where = [NSString stringWithFormat:@"name = %@",s];
            NSArray* arr = [comCityMod getList];
            if (arr.count) {
                NSDictionary* dic = [arr firstObject];
                [comCityMod updateDB:[NSDictionary dictionaryWithObjectsAndKeys:
                                      s,@"name",
                                      [NSNumber numberWithInt:([[dic objectForKey:@"count"] intValue] + 1)],@"count",
                                      nil]];
            }else{
                [comCityMod insertDB:[NSDictionary dictionaryWithObjectsAndKeys:
                                      s,@"name",
                                      nil]];
            }
        }
        [comCityMod release];
        
    }else{
        [self selectAllToSee];
    }
}

#pragma mark - choiceCircle
//选择圈子回调
-(void) sureCircleClick:(NSDictionary *)selectCircles{
    
    if (selectCircles) {
        
        [_selectedCLArr removeAllObjects];
        [_selectedORGArr removeAllObjects];
        
        [_selectedCLArr addObjectsFromArray:[selectCircles objectForKey:@"circles"]];
        [_selectedORGArr addObjectsFromArray:[selectCircles objectForKey:@"orgs"]];
        
        NSLog(@"--circle:%@\norg:%@--",_selectedCLArr,_selectedORGArr);
        
        if (_selectedCLArr.count || _selectedORGArr.count) {
            see_type = 1;
        }else{
            [self selectAllToSee];
            return;
        }
        
        NSString* str = nil;
        int i = 0;
        for (NSDictionary* s in _selectedCLArr) {
            i++;
            if (str == nil) {
                str = [s objectForKey:@"name"];
            }else{
//                if (i > 2) {
//                    str = [NSString stringWithFormat:@"%@ 等%d个圈子",str,_selectedLMArr.count];
//                    break;
//                }
                str = [NSString stringWithFormat:@"%@,%@",str,[s objectForKey:@"name"]];
            }
        }
        
        for (NSDictionary* s in _selectedORGArr) {
            i++;
            if (str == nil) {
                str = [s objectForKey:@"name"];
            }else{
                str = [NSString stringWithFormat:@"%@,%@",str,[s objectForKey:@"name"]];
            }
        }
        
//        UITableViewCell* circleCell = [_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        UITableViewCell* circleCell = [_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        for (UIView* v in circleCell.contentView.subviews) {
            if ([v isKindOfClass:[UILabel class]]) {
                UILabel* lab = (UILabel*)v;
                lab.text = str;
            }
        }
        
        //保存常用圈子,1圈子，2组织
        dynamic_commonUseCircle_model* comClMod = [[dynamic_commonUseCircle_model alloc] init];
        [comClMod deleteDBdata];
        
        NSString* cl_ids = nil;
        NSString* cl_names = nil;
        for (NSDictionary* dic in _selectedCLArr) {
            if (cl_ids == nil) {
                cl_ids = [dic objectForKey:@"circle_id"];
            }else{
                cl_ids = [NSString stringWithFormat:@"%@,%@",cl_ids,[dic objectForKey:@"circle_id"]];
            }
            if (cl_names == nil) {
                cl_names = [dic objectForKey:@"name"];
            }else{
                cl_names = [NSString stringWithFormat:@"%@,%@",cl_names,[dic objectForKey:@"name"]];
            }
        }
        
        NSString* org_ids = nil;
        NSString* org_names = nil;
        for (NSDictionary* dic in _selectedORGArr) {
            if (org_ids == nil) {
                org_ids = [dic objectForKey:@"id"];
            }else{
                org_ids = [NSString stringWithFormat:@"%@,%@",org_ids,[dic objectForKey:@"id"]];
            }
            if (org_names == nil) {
                org_names = [dic objectForKey:@"name"];
            }else{
                org_names = [NSString stringWithFormat:@"%@,%@",org_names,[dic objectForKey:@"name"]];
            }
        }
        [comClMod insertDB:[NSDictionary dictionaryWithObjectsAndKeys:
                            org_ids,@"org_ids",
                            org_names,@"org_names",
                            cl_ids,@"circle_ids",
                            cl_names,@"circle_names",
                            nil]];
        
        [comClMod release];
        
    }else{
        [self selectAllToSee];
    }
}

#pragma mark - choiceLM
//选择联系人回调
-(void) sureLMClick:(NSArray *)selectLMs{
    
    if (selectLMs.count != 0) {
        
        see_type = 2;
        
        [_selectedLMArr removeAllObjects];
        [_selectedLMArr addObjectsFromArray:selectLMs];
        
        NSString* str = nil;
        int i = 0;
        for (NSDictionary* s in _selectedLMArr) {
            i++;
            if (str == nil) {
                str = [s objectForKey:@"realname"];
            }else{
                if (i > 3) {
                    str = [NSString stringWithFormat:@"%@ 等%d人",str,_selectedLMArr.count];
                    break;
                }
                str = [NSString stringWithFormat:@"%@,%@",str,[s objectForKey:@"realname"]];
            }
        }
//        UITableViewCell* circleCell = [_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        UITableViewCell* circleCell = [_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        for (UIView* v in circleCell.contentView.subviews) {
            if ([v isKindOfClass:[UILabel class]]) {
                UILabel* lab = (UILabel*)v;
                lab.text = str;
            }
        }
        
        //保存联系人
        dynamic_commonUseLinkman_model* comLmMod = [[dynamic_commonUseLinkman_model alloc] init];
        
        NSString* user_ids = nil;
        NSString* realnames = nil;
        for (NSDictionary* lmDic in _selectedLMArr) {
            if (user_ids == nil) {
                user_ids = [lmDic objectForKey:@"user_id"];
            }else{
                user_ids = [NSString stringWithFormat:@"%@,%@",user_ids,[lmDic objectForKey:@"user_id"]];
            }
            
            realnames = str;
        }
        [comLmMod deleteDBdata];
        [comLmMod insertDB:[NSDictionary dictionaryWithObjectsAndKeys:
                            user_ids,@"user_ids",
                            realnames,@"realnames",
                            nil]];
        
        [comLmMod release];
        
    }else{
        [self selectAllToSee];
    }
}

//发布的请求，根据动态类型、可见类型，添加对应的参数
-(void) accessPublishNews{
    [[NSUserDefaults standardUserDefaults] setInteger:see_type forKey:@"dy_see_type"];
    
    NSString* reqUrl = @"publish/addwrite.do?param=";
    
    //从_paraDic获取部分参数信息
    NSMutableDictionary* requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                       [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                                       [NSNumber numberWithInt:_type],@"type",
                                       [_paraDic objectForKey:@"title"],@"title",
                                       nil];
    
    NSArray* images = [_paraDic objectForKey:@"images"];
    NSString* title = [_paraDic objectForKey:@"title"];
    NSString* city = [_paraDic objectForKey:@"city"];
    
    if (city.length > 0) {
        [requestDic setObject:city forKey:@"city"];
        
        CLLocationCoordinate2D location = [Global sharedGlobal].myLocation;
        
        [requestDic setObject:[NSNumber numberWithDouble:location.longitude] forKey:@"longitude"];
        [requestDic setObject:[NSNumber numberWithDouble:location.latitude] forKey:@"latitude"];
    }
    
    //动态类型
    if (_type == 0) {
        if (images.count) {
            if ([title length] == 0) {
                [requestDic setObject:[NSNumber numberWithInt:7] forKey:@"type"];
            }else{
                [requestDic setObject:[NSNumber numberWithInt:0] forKey:@"type"];
            }
            
        }else{
            [requestDic setObject:[NSNumber numberWithInt:6] forKey:@"type"];
        }
    }else if (_type == 1) {
        [requestDic setObject:@"x" forKey:@"choice1"];
        [requestDic setObject:@"o" forKey:@"choice2"];
        
        [requestDic setObject:[NSNumber numberWithInt:1] forKey:@"type"];
    }else if (_type == 2) {
        [requestDic setObject:[_paraDic objectForKey:@"start_time"] forKey:@"start_time"];
        [requestDic setObject:[_paraDic objectForKey:@"end_time"] forKey:@"end_time"];
        
        [requestDic setObject:[NSNumber numberWithInt:2] forKey:@"type"];
    }else if (_type == 3) {
        [requestDic setObject:[NSNumber numberWithInt:3] forKey:@"type"];
    }else if (_type == 4) {
        [requestDic setObject:[NSNumber numberWithInt:4] forKey:@"type"];
    }else if (_type == 8) {
        [requestDic setObject:[_paraDic objectForKey:@"start_time"] forKey:@"start_time"];
        [requestDic setObject:[_paraDic objectForKey:@"end_time"] forKey:@"end_time"];
        
        [requestDic setObject:[_paraDic objectForKey:@"address"] forKey:@"address"];
    }
    
    //可见类型,及相应参数
    if (see_type == 0) {
        
    }else if (see_type == 1) {
        NSString* cl_ids = nil;
        for (NSDictionary* dic in _selectedCLArr) {
            if (cl_ids == nil) {
                cl_ids = [dic objectForKey:@"circle_id"];
            }else{
                cl_ids = [NSString stringWithFormat:@"%@,%@",cl_ids,[dic objectForKey:@"circle_id"]];
            }
        }
        NSString* org_ids = nil;
        for (NSDictionary* dic in _selectedORGArr) {
            if (org_ids == nil) {
                org_ids = [dic objectForKey:@"id"];
            }else{
                org_ids = [NSString stringWithFormat:@"%@,%@",org_ids,[dic objectForKey:@"id"]];
            }
        }
        NSLog(@"--cl:%@\norg:%@--",cl_ids,org_ids);
        if (cl_ids) {
            [requestDic setObject:cl_ids forKey:@"see_circle_ids"];
        }
        if (org_ids) {
            [requestDic setObject:org_ids forKey:@"see_org_ids"];
        }
        
    }else if (see_type == 2) {
        NSString* user_ids = nil;
        for (NSDictionary* lmDic in _selectedLMArr) {
            if (user_ids == nil) {
                user_ids = [lmDic objectForKey:@"user_id"];
            }else{
                user_ids = [NSString stringWithFormat:@"%@,%@",user_ids,[lmDic objectForKey:@"user_id"]];
            }
        }
        
        [requestDic setObject:user_ids forKey:@"see_user_ids"];
        
        NSLog(@"++lm:%@++",user_ids);
    }else if (see_type == 3) {
        NSString* see_citys = [_selectedCTArr componentsJoinedByString:@","];
        [requestDic setObject:see_citys forKey:@"see_citys"];
    }else if (see_type == 4) {
        NSString* see_circle = [[_commonUserArr objectForKey:@"circle"] objectForKey:@"circle_ids"];
        NSString* see_orgs = [[_commonUserArr objectForKey:@"circle"] objectForKey:@"org_ids"];
        if (see_circle != nil && see_circle.length > 0) {
            [requestDic setObject:see_circle forKey:@"see_circle_ids"];
        }
        if (see_orgs != nil && see_orgs.length > 0) {
            [requestDic setObject:see_orgs forKey:@"see_org_ids"];
        }
        
        [requestDic setObject:[NSNumber numberWithInt:1] forKey:@"see_type"];
    }else if (see_type == 5) {
        NSString* user_ids = [NSString stringWithFormat:@"%d",[[[_commonUserArr objectForKey:@"linkman"] objectForKey:@"user_ids"] intValue]];
        
        [requestDic setObject:user_ids forKey:@"see_user_ids"];
        [requestDic setObject:[NSNumber numberWithInt:2] forKey:@"see_type"];
    }else{
        NSString* see_citys = [[_commonUserArr objectForKey:@"city"] objectForKey:@"name"];
        
        [requestDic setObject:see_citys forKey:@"see_citys"];
        [requestDic setObject:[NSNumber numberWithInt:3] forKey:@"see_type"];
    }
    
    //图片数据
    NSMutableArray* dataArr = [NSMutableArray arrayWithCapacity:0];
    if (images.count != 0) {
        //压缩图片尺寸
//        CGSize size;
        for (UIImage* img in images) {
//            if (img.size.height >= img.size.width) {
//                if (img.size.width > 640) {
//                    size = [UIImage fitsize:img.size width:640];
//                    img = [img imageByScalingAndCroppingForSize:size];
//                }
//            }
            [dataArr addObject:UIImageJPEGRepresentation(img, 0.5)];
        }
    }else{
        dataArr = nil;
    }
    NSLog(@"--dataArr:%d--",dataArr.count);
    //data 是图片数据，根据需要传
//    [[NetManager sharedManager] accessService:requestDic dataList:dataArr command:DYNAMIC_PUBLISH_NEWS_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
    
    //同步方式，无队列
//    NSDictionary* responseDic = [upLoadPicManager upLoadPicWithRequestDic:requestDic dataList:dataArr requestUrl:reqUrl];
    //connect
    NSDictionary* responseDic = [upLoadPicManager upLoadPicWithPara:requestDic dataList:dataArr requestUrl:reqUrl];
    
    NSLog(@"--responseStr:%@--",responseDic);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissProgress];
        
        if (responseDic == nil) {
//            [Common checkProgressHUD:@"网络异常,请检查网络后重新发布哦" andImage:nil showInView:self.view];
            [Common checkProgressHUDShowInAppKeyWindow:@"网络异常,请稍后重试.." andImage:KAccessFailedIMG];
            return;
        }
        
        if ([[responseDic objectForKey:@"ret"] intValue] == 1) {
            [self upLoadPicSuccess:responseDic];
        }else{
//            [Common checkProgressHUD:@"服务器错误，发布失败，请稍后发布" andImage:nil showInView:self.view];
            [Common checkProgressHUDShowInAppKeyWindow:@"服务器错误，发布失败,请稍后重试.." andImage:KAccessFailedIMG];
        }
    });
    
}

//缓存发布的图片到本地
-(void) upLoadPicSuccess:(NSDictionary*) responseDic{
    NSArray* pics = [responseDic objectForKey:@"pics"];
    //发送的图片，直接缓存在本地
    if (pics) {
        NSArray* images = [_paraDic objectForKey:@"images"];
        for (int i = 0;i<pics.count;i++) {
            NSString* urlStr = pics[i];
            if (urlStr) {
                [[SDImageCache sharedImageCache] storeImage:images[i] forKey:urlStr toDisk:YES];
            }
        }
    }
    
    sleep(1);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewCard" object:nil userInfo:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 请求回调
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
    
    NSLog(@"--pubish result:%@--",resultArray);
    [self dismissProgress];
    switch (commandid) {
        case DYNAMIC_PUBLISH_NEWS_COMMAND_ID:
        {
            //...
            
            if ([[resultArray lastObject] isKindOfClass:[NSString class]]) {
                [Common checkProgressHUD:@"发布失败" andImage:nil showInView:self.view];
            }else{
                if ([[[resultArray lastObject] objectForKey:@"ret"] intValue] == 0) {
                    [Common checkProgressHUD:@"发布失败" andImage:nil showInView:self.view];
                }else if ([[[resultArray lastObject] objectForKey:@"ret"] intValue] == 1) {
                    [self performSelectorOnMainThread:@selector(publishSuccess:) withObject:[[resultArray lastObject] objectForKey:@"pics"] waitUntilDone:NO];
                }
            }
        }
            break;
            
        default:
            break;
    }
}

//发布成功
-(void) publishSuccess:(NSArray*) pics{
    //发送的图片，直接缓存在本地
    if (pics) {
        NSArray* images = [_paraDic objectForKey:@"images"];
        for (int i = 0;i<pics.count;i++) {
            NSString* urlStr = pics[i];
            if (urlStr) {
                [[SDImageCache sharedImageCache] storeImage:images[i] forKey:urlStr toDisk:YES];
            }
        }
    }
    
    sleep(1);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewCard" object:nil userInfo:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//加载框显示
-(void) showProgress{
    hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    hud.labelText = @"正在发布...";
    hud.mode = MBProgressHUDModeCustomView;
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud show:YES];
    
}
//加载框收起
-(void) dismissProgress{
    [hud hide:YES];
    [hud removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    RELEASE_SAFE(_paraDic);
    
    RELEASE_SAFE(_commonUseKeys);
    RELEASE_SAFE(_commonUserArr);
    RELEASE_SAFE(_selectedCTArr);
    RELEASE_SAFE(_selectedCLArr);
    RELEASE_SAFE(_selectedLMArr);
    RELEASE_SAFE(_selectedORGArr);
    RELEASE_SAFE(_tableview);
    [super dealloc];
}

@end
