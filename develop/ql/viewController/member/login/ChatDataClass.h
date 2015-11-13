//
//  ChatDataClass.h
//  ql
//
//  Created by yunlai on 14-4-15.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _NSBubbleType
{
    BubbleTypeMine = 0,
    BubbleTypeSomeoneElse = 1
} NSBubbleType;

@interface ChatDataClass : NSObject
@property (readonly, nonatomic, strong) NSDate *date;
@property (readonly, nonatomic) NSBubbleType type;
@property (readonly, nonatomic, strong) NSString *text;

- (id)initWithText:(NSString *)text andDate:(NSDate *)date andType:(NSBubbleType)type;
+ (id)dataWithText:(NSString *)text andDate:(NSDate *)date andType:(NSBubbleType)type;

@end
