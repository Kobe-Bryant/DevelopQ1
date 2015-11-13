//
//  wantHaveData.m
//  ql
//
//  Created by yunlai on 14-6-18.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "wantHaveData.h"

@implementation wantHaveData

@synthesize objtype = _objtype;

-(instancetype) init{
    if (self = [super init]) {
        _objtype = 7;
        _tbdesc = @"";
        _tburl = @"";
        _ID = 0;
        _txt = @"";
        _msgdesc = @"";
        _type = PersonMessageHave;
    }
    return self;
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]){
        _objtype = [[dic objectForKey:@"objtype"]intValue];
        NSDictionary * dataDic = [dic objectForKey:@"data"];
        _tbdesc = [dataDic objectForKey:@"tbdesc"];
        _tburl = [dataDic objectForKey:@"tburl"];
        _ID = [[dataDic objectForKey:@"id"]intValue];
        _msgdesc = [dataDic objectForKey:@"msgdesc"];
        _txt = [dataDic objectForKey:@"txt"];
        _type = [[dataDic objectForKey:@"type"]intValue];
    }
    return self;
}

-(NSDictionary*) getDic{
    NSDictionary* dataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             self.tbdesc,@"tbdesc",
                             self.tburl,@"tburl",
                             [NSNumber numberWithInt:self.ID],@"id",
                             self.txt,@"txt",
                             self.msgdesc,@"msgdesc",
                             [NSNumber numberWithInt:self.type],@"type",
                             nil];
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithInt:self.objtype],@"objtype",
                         dataDic,@"data",
                         self.status,@"msgDataStatus",
                         nil];
    
    return dic;
}

@end
