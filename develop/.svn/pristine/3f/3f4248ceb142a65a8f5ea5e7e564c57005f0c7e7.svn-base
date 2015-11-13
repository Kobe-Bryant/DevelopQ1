//
//  FatherManager.h
//  ql
//
//  Created by LazySnail on 14-6-13.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FatherCircleManager;

@protocol FatherCircleManagerDelegate <NSObject>

@optional
- (void)dismissCircleSuccess:(FatherCircleManager *)sender;
- (void)removeMemberSucess:(FatherCircleManager *)sender;
- (void)createCircleSucess:(FatherCircleManager *)sender andCircleID:(long long)circleID;
@end

@interface FatherCircleManager : NSObject

@property (nonatomic, assign) id <FatherCircleManagerDelegate> fatherDelegate;
@property (nonatomic, retain) NSIndexPath * removeIndexPath;


@end
