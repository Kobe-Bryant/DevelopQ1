//
//  PreviewImageViewController.h
//  JWProject
//
//  Created by 云来ios－04 on 13-10-25.
//  Copyright (c) 2013年 云来ios－04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myImageView.h"

@protocol previewImageViewControllerDelegate <NSObject>

-(void)imagesDidRemain:(NSArray *)remainImages;

@end

@interface previewImageViewController : UIViewController<UIScrollViewDelegate,myImageViewDelegate>

@property (nonatomic,copy) NSArray *imagesArray; //用copy防止两边同一个引用
@property (nonatomic,assign) NSInteger chooseIndex;

@property (nonatomic,assign) id<previewImageViewControllerDelegate> delegate;

@end
