//
//  PictureData.m
//  ql
//
//  Created by LazySnail on 14-5-7.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "PictureData.h"

@implementation PictureData

@synthesize objtype = _objtype;

- (id)init{
    self = [super init];
    if (self) {
        _objtype = 2;
//        _picsArr = [NSArray new];
        _desc = @"";
        _tbdesc = @"";
        _tburl = @"";
        _url = @"";
    }
    return self;
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [self init];
    if (self) {
        _objtype = 2;
        NSDictionary * dataDic = [dic objectForKey:@"data"];
        
        _tburl = [dataDic objectForKey:@"tburl"];
        _url = [dataDic objectForKey:@"url"];
        _status = [dic objectForKey:@"msgDataStatus"];
    }
    return self;
}

- (NSDictionary *)getDic{
    NSDictionary * dataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.tburl,@"tburl",
                              self.url,@"url",nil];
    
    NSDictionary * tempDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:self.objtype],@"objtype",
                              dataDic,@"data",
                              _status,@"msgDataStatus",
                              nil];
    return tempDic;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    PictureData * theCopy = [PictureData new];
    theCopy.desc = [self.desc copy];
    theCopy.tbdesc = [self.tbdesc copy];
    theCopy.tburl = [self.tburl copy];
    theCopy.url = [self.url copy];
    theCopy.status = [self.status copy];
    
    return theCopy;
}

- (void)dealloc
{
    RELEASE_SAFE(_desc);
    RELEASE_SAFE(_tburl);
    RELEASE_SAFE(_tbdesc);
    RELEASE_SAFE(_url);
    [super dealloc];
}
@end
