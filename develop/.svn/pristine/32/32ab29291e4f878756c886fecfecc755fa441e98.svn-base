//
//  VoiceData.m
//  ql
//
//  Created by LazySnail on 14-6-26.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "VoiceData.h"

@implementation VoiceData

@synthesize objtype = _objtype;

- (instancetype)init{
    self = [super init];
    if (self) {
        _objtype = 6;
        self.duration = 0;
        self.urlStr = @"";
    }
    return self;
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [self init];
    if (self) {
        self.status = [dic objectForKey:@"msgDataStatus"];
        
        NSDictionary *data = [dic objectForKey:@"data"];
        
        if ([data objectForKey:@"voicetime"] != nil) {
            self.duration = [[data objectForKey:@"voicetime"]intValue];
        } 
        
        if ([data objectForKey:@"link"]) {
            self.urlStr = [data objectForKey:@"link"];
        }
    }
    return self;
}

- (NSDictionary *)getDic{
    
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             self.urlStr,@"link",
                             [NSNumber numberWithInt:self.duration],@"voicetime",nil];
    
    NSDictionary * tempDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:self.objtype],@"objtype",
                              dataDic,@"data",
                              self.status,@"msgDataStatus",nil];
    
    return tempDic;
}

- (instancetype) copyWithZone:(NSZone *)zone
{
    VoiceData * theCopy = [VoiceData new];
    theCopy.status = [self.status copy];
    theCopy.urlStr = [self.urlStr copy];
    return theCopy;
}

- (void)dealloc
{
    [super dealloc];
    RELEASE_SAFE(self);
}

@end
