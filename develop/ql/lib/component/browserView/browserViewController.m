    //
//  browserViewController.m
//  Profession
//
//  Created by siphp on 12-8-25.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "browserViewController.h"
//#import "PopShareView.h"
#import "NetManager.h"
#import "WatermarkCameraViewController.h"
#import "Global.h"
#import "config.h"
#import "NSObject+SBJson.h"
#import "imageBrowser.h"

@implementation browserViewController

@synthesize url;
@synthesize webTitle;
@synthesize shareImage;

@synthesize mbProgressHUD;
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = webTitle;
    
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    
	myWebView = [[UIWebView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.view.frame.size.width , KUIScreenHeight - 44)];
	myWebView.delegate = self;
	myWebView.scalesPageToFit = YES;
	[self.view addSubview:myWebView];
    
	if ([self.url length] > 1)
	{
		//开始请求连接
		NSURL *webUrl =[NSURL URLWithString:self.url];
		NSURLRequest *request =[NSURLRequest requestWithURL:webUrl];
		[myWebView loadRequest:request];
	}
//    [self showToolBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


//工具栏
-(void)showToolBar
{
    UIView *toolBarView = [[UIView alloc] initWithFrame:
                           CGRectMake(0.0f, self.view.frame.size.height - 44.0f, self.view.frame.size.width, 44.0f)];
    [self.view addSubview:toolBarView];
    toolBarView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    [toolBarView release];
    
    UIImageView *toolBarBackgroundView = [[UIImageView alloc] initWithFrame:
								CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
	UIImage *image = [[UIImage alloc]initWithContentsOfFile:
					  [[NSBundle mainBundle] pathForResource:@"共用_下bar" ofType:@"png"]];
	toolBarBackgroundView.backgroundColor = [UIColor clearColor];
	toolBarBackgroundView.userInteractionEnabled = YES;
    toolBarBackgroundView.image = image;
    [image release];
	[toolBarView addSubview:toolBarBackgroundView];
    [toolBarBackgroundView release];
    
    
    //添加按钮
    NSArray *toolItems = [NSArray arrayWithObjects:@"close",@"share",@"refresh",@"back",@"forward",nil];
    int itemsCouns = [toolItems count];
    int bTag = 1000;
    CGFloat oneButtonWidth = self.view.frame.size.width/itemsCouns;
    CGFloat marginWidth = oneButtonWidth/2;
    CGFloat fixWidth = 0.0f;
    for (NSString *itemTitle in toolItems) 
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = ++bTag;
        fixWidth = marginWidth + ((button.tag - 1000)-1) * oneButtonWidth;
		[button setFrame:CGRectMake(0.0f , 0.0f , 44.0f, 44.0f)];
        button.center = CGPointMake(fixWidth , 22.0f);
		[button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        
        //设置背景图
        NSString *imageName = [NSString stringWithFormat:@"browser_%@_icon",itemTitle];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
        [button setImage:image forState:UIControlStateNormal];
        [toolBarView addSubview:button];
        [image release];
        
    }
}

//功能按钮
-(void)buttonClick:(id)sender
{
	UIButton *currentButton = sender;
	switch (currentButton.tag) 
	{
		case 1001:
		{
            [self close];
			break;
		}
		case 1002:
		{
            [self share];
			break;
		}
        case 1003:
		{
            [self reload];
			break;
		}
        case 1004:
		{
            [self back];
			break;
		}
        case 1005:
		{
            [self forward];
			break;
		}
		default:
			break;
	}
}


//关闭
-(void)close
{
//    NSString *controllerClassStr = NSStringFromClass(self.class);
//    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@notificationHidePopView",controllerClassStr] object:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//分享
-(void)share
{
    
}

//刷新
-(void)reload
{
    [myWebView reload];
}

//后退
-(void)back
{
    [myWebView goBack];
}

//前进
-(void)forward
{
    [myWebView goForward];
}

//调取本地的相册
- (void)getImagePhoto{
    UIImagePickerController *myPicker  = [[UIImagePickerController alloc] init];
    myPicker.delegate = self;
//    myPicker.editing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        myPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        myPicker.allowsEditing = NO;
        [self presentModalViewController:myPicker animated:YES];
    }
    [myPicker release];
}

//调取本地的拍照
- (void)getImageTakePhoto{
    BOOL canUseCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (canUseCamera) {
        UIImagePickerController * imageCamera = [[UIImagePickerController alloc]init];
//        imageCamera.editing = YES;
        imageCamera.delegate = self;
        imageCamera.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:imageCamera animated:YES];
        RELEASE_SAFE(imageCamera);
    } else {
        [Common checkProgressHUDShowInAppKeyWindow:@"设备不支持该功能" andImage:nil];
    }
}

//当前的图片的滚动
-(void)getScrollowImageView:(NSArray *)imageArray currentIndex:(int)currentInt{
    imageBrowser* browser = [[imageBrowser alloc] initWithPhotoList:imageArray];
    browser.currentIndex = currentInt;
    [browser showWithAnimation:YES];
    [browser release];
}

