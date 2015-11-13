//
//  MessageCell.m
//  ql
//
//  Created by LazySnail on 14-6-6.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "MessageCell.h"
#import "UIImageView+WebCache.h"
#import "MemberMainViewController.h"
#import "CRNavigationController.h"


@implementation MessageCell
@synthesize messageDictionary;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];
    
    if (self) {
        // Initialization code
        //用户名字
        _userName = [UILabel new];
        _userName.font = KQLSystemFont(12);
        _userName.textColor = [UIColor grayColor];
        _userName.backgroundColor = [UIColor clearColor];
        
        //用户头像
        _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kpadding, kpadding, 50, 50)];
        _headImgView.backgroundColor = [UIColor clearColor];
        _headImgView.userInteractionEnabled = YES;
        _headImgView.layer.cornerRadius = 25;
        _headImgView.clipsToBounds = YES;
        
        //add vincent
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImgViewTapGesture)];
        [_headImgView addGestureRecognizer:tap];
        RELEASE_SAFE(tap);
            
        //发送时间
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor colorWithRed:136.0f/225.0f green:136.0f/225.0f blue:136.0f/225.0f alpha:1.0f];
        _timeLabel.textAlignment = UITextAlignmentCenter;//booky
        _timeLabel.font = KQLSystemFont(SessionViewTimeFront);
        
        //消息背景框
        _sessionBackView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _sessionBackView.backgroundColor = [UIColor clearColor];
        _sessionBackView.userInteractionEnabled = YES;
        
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:
                                                    self
                                                    action:@selector(handleLongPress:)];
        [recognizer setMinimumPressDuration:0.4];
        [_sessionBackView addGestureRecognizer:recognizer];
        RELEASE_SAFE(recognizer);
        
        [self.contentView addSubview:_userName];
        [self.contentView addSubview:_headImgView];
        [self.contentView addSubview:_sessionBackView];
        [self.contentView addSubview:_timeLabel];
        
        //图片缓存器
        _sessionCellImgCache = [SDImageCache sharedImageCache];      
    }
    return self;
}

+ (float)caculateCellHeighFrom:(NSDictionary *)messageDic
{
    MessageData * data = [messageDic objectForKey:@"msgObject"];
    float textHeight = 0.0f;
    if (data.showTimeSign) {
        textHeight = timeLabelHight/2 + timeUpMargin;
    }
    return textHeight;
}

#pragma mark - Copying
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(action == @selector(copy:))
        return YES;
    
    return [super canPerformAction:action withSender:sender];
}

- (void)copy:(id)sender
{
    if ([self.messageDictionary objectForKey:@"textMessage"]) {
        [[UIPasteboard generalPasteboard] setString:[self.messageDictionary objectForKey:@"textMessage"]];
    }
    [self resignFirstResponder];
}

/*
 其实扩展的时候不需要在这里添加，直接添加在这个方法里
 -(BOOL)canPerformAction:(SEL)action withSender:(id)sender
 if(action == @selector(copy:)|| action == @selector(select:) )即可 add by devin
 
 UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"扩展Item项" action:@selector(more)];
 NSArray *itemArr = [NSArray arrayWithObjects:copyItem, nil];
 添加自定义方法的时候需要在canperformAction里加入 action == @selector(more)判断
 */
#pragma mark - Gestures
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    if(longPress.state != UIGestureRecognizerStateBegan
       || ![self becomeFirstResponder])
    return;
    
    //只有文本才有复制，图片录音没有
    if ([self.messageDictionary objectForKey:@"textMessage"]) {
        CGRect targetRect = [self convertRect:_messageContentView.frame
                                     fromView:_sessionBackView];
        
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setMenuVisible:YES animated:YES];
        [menuController setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:self];
    }
}

-(void)headImgViewTapGesture{
    //找到window最前面的ViewController
    kSessionCellStyle freshSessionStyle = [[self.messageDictionary objectForKey:@"sessionStyle"]intValue];
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    switch (freshSessionStyle)
    {
        case kSessionCellStyleSelf:
        {
            MemberMainViewController* memberVC = [[MemberMainViewController alloc] init];
            memberVC.lookId = [Global sharedGlobal].user_id.longLongValue;
            memberVC.accessType = AccessTypeSelf;
            memberVC.pushType = PushTypesButtom;
            
            CRNavigationController * nav = [[CRNavigationController alloc]initWithRootViewController:memberVC];
            [result presentViewController:nav animated:YES completion:nil];
            RELEASE_SAFE(nav);
            RELEASE_SAFE(memberVC);
        }
            break;
        case kSessionCellStyleOther:
        {
            //senderID receiverID
            MemberMainViewController* memberVC = [[MemberMainViewController alloc] init];
            memberVC.lookId = [[self.msgObject.speakerinfo objectForKey:@"uid"] intValue];//_msg.senderID;
            memberVC.accessType = AccessTypeLookOther;
            memberVC.pushType = PushTypesButtom;
            
            CRNavigationController * nav = [[CRNavigationController alloc]initWithRootViewController:memberVC];
            [result presentViewController:nav animated:YES completion:nil];
            RELEASE_SAFE(nav);
            RELEASE_SAFE(memberVC);
        }
            break;
    }
}

