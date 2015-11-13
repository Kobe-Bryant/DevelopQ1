//
//  MeetingMainViewController.h
//  ql
//
//  Created by ChenFeng on 14-1-9.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImagePickerController.h"
#import "previewImageViewController.h"

#import "WatermarkCameraViewController.h"

@interface MeetingMainViewController : UIViewController<UITextViewDelegate,QBImagePickerControllerDelegate,UIActionSheetDelegate,previewImageViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WatermarkCameraViewControllerDelegate,UIAlertViewDelegate>

@end
