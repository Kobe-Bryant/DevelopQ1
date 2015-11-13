//
//  SGSheetMenu.m
//  SGActionView
//
//  Created by Sagi on 13-9-6.
//  Copyright (c) 2013年 AzureLab. All rights reserved.
//

#import "SGSheetMenu.h"
#import <QuartzCore/QuartzCore.h>

#define kMAX_SHEET_TABLE_HEIGHT   400
#define KUIWidth          [UIScreen mainScreen].applicationFrame.size.width
#define KUIHeight         [UIScreen mainScreen].applicationFrame.size.height

@interface SGSheetMenu () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *subItems;
@property (nonatomic, strong) UIButton *setIcon;
@property (nonatomic, strong) UIButton *nullIcon;
@property (nonatomic, strong) UITextField *setField;
@property (nonatomic, strong) UITextField *nullField;

@property (nonatomic, strong) void(^actionHandle)(NSInteger);
@end

@implementation SGSheetMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BaseMenuBackgroundColor(self.style);

        _selectedItemIndex = NSIntegerMax;
        _items = [NSArray array];
        _subItems = [NSArray array];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
        [self addSubview:_titleLabel];
        
        _setIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setIcon setFrame:CGRectMake(20, 50, 40, 40)];
        [_setIcon setTag:1];
        [_setIcon addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
        _setIcon.backgroundColor = [UIColor redColor];
        [_setIcon setImage:[UIImage imageNamed:@"facebook@2x"] forState:UIControlStateNormal];
        [self addSubview:_setIcon];
        
        _setField = [[UITextField alloc]initWithFrame:CGRectMake(65, 50, 220, 40)];
        _setField.backgroundColor = [UIColor grayColor];
        _setField.placeholder = @"输入头衔";
        [self addSubview:_setField];
        
        _nullIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nullIcon setFrame:CGRectMake(20, 100, 40, 40)];
        [_nullIcon setTag:2];
        [_nullIcon addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
        _nullIcon.backgroundColor = [UIColor redColor];
        [self addSubview:_nullIcon];
        
        _nullField = [[UITextField alloc]initWithFrame:CGRectMake(65, 100, 220, 40)];
        _nullField.backgroundColor = [UIColor grayColor];
        _nullField.enabled = NO;
        _nullField.text = @"  空";
        [self addSubview:_nullField];

        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        [self addSubview:_tableView];
        
        // 键盘将要显示的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        // 键盘将要隐藏的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)chooseClick:(UIButton *)btn{
    switch (btn.tag) {
        case 1:
        {
            [_setIcon setImage:[UIImage imageNamed:@"facebook@2x"] forState:UIControlStateNormal];
            [_nullIcon setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            _setField.enabled = YES;
        }
            break;
        case 2:
        {
            [_setIcon setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [_nullIcon setImage:[UIImage imageNamed:@"facebook@2x"] forState:UIControlStateNormal];
            _setField.enabled = NO;
        }
            break;
        default:
            break;
    }
}

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles
{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self setupWithTitle:title items:itemTitles subItems:nil];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles subTitles:(NSArray *)subTitles
{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self setupWithTitle:title items:itemTitles subItems:subTitles];
    }
    return self;
}

- (void)setupWithTitle:(NSString *)title items:(NSArray *)items subItems:(NSArray *)subItems;
{
    _titleLabel.text = title;
    _items = items;
    _subItems = subItems;
}

- (void)setStyle:(SGActionViewStyle)style{
    _style = style;
    
    self.backgroundColor = BaseMenuBackgroundColor(style);
    self.titleLabel.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float height = 0;
    float table_top_margin = 0;
    float table_bottom_margin = 10;
    
    self.titleLabel.frame = (CGRect){CGPointMake(15, 5), CGSizeMake(self.bounds.size.width, 40)};
    height += self.titleLabel.bounds.size.height;
    height += table_top_margin;
    
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    float contentHeight = self.tableView.contentSize.height;
    if (contentHeight > kMAX_SHEET_TABLE_HEIGHT) {
        contentHeight = kMAX_SHEET_TABLE_HEIGHT;
        self.tableView.scrollEnabled = YES;
    }else{
        self.tableView.scrollEnabled = NO;
    }
    self.tableView.frame = CGRectMake(self.bounds.size.width * 0.05, height, self.bounds.size.width * 0.9, contentHeight);
    height += self.tableView.bounds.size.height;
    
    height += table_bottom_margin;
    
    self.bounds = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, height)};
}
#pragma mark -

- (void)textFieldDidBeginEditing:(UITextField *)textField{
  
    NSLog(@"begin");
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

}

#pragma mark - Responding to keyboard events
// 键盘将要显示
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // 键盘显示需要的frame
    CGRect keyboardRect = [aValue CGRectValue];
    NSLog(@"keyboardRect==%f",keyboardRect.size.height);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.frame = CGRectMake(0,5, KUIWidth, KUIHeight);
    [UIView commitAnimations];
}

// 键盘将要隐藏
- (void)keyboardWillHide:(NSNotification *)notification
{
   
    self.frame = CGRectMake(0,220, KUIWidth, KUIHeight);
}


#pragma mark -

- (void)triggerSelectedAction:(void (^)(NSInteger))actionHandle
{
    self.actionHandle = actionHandle;
}

#pragma mark - 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.subItems.count > 0) {
        return 50;
    }else{
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    SGSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[SGSheetCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    [cell.setIcon setImage:[UIImage imageNamed:@"facebook@2x"] forState:UIControlStateNormal];
    [cell.setIcon addTarget:self action:@selector(clickChoose:) forControlEvents:UIControlEventTouchUpInside];
    [cell.setIcon setTag:indexPath.row];
    
//    cell.setImge.image =[UIImage imageNamed:@"facebook@2x"];
    
    if (self.selectedItemIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        cell.setImge.image =[UIImage imageNamed:@"wechat@2x"];
        [cell.setIcon setImage:[UIImage imageNamed:@"wechat@2x"] forState:UIControlStateNormal];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedItemIndex != indexPath.row) {
        self.selectedItemIndex = indexPath.row;
        [tableView reloadData];
    }
    
    NSLog(@"indexPath.row===%ld",(long)indexPath.row);
    
    if (self.actionHandle) {
        double delayInSeconds = 0.15;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            self.actionHandle(indexPath.row);
        });
    }
}

@end
