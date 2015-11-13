//
//  config.h
//  cw
//
//  Created by siphp on 14-2-7.
//  Copyright 2014 yunlai. All rights reserved.

/* ========================================应用 配置=============================================== */

/*
 *
 *网络请求接口地址 配置
 */

// 服务器环境控制器 1 开发环境 2 内网测试 3 正式外网 4 为Linux 内网Java环境
#define EnvironmentJudger 2

//Java 服务器地址
#define ACCESS_SERVER_LINK  EnvironmentJudger == 2 ? @"http://192.168.1.57:8080/QL_APPInterfaceServers/" : (EnvironmentJudger == 2) ? @"http://192.168.1.47:8080/QL_APPInterfaceServers/" : ((EnvironmentJudger == 3) ? @"http://ql.yunlai.cn:8080/QL_APPInterfaceServers/" :(EnvironmentJudger == 4) ? @"http://192.168.1.187:8080/QL_APPInterfaceServers/" : @"http://192.168.1.123:8080/QL_APPInterfaceServers/")

// iM 服务器地址
#define SOCKETIP            EnvironmentJudger == 1 ? @"192.168.1.55" : (EnvironmentJudger == 2) ? @"192.168.1.45" : ((EnvironmentJudger == 3) ? @"im.yunlai.cn" : @"192.168.1.74")

//企业开通轻App链接
# define LIGHTAPPURL EnvironmentJudger == 1 ? @"http://192.168.1.56/common/index/company_app" : (EnvironmentJudger == 2) ? @"http://192.168.1.46/common/index/company_app" : ((EnvironmentJudger == 3) ? @"http://yq.yunlai.cn/common/index/company_app" : @"192.168.1.74")


//服务协议链接
#define SERVICEDELEGATE   EnvironmentJudger == 1 ? @"http://192.168.1.46/common/index/agreement" : (EnvironmentJudger == 2) ? @"http://192.168.1.46/common/index/agreement" : ((EnvironmentJudger == 3) ? @"http://yq.yunlai.cn/common/index/agreement" : @"192.168.1.74")

//圈子最大创建数
#define CREATECIRCLEMAX 5

//SOCKET端口 内网 外网 共用
#if EnvironmentJudger==1
#define SOCKETPORT 8100

#elif EnvironmentJudger==2
#define SOCKETPORT 8100

#elif EnvironmentJudger==3
#define SOCKETPORT 8100
#endif

//网络请求加密key
#define SignSecureKey       @"QLAPP906"

//数据库名称
#define dataBaseFile        @"ql.db"

//应用系统数据库名
#define AppDataBaseName     @"QlApplication.db"

//图片下载最大数
#define DOWNLOAD_IMAGE_MAX_COUNT 3

//loading提示
#define LOADING_TIPS        @"云端同步中..."

//更新版本标题
#define VERSIONTITLE        @"发现新版本"

//分享
#define CLIENT_SHARE_LINK   @"www.yunlai.cn"

//微信授权
#define WEICHATID           @"wx26dc8e121a2fa5d1"
// QQ授权
#define QQTencent           @"100520264"    // (注：需要将其转为16进制)
//微博接口
#define SINA                @"sina"
#define TENCENT             @"tencent"
#define SinaAppKey          @"956585871"
#define SinaAppSecret       @"20a7e950f6fe68ec8e0ddd410067f4e5"
#define QQAppKey            @"801460729"
#define QQAppSecret         @"dd4f243aa71ef1589d90c2bfcde18585"
#define SINAredirectUrl     @"http://our.3g.yunlai.cn/"
#define TENCENTredirectUrl  @"http://yungo.skyallhere.net:9001/download/index"

#define HOME_STR_COLOR [UIColor colorWithRed:102.f/255.f green:102.f/255.f blue:102.f/255.f alpha:1.f]

/* ========================================系统 参数=============================================== */

//app名称
#define appName                 @"云圈"

//前一次登录的用户名Key
#define kPreviousUserName       @"PreviousUserName"

