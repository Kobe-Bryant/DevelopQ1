//
//  iMMessageDataManager.m
//  ql
//
//  Created by LazySnail on 14-6-5.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "iMMessageDataManager.h"
#import "PictureData.h"
#import "MessageData.h"
#import "TextData.h"
#import "VoiceData.h"
#import "CustomEmotionData.h"
#import "UIImageScale.h"
#import "SDImageCache.h"
#import "SnailCacheManager.h"
#import "XHAudioPlayerHelper.h"

#define ChatImgCompressionQuality 0.5f

typedef enum{
    MessageSendTypePicture,
}MessageSendType;

@interface iMMessageDataManager ()
{
    
}

@property (nonatomic,retain) NSMutableArray * waitingToSendMessageArr;

@end

@implementation iMMessageDataManager

static id _iMMessageManager;
static bool sendingIndicater = NO;

//单例一个iMMessageManager
+ (iMMessageDataManager *)shareiMMessageDataManager
{
    if (_iMMessageManager == nil)
    {
        _iMMessageManager = [iMMessageDataManager new];
    }
    return _iMMessageManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        _dataManager = [MessageDataManager shareMessageDataManager];
        NSMutableArray * arr = [NSMutableArray new];
        self.waitingToSendMessageArr = arr;
        RELEASE_SAFE(arr);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedMessageSendWithDic:) name:kNotiSendMessageSuccess object:nil];
    }
    return self;
}

//发送图片的默认key
//打包图片到Http服务器并发送图片数据到iM服务器
- (MessageData *)sendImageData:(NSDictionary *)imgPickerInfoDic
{
    NSDictionary * imgMessageDic = [imgPickerInfoDic objectForKey:kMessageData];
    NSDictionary * userInfoDic = [imgPickerInfoDic objectForKey:kMessageUserInfo];
    
    UIImage * img = [imgMessageDic objectForKey:@"img"];
    NSString * imgUrlStr = [imgMessageDic objectForKey:@"imgUrlStr"];
    
    NSMutableArray * picMuArr = [NSMutableArray new];
    NSMutableArray * picDefaulUrlArr = [NSMutableArray new];
    
    
    NSData * imgData = UIImageJPEGRepresentation(img, ChatImgCompressionQuality);
    [picMuArr addObject:imgData];
    [[SDImageCache sharedImageCache]storeImage:img forKey:imgUrlStr];
    [picDefaulUrlArr addObject:imgUrlStr];
    
    MessageData * picMsgData = [self generateMessageDataWithInfoDic:imgPickerInfoDic];
    //生成发送的消息数据
    PictureData * sendData = [[PictureData alloc]init];
    
    //附上缩略图地址
    sendData.tburl = imgUrlStr;
    //附上大图地址
    sendData.url = imgUrlStr;
    sendData.img = img;
    sendData.status = SendFailedMessageData;
    picMsgData.msgData = sendData;
    [self.dataManager restoreData:picMsgData];
    RELEASE_SAFE(sendData);
    
    NSArray * sendPicArr = [NSArray arrayWithArray:picMuArr];
    NSMutableDictionary * paramDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      sendPicArr,kMessageData,
                                      userInfoDic,kMessageUserInfo,
                                      picMsgData,kMessageObjct,
                                      nil];
    
    NSMutableDictionary * msgSendDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:MessageSendTypePicture],@"messageType",
                                            sendPicArr,@"resource",
                                            paramDic,@"param",
                                        nil];
    
    if ([self isCanConnectToInternet]) {
        picMsgData.msgData.status = SendingMessageData;
        [self.waitingToSendMessageArr addObject:msgSendDic];
        [self submitMessageFromSendingArray];
    } else {
        picMsgData.msgData.status = SendFailedMessageData;
    }
  
    RELEASE_SAFE(picMuArr);
    return picMsgData;
}

