//
//  LoginManager.h
//  ql
//
//  Created by LazySnail on 14-6-18.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest.h"

@class LoginManager;

@protocol LoginManagerDelegate <NSObject>

@optional
- (void)loginSuccess:(LoginManager *)sender;
- (void)loginFailed:(LoginManager *)sender;
- (void)loginWithError:(LoginManager *)sender;
- (void)userUnExist:(LoginManager *)sender;
- (void)accessContactFinished:(LoginManager *)sender;
//无网络
-(void) loginNoWeb:(LoginManager*) sender;

- (void)LoginConnectFail; // add by devin

@end


@interface LoginManager : NSObject <HttpRequestDelegate,UIAlertViewDelegate>

@property (nonatomic, assign) id <LoginManagerDelegate> delegete;


+ (LoginManager *)shareLoginManager;

- (void)loginWithUserName:(NSString *)userName andPassword:(NSString *)passWord;

- (void)accessContactlistService:(int)orgId;

- (void)autoLogin;

- (void)loginOut;

@end
