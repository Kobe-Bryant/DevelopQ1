//
//  TextData.m
//  ql
//
//  Created by LazySnail on 14-5-7.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TextData.h"

@implementation TextData

@synthesize objtype = _objtype;

- (instancetype)init{
    self = [super init];
    if (self) {
        _objtype = 1;
        _txttype = 1;
        _txt = @"";
    }
    return self;
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [self init];
    if (self) {
        _txttype = [[dic objectForKey:@"txttype"]intValue];
        _status = [dic objectForKey:@"msgDataStatus"];

        NSDictionary *data = [dic objectForKey:@"data"];
        
        if ([data objectForKey:@"txt"] != nil) {
            _txt = [data objectForKey:@"txt"];
        } else {
            _txt = @"";
        }
    }
    return self;
}

- (NSDictionary *)getDic{
    
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             self.txt,@"txt",
                             [NSNumber numberWithInt:self.txttype],@"txttype",nil];
    
    NSDictionary * tempDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:self.objtype],@"objtype",
                              dataDic,@"data",self.status,@"msgDataStatus",nil];
    
    return tempDic;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    TextData * theCopy = [TextData new];
    theCopy.txt= [self.txt copy];
    theCopy.status = [self.status copy];
    return theCopy;
}

@end
