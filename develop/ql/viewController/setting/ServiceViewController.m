//
//  ServiceViewController.m
//  ql
//
//  Created by Dream on 14-9-9.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "ServiceViewController.h"
#import "config.h"

@interface ServiceViewController ()<UIWebViewDelegate> {

    UIWebView *_webView;
    UIActivityIndicatorView *_indicatorView;
}

@end

@implementation ServiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    _webView.delegate = nil;
    [_webView release];
    [_indicatorView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"服务协议";
    self.view.backgroundColor = COLOR_LIGHTWEIGHT;
    
    [self backBar];
    
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0 ,self.view.bounds.size.width, KUIScreenHeight - 64)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    NSURL *url = [NSURL URLWithString:SERVICEDELEGATE];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_indicatorView setCenter:self.view.center];
    [self.view addSubview:_indicatorView];
}


#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)aWebView{
	[_indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView{
	[_indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error{
    [_indicatorView stopAnimating];
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

- (void)backTo {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
