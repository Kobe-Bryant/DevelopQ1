//
//  PictureMessageCell.m
//  ql
//
//  Created by LazySnail on 14-6-6.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//
#import "PictureData.h"
#import "PictureMessageCell.h"
#import "UIImageView+WebCache.h"
#import "SnailCacheManager.h"

@implementation PictureMessageCell
{
    UIImageView * _imgMessageView;
    imageBrowser * _imgBrowser;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _imgMessageView = [UIImageView new];
        _imgMessageView.frame = (CGRect){.origin = CGPointMake(10, 10),.size = kChatThumbnailSize};
//        booky 8.6
        _imgMessageView.contentMode = UIViewContentModeScaleAspectFill;
        _imgMessageView.clipsToBounds = YES;
        _imgMessageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * singleTap = [UITapGestureRecognizer new];
        singleTap.numberOfTapsRequired = 1;
        [singleTap addTarget:self action:@selector(showTheWholePic)];
        [_imgMessageView addGestureRecognizer:singleTap];
        RELEASE_SAFE(singleTap);
    }
    return self;
}

- (void)showTheWholePic
{
    [self.delegate haveClickPicture];
     [_imgBrowser showWithAnimation:YES];
}

- (void)setWholeImgUrlStr:(NSString *)wholeImgUrlStr
{
    NSArray * photoArr = [NSArray arrayWithObjects:wholeImgUrlStr, nil];
    if (_imgBrowser != nil) {
        RELEASE_SAFE(_imgBrowser);
        _imgBrowser = [[imageBrowser alloc]initWithPhotoList:photoArr];
        _imgBrowser.delegate = self;
    } else{
        _imgBrowser = [[imageBrowser alloc]initWithPhotoList:photoArr];
        _imgBrowser.delegate = self;
    }
}

+ (float)caculateCellHeighFrom:(NSDictionary *)messageDic
{
    return kChatThumbnailSize.height + 40 + [MessageCell caculateCellHeighFrom:messageDic];
}

- (void)freshWithInfoDic:(NSDictionary *)messageDic
{
    NSString * thumbnailUrlStr = [messageDic objectForKey:@"pictureMessage"];
    self.wholeImgUrlStr = [messageDic objectForKey:@"wholeImgUrl"];
    MessageData * messageData = [messageDic objectForKey:@"msgObject"];
    PictureData * picData = (PictureData *)messageData.msgData;
    
    //读取缓存区图片
    UIImage * thumbnailImg = nil;
    if (picData.img != nil) {
        thumbnailImg = picData.img;
    } else {
        thumbnailImg = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:thumbnailUrlStr];
    }
    
    //如果有该图片缓存则直接等Size替换
    if (thumbnailImg != nil) {
        _imgMessageView.image = thumbnailImg;
    } else {
        NSURL * thumbnailUrl = [NSURL URLWithString:thumbnailUrlStr];
        UIImage * defaultImg = [UIImage imageCwNamed:@"default_600.png"];
        [_imgMessageView setImageWithURL:thumbnailUrl placeholderImage:defaultImg];
    }
    
    //将图片imageView 设置为Cell 的content View
    _messageContentView = _imgMessageView;
    [super freshWithInfoDic:messageDic];
    
    if (_indicatorView != nil) {
        _indicatorView.frame = CGRectMake(CGRectGetMinX(_sessionBackView.frame) + CGRectGetWidth(_sessionBackView.frame)/2 - CGRectGetWidth(_indicatorView.frame)/2, CGRectGetMaxY(_sessionBackView.frame) - CGRectGetWidth(_sessionBackView.frame)/2 - CGRectGetWidth(_indicatorView.frame)/2, _indicatorView.frame.size.width, _indicatorView.frame.size.height);
        UIView * shadowBack = [[UIView alloc]initWithFrame:_imgMessageView.frame];
        shadowBack.backgroundColor = [UIColor whiteColor];
        shadowBack.alpha = 0.5f;
        [_sessionBackView addSubview:shadowBack];
        self.shadowBackView = shadowBack;
        RELEASE_SAFE(shadowBack);
    }
}

#pragma mark - ImageBrowserDelegate 

- (void)shouldHideImageBrowser
{
    [self.delegate shouldHideWholePictureBrowser];
}

#pragma makr - MessageSendSuccessMethod OverideFatherMethod

- (void)recieveMessageSendNoti:(NSNotification *)notif
{
    if ([super judgeSendedNofityMessageWithNoti:notif]) {
        if (self.shadowBackView != nil) {
            if ([self.shadowBackView superview] != nil) {
                [self.shadowBackView removeFromSuperview];
            }
        }

    }
}


- (void)dealloc
{
    RELEASE_SAFE(_imgMessageView);
    RELEASE_SAFE(_imgBrowser);
    LOG_RELESE_SELF;
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
