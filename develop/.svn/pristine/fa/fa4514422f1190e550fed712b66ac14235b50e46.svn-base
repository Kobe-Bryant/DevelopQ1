//
//  LoginViewController.h
//  ql
//
//  Created by ChenFeng on 14-1-9.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"
#import "MBProgressHUD.h"
#import "SFHFKeychainUtils.h"
#import "LoginManager.h"
#import "AlertView.h"

@interface LoginViewController : UIViewController<AsyncSocketDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MBProgressHUDDelegate,LoginManagerDelegate>
{
    AsyncSocket *_listenSocket;
    AsyncSocket *_clientSocket;
    AsyncSocket *_serverSocket;
    
    UITextField *_messageField;
    NSMutableArray *_clientArray;
    UIButton *_sendBtn;
    AlertView *_alertHud;  //登陆改为红色的提示语 add by devin
}
@end
