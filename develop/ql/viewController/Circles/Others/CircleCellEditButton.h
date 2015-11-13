//
//  CircleCellEditButton.h
//  ql
//
//  Created by LazySnail on 14-6-9.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleCellEditButton : UIButton

//用于赋值其父类cell的indexPath
@property (nonatomic, retain) NSIndexPath * cellIndexPath;

@end
