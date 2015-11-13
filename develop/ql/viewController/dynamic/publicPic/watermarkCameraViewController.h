//
//  WatermarkCameraViewController.h
//  JWProject
//
//  Created by 云来ios－04 on 13-10-26.
//  Copyright (c) 2013年 云来ios－04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImagePickerController.h"

@protocol WatermarkCameraViewControllerDelegate <NSObject>

-(void)didSelectImages:(NSArray *)images;

@end

@interface WatermarkCameraViewController : UIViewController<UIScrollViewDelegate,QBImagePickerControllerDelegate>

@property (nonatomic,assign) id<WatermarkCameraViewControllerDelegate> delegate;
@property (nonatomic,assign) int type;
@property (nonatomic,assign) int currentImageCount;

@end
