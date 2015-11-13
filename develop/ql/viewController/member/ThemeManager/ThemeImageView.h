//
//  ThemeImageView.h
//  WXWeibo
//
//  Created by chenfeng on 13-5-14.
//  Copyright (c) 2014年 yunlai.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeImageView : UIImageView

//图片名称
@property(nonatomic,copy)NSString *imageName;

- (id)initWithImageName:(NSString *)imageName;

@end
