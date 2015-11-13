//
//  AcceptInvitationLoginController.h
//  ql
//
//  Created by yunlai on 14-5-27.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"
#import "MBProgressHUD.h"
#import "SFHFKeychainUtils.h"
#import "LoginManager.h"
#import "AlertView.h"

@interface AcceptInvitationLoginController : UIViewController<AsyncSocketDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MBProgressHUDDelegate,LoginManagerDelegate>
{
    AsyncSocket *_listenSocket;
    AsyncSocket *_clientSocket;
    AsyncSocket *_serverSocket;
    
    UITextField *_messageField;
    NSMutableArray *_clientArray;
    UIButton *_sendBtn;
    AlertView *_alertHud; //提示语
}
@property (nonatomic ,retain) NSString *mobiles;
@property (nonatomic ,retain) NSString *userName;
@end
