//
//  AlertView.h
//  lable
//
//  Created by Dream on 14-7-9.
//  Copyright (c) 2014年 Yunlai-mac02. All rights reserved.
//

#import <UIKit/UIKit.h>

//add by devin 主要用于登陆红色的提示

@interface AlertView : UIView{
    UIImageView *_image;
    UILabel *_lable;
}

@property (nonatomic,retain) UIImageView *image;
@property (nonatomic, retain) UILabel *lable;
@end