- (void)recieveMessageSendNoti:(NSNotification *)noti
{
    [self judgeSendedNofityMessageWithNoti:noti];
   }

- (BOOL)judgeSendedNofityMessageWithNoti:(NSNotification *)noti
{
    NSDictionary *retDic = [noti object];
    NSLog(@"In message cell Message Sended With dic %@ ",retDic);
    
    //通过locmsigid 来判断消息的发送成功 并从待确认的已发消息队列中移除
    if ([[retDic objectForKey:@"rcode"]intValue] == 0) {
        long locmsgid = [[retDic objectForKey:@"locmsgid"]longValue];
        if (self.msgObject.locmsgid == locmsgid)
        {
            self.msgObject.msgData.status = SendSuccessMessageData;
            // 将已发消息展现在界面上
            [_indicatorView stopAnimating];
            [_indicatorView removeFromSuperview];
            RELEASE_SAFE(_indicatorView);
            
            [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotiSendMessageSuccess object:nil];
            return YES;
        }
    }
    return NO;
}

- (void)freshWithInfoDic:(NSDictionary *)messageDic
{
    self.messageDictionary = messageDic;
    self.msgObject = [messageDic objectForKey:@"msgObject"];

    // 装载消息内容 如头像发送时间文本等
    if (self.msgObject.showTimeSign) {
        _timeLabel.hidden = NO;
        _timeLabel.frame = CGRectMake(KUIScreenWidth/2 - timeLabelWidth/2,  timeUpMargin, timeLabelWidth, timeLabelHight);
        _timeLabel.textAlignment = UITextAlignmentCenter;
        _timeLabel.backgroundColor = [UIColor clearColor];
        NSNumber * timeNum = [messageDic objectForKey:@"time"];
        _timeLabel.text = [Common makeSessionViewHumanizedTimeForWithTime:timeNum.doubleValue];
    } else{
        _timeLabel.hidden = YES;
        _timeLabel.frame = CGRectZero;
    }
    
    //添加消息内容视图
    if (_messageContentView != nil) {
        [_sessionBackView addSubview:_messageContentView];
    }
    
    //判断消息数据类型 如果是发送状态1 数据则打开进度视图
    if (self.msgObject.msgData.status.intValue == SendingMessageData.intValue)
    {
        if (_indicatorView == nil) {
            //添加进度指示器
            _indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
            _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            _indicatorView.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_indicatorView];
        }
        [_indicatorView startAnimating];

        //添加信息发送成功监听器
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieveMessageSendNoti:) name:kNotiSendMessageSuccess object:nil];
    } else {
        
        if (_indicatorView != nil) {
            [_indicatorView removeFromSuperview];
            RELEASE_SAFE(_indicatorView);
        }
    }
   
    //判断消息是否加发送失败标识
    if (self.msgObject.msgData.status.intValue == SendFailedMessageData.intValue)
    {
        if (_sendFaildFlag == nil && [_sendFaildFlag superview] == nil) {
            //如果该消息未发送成功则显示未发送成功提示
            UIImage * faildFlag = [[ThemeManager shareInstance]getThemeImage:@"ico_common_warn.png"];
            _sendFaildFlag = [[UIImageView alloc]initWithImage:faildFlag];
            _sendFaildFlag.layer.cornerRadius = 5;
            _sendFaildFlag.layer.masksToBounds = YES;
            [self.contentView addSubview:_sendFaildFlag];
        }
    } else {
        if (_sendFaildFlag != nil) {
            [_sendFaildFlag removeFromSuperview];
            RELEASE_SAFE(_sendFaildFlag);
        }
    }
    
  
    _userName.text = [messageDic objectForKey:@"name"];
    kSessionCellStyle freshSessionStyle = [[messageDic objectForKey:@"sessionStyle"]intValue];
    
    float namelength = _userName.text.length * 20;
    CGSize nameSize = [_userName.text sizeWithFont:KQLSystemFont(12) constrainedToSize:CGSizeMake(namelength, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    NSString * portraitStr = nil;
    NSURL * portraitUrl = nil;
    
    switch (freshSessionStyle)
    {
        case kSessionCellStyleSelf:
        {
            //获取自己的头像
            portraitStr = [[[Global sharedGlobal]userInfo] objectForKey:@"portrait"];
            portraitUrl = [NSURL URLWithString:portraitStr];
            
            UIImage * selfPortraitImg = [_sessionCellImgCache imageFromDiskCacheForKey:portraitStr];
            
            if (selfPortraitImg != nil) {
                _headImgView.image = selfPortraitImg;
            } else {
                [_headImgView setImageWithURL:portraitUrl placeholderImage:[UIImage imageNamed:DEFAULT_MALE_PORTRAIT_NAME]];
            }
            
            _headImgView.frame = CGRectMake(KUIScreenWidth - _headImgView.frame.size.width - LRMargin, UDMargin, _headImgView.frame.size.width, _headImgView.frame.size.height);
            _headImgView.backgroundColor = [UIColor clearColor];
            
            if (_sessionImageSelf == nil) {
                _sessionImageSelf = [UIImage imageNamed:@"bg_common_dialog_blue.png"];
                _sessionImageSelf = [[_sessionImageSelf stretchableImageWithLeftCapWidth:25 topCapHeight:25]retain];
            }
            _sessionBackView.image = _sessionImageSelf;
            _messageContentView.frame = (CGRect){.origin = {.x = DailogueFrameMargin,.y = DailogueFrameMargin},.size = _messageContentView.frame.size};
            _sessionBackView.frame =  CGRectMake(KUIScreenWidth - _messageContentView.bounds.size.width - PortraitDistanceLength - DailogueFrameMargin*2 - BubbleArrowLength,BubbleOriginY, _messageContentView.bounds.size.width + (DailogueFrameMargin*2 + BubbleArrowLength),_messageContentView.bounds.size.height + DailogueFrameMargin*2);
            
            _sendFaildFlag.frame = CGRectMake(_sessionBackView.frame.origin.x - _sendFaildFlag.frame.size.width - 5, CGRectGetMidY(_sessionBackView.frame) - _sendFaildFlag.frame.size.height/2, _sendFaildFlag.frame.size.width, _sendFaildFlag.frame.size.height);
            
            _userName.frame = CGRectMake(KUIScreenWidth - PortraitDistanceLength - nameSize.width - NamePortraitDistance ,UDMargin, nameSize.width + DailogueFrameMargin *2, nameSize.height + 5);
            
            _userName.textAlignment = UITextAlignmentCenter;
            _userName.hidden = YES;
        }
            break;
            
        case kSessionCellStyleOther:
        {
            //获取别人的头像
            portraitStr = [self.msgObject.speakerinfo objectForKey:@"portrait"];
            portraitUrl = [NSURL URLWithString:portraitStr];
            
            UIImage * otherPortraitImg = [_sessionCellImgCache imageFromDiskCacheForKey:portraitStr];
            
            if (otherPortraitImg != nil) {
                _headImgView.image = otherPortraitImg;
            } else {
                [_headImgView setImageWithURL:portraitUrl placeholderImage:[UIImage imageNamed:DEFAULT_MALE_PORTRAIT_NAME]];
            }
            
            _headImgView.frame = CGRectMake(LRMargin, UDMargin, _headImgView.frame.size.width, _headImgView.frame.size.height);
            
            if (_sessionImageOther == nil) {
                _sessionImageOther = [UIImage imageNamed:@"bg_common_dialog_white.png"];
                _sessionImageOther = [[_sessionImageOther stretchableImageWithLeftCapWidth:25 topCapHeight:25]retain];
            }
            _sessionBackView.image = _sessionImageOther;
            
            //由于聊天背景的会话泡泡左边比较宽 因此需要调整内容的位置左边间距设为20 px 使其局中
            _messageContentView.frame = (CGRect){.origin = {.x = BubbleArrowLength + DailogueFrameMargin,.y = DailogueFrameMargin},.size = _messageContentView.frame.size};
            
            _sessionBackView.frame = CGRectMake(PortraitDistanceLength ,BubbleOriginY, _messageContentView.bounds.size.width + (DailogueFrameMargin*2 + BubbleArrowLength), _messageContentView.bounds.size.height + (DailogueFrameMargin*2));
            
            _sendFaildFlag.frame = CGRectMake(CGRectGetMaxX(_sessionBackView.frame) + _sendFaildFlag.frame.size.width + 5, CGRectGetMidY(_sessionBackView.frame) - _sendFaildFlag.frame.size.height/2, _sendFaildFlag.frame.size.width, _sendFaildFlag.frame.size.height);
            
            _userName.frame = CGRectMake(LRMargin + _headImgView.frame.size.width + 10, UDMargin, nameSize.width + 20, nameSize.height +5);
            _userName.hidden = NO;
        }
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark- Dealloc

- (void)dealloc
{
    RELEASE_SAFE(_sessionBackView);
    RELEASE_SAFE(_sessionImageSelf);
    RELEASE_SAFE(_sessionImageOther);
    RELEASE_SAFE(_userName);
    RELEASE_SAFE(_timeLabel);
    RELEASE_SAFE(_headImgView);
    RELEASE_SAFE(_indicatorView);
    LOG_RELESE_SELF;
    [super dealloc];
}

@end
