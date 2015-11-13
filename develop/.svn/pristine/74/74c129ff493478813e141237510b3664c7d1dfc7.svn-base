//
//  SessionViewController.h
//  ql
//
//  Created by yunlai on 14-3-8.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "faceView.h"
#import "CircleDownBarView.h"
#import "QBImagePickerController.h"
#import "PictureMessageCell.h"
#import "DataChecker.h"
#import "TcpRequestHelper.h"
#import "SnailMessageViewController.h"
#import "EGORefreshTableHeaderView.h"

typedef enum {
    kSessionStylePerson,
    kSessionStyleCircle
}kSessionStyle;

@interface SessionViewController : SnailMessageViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,QBImagePickerControllerDelegate,PictureMessageCellDelegate,DataCheckerDelegate,EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView* headerView;
}

@property (nonatomic, assign) kSessionStyle style;
@property (nonatomic, retain) NSDictionary * selectedDic;
@property (nonatomic, retain) NSMutableArray * circleContactsList;
@property (nonatomic, assign) BOOL isCloudPagePresent;

@end
