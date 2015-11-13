//
//  DBConfig.m
//  cw
//
//  Created by siphp on 13-8-12.
//
//

#import "DBConfig.h"

@implementation DBConfig

//所有数据表
+(NSDictionary *)getDbTablesDic
{
    // 欢迎页信息表
    NSString *t_welcome_info = @"t_welcome_info";
    NSString *t_welcome_info_sql = @"create table t_welcome_info(image_path TEXT,desc TEXT,btn_name TEXT);";
    
    //会员登录信息表
    NSString *t_login_info = @"t_login_info";
    NSString *t_login_info_sql = @"create table t_login_info(id INTEGER PRIMARY KEY,realname TEXT,portrait TEXT,role TEXT,company_name TEXT,front_character TEXT);";
    
    //会员登录组织信息表
    NSString *t_login_organization = @"t_login_organization";
    NSString *t_login_organization_sql = @"create table t_login_organization(id INTEGER PRIMARY KEY,front_character TEXT,name TEXT,\
    parent_id INTEGER,position TEXT,cat_pic TEXT);";
    
    //会员信息提醒设置
    NSString *t_userInfo_setting = @"t_userInfo_setting";
    NSString *t_userInfo_setting_sql = @"create table t_userInfo_setting(id INTEGER,msg_alert INTEGER,\
    supply_demand_alert INTEGER,company_dynamic_alert INTEGER,dynamic_alert INTEGER,\
    open_time_alert INTEGER,private_password TEXT,chat_message_checked INTEGER DEFAULT 0);";
    
    //会员圈子信息
    NSString *t_user_circles = @"t_user_circles";
    NSString *t_user_circles_sql = @"create table t_user_circles(id INTEGER PRIMARY KEY,user_sum INTEGER,image_path TEXT,\
    content TEXT,portrait TEXT,front_character TEXT,creater_name TEXT,name TEXT);";
    
    
    //会员名片夹
    NSString *t_member_card = @"t_member_card";
    NSString *t_member_card_sql = @"create table t_member_card(id INTEGER PRIMARY KEY,username TEXT,realname TEXT,\
    email TEXT,portrait TEXT,mobile TEXT,sex INTEGER,weixin TEXT,weibo TEXT,birthday INTEGER,signature TEXT,visitor_sum INTEGER,\
    agree_sum INTEGER,permission INTEGER,is_login INTEGER);";
    
    //组织列表
    NSString *t_org_list = @"t_org_list";
    NSString *t_org_list_sql = @"create table t_org_list(id INTEGER PRIMARY KEY,name TEXT,\
    parent_id INTEGER,position INTEGER,cat_pic TEXT,front_character TEXT,member_count INTEGER DEFAULT 0);";
    
    //固定圈子列表
    NSString *t_circle_list = @"t_circle_list";
    NSString *t_circle_list_sql = @"create table t_circle_list(circle_id INTEGER PRIMARY KEY,user_sum INTEGER,image_path TEXT,\
    content TEXT,portrait TEXT,front_character TEXT,creater_name TEXT,creater_id INTEGER,name TEXT,msgid INTEGER DEFAULT 0,unread INTEGER DEFAULT 0,msg_switch INTEGER DEFAULT 1);";
    
    //临时圈子列表
    NSString *t_temporary_circle_list = @"t_temporary_circle_list";
    NSString *t_temporary_circle_list_sql = @"create table t_temporary_circle_list(temp_circle_id INTEGER PRIMARY KEY,name TEXT,\
    portrait TEXT,front_character TEXT,creater_name TEXT,creater_id INTEGER,user_sum INTEGER,msgid INTEGER DEFAULT 0,msg_switch INTEGER DEFAULT 1);";
    
    //组织成员列表
    NSString *t_org_member_list = @"t_org_member_list";
    NSString *t_org_member_list_sql = @"create table t_org_member_list(user_id INTEGER PRIMARY KEY,status INTEGER,\
    portrait TEXT,company_name TEXT,front_character TEXT,is_supply INTEGER,realname TEXT,invite_status INTEGER,honor_sort INTEGER,honor TEXT,org_id INTEGER,level INTEGER,role TEXT,sex INTEGER);";
    
    //圈子成员列表
    NSString *t_circle_member_list = @"t_circle_member_list";
    NSString *t_circle_member_list_sql = @"create table t_circle_member_list(circle_id INTEGER, user_id INTEGER,realname TEXT,\
    portrait TEXT,role TEXT,created INTEGER,sex INTEGER,company_name TEXT);";
    
    //临时圈子成员列表
    NSString *t_temporary_circle_member_list = @"t_temporary_circle_member_list";
    NSString *t_temporary_circle_member_list_sql = @"create table t_temporary_circle_member_list(circle_id INTEGER, user_id INTEGER,realname TEXT,\
    portrait TEXT,role TEXT,created INTEGER);";
    
    // 临时圈子消息列表
    //圈子消息
    NSString *t_temporary_circle_chat_msg = @"t_temporary_circle_chat_msg";
    NSString *t_temporary_circle_chat_msg_sql = @"create table t_temporary_circle_chat_msg(id INTEGER PRIMARY KEY,sender_id INTEGER,receiver_id INTEGER,msg TEXT,msgtype INTEGER,speakerinfo TEXT,msgid INTEGER,sendtime INTEGER,show_time BOOL)";
    
    //收到邀请加入圈子信息表
    NSString *t_invite_join_circlemsg = @"t_invite_join_circlemsg";
    NSString *t_invite_join_circlemsg_sql = @"create table t_invite_join_circlemsg(sender_id INTEGER,\
    nickname TEXT,client_type INTEGER,msg TEXT,send_time INTEGER,circle_name TEXT,circle_id INTEGER,circle_portrait TEXT,joined INTEGER);";
    
    //圈子联系人列表
    NSString *t_circle_contacts = @"t_circle_contacts";
    NSString *t_circle_contacts_sql = @"create table t_circle_contacts(user_id INTEGER PRIMARY KEY,realname TEXT,\
    portrait TEXT,role TEXT,company_name TEXT,front_character TEXT,nickname TEXT,level INTEGER,sex INTEGER,sub_org_id INTEGER,status INTEGER);";
    
    //云主页用户信息
    NSString *t_mainpage_userInfo = @"t_mainpage_userInfo";
    NSString *t_mainpage_userInfo_sql = @"create table t_mainpage_userInfo(id INTEGER PRIMARY KEY,visitor_sum INTEGER,\
    mobile INTEGER,realname TEXT,company_name INTEGER,signature TEXT,portrait TEXT,care_sum INTEGER,company_role TEXT,\
    role TEXT,interests TEXT,nickname TEXT,email TEXT,sex INTEGER,is_new_vistor INTEGER,is_new_care INTEGER);";
    
    //云主页公司信息
    NSString *t_mainpage_company = @"t_mainpage_company";
    NSString *t_mainpage_company_sql = @"create table t_mainpage_company(id INTEGER PRIMARY KEY,user_id INTEGER,\
    name TEXT,image_path TEXT,scan_sum INTEGER,describe TEXT,lightapp TEXT,role TEXT);";
    
    //云主页公司动态
    NSString *t_mianpage_company_dynamic = @"t_mianpage_company_dynamic";
    NSString *t_mianpage_company_dynamic_sql = @"create table t_mianpage_company_dynamic(id INTEGER PRIMARY KEY,content TEXT,created INTEGER,url TEXT);";
    
    //云主页我有
    NSString *t_mainpage_newpublish = @"t_mainpage_newpublish";
    NSString *t_mainpage_newpublish_sql = @"create table t_mainpage_newpublish(id INTEGER PRIMARY KEY,content TEXT,\
    created INTEGER,type INTEGER);";
    
    //云主页我要
    NSString *t_mainpage_supplydemand = @"t_mainpage_supplydemand";
    NSString *t_mainpage_supplydemand_sql = @"create table t_mainpage_supplydemand(id INTEGER PRIMARY KEY,content TEXT,\
    created INTEGER,type INTEGER);";
    
    //单聊消息
    NSString *t_personal_chat_msg = @"t_personal_chat_msg";
    NSString *t_personal_chat_msg_sql = @"create table t_personal_chat_msg(id INTEGER PRIMARY KEY,sender_id INTEGER,receiver_id INTEGER,msg TEXT,msgtype INTEGER,speakerinfo TEXT,msgid INTEGER,sendtime INTEGER,show_time BOOL)";
    
    //聊一聊会话列表 为发送方id 可能重复 但可以与 talk_type 共同来确定新消息是属于哪一个表单 speak_id 说话这个人的id  用于确认接收到消息是属于哪个人
    NSString *t_chatmsg_list = @"t_chatmsg_list";
    NSString *t_chatmsg_list_sql = @"create table t_chatmsg_list(id INTEGER,talk_type INTEGER,drawable INTEGER,icon_path TEXT,title TEXT,speak_id INTEGER,speak_name TEXT,content TEXT,send_time INTEGER,can_delete BOOL,unreaded INTEGER,invited_sign INTEGER)";
    
    //自定义表情商店信息
    NSString *t_emoticon_store_info = @"t_emoticon_store_info";
    NSString *t_emoticon_store_info_sql = @"create table t_emoticon_store_info(ts INTEGER,thumbnails TEXT,res_path TEXT)";

    //自定义表情商店列表
    NSString *t_emoticon_list = @"t_emoticon_list";
    NSString *t_emoticon_list_sql = @"create table t_emoticon_list(title TEXT,subtitle TEXT,packet_path TEXT,packet_name TEXT,icon TEXT,chat_icon TEXT,price INTEGER,status INTEGER,emoticon_id INTEGER PRIMARY KEY,create_time INTEGER,update_time INTEGER,enabled INTEGER)";
    
    //自定义表情详情信息
    NSString *t_emoticon_detail_info = @"t_emoticon_detail_info";
    NSString *t_emoticon_detail_info_sql = @"create table t_emoticon_detail_info(description TEXT,status INTEGER,emoticon_id INTEGER,create_time INTEGER,update_time INTEGER, thumbnails TEXT,ts INTEGER,res_path TEXT,enabled INTEGER,packet_path TEXT,packet_name TEXT)";

    //自定义表情项列表 （每个表情自己的属性列表）
    NSString *t_emoticon_item_list = @"t_emoticon_item_list";
    NSString *t_emoticon_item_list_sql = @"create table t_emoticon_item_list(id INTEGER PRIMARY KEY,title TEXT,code TEXT,emoticon_id INTEGER,preview_icon TEXT,emoticon_path TEXT,create_time INTEGER,update_time INTEGER,enabled INTEGER)";

    //圈子消息
    NSString *t_circle_chat_msg = @"t_circle_chat_msg";
    NSString *t_circle_chat_msg_sql = @"create table t_circle_chat_msg(id INTEGER PRIMARY KEY,sender_id INTEGER,receiver_id INTEGER,msg TEXT,msgtype INTEGER,speakerinfo TEXT,msgid INTEGER,sendtime INTEGER,show_time BOOL)";
    
    
    //动态列表 表
    NSString* t_dynamic_card = @"t_dynamic_card";
    NSString* t_dynamic_card_sql = @"create table t_dynamic_card(id INTEGER,user_id INTEGER,type INTEGER,realname TEXT,portrait TEXT,title TEXT,content TEXT,pics TEXT,province TEXT,city TEXT,care_sum INTEGER,comment_sum INTEGER,response_sum INTEGER,start_time INTEGER,end_time INTEGER,url_content TEXT,created INTEGER,is_care INTEGER,is_choice INTEGER,choice1_sum INTEGER,choice2_sum INTEGER,org_id INTEGER,user_choice INTEGER,sex INTEGER,address TEXT);";
    
    //与我相关得动态表
    NSString* t_dynamic_relationme = @"t_dynamic_relationme";
    NSString* t_dynamic_relationme_sql = @"create table t_dynamic_relationme(id INTEGER PRIMARY KEY,user_id INTEGER,type INTEGER,relation_id INTEGER,relation_type INTEGER,realname TEXT,portrait TEXT,content TEXT,title TEXT,image_path TEXT,created INTEGER,is_care INTEGER,is_choice INTEGER,choice1_sum INTEGER,choice2_sum INTEGER,user_choice INTEGER,sex INTEGER)";
    
    //动态－评论列表
    NSString* t_dynamic_commentList = @"t_dynamic_commentList";
    NSString* t_dynamic_commentList_sql = @"create table t_dynamic_commentList(id INTEGER PRIMARY KEY,user_id INTEGER,realname TEXT,portrait TEXT,content TEXT,created INTEGER)";
    
    //动态－赞列表
    NSString* t_dynamic_support = @"t_dynamic_support";
    NSString* t_dynamic_support_sql = @"create table t_dynamic_support(id INTEGER PRIMARY KEY,user_id INTEGER,portrait TEXT)";
    
    //商务助手 表
    NSString* t_tool_privilege = @"t_tool_privilege";
    NSString* t_tool_privilege_sql = @"create table t_tool_privilege(id INTEGER PRIMARY KEY,title TEXT,image_path TEXT,start_time INTEGER,end_time INTEGER,desc TEXT,use_explain TEXT,updateTime TEXT)";
    
    //常用联系人 表
    NSString* t_dynamic_commonUseLinkman = @"t_dynamic_commonUseLinkman";
    NSString* t_dynamic_commonUseLinkman_sql = @"create table t_dynamic_commonUseLinkman(id INTEGER PRIMARY KEY,user_ids TEXT,realnames TEXT)";
    
    //常用圈子、组织 表
    NSString* t_dynamic_commonUseCircle = @"t_dynamic_commonUseCircle";
    NSString* t_dynamic_commonUseCircle_sql = @"create table t_dynamic_commonUseCircle(id INTEGER PRIMARY KEY,circle_ids TEXT,circle_names TEXT,org_ids TEXT,org_names TEXT)";
    
    //常用城市表
    NSString* t_dynamic_commonUseCity = @"t_dynamic_commonUseCity";
    NSString* t_dynamic_commonUseCity_sql = @"create table t_dynamic_commonUseCity(id INTEGER PRIMARY KEY,names TEXT)";
    
    //设置 配置表
    NSString* t_set_config = @"t_set_config";
    NSString* t_set_config_sql = @"create table t_set_config(msg_alert INTEGER,dynamic_alert INTEGER,supply_demand_alert INTEGER,open_time_alert INTEGER,company_dynamic_alert INTEGER,private_password TEXT)";
    
    //小秘书
    NSString* t_secretary = @"t_secretary";
    NSString* t_secretary_sql = @"create table t_secretary(id INTEGER,realname TEXT,portrait TEXT)";

    
    //小秘书消息表(反馈、工具、特权)
    NSString* t_secretary_tool = @"t_secretary_tool";
    NSString* t_secretary_tool_sql = @"create table t_secretary_tool(id INTEGER PRIMARY KEY,user_id INTEGER,realname TEXT,portrait TEXT,message TEXT,created INTEGER)";
    
    NSString* t_secretary_privilege = @"t_secretary_privilege";
    NSString* t_secretary_privilege_sql = @"create table t_secretary_privilege(id INTEGER PRIMARY KEY,user_id INTEGER,realname TEXT,portrait TEXT,message TEXT,created INTEGER)";
    
    NSString* t_secretary_feedback = @"t_secretary_feedback";
    NSString* t_secretary_feedback_sql = @"create table t_secretary_feedback(id INTEGER PRIMARY KEY,user_id INTEGER,realname TEXT,portrait TEXT,message TEXT,created INTEGER)";
    
    //关于我们
    NSString* t_set_aboutUs = @"t_set_aboutUs";
    NSString* t_set_aboutUs_sql = @"create table t_set_aboutUs(ver INTEGER,image_path TEXT,phone TEXT)";
    
    //主题配置
//    NSString* t_theme_config = @"t_theme_config";
//    NSString* t_theme_config_sql = @"create table t_theme_config(org_id INTEGER,org_name TEXT,cat_pic TEXT,url TEXT,themePackagePath TEXT)";
    
    //商务工具表
    NSString* t_tool_tools = @"t_tool_tools";
    NSString* t_tool_tools_sql = @"create table t_tool_tools(tool_id INTEGER PRIMARY KEY,tool_name TEXT,tool_image TEXT)";
    
    // 二维码扫描记录表
    NSString *t_scan_history = @"t_scan_history";
    NSString *t_scan_history_sql = @"create table t_scan_history(id INTEGER PRIMARY KEY,type TEXT,info TEXT,result TEXT,created INTEGER)";
    
    //商务助手侧边栏消息提醒时间跟新（目前没用这个表，可以考虑删了）
    NSString *t_toolupdatetime_sider = @"t_toolupdatetime_sider";
    NSString *t_toolupdatetime_sider_sql = @"create table t_toolupdatetime_sider(id INTEGER PRIMARY KEY,tool_updateTime TEXT)";
    
    //商务助手工具消息提醒时间更新
    NSString *t_toolupdatetime_list = @"t_toolupdatetime_list";
    NSString *t_toolupdatetime_list_sql = @"create table t_toolupdatetime_list(plug_id INTEGER PRIMARY KEY,plug_update_time TEXT)";
    
    //商务助手列表消息提醒时间更新
    NSString* t_tool_privilege_updatetime = @"t_tool_privilege_updatetime";
    NSString* t_tool_privilege_updatetime_sql = @"create table t_tool_privilege_updatetime(id INTEGER PRIMARY KEY,update_time TEXT,isRead TEXT)";
    
    //商务助手插件消息提醒时间更新
    NSString* t_tool_plug_updatetime = @"t_tool_plug_updatetime";
    NSString* t_tool_plug_updatetime_sql = @"create table t_tool_plug_updatetime(plug_id INTEGER PRIMARY KEY,plug_update_time TEXT,isRead TEXT)";
    
    //云主页公司信息liveApp接入
    NSString* t_liveapp_companyinfo = @"t_liveapp_companyinfo";
    NSString* t_liveapp_companyinfo_sql = @"create table t_liveapp_companyinfo(logo_url TEXT,company_name TEXT,liveapp_url TEXT,liveapp_list TEXT,pv TEXT)";
    
    
//    开通轻app add vincent
    NSString *t_mainpage_openeduser = @"t_mainpage_openeduser";
    NSString *t_mainpage_openeduser_sql = @"create table t_mainpage_openeduser(id INTEGER PRIMARY KEY,realname TEXT,portrait TEXT,company_name TEXT,lightapp TEXT)";
    
    NSDictionary *tableDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              t_login_info_sql,t_login_info,
                              t_login_organization_sql,t_login_organization,
                              t_member_card_sql,t_member_card,
                              t_org_list_sql,t_org_list,
                              t_circle_list_sql,t_circle_list,
                              t_org_member_list_sql,t_org_member_list,
                              t_circle_member_list_sql,t_circle_member_list,
                              t_user_circles_sql,t_user_circles,
                              t_userInfo_setting_sql,t_userInfo_setting,
                              t_mainpage_userInfo_sql,t_mainpage_userInfo,
                              t_mainpage_company_sql,t_mainpage_company,
                              t_mianpage_company_dynamic_sql,t_mianpage_company_dynamic,
                              t_mainpage_newpublish_sql,t_mainpage_newpublish,
                              t_mainpage_supplydemand_sql,t_mainpage_supplydemand,
                              t_personal_chat_msg_sql,t_personal_chat_msg,
                              t_dynamic_card_sql,t_dynamic_card,
                              t_dynamic_commentList_sql,t_dynamic_commentList,
                              t_dynamic_support_sql,t_dynamic_support,
                              t_dynamic_relationme_sql,t_dynamic_relationme,
                              t_tool_privilege_sql,t_tool_privilege,
                              t_set_config_sql,t_set_config,
                              t_secretary_sql,t_secretary,
                              t_chatmsg_list_sql,t_chatmsg_list,
                              t_circle_contacts_sql,t_circle_contacts,
                              t_secretary_feedback_sql,t_secretary_feedback,
                              t_secretary_privilege_sql,t_secretary_privilege,
                              t_secretary_tool_sql,t_secretary_tool,
                              t_dynamic_commonUseLinkman_sql,t_dynamic_commonUseLinkman,
                              t_dynamic_commonUseCircle_sql,t_dynamic_commonUseCircle,
                              t_dynamic_commonUseCity_sql,t_dynamic_commonUseCity,
                              t_set_aboutUs_sql,t_set_aboutUs,
                              t_invite_join_circlemsg_sql,t_invite_join_circlemsg,
                              t_circle_chat_msg_sql,t_circle_chat_msg,
                              t_temporary_circle_list_sql,t_temporary_circle_list,
                              t_temporary_circle_member_list_sql,t_temporary_circle_member_list,
                              t_temporary_circle_chat_msg_sql,t_temporary_circle_chat_msg,
                              t_welcome_info_sql,t_welcome_info,
                              t_tool_tools_sql,t_tool_tools,
                              t_scan_history_sql,t_scan_history,t_mainpage_openeduser_sql,t_mainpage_openeduser,
                              t_toolupdatetime_sider_sql,t_toolupdatetime_sider,
                              t_toolupdatetime_list_sql,t_toolupdatetime_list,
                              t_tool_privilege_updatetime_sql,t_tool_privilege_updatetime,
                              t_liveapp_companyinfo_sql,t_liveapp_companyinfo,
                              t_emoticon_list_sql,t_emoticon_list,
                              t_emoticon_store_info_sql,t_emoticon_store_info,
                              t_emoticon_item_list_sql,t_emoticon_item_list,
                              t_emoticon_detail_info_sql,t_emoticon_detail_info,
                              t_tool_plug_updatetime_sql,t_tool_plug_updatetime,
                              nil];
        return tableDic;
}