- (BOOL)isCanConnectToInternet
{
    if ([Common connectedToNetwork]) {
        return YES;
    } else {
        [Common checkProgressHUDShowInAppKeyWindow:@"无法连接到网络" andImage:nil];
        return NO;
    }
}

- (MessageData *)sendVoiceDataWithDic:(NSDictionary *)voiceInfoDic
{
    NSDictionary * voiceDic = [voiceInfoDic objectForKey:kMessageData];
    
    NSString * voiceRecordPath = [voiceDic objectForKey:@"voicePath"];
    NSData * voiceData = [NSData dataWithContentsOfFile:voiceRecordPath];
    
    //使用用户字典生成所需的消息体
    MessageData * voiceMsgData = [self generateMessageDataWithInfoDic:voiceInfoDic];
    
    //生成本地声音消息 并插入数据库和作界面的发送展示
    VoiceData * voice = [[VoiceData alloc]init];
    voice.duration = [[voiceDic objectForKey:@"voiceDuration"]intValue];
    voice.urlStr = voiceRecordPath;
    
    //默认 存储发送失败状态 在收到发送成功反馈后刷新
    voice.status = SendFailedMessageData;
    voiceMsgData.msgData = voice;
    [self.dataManager restoreData:voiceMsgData];
    
    //注意添加顺序， restore 方法里面将会添加是否显示时间戳的判断该方法要在restore之后
//    [voiceMsgData addMessageDataToMsg:voice];

    NSMutableDictionary * param = [NSMutableDictionary dictionaryWithDictionary:voiceInfoDic];
    [param setObject:voiceMsgData forKey:kMessageObjct];
    [self submitVoiceDataToHttpServer:voiceData andParamDic:param];
    
    //修改消息状态用于界面的菊花展示
    
    if ([self isCanConnectToInternet]) {
        voiceMsgData.msgData.status = SendingMessageData;
    } else {
        voiceMsgData.msgData.status = SendFailedMessageData;
    }
    return voiceMsgData;
}

//发送文本消息到iM服务器
- (MessageData *)sendTextData:(NSDictionary *)textInfoDic
{
    NSString * textStr = [textInfoDic objectForKey:kMessageData];
    //使用用户字典生成所需的消息体
    MessageData * textMsgData = [self generateMessageDataWithInfoDic:textInfoDic];
    
    //生成需要发送的文本消息
    TextData *textData = [[TextData alloc]init];
    textData.txt = textStr;
    textData.status = SendFailedMessageData;
    
    //默认 存储发送失败状态 在收到发送成功反馈后刷新
    textMsgData.msgData = textData;
    
    //存储该消息 并且生成本地的消息id 用于判断是否发送成功
    [self.dataManager restoreData:textMsgData];
    
    //发送消息到服务器
    [self sendMessageDataWith:textMsgData];
    //存储结束后设置消息状态为发送中
    
    if ([self isCanConnectToInternet]) {
        textMsgData.msgData.status = SendingMessageData;
    } else {
        textMsgData.msgData.status = SendFailedMessageData;
    }
    
    return [textMsgData copy];
}

- (MessageData *)sendCustomEmoticonWithEmoticonData:(CustomEmotionData *)emoticonData andInfoDic:(NSDictionary *)emoticonInfoDic
{
    MessageData * emoticonMessageData = [self generateMessageDataWithInfoDic:emoticonInfoDic];
    emoticonMessageData.msgData = emoticonData;
    emoticonMessageData.msgData.status = SendFailedMessageData;
    [self.dataManager restoreData:emoticonMessageData];
    [self sendMessageDataWith:emoticonMessageData];
    
    if ([self isCanConnectToInternet]) {
        emoticonMessageData.msgData.status = SendingMessageData;
    } else{
        emoticonMessageData.msgData.status = SendFailedMessageData;
    }
    return [emoticonMessageData copy];
}

