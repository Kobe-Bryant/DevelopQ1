//
//  MessageCell.h
//  ql
//
//  Created by LazySnail on 14-6-6.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDImageCache.h"
#import "MessageData.h"

#define DailogueWidth               180
#define UDMargin                    10+CGRectGetMidY(_timeLabel.frame)
#define LRMargin                    10
#define timeUpMargin                0
#define kpadding                    10.f
#define DailogueFrameMargin         5.f
#define BubbleArrowLength           10.f
#define PortraitDistanceLength      65.f
#define BubbleOriginY               UDMargin + 18
#define NamePortraitDistance        10.f

typedef enum{
    kSessionCellStyleSelf ,
    kSessionCellStyleOther
}kSessionCellStyle;

@interface MessageCell : UITableViewCell
{
    UIImageView * _sessionBackView;
    UIImage *_sessionImageSelf;
    UIImage *_sessionImageOther;
    SDImageCache *_sessionCellImgCache;
    UILabel *_userName;
    UILabel *_timeLabel;
    UIImageView * _headImgView;
    UIView * _messageContentView;
    UIActivityIndicatorView * _indicatorView;
    UIImageView * _sendFaildFlag;
    BOOL * _isSendSuccess;
}
@property (nonatomic,retain) NSDictionary *messageDictionary;
@property (nonatomic,retain) MessageData * msgObject;
@property (nonatomic,retain) UIView * messageContentView;


- (void)freshWithInfoDic:(NSDictionary *)messageDic;
- (void)recieveMessageSendNoti:(NSNotification *)notif;
- (BOOL)judgeSendedNofityMessageWithNoti:(NSNotification *)noti;
+ (float)caculateCellHeighFrom:(NSDictionary *)messageDic;

@end