+ (NSDictionary *)getApplicationConfigTableDic
{
    //所有用户列表
    NSString * t_whole_users = @"t_whole_users";
    NSString * t_whole_users_sql = @"create table t_whole_users(user_account_name TEXT PRIMARY KEY, all_org_numbers TEXT,previous_choose_org INTEGER)";
    
    //------apns 表------//
    //版本信息表
    NSString* t_upgrade = @"t_upgrade";
    NSString* t_upgrade_sql = @"create table t_upgrade(ver INTEGER,url TEXT,remark TEXT,scoreUrl TEXT)";
    
    // 选择组织表
    NSString *t_chooseOrg = @"t_chooseOrg";
    NSString *t_chooseOrg_sql = @"create table t_chooseOrg(id INTEGER PRIMARY KEY,org_name TEXT,cat_pic TEXT,url TEXT,wel_pic TEXT,wel_content TEXT,wel_luokuan TEXT,wel_btn TEXT);";
    
    //小秘书文本
    NSString* t_secret_message = @"t_secret_message";
    NSString* t_secret_message_sql = @"create table t_secret_message(type INTEGER,message TEXT)";
    
    NSDictionary * appConfigTables = [NSDictionary dictionaryWithObjectsAndKeys:
                                      t_whole_users_sql,t_whole_users,
                                      t_upgrade_sql,t_upgrade,
                                      t_chooseOrg_sql,t_chooseOrg,
                                      t_secret_message_sql,t_secret_message,
                                      nil];
    return appConfigTables;
}

@end