//前一次登陆的组织id
#define kPreviousOrgID          @"PreviousOrgID "

//默认Http请求timeout时限
#define kHttpTimeOutTime        30

//聊天时间字体大小
#define SessionViewTimeFront    12
//时间框宽
#define timeLabelWidth          180
//时间框高
#define timeLabelHight          30


//系统版本号
#define IOS_VERSION_7 [[[UIDevice currentDevice] systemVersion] floatValue] > 6.99

//iphone4s和iphone5的适配
#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//版本ID KEY
#define APP_SOFTWARE_VER_KEY @"app_ver"

//版本ID 当前版本号
#define CURRENT_APP_VERSION 10


//app打开次数，用户弹出评分地址
#define APP_OPEN_NUM @"app_open_num"

//是否弹出更新提醒 key
#define IS_SHOW_UPDATE_ALERT @"is_show_update_alert"

//引导页面个数 GuideView
#define GUIDE_VIEW_NUM 4

//城市 KEY
#define CITY_KEY @"city_key"

//是否显示引导 KEY
#define GUIDE_KEY @"guide_key"

//token号 key
#define TOKEN_KEY @"token_key"

//gradeUrl评分地址
#define GRADEURL @"gradeUrl"

/* ========================================UI 配置=============================================== */
//bar 配置
#define SHOW_NAV_TAB_BG 2
#define BG_NAV_PIC @"top_bar.png"
#define BG_TAB_PIC @"bg_bottom_bar.png"

/*===========================================汇丰商学院颜色值=======================================*/
//上bar红色
#define COLOR_TOPBAR [UIColor colorWithRed:153/255.0 green:37/255.0 blue:22/255.0 alpha:1.f]
//背景淡色
#define COLOR_LIGHTWEIGHT [UIColor colorWithRed:232/255.0 green:237/255.0 blue:241/255.0 alpha:1.f]
//红色
#define COLOR_FONT [UIColor colorWithRed:205/255.0 green:51/255.0 blue:51/255.0 alpha:1.f]
//灰色
#define COLOR_GRAY [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.f]
//淡灰色
#define COLOR_GRAY2 [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.f]
//淡黑色
#define COLOR_DEFAULT [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.f]
//分割线颜色
#define COLOR_LINE [UIColor colorWithRed:232/255.0 green:237/255.0 blue:241/255.0 alpha:1.f]
//分割线颜色
#define COLOR_LINE_SLIGHT [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.f]
//左侧菜单背景
#define COLOR_MENE_BACKVIEW [UIColor colorWithRed:52/255.0f green:56/255.0f blue:59/255.0f alpha:1.f]
//左滑菜单选中颜色
#define COLOR_MENE_SELECTED [UIColor colorWithRed:0.1098 green:0.1098 blue:0.1098 alpha:0.98f]
//蓝色   按键色
#define COLOR_CONTROL [UIColor colorWithRed:0/255.0f green:160/255.0 blue:233/255.0 alpha:1.f]
//白色 上bar字体色
#define COLOR_TOPBARTXT [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.f]

//rgb的颜色
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

//左滑菜单 配置
#define ARRAYS_TAB_BAR [[NSMutableArray alloc] initWithObjects:@"动态",@"聊天",@"圈子",@"云主页",@"商务助手", nil];
#define ARRAYS_TAB_PIC_NAME [[NSMutableArray alloc] initWithObjects:@"ico_home_feed",@"ico_home_chat",@"ico_home_group",@"ico_home_member",@"ico_home_tool", nil];


/* ========================================公用====================================================== */

//聊天缩略图Size大小定义
#define kChatThumbnailSize      CGSizeMake(84, 84)

// 尺寸
#define KUpBarHeight            44.f
#define KDownBarHeight          49.f
#define KUIScreenWidth          [UIScreen mainScreen].applicationFrame.size.width
#define KUIScreenHeight         [UIScreen mainScreen].applicationFrame.size.height
#define kSelfViewHeight         self.view.bounds.size.height
#define kSelfViewWidth          self.view.bounds.size.width
//RGB获得颜色
#define kColorRGB(R,G,B,A) [UIColor colorWithRed:R green:G blue:B alpha:A]

