//
//  commentView.h
//  ql
//
//  Created by yunlai on 14-4-18.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "faceView.h"
#import "HPGrowingTextView.h"
#import "emoji.h"
#import "LoadMoreTableFooterView.h"

#import "MBProgressHUD.h"

#import "TYDotIndicatorView.h"

@protocol commentDelegate <NSObject>

-(void) headViewTouch:(int) userId;

@end

typedef enum{
    CommentFromTypeCom = 0,
    CommentFromTypeMe
}CommentFromType;

typedef enum{
    CommentTypeNomal = 0,
    CommentTypeOOXX
}CommentType;

@interface commentView : UIView<UITableViewDataSource,UITableViewDelegate,faceViewDelegate,HPGrowingTextViewDelegate,UIActionSheetDelegate,LoadMoreTableFooterDelegate>{
    
    UITableView* _tableView;
//    评论输入框
    UIView *containerView;
    UIButton *faceButton;
    HPGrowingTextView *textView;
    faceView *faceKeyboardView;
    
    UIButton *backGrougBtn;
    UILabel *remainCountLabel;
    
    BOOL isChangKeyboard;
    BOOL isKeyboardDown;
    
    CGFloat scImgHeight;
    
//    评论、赞、oo、xx列表数据
    NSMutableArray* commentArr;
    NSMutableArray* careArr;
    
    NSMutableArray* ooArr;
    NSMutableArray* xxArr;
//    加载更多
    LoadMoreTableFooterView* footerView;
//    是否load
    BOOL commentCanLoad;
    BOOL supportCanLoad;
//    指示器
    MBProgressHUD* progress;
//    加载框
    TYDotIndicatorView *_darkCircleDot;
    
    CGFloat fromTypeMargin;
//    评论页数  用于加载更多
    int commentPage;
}

@property(nonatomic,assign) id<commentDelegate> delegate;
@property(nonatomic,retain) NSDictionary* dataDic;//动态数据
@property(nonatomic,assign) int publishId;//动态ID
@property(nonatomic,assign) CommentFromType fromType;//评论视图从哪里跳转来
@property(nonatomic,assign) CommentType comType;//评论视图类型normal和ooxx
//0表示来自点击评论，1表示回应
@property(nonatomic,assign) int comeBtnType;
//初始化动态ID和动态数据
-(id) initWithData:(NSDictionary*) dic publishId:(int) pId;
//展示评论视图
-(void) showCommentView;
//隐藏评论视图
-(void) hideCommentView;

@end
