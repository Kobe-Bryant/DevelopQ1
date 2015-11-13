//
//  TogetherData.m
//  ql
//
//  Created by yunlai on 14-8-20.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "TogetherData.h"

@implementation TogetherData

@synthesize objtype = _objtype;

-(instancetype) init{
    if (self = [super init]) {
        _objtype = 8;
        _ID = 0;
        _txt = @"";
        _msgdesc = @"";
    }
    return self;
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]){
        _objtype = [[dic objectForKey:@"objtype"]intValue];
        NSDictionary * dataDic = [dic objectForKey:@"data"];
        _ID = [[dataDic objectForKey:@"id"]intValue];
        _msgdesc = [dataDic objectForKey:@"msgdesc"];
        _txt = [dataDic objectForKey:@"txt"];
    }
    return self;
}

-(NSDictionary*) getDic{
    NSDictionary* dataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:self.ID],@"id",
                             self.txt,@"txt",
                             self.msgdesc,@"msgdesc",
                             nil];
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithInt:self.objtype],@"objtype",
                         dataDic,@"data",
                         self.status,@"msgDataStatus",
                         nil];
    
    return dic;
}

@end