// 颜色值
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

// 视图字体
#define KQLSystemFont(s)        [UIFont systemFontOfSize:s]
#define KQLboldSystemFont(s)    [UIFont boldSystemFontOfSize:s]

#define KCWNetNOPrompt          @"网络不可用，请检查您的网络"
#define KCWServerBusyPrompt     @"服务器繁忙，请稍后再试"
#define KCWNetBusyPrompt        @"网络繁忙，加载失败，请稍后再试"
//add vincent  2014.7.5
#define QLLoginErrorWarning     @"用户名或密码不能为空"

//add vincent  2014.7.5
#define QLPagingNumberCount    10

//add booky 8.6
//网络请求成功指示框表情图片
#define KAccessSuccessIMG       IMGREADFILE(@"ico_group_right.png")

//网络请求失败指示框表情图片
#define KAccessFailedIMG        IMGREADFILE(@"ico_group_wrong.png")

// 内存release置空
#define RELEASE_SAFE(x) if (x != nil) {[x release] ;x = nil;}

// view左上角的x ，y
#define VIEW_X(view) (view.frame.origin.x)
#define VIEW_Y(view) (view.frame.origin.y)

// view的宽高
#define VIEW_W(view)  (view.frame.size.width)
#define VIEW_H(view)  (view.frame.size.height)

// 系统的AppDelegate
#define APPDELEGATE                 ((AppDelegate*)[UIApplication sharedApplication].delegate)

// 系统的UIApplication
#define APPD                        [UIApplication sharedApplication]

// KeyWindow
#define APPKEYWINDOW                [[UIApplication sharedApplication]keyWindow]

/*消息状态定义*/
//1 为发送中
#define SendingMessageData          [NSNumber numberWithInt:1]
//2 为发送成功
#define SendSuccessMessageData      [NSNumber numberWithInt:2]
//3 为发送失败
#define SendFailedMessageData       [NSNumber numberWithInt:3]
//4 为接收未读消息
#define ReceiveMessageUnread        [NSNumber numberWithInt:4]


// 自我释放log
#define LOG_RELESE_SELF NSLog(@"Safe dealloc %@",self)

// 定义默认头像男 胡子
#define DEFAULT_MALE_PORTRAIT_NAME @"img_common_default_male1.png"

#define DEFAULT_FEMALE_PORTRAIT_NAME @"img_common_default_female2.png"

#define IMG(name) [UIImage imageNamed:name]
// 读取本地图片地址
#define IMGREADFILE(imageName) [UIImage imageCwNamed:imageName]

// UIBarButtonItem的事件
#define BARBUTTON(TITLE,SELECTOR)  [[UIBarButtonItem alloc]initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]

// 在Debug模式下就会输出信息，包括方法名，行数及你想要输出的内容
#ifdef DEBUG

#define DLog(fmt, ...) NSLog((@"%s [Line:%d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#else
#define DLog(...)

#endif


/* ========================================网络请求标识=============================================== */

#define NEED_UPDATE     1
#define NO_UPDATE       0

//设备令牌
#define APNS_COMMAND_ID                     1

//引导页
#define GUIDE_COMMAND_ID                    2

//闪屏
#define CHANGE_SCREENIMAGE_ID               3

//内容更新通知
#define CONTENT_MODIFY_NOTICE_ID            4

// 会员登录
#define MEMBER_LOGIN_COMMAND_ID             10

//会员注册
#define MEMBER_REGIST_COMMAND_ID            11

//会员注册获取验证码
#define MEMBER_REGISTERAUTHCODE_COMMAND_ID  12

//会员获取验证码
#define MEMBER_AUTHCODE_COMMAND_ID          13

//验证手机号和验证码
#define MEMBER_VERIFY_CODE_COMMAND_ID       21

//会员重置密码
#define MEMBER_UPDATEPWD_COMMAND_ID         14

//会员上传头像
#define MEMBER_UPDATEPIMAGE_COMMAND_ID      15

