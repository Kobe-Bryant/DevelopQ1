//
//  companyInfoBrowserViewController.m
//  ql
//
//  Created by Dream on 14-8-16.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "companyInfoBrowserViewController.h"
#import "MBProgressHUD.h"
#import "NSObject+SBJson.h"
#import "CompanyInfobrowserModel.h"
#import "liveapp_companyInfo_model.h"

#import "ThemeManager.h"
#import "NetManager.h"
#import "Global.h"
#import "config.h"

@interface companyInfoBrowserViewController () 

@end

@implementation companyInfoBrowserViewController
@synthesize mbProgressHUD = _mbProgressHUD;
@synthesize webTitle = _webTitle;
@synthesize url = _url;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    _myWebView.delegate = nil;
    [_myWebView release]; _myWebView = nil;
    [spinner release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _webTitle;
    
    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    //初始化webView
	_myWebView = [[UIWebView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.view.frame.size.width , KUIScreenHeight - 44)];
	_myWebView.delegate = self;
	_myWebView.scalesPageToFit = YES;
	[self.view addSubview:_myWebView];
    
    //网络请求加载
    if ([self.url length]) {
        NSURL *url = [NSURL URLWithString:self.url];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_myWebView loadRequest:request];
    }

}


//调取本地的相册
- (void)getImagePhoto {
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
- (void)getImageTakePhoto {
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

//将图片文件上传给Java服务器端
- (void)upLoadImage:(NSArray *)dataList {
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

#pragma mark -
#pragma mark - webViewDelegate
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
    
    if (_webTitle == nil)
    {
        NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        self.title = str;
        self.webTitle = str;
    }
}

//当网页视图被指示载入内容而得到通知
-(BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*) reuqest navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[reuqest URL] absoluteString];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
            
            NSRange returnCompanyInfoFoundObj = [funcStr rangeOfString:@"returnCompanyInfo" options:NSCaseInsensitiveSearch];
            if (returnCompanyInfoFoundObj.length > 0) {
                /*
                 *返回应用公司信息
                 */
                
                CompanyInfobrowserModel *browserModel = [[CompanyInfobrowserModel alloc]init];
                //公司logo
                NSArray *logo_urlComps =  [urlString componentsSeparatedByString:@"&company_name"];
                NSString *logo_url_ = [logo_urlComps objectAtIndex:0];
                NSArray *logo_url_arr =  [logo_url_ componentsSeparatedByString:@"logo_url="];
                browserModel.logo_url = [logo_url_arr objectAtIndex:1];
                
                //公司名字
                NSArray *company_nameComps =  [urlString componentsSeparatedByString:@"&liveapp_url"];
                NSString *company_name_ = [company_nameComps objectAtIndex:0];
                NSArray *company_name_arr =  [company_name_ componentsSeparatedByString:@"company_name="];
                browserModel.company_name = [company_name_arr objectAtIndex:1];
                
                //liveapp_url
                NSArray *liveapp_urlComps =  [urlString componentsSeparatedByString:@"&liveapp_list"];
                NSString *liveapp_url_ = [liveapp_urlComps objectAtIndex:0];
                NSArray *liveapp_url_arr =  [liveapp_url_ componentsSeparatedByString:@"liveapp_url="];
                browserModel.liveapp_url = [liveapp_url_arr objectAtIndex:1];
                
                
                //live_list
                NSArray *liveapp_listComps =  [urlString componentsSeparatedByString:@"&pv"];
                NSString *liveapp_list_ = [liveapp_listComps objectAtIndex:0];
                NSArray *liveapp_list_arr =  [liveapp_list_ componentsSeparatedByString:@"liveapp_list="];
                browserModel.liveapp_list = [liveapp_list_arr objectAtIndex:1];
                
                //浏览量
                NSArray *pvComps =  [urlString componentsSeparatedByString:@"&pv="];
                browserModel.pv = [pvComps objectAtIndex:1];

                NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         browserModel.logo_url,@"logo_url",
                                         browserModel.company_name,@"company_name",
                                         browserModel.liveapp_url,@"liveapp_url",
                                         browserModel.liveapp_list,@"liveapp_list",
                                         browserModel.pv,@"pv",
                                         nil];

                // 写入数据库中
                liveapp_companyInfo_model *liveappModel = [[liveapp_companyInfo_model alloc]init];
                [liveappModel deleteDBdata];
                [liveappModel insertDB:infoDic];
                
                [browserModel release];
                [liveappModel release];
                
                //存好数据之后再返回云主页
                [self goCompanyInfo];
            }
        }
        return NO;
        
    };
    return YES;
}

- (void)goCompanyInfo{
    [self.navigationController popViewControllerAnimated:YES];
}

//当在请求加载中发生错误时，得到通知。会提供一个NSSError对象，以标识所发生错误类型。
-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error {
	NSLog(@"浏览器浏览发生错误...");
}

#pragma mark - HttpRequestDelegate

- (void)didFinishCommand:(NSMutableArray *)resultArray cmd:(int)commandid withVersion:(int)ver {
    //安全解析Http请求所返回的数据
    [self.mbProgressHUD hide:YES];
    [self.mbProgressHUD removeFromSuperViewOnHide];
    
    if (resultArray && ![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        int resultInt = [[[resultArray objectAtIndex:0] objectForKey:@"ret"]intValue];
        
        if (commandid == CHAT_PICTURE_DATA_SEND_COMMAND_ID) {
            if (resultInt == 1) {
                NSDictionary *tempDict = [resultArray lastObject];
                NSString *josnString=[tempDict JSONRepresentation];
                
                [_myWebView
                 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.parent.getImageCallback('%@')",josnString]];
                
                [Common checkProgressHUDShowInAppKeyWindow:@"上传成功" andImage:KAccessSuccessIMG];
                
            }else{
        
                [Common checkProgressHUDShowInAppKeyWindow:@"上传失败" andImage:KAccessFailedIMG];
            }
        }
    }else{
        
        [Common checkProgressHUDShowInAppKeyWindow:@"数据异常" andImage:KAccessFailedIMG];
    }
    
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}



@end
