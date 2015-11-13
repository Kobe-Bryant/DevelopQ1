//
//  DynamicCardView.h
//  ql
//
//  Created by yunlai on 14-4-1.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    CardImage = 0,
    CardLabel,
    CardOOXX,
    CardWantOrHave,
    CardNews,
    CardOpenTime,
    CardTogether
}CardType;

typedef enum{
    CardShowTypeThum = 0,
    CardShowTypeAll
}CardShowType;

@protocol DynamicCardDelegate <NSObject>

@optional
-(void) responseLabTouch;
-(void) userImageTouch;
-(void) commentButtonClick;
-(void) middleImageTouch:(UIImageView*)imageView;
-(void) wantButtonClick;
-(void) haveButtonClick;
-(void) responseButtonClick;
-(void) fullTextToWeb:(NSString*) url;
-(void) joinButtonClick:(UIButton*) btn;

@end

@interface DynamicCardView : UIView<UIScrollViewDelegate>{
    id<DynamicCardDelegate> delegate;
    //卡片类型
    CardType _currentType;
    //卡片数据
    NSMutableDictionary* _dataDic;
    //点赞按钮
    UIButton* likeBtn;
    //展示类型
    CardShowType showType;
    //响应人数
    int responseNum;
}

@property(assign,nonatomic) id<DynamicCardDelegate> delegate;
//用于区别查看自己动态详情，可以删除，查看别人的，不能删除
@property(assign,nonatomic) AccessPageType accessType;
@property(nonatomic,retain) UIPageControl* pageCtl;

//初始化卡片数据
-(id) initWithCardType:(CardType) cardType data:(NSDictionary*) dic frame:(CGRect) frame showType:(CardShowType) showT;
//改变回应数字
-(void) changeResponseNum:(int) num;

@end