//会员注销
#define MEMBER_LOGOUT_COMMAND_ID            16

//邀请码
#define MEMBER_INVITED_COMMAND_ID           17

//验证手机号
#define VALIDATE_MOBILE_COMMAND_ID          22

//会员名片夹
#define MEMBER_CARD_COMMAND_ID              18

//消息列表
#define MEMBER_LISTINFO_COMMAND_ID          19

//会员二维码
#define MEMBER_QRCODE_COMMAND_ID            20

//个人信息修改
#define USERINFO_UPDATE_COMMAND_ID          23

//没有帐号小秘书
#define MEMBER_NOCOUNTTIPS_COMMAND_ID       24

//--------- 通讯录标示数25 ~ 50 ----------

//圈子主页
#define GROUP_LIST_COMMAND_ID               25

//创建圈子
#define GROUP_CREATE_COMMAND_ID             26

//成员列表邀请好友
#define INVITE_OTHER_COMMAND_ID             27

//组织成员列表详情
#define ORG_MEMBER_LIST_COMMAND_ID          28

//圈子成员列表信息
#define GROUP_MEMBER_LIST_COMMAND_ID        29

//圈子成员头衔修改
#define CIRCLE_MEMBER_DUTY_COMMAND_ID       30

//圈子详情圈子名称修改
#define CIRCLE_NAME_COMMAND_ID              31

//圈子详情圈子介绍修改
#define CIRCLE_INTRO_COMMAND_ID             32

//删除圈子成员
#define REMOVE_MEMBER_COMMAND_ID            33

//圈子成员列表
#define GROUP_CONTACTLIST_COMMAND_ID        34

//--------- 动态指示数 51 ~ 70 ---------

//动态列表数据
#define DYNAMIC_MAINLIST_COMMAND_ID         51

//动态与我相关
#define DYNAMIC_RELATIONME_COMMAND_ID       52

//点赞
#define DYNAMIC_SUPPORT_COMMAND_ID          53

//OOXX投票
#define DYNAMIC_OOXX_COMMAND_ID             54

//OOXX取消投票
#define DYNAMIC_OOXX_CANCEL_COMMAND_ID      62

//评论列表
#define DYNAMIC_COMMENTLIST_COMMAND_ID      55

//发布动态
#define DYNAMIC_PUBLISH_NEWS_COMMAND_ID     56

//发表评论
#define DYNAMIC_PUBLISH_COMMENT_COMMAND_ID  57

//动态列表加载更多
#define DYNAMIC_MAINLIST_MORE_COMMAND_ID    58

//评论列表加载更多
#define DYNAMIC_COMMENTLIST_MORE_COMMAND_ID 59

//赞列表加载更多
#define DYNAMIC_SUPPORTLIST_MORE_COMMAND_ID 60

//删除评论
#define DYNAMIC_DELETECOMMENT_COMMAND_ID    61

//@我
#define DYNAMIC_ABOUTMEMSGLIST_COMMAND_ID   70

//@我加载更多
#define DYNAMIC_ABOUTMEMSGLIST_MORE_COMMAND_ID   71

//单条动态详情
#define DYNAMIC_DETAIL_COMMAND_ID           72

//参加聚聚
#define DYNAMIC_TOGETHER_COMMAND_ID         73

//--------- 设置指示数 81 ~ 90 ---------
//提意见
#define SET_FEEDBACK_COMMAND_ID             81

//关于我们
#define SET_ABOUTUS_COMMAND_ID              82

//提醒设置
#define SET_MSGSET_COMMAND_ID               83

//检查新版本
#define SET_CHECKNEWVER_COMMAND_ID          84

//--------- 设置指示数 91 ~ 100 ---------
//特权列表
#define TOOL_PRIVILEGELIST_COMMAND_ID       91

//特权详情
#define TOOL_PRIVILEGEDETAIL_COMMAND_ID     92

//商务助手特权小秘书
#define TOOL_PRIVILEGETIPS_COMMAND_ID       93