//当前view的截屏
- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.frame.size.width, view.frame.size.height), view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//将图片文件上传给Java服务器端
- (void)upLoadImage:(NSArray *)dataList
{
    MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
    progressHUDTmp.frame = CGRectMake(0, 0, KUIScreenWidth, KUIScreenHeight);
    progressHUDTmp.center = CGPointMake(self.view.center.x, self.view.center.y);
    self.mbProgressHUD = progressHUDTmp;
    [progressHUDTmp release];
    self.mbProgressHUD.labelText = @"正在上传...";
    [self.view addSubview:self.mbProgressHUD];
    [self.mbProgressHUD show:YES];
    
    NSString * requestStr = @"uploadfile.do?param=";
    [[NetManager sharedManager] accessService:nil
                                    dataList:dataList
                                     command:CHAT_PICTURE_DATA_SEND_COMMAND_ID
                                accessAdress:requestStr
                                    delegate:self
                                   withParam:nil];
}


#pragma mark -
#pragma mark webView委托

//当网页视图被指示载入内容而得到通知
-(BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*) reuqest navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[reuqest URL] absoluteString];
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    NSLog(@"urlComps %@",urlComps);
    
    if([urlComps count] && [[urlComps objectAtIndex:0]
                            isEqualToString:@"yunlai"])
    {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps
                                                       objectAtIndex:1] componentsSeparatedByString:@":/"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        if (1 == [arrFucnameAndParameter count])
        {
            NSRange foundObj = [funcStr rangeOfString:@"photo" options:NSCaseInsensitiveSearch];
            if(foundObj.length>0) {
                /*
                 *调取本地图片相册
                 */
                NSLog(@"photo");
                [self getImagePhoto];
            } else {
                NSLog(@"photo ! no photo");
            }
            
            NSRange cameraFoundObj = [funcStr rangeOfString:@"camera" options:NSCaseInsensitiveSearch];
            if(cameraFoundObj.length>0) {
                /*
                 *调取本地照相
                 */
                NSLog(@"camera");
                [self getImageTakePhoto];
            } else {
                NSLog(@"camera ! no camera");
            }
            
            NSRange enlargeImageFoundObj = [funcStr rangeOfString:@"enlargeImage" options:NSCaseInsensitiveSearch];
            if(enlargeImageFoundObj.length>0) {
                /*
                 *图片的放大滚动
                 */
                NSLog(@"enlargeImage");
                NSArray *enlargeImageComps = [urlString componentsSeparatedByString:@"="];
                NSArray *pictureArray = [[enlargeImageComps objectAtIndex:1] componentsSeparatedByString:@"&"];
                NSString *picString = [pictureArray objectAtIndex:0];
                
                [self getScrollowImageView:[picString componentsSeparatedByString:@","] currentIndex:[[enlargeImageComps lastObject] integerValue]];
            } else {
                NSLog(@"enlargeImage ! no jap");
            }
        }
        return NO;
        
    };
    return YES;
}



//当网页视图已经开始加载一个请求后，得到通知。
-(void)webViewDidStartLoad:(UIWebView*)webView
{
	//添加loading图标
    if (spinner == nil)
    {
        spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        [spinner setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2.0)];
    }
	
    [self.view addSubview:spinner];
	[spinner startAnimating];
}

//当网页视图结束加载一个请求之后，得到通知。 
-(void)webViewDidFinishLoad:(UIWebView*)webView
{
    [spinner stopAnimating];
	[spinner removeFromSuperview];
    
    if (webTitle == nil)
    {
        NSString *str = [myWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
        self.title = str;
        self.webTitle = str;
    }
    
}

//当在请求加载中发生错误时，得到通知。会提供一个NSSError对象，以标识所发生错误类型。
-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error
{
	NSLog(@"浏览器浏览发生错误...");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[myWebView release];
    myWebView.delegate = nil;//booky
    [spinner release];
	[url release];
    [webTitle release];
    [shareImage release];
    [super dealloc];
}

#pragma mark --UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
//        image = [info objectForKey:UIImagePickerControllerEditedImage];
//    }else{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    }
    [self upLoadImage:[[NSArray alloc] initWithObjects:UIImageJPEGRepresentation(image, 0.05), nil]];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - HttpRequestDelegate

- (void)didFinishCommand:(NSMutableArray *)resultArray cmd:(int)commandid withVersion:(int)ver
{
    //安全解析Http请求所返回的数据
    [self.mbProgressHUD hide:YES];
    [self.mbProgressHUD removeFromSuperViewOnHide];
    
    if (resultArray && ![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        int resultInt = [[[resultArray objectAtIndex:0] objectForKey:@"ret"]intValue];
        
        if (commandid == CHAT_PICTURE_DATA_SEND_COMMAND_ID) {
            if (resultInt == 1) {
                NSDictionary *tempDict = [resultArray lastObject];
                NSString *josnString = [tempDict JSONRepresentation];

                [myWebView
                 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.parent.getImageCallback('%@')",josnString]];
                
                [Common checkProgressHUDShowInAppKeyWindow:@"上传成功" andImage:KAccessSuccessIMG];
                
            }else{
                
//                [Common checkProgressHUD:@"上传失败" andImage:nil showInView:self.view];
                [Common checkProgressHUDShowInAppKeyWindow:@"上传失败" andImage:KAccessFailedIMG];
            }
        }
    }else{
//        [Common checkProgressHUD:@"数据异常" andImage:nil showInView:self.view];
        [Common checkProgressHUDShowInAppKeyWindow:@"数据异常" andImage:KAccessFailedIMG];
    }
    
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
