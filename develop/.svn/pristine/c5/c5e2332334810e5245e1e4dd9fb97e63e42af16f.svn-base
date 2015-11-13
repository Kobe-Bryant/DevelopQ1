//
//  YLDataObj.h
//  CardHolderDemo
//
//  Created by yunlai on 14-1-17.
//  Copyright (c) 2014年 yunlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDataObj : NSObject

@property (nonatomic,retain) NSNumber *localID;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSMutableArray *phoneArray;

// 根据名字首字母排列数据
+ (NSMutableDictionary *)accordingFirstLetterGetTips;

+(NSMutableDictionary*) LMaccordingFirstLetterGetTipsWithOutSelf:(BOOL) b;

// 解析姓名首字母
+ (NSMutableDictionary *)accordingFirstLetterGetTips:(NSArray *)dataArr;

// 解析组织名称首字母
+ (NSMutableDictionary*) accordingFirstLetterFromOrgs:(NSArray*) dataArr;

//名字全拼排序
+(NSArray*) sortRealNameWith:(NSArray*) arr;

@end