//商务助手工具小秘书
#define TOOL_TOOLTIPS_COMMAND_ID            94

//商务工具列表
#define TOOL_LIST_COMMAND_ID                95

//--------- 设置指示数 101 ~ 110 聊一聊列表的很多东西 ---------

//----------聊一聊-----------//

//首次获取欢迎信息
#define CHAT_WELCOME_COMMAND_ID                     101

//获取自定义表情商店信息
#define CHAT_EMOTION_STORE_GET_INFO_COMMAND_ID      102

//获取自定义表情详情信息
#define CHAT_EMOTION_DETAIL_COMMAND_ID              103

//发送自定义表情下载或删除信号
#define CHAT_EMOTICON_MODIFY_COMMAND_ID             104


//--------- 设置指示数 150 ~ 160 云主页---------
//云主页信息
#define MIANPAGE_INFO_COMMAND_ID            150

//云主页查看他人信息
#define MIANPAGE_INFO_OTHER_COMMAND_ID      151

//邀请开通公司轻app
#define INVITE_COMPANY_COMMAND_ID           152

//云主页赞列表
#define MAINPAGE_LIKELIST_COMMAND_ID        153

//云主页赞列表更多
#define MAINPAGE_LIKELIST_MORE_COMMAND_ID   154

//云主页访客列表
#define MAINPAGE_VISITLIST_COMMAND_ID       155

//云主页访客列表更多
#define MAINPAGE_VISITLIST_MORE_COMMAND_ID  156

//云主页我有我要
#define MAINPAGE_DYNAMIC_COMMAND_ID         157

//云主页我的动态
#define MAINPAGE_SUPPLUYDEMAND_COMMAND_ID   158

//booky 云主页删除我的动态
#define MAINPAGE_DELETEDYANMIC_COMMAND_ID   159

//获取临时圈子信息
#define TEMPRORAY_INFO_COMMAND_ID           160

//发送聊天图片到Http服务器
#define CHAT_PICTURE_DATA_SEND_COMMAND_ID   161

//删除圈子成员
#define CIRCLE_MEMBER_DELETE_COMMAND_ID     162

//解散圈子
#define CIRCLE_DISMISS_COMMAND_ID           163

//获取固定圈子信息
#define CIRCLE_INFO_COMMAND_ID              164

//解散临时圈子
#define TEMP_CIRCLE_DISMISS_COMMAND_ID      165

//发送语音消息到Java服务器
#define CHAT_VOICE_DATA_SEND_COMMAND_ID     166

//云主页我的动态加载更多
#define MAINPAGE_DYNAMIC_MORE_COMMAND_ID    167

//绑定聚聚和临时会话
#define BIND_CIRCLE_COMMAND_ID              168

/* ========================================长连接网络标示符====================================================== */
//从标识数300之后开始

//登录
#define TCP_LOGIN_COMMAND_ID                300

//心跳包
#define TCP_XINTIAO_COMMAND_ID              301

//退出登陆
#define TCP_LOGOUT_COMMAND_ID               302

//反馈小秘书
#define TCP_FEEDBACK_SECRETARY_COMMAND_ID   305

//商务工具联系小秘书
#define TCP_TOOL_SECRETARY_COMMAND_ID       306

//商务特权联系小秘书
#define TCP_PRIVILEGE_SECRETARY_COMMAND_ID  307

//文本个人消息
#define TCP_TEXTMESSAG_EPERSON_COMMAND_ID   303

//获取文本消息
#define TCP_TEXTMESSAGE_ACK                 304

//邀请加入圈子
#define TCP_INVITE_JOIN_COMMAND_ID          308

//删除圈子成员
#define TCP_DELETECIRCLE_MEMBER_COMMAND_ID  309

//创建临时圈子
#define TCP_CREATE_TEMPORARY_CIRCLE         310

//添加临时圈子成员
#define TCP_ADD_TEMPORARY_MEMBER            311





/* ===== IM接口命令字定义===== */

//不加密版本号
#define IM_PACKAGE_NO_ENCRYPTION            0x1001

