//
//  ChatDataClass.m
//  ql
//
//  Created by yunlai on 14-4-15.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "ChatDataClass.h"

@implementation ChatDataClass

@synthesize date = _date;
@synthesize type = _type;
@synthesize text = _text;

+ (id)dataWithText:(NSString *)text andDate:(NSDate *)date andType:(NSBubbleType)type
{
    return [[[ChatDataClass alloc] initWithText:text andDate:date andType:type] autorelease];
}

- (id)initWithText:(NSString *)initText andDate:(NSDate *)initDate andType:(NSBubbleType)initType
{
    self = [super init];
    if (self)
    {
        _text = [initText retain];
        if (!_text || [_text isEqualToString:@""]) _text = @" ";
        
        _date = [initDate retain];
        _type = initType;
    }
    return self;
}

- (void)dealloc
{
    [_date release];
	_date = nil;
	[_text release];
	_text = nil;
    [super dealloc];
}

@end
