//
//  YLDataObj.m
//  CardHolderDemo
//
//  Created by yunlai on 14-1-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import "YLDataObj.h"
#import "PYMethod.h"
#import "circle_contacts_model.h"

@implementation YLDataObj
@synthesize localID;
@synthesize name;
@synthesize phoneArray;

- (void)dealloc
{
    self.localID = nil;
    self.name = nil;
    self.phoneArray = nil;
    
    [super dealloc];
}

+(NSMutableDictionary*) LMaccordingFirstLetterGetTipsWithOutSelf:(BOOL)isLimitNoActivated{
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSMutableArray *dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    //获取所有联系人数据
    circle_contacts_model *contactMod = [[circle_contacts_model alloc]init];
    if (isLimitNoActivated) {
        //不显示未激活的用户
//        contactMod.where = [NSString stringWithFormat:@"user_id != %@ and status = 1",[Global sharedGlobal].user_id];
        contactMod.where = @"status = 1";
    }
    NSArray *allContactsArr = [contactMod getList];
    
    if (allContactsArr.count !=0) {
        //把联系人姓名和头像拼接一起保存在数组中
        for (int i =0; i<allContactsArr.count; i++) {
            NSDictionary *userDic = [allContactsArr objectAtIndex:i];
            [dataArr addObject:userDic];
            
        }
    }
    
    for (int j = 0; j < dataArr.count; j++) {
        NSString* name = [[dataArr objectAtIndex:j] objectForKey:@"realname"];
        NSString *key = nil;
        if (name.length > 0) {
            key = [PYMethod getPinYin:[name substringWithRange:NSMakeRange(0,1)]];
        }
        
        if (key != nil) {
            if ([[mutDict allKeys] containsObject:key]) {
                NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *tmpArr = [mutDict objectForKey:key];
                [arr addObjectsFromArray:tmpArr];
                [arr addObject:[dataArr objectAtIndex:j]];
                [mutDict setObject:arr forKey:key];
            } else {
                NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
                [arr addObject:[dataArr objectAtIndex:j]];
                [mutDict setObject:arr forKey:key];
            }
        }
        
    }
    RELEASE_SAFE(dataArr);
    
    //对数组进行全拼排序
    for (NSString* key in [mutDict allKeys]) {
        NSArray* arr = [mutDict objectForKey:key];
        if (arr.count > 1) {
            NSArray* newArr = [self sortRealNameWith:arr];
            
            [mutDict setObject:newArr forKey:key];
        }
        
    }
    
    return mutDict;
}

+ (NSMutableDictionary *)accordingFirstLetterGetTips{
    
    
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSMutableArray *dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    //获取所有联系人数据
    circle_contacts_model *contactMod = [[circle_contacts_model alloc]init];
    
    NSArray *allContactsArr = [contactMod getList];
    
    if (allContactsArr.count !=0) {
        //把联系人姓名和头像拼接一起保存在数组中
        for (int i =0; i<allContactsArr.count; i++) {
            NSDictionary *userDic = [allContactsArr objectAtIndex:i];
//            NSString *dataStr = [NSString stringWithFormat:@"%@,%@,%d,%@,%@",[userDic objectForKey:@"realname"],[userDic objectForKey:@"portrait"],[[userDic objectForKey:@"user_id"] intValue],[userDic objectForKey:@"company_name"],[userDic objectForKey:@"front_character"]];
//            [dataArr addObject:dataStr];
            [dataArr addObject:userDic];
            
        }
    }
    
    NSLog(@"--dataArr:%@--",dataArr);
    
    for (int j = 0; j < dataArr.count; j++) {
        NSString* name = [[dataArr objectAtIndex:j] objectForKey:@"realname"];
        NSString *key = nil;
        if (name.length > 0) {
            key = [PYMethod getPinYin:[name substringWithRange:NSMakeRange(0,1)]];
        }
        
        if (key != nil) {
            if ([[mutDict allKeys] containsObject:key]) {
                NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *tmpArr = [mutDict objectForKey:key];
                [arr addObjectsFromArray:tmpArr];
                [arr addObject:[dataArr objectAtIndex:j]];
                [mutDict setObject:arr forKey:key];
            } else {
                NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
                [arr addObject:[dataArr objectAtIndex:j]];
                [mutDict setObject:arr forKey:key];
            }
        }
        
    }
    RELEASE_SAFE(dataArr);
    
    return mutDict;
}

+ (NSMutableDictionary *)accordingFirstLetterGetTips:(NSArray *)dataArr {
    
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    for (int j = 0; j < dataArr.count; j++) {
        
        if ([[[dataArr objectAtIndex:j]objectForKey:@"realname"]length]>0) {
            NSString *key = [PYMethod getPinYin:[[[dataArr objectAtIndex:j]objectForKey:@"realname"]substringWithRange:NSMakeRange(0,1)]];
            
            if ([[mutDict allKeys] containsObject:key]) {
                NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *tmpArr = [mutDict objectForKey:key];
                [arr addObjectsFromArray:tmpArr];
                [arr addObject:[dataArr objectAtIndex:j]];
                [mutDict setObject:arr forKey:key];
            } else {
                NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
                [arr addObject:[dataArr objectAtIndex:j]];
                [mutDict setObject:arr forKey:key];
            }
        }
       
    }
    
    //对数组进行全拼排序
    for (NSString* key in [mutDict allKeys]) {
        NSArray* arr = [mutDict objectForKey:key];
        if (arr.count > 1) {
            NSArray* newArr = [self sortRealNameWith:arr];
            
            [mutDict setObject:newArr forKey:key];
        }
        
    }
    
    return mutDict;
}

+(NSArray*) sortRealNameWith:(NSArray*) arr{
    NSArray* newArr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2){
        
        NSDictionary* dic1 = (NSDictionary*)obj1;
        NSDictionary* dic2 = (NSDictionary*)obj2;
        
        NSString* str1 = [PYMethod getPinYin:[dic1 objectForKey:@"realname"]];
        NSString* str2 = [PYMethod getPinYin:[dic2 objectForKey:@"realname"]];
        
        return [str1 compare:str2];
    }];
    return newArr;
}

+(NSMutableDictionary*) accordingFirstLetterFromOrgs:(NSArray *)dataArr{
    NSMutableDictionary* mutDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    for (NSDictionary* dic in dataArr) {
        NSString* key = [PYMethod getPinYin:[[dic objectForKey:@"org_name"] substringWithRange:NSMakeRange(0, 1)]];
        if ([[mutDic allKeys] containsObject:key]) {
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *tmpArr = [mutDic objectForKey:key];
            [arr addObjectsFromArray:tmpArr];
            [arr addObject:dic];
            [mutDic setObject:arr forKey:key];
        } else {
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            [arr addObject:dic];
            [mutDic setObject:arr forKey:key];
        }
    }
    
    return mutDic;
}

@end