//采用AES加密协议加密版本号
#define IM_PACKAGE_ENCRYPTION_AES           0x1002

//包头扩展号
#define EXTEND_NUM                          0x0000

#define CMD_USER_LOGIN                      0x0000

#define CMD_USER_LOGIN_ACK                  0x0001

#define CMD_USER_LOGOUT                     0x0002

#define CMD_USER_LOGOUT_ACK                 0x0003

#define CMD_USER_HEARTBEAT                  0x0004

#define CMD_USER_HEARTBEAT_ACK              0x0005

//圈子消息发送
#define CMD_CIRCLE_MSG_SEND                 0x0010
//圈子消息发送回馈
#define CMD_CIRCLE_MSG_SEND_ACK             0x0011
//圈子消息接收
#define CMD_CIRCLE_MSG_RECEIVE              0x0012

#define CMD_DISCUSS_PUSHREC                 0x0014

//单聊消息发送
#define CMD_PERSONAL_MSGSEND                0x0015

//单聊消息发送回调
#define CMD_PERSONAL_MSGSEND_ACK            0x0016

//单聊消息接收
#define CMD_PERSONAL_MSGRECV                0x0017

//邀请成员加入圈子
#define CMD_INVITE_JOIN                     0x0019

#define CMD_INVITE_JOIN_ACK                 0x001a

//确认加入圈子
#define CMD_INVITE_JOIN_CONFIRM             0x001b

#define CMD_INVITE_JOIN_CONFIRM_ACK         0x001c

//创建临时圈子或者添加成员
#define CMD_TEMCIRCLE_ADDMEMBER             0x001d

//临时圈子创建回馈
#define CMD_TEMCIRCLE_ADDMEMBER_ACK         0x001e

//临时圈子消息发送
#define CMD_TEMP_CIRCLE_MSGSEND             0x0020

//临时圈子圈子消息发送回执
#define CMD_TEMP_CIRCLE_MSGSEND_ACK         0x0021

//临时圈子消息接收
#define CMD_TEMP_CIRCLE_MSGRECV             0x0022

//圈子成员变更
#define CMD_CIRCLEMEMBER_CHG_NTF            0x001f

//临时圈子成员变更
#define CMD_TEMP_CIRCLEMEMBER_CHG_NTF       0x0024

//单聊消息离线消息接收
#define CMD_PERSONAL_PUSHREC                0x0018

//单聊离线消息接收回馈
#define CMD_PERSONAL_PUSHREC_ACK            0x0036

//圈子离线消息的接收
#define CMD_DISCUSS_PUSHREC                 0x0014

//临时圈子离线消息接收
#define CMD_TEMP_CIRCLE_PUSHREC             0x0023

//固定圈子信息变更通知
#define CMD_CIRCLE_CHG_NTF                  0x0030

//临时圈子信息变更通知
#define CMD_TEMP_CIRCLE_CHG_NTF             0x0031

//固定圈子退出
#define CMD_QUIT_CIRCLE                     0x0032

//退出固定圈子相应
#define CMD_QUIT_CIRCLR_ACK                 0x0033

//临时圈子退出
#define CMD_QUIT_TEMP_CIRCLE                0x0034

//临时圈子退出响应
#define CMD_QUIT_TEMP_CIRCLE_ACK            0x0035

//被迫下线通知
#define CMD_FORCEDOWN_NTF                   0x0037

//申请加入固定圈子
#define CMD_APPLY_JOIN                      0x0040

//申请加入固定圈子响应
#define CMD_APPLY_JOIN_ACK                  0x0041

//同意加入固定圈子的申请
#define CMD_APPLY_JOIN_CONFIRM              0x0042

//同意加入固定圈子的申请响应
#define CMD_APPLY_JOIN_CONFIRM_ACK          0x0043

//拒绝加入固定圈子的申请
#define CMD_APPLY_JOIN_DECLINE              0x0044

//拒绝加入固定圈子的申请响应
#define CMD_APPLY_JOIN_DECLINE_ACK          0x0045
