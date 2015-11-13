//
//  VoiceMessageCell.h
//  ql
//
//  Created by LazySnail on 14-6-26.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "MessageCell.h"
#import "VoiceData.h"

@protocol VoiceMessageCellDelegate <NSObject>

- (void)voiceMessageDidFinishedPlay:(id)sender;

@end

@interface VoiceMessageCell : MessageCell

@property (nonatomic, assign) id <VoiceMessageCellDelegate> delegate;

@property (nonatomic, retain) VoiceData * voiceObject;

- (void)playCurrentVoice;

@end
