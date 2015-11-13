//
//  PictureMessageCell.h
//  ql
//
//  Created by LazySnail on 14-6-6.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "MessageCell.h"
#import "imageBrowser.h"

@protocol PictureMessageCellDelegate <NSObject>

- (void)haveClickPicture;
- (void)shouldHideWholePictureBrowser;

@end

@interface PictureMessageCell : MessageCell <ImageBrowserDelegate>

@property (nonatomic, retain) NSString * wholeImgUrlStr;
@property (nonatomic, retain) UIView * shadowBackView;
@property (nonatomic, assign) id <PictureMessageCellDelegate> delegate;

@end
