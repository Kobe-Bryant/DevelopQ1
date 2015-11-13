//
//  VoiceData.h
//  ql
//
//  Created by LazySnail on 14-6-26.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "OriginData.h"

@interface VoiceData : OriginData <NSCopying>

@property (nonatomic, assign) int duration;

@property (nonatomic, retain) NSString * urlStr;

@property (nonatomic, assign) UITableViewCell * currentCell;

@end