//将音频文件上传给Java服务器端
- (void)submitVoiceDataToHttpServer:(NSData *)voiceData andParamDic:(NSMutableDictionary *)param
{
    NSString * requestStr = @"uploadfile.do?param=";
    [[NetManager sharedManager]accessService:nil
                                        data:voiceData
                                     command:CHAT_VOICE_DATA_SEND_COMMAND_ID
                                accessAdress:requestStr delegate:self withParam:param];
}

//将选择的图片提交给Http服务器
- (void)submitMessageFromSendingArray
{
    if (sendingIndicater == NO) {
        if (_waitingToSendMessageArr.count > 0) {
            NSDictionary * messageDic = [_waitingToSendMessageArr firstObject];
            int messageType = [[messageDic objectForKey:@"messageType"]intValue];
            switch (messageType) {
                case MessageSendTypePicture:{
                    NSArray * imgArr = [messageDic objectForKey:@"resource"];
                    NSMutableDictionary * param = [messageDic objectForKey:@"param"];
                    [self submitResource:imgArr withParam:param];
                    [_waitingToSendMessageArr removeObject:messageDic];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (void)submitResource:(NSArray *)resources withParam:(NSMutableDictionary *)param
{
    //设置发送上传指示器为Yes 限制后面的发送操作将其添加到发送队列中延后发送
    sendingIndicater = YES;
    NSString * requestStr = @"uploadfile.do?param=";
    [[NetManager sharedManager]accessService:nil
                                    dataList:resources
                                     command:CHAT_PICTURE_DATA_SEND_COMMAND_ID
                                accessAdress:requestStr
                                    delegate:self
                                   withParam:param];
}

//发送MessageData到iM服务器 用于为sendPic.. 和sendText...提供发送方法
- (void)sendMessageDataWith:(MessageData *)msgData
{
    //更新本地存储的消息 用于图片声音的链接跟新 将发送状态设置为失败 发送成功后会再次作跟新
    MessageData * updateData = [msgData copy];
    
    updateData.msgData.status = SendFailedMessageData;
    if (msgData.msgData.objtype != dataTypeText) {
        [self.dataManager updateData:msgData];
    }
    
    //将消息存入待确认发送成功消息队列
    [self.dataManager.dataQueue addObject:msgData];
    RELEASE_SAFE(updateData);
    //判断iM服务器是否链接 如果连接则直接发送消息 若没有链接则先重新链接在登陆并且重新从wait队列中取出消息进行发送
    BOOL isConnected = [[ChatTcpHelper shareChatTcpHelper]connectToHost];
    if (isConnected) {
        [[TcpRequestHelper shareTcpRequestHelperHelper]sendMessagePackageCommandId:TCP_TEXTMESSAG_EPERSON_COMMAND_ID andMessageData:msgData];
    } else {
        [self.dataManager.waitToResendQueue addObject:msgData];
    }
    RELEASE_SAFE(msgData);
}

//将http服务器返回的数据封装为一个图片消息类型，并且发送给iM
- (void)sendPictureDataWithHttpServerResultArr:(NSMutableArray *)resultArr
{
    NSDictionary * picInfoDic = [resultArr firstObject];
    NSDictionary * imgInfoDic = [resultArr lastObject];
    NSString * wholeUrlStrs = [picInfoDic objectForKey:@"url"];
    NSString * thumbnailUrlStrs = [picInfoDic objectForKey:@"tburl"];
    MessageData * picMsgData = [imgInfoDic objectForKey:kMessageObjct];
    
    //由于可以选择发送多张图片因此 发送成功后搜到的是一推url
    NSArray * imgArr = [imgInfoDic objectForKey:kMessageData];
    NSArray * imgWholeUrlArr = [wholeUrlStrs componentsSeparatedByString:@","];
    NSArray * imgThumbnailUrlArr = [thumbnailUrlStrs componentsSeparatedByString:@","];
    
    if ([imgWholeUrlArr firstObject] != nil && imgWholeUrlArr.count > 0) {
        // 将发送出去的图片分别关联url并做本地的存储
        for (int i = 0; i < imgArr.count; i++) {
            NSData * wholeImgData = [imgArr objectAtIndex:i];
            UIImage *wholeImg = [UIImage imageWithData:wholeImgData];
            NSString * wholeUrlStr = [imgWholeUrlArr objectAtIndex:i];
            [[SDImageCache sharedImageCache]storeImage:wholeImg forKey:wholeUrlStr];
            
            UIImage * thumbnailImg = [wholeImg fillSize:kChatThumbnailSize];
            NSString * thumbnailUrlStr = [imgThumbnailUrlArr objectAtIndex:i];
            [[SDImageCache sharedImageCache]storeImage:thumbnailImg forKey:thumbnailUrlStr];
            
            PictureData * picData = (PictureData *)picMsgData.msgData;
            picData.tburl = thumbnailUrlStr;
            picData.url = wholeUrlStr;
        }
    }
    [self sendMessageDataWith:picMsgData];
}

//将http服务器返回的数据封装为一个声音消息类型，并且发送给iM
- (void)sendVoiceMessageWithHttpServerResultArr:(NSMutableArray *)resultArr
{
    NSDictionary * voiceUrlDic = [resultArr firstObject];
    NSDictionary * voiceMessageUserDic = [resultArr lastObject];
    NSDictionary * voiceDic = [voiceMessageUserDic objectForKey:kMessageData];
    
    MessageData * voice = [voiceMessageUserDic objectForKey:kMessageObjct];
    VoiceData * freshData = (VoiceData *)voice.msgData;
    NSString * retreiveUr = [voiceUrlDic objectForKey:@"tburl"];
  
    if (retreiveUr != nil && ![retreiveUr isEqualToString:@""]) {
        //  存储跟新发送消息声音消息key到本地
        NSString * previousVoicePath = [voiceDic objectForKey:@"voicePath"];
        NSString * voiceInternetUrlStr = [voiceUrlDic objectForKey:@"tburl"];
        // 获取Url对应的本地缓存路径
        NSString * voiceCachePath = [SnailCacheManager getVoiceCachePathForKey:voiceInternetUrlStr];
        
        [[NSFileManager defaultManager] moveItemAtPath:previousVoicePath toPath:voiceCachePath error:nil];
       
        freshData.urlStr = retreiveUr;
        [self sendMessageDataWith:voice];

        if ([[NSFileManager defaultManager]isExecutableFileAtPath:voiceCachePath]) {
            if (previousVoicePath != nil) {
                [[NSFileManager defaultManager]removeItemAtPath:previousVoicePath error:nil];
            }
        }
    } else {
        [Common checkProgressHUDShowInAppKeyWindow:@"上传语音失败" andImage:KAccessFailedIMG];
    }
}

//生成带有用户信息的消息数据
- (MessageData *)generateMessageDataWithInfoDic:(NSDictionary *)infoDic
{
    NSDictionary * senderInfoDic = [infoDic objectForKey:kMessageUserInfo];
    //获取用户基本信息
    NSNumber *user_id = [NSNumber numberWithLongLong:[[[Global sharedGlobal]user_id]longLongValue]];
    NSTimeInterval timeInt = [[NSDate date]timeIntervalSince1970];
    NSDictionary *speakerInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                 user_id,@"uid",
                                 [NSNumber numberWithInt:2],@"client_type",
                                 [[[Global sharedGlobal]userInfo]objectForKey:@"realname"],@"nickname",nil];
    
    //将信息贴入消息体
    MessageListType _talk_type = [[senderInfoDic objectForKey:@"talk_type"]intValue];
    MessageData * msgData = [MessageData new];
    
    //判断服务器端存储类型 1 为存储 2 为不存储
    if (_talk_type == MessageListTypeOrg || _talk_type == MessageListTypeSecretory) {
        msgData.flag = 1;
    } else {
        msgData.flag = 0;
    }
    
    if (_talk_type == MessageListTypePerson || _talk_type == MessageListTypeOrg || _talk_type == MessageListTypeSecretory) {
        msgData.sendCommandType = CMD_PERSONAL_MSGSEND;
    } else if (_talk_type == MessageListTypeCircle){
        msgData.sendCommandType = CMD_CIRCLE_MSG_SEND;
        // 当flag = 3 时发送字段中无flag字段 圈子消息无须有保存选项
        msgData.flag = MessageListTypeCircle;
    } else if (_talk_type == MessageListTypeHave || _talk_type == MessageListTypeWant) {
        msgData.sendCommandType = CMD_PERSONAL_MSGSEND;
    }
    
    if (_talk_type == MessageListTypeTempCircle) {
        msgData.sendCommandType = CMD_TEMP_CIRCLE_MSGSEND;
    }
    
    msgData.msgtype = kMessageTypeNormal;
    msgData.speakerinfo = speakerInfo;
    msgData.senderID = [[[Global sharedGlobal]user_id]longLongValue];
    msgData.receiverID = [[senderInfoDic objectForKey:@"sender_id"]longLongValue];
    msgData.sendtime = timeInt;
    msgData.title = [senderInfoDic objectForKey:@"name"];
    msgData.talkType = _talk_type;
    
    return msgData;
}

#pragma  mark - SendSuccessNoficitaionCallBack
- (void)didFinishedMessageSendWithDic:(NSNotification *)notif
{
    NSDictionary *retDic = [notif object];
    NSLog(@"In iMManager Message Sended With dic %@ ",retDic);
    
    //通过locmsigid 来判断消息的发送成功 并从待确认的已发消息队列中移除
    if ([[retDic objectForKey:@"rcode"]intValue] == 0) {
        long locmsgid = [[retDic objectForKey:@"locmsgid"]longValue];
        MessageData * sendedMessage = nil;
        for (MessageData * msg in self.dataManager.dataQueue) {
            if (msg.locmsgid == locmsgid)
            {
                // 发送成功过后跟新 数据库发送消息状态为发送成功
                msg.msgData.status = SendSuccessMessageData;
                [_dataManager updateData:msg];
                sendedMessage = msg;
            }
        }
        [_dataManager.dataQueue removeObject:sendedMessage];
        [_dataManager.waitToResendQueue removeObject:sendedMessage];
    }
    else {
        [Common checkProgressHUD:[NSString stringWithFormat:@"发送消息失败: %@",[retDic objectForKey:@"other"]] andImage:nil showInView:APPKEYWINDOW];
    }
}

- (void)resetiMMessageSendStatus
{
    [_waitingToSendMessageArr removeAllObjects];
    sendingIndicater = NO;
}

#pragma mark - HttpRequestDelegate

- (void)didFinishCommand:(NSMutableArray *)resultArray cmd:(int)commandid withVersion:(int)ver
{
    //安全解析Http请求所返回的数据
    ParseMethod method = ^(){
        switch (commandid) {
            case CHAT_PICTURE_DATA_SEND_COMMAND_ID:
            {
                //重置发送标识对象，并发送剩余待传送对象
                sendingIndicater = NO;
                NSLog(@"Get image url %@",[resultArray objectAtIndex:0]);
                [self sendPictureDataWithHttpServerResultArr:resultArray];
                [self submitMessageFromSendingArray];
            }
                break;
            case CHAT_VOICE_DATA_SEND_COMMAND_ID:
            {
                NSLog(@"Get Voice Url %@",[resultArray firstObject]);
                [self sendVoiceMessageWithHttpServerResultArr:resultArray];
            }
                break;
            default:
                break;
        }
    };
    [Common securelyparseHttpResultArr:resultArray andMethod:method];
}

- (void)dealloc
{
    LOG_RELESE_SELF;
    [super dealloc];
}

@end
