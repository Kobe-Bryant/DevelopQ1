//
//  pwViewController.m
//  ql
//
//  Created by yunlai on 14-4-16.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "pwViewController.h"

@interface pwViewController (){
    NSString* pwStr;
}

@property(nonatomic,retain) UIView* fieldView;

@end

@implementation pwViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pwStr = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"设置密码";
    self.view.backgroundColor = [UIColor colorWithRed:0.14 green:0.14 blue:0.15 alpha:1.0];
    
    [self backBar];
    
    [self initFieldView];
    
	// Do any additional setup after loading the view.
}

/**
 *  返回按钮
 */
- (void)backBar{
    UIButton *backButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [[ThemeManager shareInstance] getThemeImage:@"ico_common_return.png"];
    [backButton setImage:image forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0,image.size.width, image.size.height);
    UIBarButtonItem  *backItem = [[UIBarButtonItem  alloc]  initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    }
    RELEASE_SAFE(backItem);
}

-(void) backTo{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) initFieldView{
    _fieldView = [[UIView alloc] initWithFrame:CGRectMake(10, 30, self.view.bounds.size.width - 10*2, 160)];
    _fieldView.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    _fieldView.layer.cornerRadius = 5.0;
    [self.view addSubview:_fieldView];
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, _fieldView.bounds.size.width, 20)];
    lab.text = @"请输入密码";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor darkGrayColor];
    lab.backgroundColor = [UIColor clearColor];
    lab.font = KQLboldSystemFont(15);
    [_fieldView addSubview:lab];
    
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lab.frame) + 20, _fieldView.bounds.size.width - 20*2, _fieldView.bounds.size.height - 20*2 - lab.bounds.size.height - 20)];
    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.backgroundColor = [UIColor whiteColor];
    [textField addTarget:self action:@selector(passwordChanged:) forControlEvents:UIControlEventEditingChanged];
    [_fieldView addSubview:textField];
    
    [textField becomeFirstResponder];
    textField.hidden = YES;
    
    CGFloat width = (textField.bounds.size.width - 3*10)/4;
    CGFloat ofx = 0;
    for (int i = 0; i < 4; i++) {
        
        UILabel* tmplab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(textField.frame) + ofx, CGRectGetMinY(textField.frame), width, width)];
        ofx += 10 + width;
        tmplab.textColor = [UIColor blackColor];
        tmplab.backgroundColor = [UIColor whiteColor];
        tmplab.textAlignment = NSTextAlignmentCenter;
        tmplab.font = KQLboldSystemFont(40);
        tmplab.tag = 100 + i;
        tmplab.layer.cornerRadius = 5.0;
        [_fieldView addSubview:tmplab];
        RELEASE_SAFE(tmplab);
    }
    
    RELEASE_SAFE(lab);
    RELEASE_SAFE(textField);
}

-(void) passwordChanged:(UITextField*) textField{
    if (textField.text.length == 4) {
        for (UIView* v in _fieldView.subviews) {
            if (v.tag >= 100 && v.tag <= 103) {
                UILabel* lab = (UILabel*)v;
                lab.text = @"●";
            }
        }
        
        pwStr = [[NSString alloc] initWithString:textField.text];
        NSLog(@"++%@++",pwStr);
        
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (_delegate && [_delegate respondsToSelector:@selector(savePw:)]) {
                [_delegate savePw:pwStr];
            }
            [self backTo];
            
        });
        
    }else{
        [self clearLab];
        
        int count = textField.text.length;
        for (UIView* v in _fieldView.subviews) {
            if (v.tag >= 100 && v.tag <= (100 + count - 1)) {
                UILabel* lab = (UILabel*)v;
                lab.text = @"●";
            }
            
        }
    }
}

-(void) clearLab{
    for (UIView* v in _fieldView.subviews) {
        if (v.tag >= 100 && v.tag <= 103) {
            UILabel* lab = (UILabel*)v;
            lab.text = @"";
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    [_fieldView release];
    [super dealloc];
}

@end
