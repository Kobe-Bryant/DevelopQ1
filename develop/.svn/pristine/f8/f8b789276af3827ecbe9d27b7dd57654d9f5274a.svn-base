//
//  DynamicCardView.m
//  ql
//
//  Created by yunlai on 14-4-1.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "DynamicCardView.h"

#import "UIImageScale.h"
#import "UIImageView+WebCache.h"

//#import "Common.h"
#import "AMBlurView.h"

#import "RegexKitLite.h"

#import "dynamic_card_model.h"

#define CARDHEAD 40.0f
#define LABINIMAGE  40.0f

#define BTNCOLOR [UIColor colorWithRed:0.12 green:0.55 blue:0.89 alpha:1.0]

@interface DynamicCardView (){
    float labY;
    
    //滑动指示组件
    UIView* myPageV;
    UIView* currentPageV;
    
    //ooxx按钮和ooxx数目
    UIButton* ooBtn;
    UIButton* xxBtn;
    int ooSum;
    int xxSum;
    
    int choice_status;//0未投票，1投o，2投x
}

@property(nonatomic,retain) UILabel* responsLab;

@end

@implementation DynamicCardView
@synthesize accessType;
@synthesize delegate = _delegate;
@synthesize responsLab = _responsLab;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 创建试图
//头部
-(void) createHeadView{
    
    self.backgroundColor = [UIColor whiteColor];
    //headView
    UIView* headView = [[AMBlurView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 60)];
    headView.backgroundColor = [UIColor clearColor];
    [self addSubview:headView];
    
    UIImage* placeHolderImg = nil;
    if ([[_dataDic objectForKey:@"sex"] intValue] == 1) {
        placeHolderImg = IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME);
    }else{
        placeHolderImg = IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME);
    }
    
    //头像
    UIImageView* userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, CARDHEAD, CARDHEAD)];
    [userImageView setImageWithURL:[NSURL URLWithString:[_dataDic objectForKey:@"portrait"]] placeholderImage:placeHolderImg completed:^(UIImage* image,NSError* error,SDImageCacheType SDImageCacheTypeNone){
        if (image) {
            UIImage* newImage = [image imageByScalingAndCroppingForSize:CGSizeMake(CARDHEAD*2, CARDHEAD*2)];
            userImageView.image = newImage;
        }
    }];
//    userImageView.layer.cornerRadius = 5.0;
    userImageView.layer.cornerRadius = CARDHEAD/2;
    [userImageView.layer setMasksToBounds:YES];
    userImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageClick)];
    [userImageView addGestureRecognizer:tap];
    RELEASE_SAFE(tap);
    
    [headView addSubview:userImageView];
    
    //名字
    UILabel* nameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImageView.frame) + 10, CGRectGetMidY(userImageView.frame) - 7, 200, 15)];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.font = KQLSystemFont(14);
    nameLab.text = [_dataDic objectForKey:@"realname"];
    
    NSString* picstr = [_dataDic objectForKey:@"pics"];
    NSArray* pics = [[_dataDic objectForKey:@"pics"] componentsSeparatedByString:@","];
    nameLab.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
    
    [headView addSubview:nameLab];
    
    NSString* cityStr = [_dataDic objectForKey:@"city"];
    if (cityStr.length) {
        nameLab.frame = CGRectMake(CGRectGetMaxX(userImageView.frame) + 10, CGRectGetMinY(userImageView.frame) + 5, 200, 15);
        
        //地点
        UILabel* stateLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLab.frame), CGRectGetMaxY(userImageView.frame) - 15, 200, 10)];
        stateLab.backgroundColor = [UIColor clearColor];
        stateLab.font = KQLSystemFont(10);
        stateLab.text = cityStr;
        stateLab.textColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1.0];
        [headView addSubview:stateLab];
        [stateLab release];
    }
    
    //时间
    UILabel* timeLab = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 100, nameLab.frame.origin.y, 90, 15)];
    timeLab.backgroundColor = [UIColor clearColor];
    timeLab.font = KQLSystemFont(12);
    timeLab.textAlignment = NSTextAlignmentRight;
    timeLab.text = [Common makeFriendTime:[[_dataDic objectForKey:@"created"] intValue]];
    timeLab.textColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1.0];
    [headView addSubview:timeLab];
    
//    //位置
//    UILabel* stateLab = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 60, timeLab.frame.origin.y, 60, 15)];
//    stateLab.backgroundColor = [UIColor clearColor];
//    stateLab.font = KQLSystemFont(12);
//    stateLab.text = @"CH";
//    stateLab.textColor = [UIColor darkGrayColor];
//    stateLab.textAlignment = NSTextAlignmentCenter;
//    [headView addSubview:stateLab];
    
    UIImageView* lineImgV = [[UIImageView alloc] init];
    UIImage* image = nil;
    
    if (picstr.length > 0 && pics && pics.count != 0) {
        
    }else{
        image = IMG(@"img_feed_line_gray");
    }
    
    lineImgV.frame = CGRectMake(0, CGRectGetMaxY(headView.frame) - 0.5, 320, 0.5);
    lineImgV.image = image;
    [headView addSubview:lineImgV];
    RELEASE_SAFE(lineImgV);
    
    RELEASE_SAFE(headView);
    RELEASE_SAFE(userImageView);
    RELEASE_SAFE(nameLab);
    RELEASE_SAFE(timeLab);
//    RELEASE_SAFE(stateLab);
}

//添加图片  宽度或者高度缩放到固定尺寸
-(void) createImageViews{
    NSString* picstr = [_dataDic objectForKey:@"pics"];
    NSArray*pics = [[_dataDic objectForKey:@"pics"] componentsSeparatedByString:@","];
    
    if (showType == CardShowTypeThum) {
        UIImageView* imagev = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, self.bounds.size.width, self.bounds.size.height - 60 - 40)];
        //            imagev.contentMode = UIViewContentModeScaleAspectFit;
        imagev.contentMode = UIViewContentModeScaleAspectFill;
        imagev.clipsToBounds = YES;//不超过边界
        imagev.backgroundColor = [UIColor blackColor];
        [self addSubview:imagev];
        
        __block UIImageView* mImagev = imagev;
        
        [imagev setImageWithURL:[NSURL URLWithString:[pics firstObject]] placeholderImage:IMG(@"default_600") completed:^(UIImage* image,NSError* error,SDImageCacheType SDImageCacheTypeNone){
            if (image) {
                CGSize size;
                if (image.size.height > image.size.width) {
                    size = [UIImage fitsize:image.size height:mImagev.bounds.size.height*2];
                }else{
                    size = [UIImage fitsize:image.size width:mImagev.bounds.size.width*2];
                }
                UIImage* newImage = [image imageByScalingAndCroppingForSize:size];
                NSLog(@"newsize:%@",NSStringFromCGSize(newImage.size));
                mImagev.image = newImage;
            }else{
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage* downImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[pics firstObject]]]];
                    if (downImage) {
                        CGSize size;
                        if (downImage.size.height > downImage.size.width) {
                            size = [UIImage fitsize:downImage.size height:mImagev.bounds.size.height];
                        }else{
                            size = [UIImage fitsize:downImage.size width:mImagev.bounds.size.width];
                        }
                        UIImage* newImage = [downImage imageByScalingAndCroppingForSize:size];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            mImagev.image = newImage;
                        });
                    }else{
                        NSLog(@"--down nil--");
                    }
                    
                });
            }
        }];
        
        [imagev release];
        
    }else{
        UIScrollView* midScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 60)];
        if (_currentType == CardWantOrHave || _currentType == CardOOXX || _currentType == CardTogether) {
            midScroll.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 60 - 60);
        }
        midScroll.showsHorizontalScrollIndicator = NO;
        midScroll.showsVerticalScrollIndicator = NO;
        midScroll.pagingEnabled = YES;
        midScroll.delegate = self;
        midScroll.contentOffset = CGPointMake(0, 0);
        midScroll.bounces = NO;
        [self addSubview:midScroll];
        
        _pageCtl = [[UIPageControl alloc] initWithFrame:CGRectMake((midScroll.bounds.size.width - 120)/2, self.bounds.size.height - 60 - 40, 120, 20)];
        _pageCtl.currentPage = 0;
        if ([_pageCtl respondsToSelector:@selector(setPageIndicatorTintColor:)]) {
            _pageCtl.pageIndicatorTintColor = [UIColor whiteColor];
        }
        if ([_pageCtl respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)]) {
            _pageCtl.currentPageIndicatorTintColor = COLOR_CONTROL;
        }
        [self addSubview:_pageCtl];
        
        if (pics.count > 1) {
            [self createPageControl];
            //初始化pageControl的位置
            myPageV.frame = CGRectMake(0, self.bounds.size.height - 60 - 2, self.bounds.size.width, 2);
            if (_currentType == CardWantOrHave || _currentType == CardOOXX || _currentType == CardTogether) {
                myPageV.frame = CGRectMake(0, CGRectGetMaxY(midScroll.frame), self.bounds.size.width, 2);
            }
            
            //初始化currentPageV的位置
            currentPageV.frame = CGRectMake(0, 0, self.bounds.size.width/pics.count, 2);
        }
        
        if (picstr.length > 0) {
            for (int i = 0; i < pics.count; i++) {
                UIImageView* imagev = [[UIImageView alloc] initWithFrame:CGRectMake(i*320, 0, midScroll.bounds.size.width, midScroll.bounds.size.height)];
                //            imagev.contentMode = UIViewContentModeScaleAspectFit;
                imagev.contentMode = UIViewContentModeScaleAspectFill;
                imagev.clipsToBounds = YES;//不超过边界
                imagev.userInteractionEnabled = YES;
                imagev.tag = i + 1000;
                imagev.backgroundColor = [UIColor clearColor];
                
                __block UIImageView* mImagev = imagev;
                
                [imagev setImageWithURL:[NSURL URLWithString:[pics objectAtIndex:i]] placeholderImage:IMG(@"default_600") completed:^(UIImage* image,NSError* error,SDImageCacheType SDImageCacheTypeNone){
                    if (image) {
                        CGSize size;
                        if (image.size.height > image.size.width) {
                            size = [UIImage fitsize:image.size height:mImagev.bounds.size.height*2];
                        }else{
                            size = [UIImage fitsize:image.size width:mImagev.bounds.size.width*2];
                        }
                        UIImage* newImage = [image imageByScalingAndCroppingForSize:size];
                        NSLog(@"newsize:%@",NSStringFromCGSize(newImage.size));
                        mImagev.image = newImage;
                        
                    }else{
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            UIImage* downImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[pics objectAtIndex:i]]]];
                            if (downImage) {
                                CGSize size;
                                if (downImage.size.height > downImage.size.width) {
                                    size = [UIImage fitsize:downImage.size height:mImagev.bounds.size.height*2];
                                }else{
                                    size = [UIImage fitsize:downImage.size width:mImagev.bounds.size.width*2];
                                }
                                UIImage* newImage = [downImage imageByScalingAndCroppingForSize:size];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    mImagev.image = newImage;
                                
                                });
                            }else{
                                NSLog(@"--down nil--");
                            }
                            
                        });
                    }
                    
                }];
                
                [midScroll addSubview:imagev];
                
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(midImageClick:)];
                [imagev addGestureRecognizer:tap];
                RELEASE_SAFE(tap);
                
                RELEASE_SAFE(imagev);
            }
            
            [_pageCtl setNumberOfPages:pics.count];
            _pageCtl.hidesForSinglePage = YES;
            _pageCtl.currentPageIndicatorTintColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
            if ([[_dataDic objectForKey:@"type"] intValue] != 0 && [[_dataDic objectForKey:@"type"] intValue] != 7) {
                _pageCtl.hidden = YES;
            }
            
            _pageCtl.hidden = YES;
        }
        
        [midScroll setContentSize:CGSizeMake(320*pics.count, midScroll.bounds.size.height)];
        RELEASE_SAFE(midScroll);
    }
    
    if (_currentType != CardImage) {
        NSString* titleStr = [_dataDic objectForKey:@"title"];
        if (titleStr && titleStr.length > 0) {
            CGSize size = [titleStr sizeWithFont:KQLboldSystemFont(15) constrainedToSize:CGSizeMake(self.bounds.size.width, (self.bounds.size.height - 60 - 60)/3) lineBreakMode:NSLineBreakByWordWrapping];
            
            UIImageView* textBg = [[UIImageView alloc] init];
            textBg.image = IMG(@"img_feed_shadow");
            textBg.alpha = 0.5;
            textBg.frame = CGRectMake(0, 60, self.bounds.size.width, size.height + 10);
            [self addSubview:textBg];
            [textBg release];
        }
    }
    
}

//创建滑页组件
-(void) createPageControl{
    myPageV = [[UIView alloc] init];
    myPageV.backgroundColor = [UIColor whiteColor];
    [self addSubview:myPageV];
    
    currentPageV = [[UIView alloc] init];
    currentPageV.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
    [myPageV addSubview:currentPageV];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x/320;
    _pageCtl.currentPage = page;
    
    //移动currentPageV的位置
    currentPageV.frame = CGRectMake(page*currentPageV.bounds.size.width, 0, currentPageV.bounds.size.width, 2);
}

//初始化图片类卡片
-(void) addImageViews{
    NSString* picstr = [_dataDic objectForKey:@"pics"];
    NSArray* pics = [[_dataDic objectForKey:@"pics"] componentsSeparatedByString:@","];
   
    
    if (picstr.length > 0 && pics && pics.count > 0) {
        if (showType != CardShowTypeThum) {
            self.backgroundColor = [UIColor colorWithRed:0.09 green:0.10 blue:0.12 alpha:1.0];
        }
        
        [self createImageViews];
    }
    
    UITextView* textlab = [[UITextView alloc] initWithFrame:CGRectMake(5, 60 + 10, self.bounds.size.width - 5*2, self.bounds.size.height - 60 - 60 - 20)];
    textlab.text = [[_dataDic objectForKey:@"title"] stringByReplacingOccurrencesOfRegex:@"[\n,\r]{2,}" withString:@"\n"];
    textlab.backgroundColor = [UIColor clearColor];
    textlab.editable = NO;
    textlab.showsVerticalScrollIndicator = NO;
    textlab.showsHorizontalScrollIndicator = NO;
    textlab.scrollEnabled = YES;
    textlab.font = KQLboldSystemFont(15);
    textlab.layer.shadowOffset = CGSizeMake(2, 2);
    if (picstr.length > 0 && pics && pics.count > 0) {
        textlab.textColor = [UIColor whiteColor];
        
        textlab.frame = CGRectMake(5, self.bounds.size.height - 60 - 10 - [self getSizeFromText:textlab.text], self.bounds.size.width - 5*2, [self getSizeFromText:textlab.text]);
    }else{
        textlab.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_IMPORTANT"];
        textlab.frame = CGRectMake(5, 60 + 10, self.bounds.size.width - 5*2, [self getSizeFromText:textlab.text]);
    }
    
    textlab.contentSize = CGSizeMake(640, textlab.frame.size.height);
    [self addSubview:textlab];
    
    //加文字阴影
    if (picstr.length > 0 && pics && pics.count > 0) {
        NSString* titleStr = [_dataDic objectForKey:@"title"];
        if (titleStr && titleStr.length > 0) {
            
            UIImageView* textBg = [[UIImageView alloc] init];
            textBg.image = IMG(@"img_feed_shadow");
            textBg.alpha = 0.5;
            textBg.frame = CGRectMake(0, textlab.frame.origin.y, self.bounds.size.width, textlab.bounds.size.height);
            [self addSubview:textBg];
            [textBg release];
        }
    }
    RELEASE_SAFE(textlab);
}

//获取文本size
-(CGFloat) getSizeFromText:(NSString*) text{
    CGSize size = [text sizeWithFont:KQLboldSystemFont(15) constrainedToSize:CGSizeMake(self.bounds.size.width - 5*2, self.bounds.size.height - 60 - 60 - 20) lineBreakMode:NSLineBreakByWordWrapping];
    return (size.height + 20);
}

-(void) labTap:(UITapGestureRecognizer*) tap{
    UILabel* lab = ((UILabel*)tap.view);
    lab.frame = CGRectMake(lab.frame.origin.x, labY - (100 - LABINIMAGE), lab.bounds.size.width, 100);
}

//初始化纯文本类卡片
-(void) addLabels{
    
    UITextView* textLab = [[UITextView alloc] initWithFrame:CGRectMake(5, 60 + 10, self.bounds.size.width - 5*2, self.bounds.size.height - 60 - 60 - 2*10)];
    textLab.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_IMPORTANT"];
    textLab.font = KQLboldSystemFont(15);
    textLab.text = [[_dataDic objectForKey:@"title"] stringByReplacingOccurrencesOfRegex:@"[\n,\r]{2,}" withString:@"\n"];
    textLab.editable = NO;
    textLab.showsHorizontalScrollIndicator = NO;
    textLab.showsVerticalScrollIndicator = NO;
    textLab.scrollEnabled = YES;
    textLab.backgroundColor = [UIColor clearColor];
    
    textLab.frame = CGRectMake(5, 60 + 10, self.bounds.size.width - 5*2, [self getSizeFromText:textLab.text]);
    [self addSubview:textLab];
    
    RELEASE_SAFE(textLab);
}

//初始化ooxx类卡片
-(void) addOOXXs{
    NSString* picstr = [_dataDic objectForKey:@"pics"];
    NSArray* pics = [[_dataDic objectForKey:@"pics"] componentsSeparatedByString:@","];
    
    BOOL blackFont = YES;
    
    if (picstr.length > 0 && pics && pics.count > 0) {
        blackFont = NO;
        if (showType != CardShowTypeThum) {
            self.backgroundColor = [UIColor colorWithRed:0.09 green:0.10 blue:0.12 alpha:1.0];
        }
        [self createImageViews];
    }
    
    UITextView* textLab = [[UITextView alloc] initWithFrame:CGRectMake(5, 60 + 10, self.bounds.size.width - 5*2, self.bounds.size.height - 60 - 60 - 10*2)];
    textLab.font = KQLboldSystemFont(15);
    textLab.text = [[_dataDic objectForKey:@"title"] stringByReplacingOccurrencesOfRegex:@"[\n,\r]{2,}" withString:@"\n"];
    if (picstr.length > 0 && pics && pics.count > 0) {
        textLab.textColor = [UIColor whiteColor];
    }else{
        textLab.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_IMPORTANT"];
    }
    textLab.editable = NO;
    textLab.showsVerticalScrollIndicator = NO;
    textLab.showsHorizontalScrollIndicator = NO;
    textLab.scrollEnabled = YES;
    textLab.backgroundColor = [UIColor clearColor];
    
    textLab.frame = CGRectMake(5, 60 + 10, self.bounds.size.width - 5*2, [self getSizeFromText:textLab.text]);
    [self addSubview:textLab];
    
    ooBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ooBtn setTitle:[NSString stringWithFormat:@"%d",[[_dataDic objectForKey:@"choice1_sum"] intValue]] forState:UIControlStateNormal];
    
    UIImage *ooimage = IMG(@"ico_feed_o.png");
    UIImage* ooselImage = IMG(@"ico_feed_o_select");
    [ooBtn setImage:ooimage forState:UIControlStateNormal];
    [ooBtn setImage:ooselImage forState:UIControlStateSelected];
    
    [ooBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    ooBtn.frame = CGRectMake(80, (self.bounds.size.height - 60 - 60 - 40), 60, 80);
    [ooBtn.layer setMasksToBounds:YES];
    ooBtn.tag = 101;
    [ooBtn addTarget:self action:@selector(ooBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [ooBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
    [ooBtn setTitleEdgeInsets:UIEdgeInsetsMake(60, -70, 0, 0)];
    
    [self addSubview:ooBtn];
    
    xxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [xxBtn setTitle:[NSString stringWithFormat:@"%d",[[_dataDic objectForKey:@"choice2_sum"] intValue]] forState:UIControlStateNormal];
    UIImage *xximage = IMG(@"ico_feed_x");
    UIImage* xxselImage = IMG(@"ico_feed_x_select");
    
    [xxBtn setImage:xximage forState:UIControlStateNormal];
    [xxBtn setImage:xxselImage forState:UIControlStateSelected];
    [xxBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    xxBtn.frame = CGRectMake(CGRectGetMaxX(ooBtn.frame) + 40, CGRectGetMinY(ooBtn.frame), 60, 80);
    [xxBtn.layer setMasksToBounds:YES];
    xxBtn.tag = 100;
    [xxBtn addTarget:self action:@selector(xxBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [xxBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
    [xxBtn setTitleEdgeInsets:UIEdgeInsetsMake(60, -70, 0, 0)];
    
    [self addSubview:xxBtn];
    
    if ([[_dataDic objectForKey:@"user_choice"] intValue] == 1) {
        ooBtn.selected = YES;
    }else if ([[_dataDic objectForKey:@"user_choice"] intValue] == 2) {
        xxBtn.selected = YES;
    }
    
    ooSum = [[_dataDic objectForKey:@"choice1_sum"] intValue];
    xxSum = [[_dataDic objectForKey:@"choice2_sum"] intValue];
    
    choice_status = [[_dataDic objectForKey:@"user_choice"] intValue];
    
    RELEASE_SAFE(textLab);
}

#pragma mark - ooClick
//oo数字+1，选择状态改为1，按钮选中状态，回应数+1，发送请求。反之
-(void) ooBtnClick:(UIButton*) btn{
    if (choice_status == 0) {
        ooSum += 1;
        choice_status = 1;
        ooBtn.selected = YES;
        responseNum += 1;
        [ooBtn setTitle:[NSString stringWithFormat:@"%d",ooSum] forState:UIControlStateNormal];
        [self accessOOXXcommand:0];
        
    }else if (choice_status == 1) {
        ooSum += -1;
        choice_status = 0;
        ooBtn.selected = NO;
        xxBtn.selected = NO;
        responseNum -= 1;
        [ooBtn setTitle:[NSString stringWithFormat:@"%d",ooSum] forState:UIControlStateNormal];
        [self accessCancelOOXXcommand];
    }else{
        xxSum += -1;
        choice_status = 0;
        ooBtn.selected = NO;
        xxBtn.selected = NO;
        responseNum -= 1;
        [xxBtn setTitle:[NSString stringWithFormat:@"%d",xxSum] forState:UIControlStateNormal];
        [self accessCancelOOXXcommand];
    }
    
}

#pragma mark - xxClick
-(void) xxBtnClick:(UIButton*) btn{
    if (choice_status == 0) {
        xxSum += 1;
        choice_status = 2;
        xxBtn.selected = YES;
        responseNum += 1;
        [xxBtn setTitle:[NSString stringWithFormat:@"%d",xxSum] forState:UIControlStateNormal];
        [self accessOOXXcommand:1];
    }else if (choice_status == 1) {
        ooSum += -1;
        xxBtn.selected = NO;
        ooBtn.selected = NO;
        choice_status = 0;
        responseNum -= 1;
        [ooBtn setTitle:[NSString stringWithFormat:@"%d",ooSum] forState:UIControlStateNormal];
        [self accessCancelOOXXcommand];
    }else{
        xxSum += -1;
        xxBtn.selected = NO;
        ooBtn.selected = NO;
        choice_status = 0;
        responseNum -= 1;
        [xxBtn setTitle:[NSString stringWithFormat:@"%d",xxSum] forState:UIControlStateNormal];
        [self accessCancelOOXXcommand];
    }
}

//初始化我有我要类卡片
-(void) addWantOrHave{
    NSString* picstr = [_dataDic objectForKey:@"pics"];
    NSArray*pics = [[_dataDic objectForKey:@"pics"] componentsSeparatedByString:@","];
  
    
    if (picstr.length > 0 && pics && pics.count > 0) {
        [self createImageViews];
    }
    
    UITextView* textLab = [[UITextView alloc] initWithFrame:CGRectMake(5, 70, self.bounds.size.width - 5*2, 200)];
    textLab.backgroundColor = [UIColor clearColor];
    if (picstr.length > 0 && pics && pics.count > 0) {
        textLab.textColor = [UIColor whiteColor];
    }else{
        textLab.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_IMPORTANT"];
    }
    textLab.font = KQLboldSystemFont(15);
    textLab.text = [[_dataDic objectForKey:@"title"] stringByReplacingOccurrencesOfRegex:@"[\n,\r]{2,}" withString:@"\n"];
    textLab.editable = NO;
    textLab.showsHorizontalScrollIndicator = NO;
    textLab.showsVerticalScrollIndicator = NO;
    textLab.scrollEnabled = YES;
    
    textLab.frame = CGRectMake(5, 60 + 10, self.bounds.size.width - 5*2, [self getSizeFromText:textLab.text]);
    [self addSubview:textLab];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((self.bounds.size.width - 60)/2, self.bounds.size.height - 60 - 60 - 30, 60, 60);
    btn.backgroundColor = BTNCOLOR;
    //发布的我有，展示为我要
    if ([[_dataDic objectForKey:@"type"] intValue] == 3) {
        [btn setTitle:@"我要" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(wantBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [btn setTitle:@"我有" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(haveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([[_dataDic objectForKey:@"user_id"] intValue] == [[Global sharedGlobal].user_id intValue]) {
        btn.backgroundColor = COLOR_GRAY2;
        btn.enabled = NO;
    }
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = btn.bounds.size.width/2;
    [btn.layer setMasksToBounds:YES];
    [self addSubview:btn];
    
    RELEASE_SAFE(textLab);
}

//聚聚类卡片
-(void) addTogether{
    NSString* picstr = [_dataDic objectForKey:@"pics"];
    NSArray*pics = [[_dataDic objectForKey:@"pics"] componentsSeparatedByString:@","];
    
    
    if (picstr.length > 0 && pics && pics.count > 0) {
        [self createImageViews];
    }
    
    //时间
    NSString* timeStr = [NSString stringWithFormat:@"%@ -- %@\n",[Common makeTime:[[_dataDic objectForKey:@"start_time"] intValue] withFormat:@"MM月dd日 HH:mm"],[Common makeTime:[[_dataDic objectForKey:@"end_time"] intValue] withFormat:@"MM月dd日 HH:mm"]];
    //城市
    NSString* city = [_dataDic objectForKey:@"city"];
    //地址
    NSString* addressStr = [_dataDic objectForKey:@"address"];
    if (addressStr == nil) {
        addressStr = @"";
    }
    if (city == nil) {
        city = @"";
    }
    //文本
    NSString* titleStr = [_dataDic objectForKey:@"title"];
    
    NSString* textStr = [NSString stringWithFormat:@"%@ %@%@ %@",timeStr,city,addressStr,titleStr];
    
    UITextView* textLab = [[UITextView alloc] initWithFrame:CGRectMake(5, 70, self.bounds.size.width - 5*2, 200)];
    textLab.backgroundColor = [UIColor clearColor];
    if (picstr.length > 0 && pics && pics.count > 0) {
        textLab.textColor = [UIColor whiteColor];
    }else{
        textLab.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_IMPORTANT"];
    }
    textLab.font = KQLboldSystemFont(15);
    textLab.text = [textStr stringByReplacingOccurrencesOfRegex:@"[\n,\r]{2,}" withString:@"\n"];
    textLab.editable = NO;
    textLab.showsHorizontalScrollIndicator = NO;
    textLab.showsVerticalScrollIndicator = NO;
    textLab.scrollEnabled = YES;
    
    textLab.frame = CGRectMake(5, 60 + 10, self.bounds.size.width - 5*2, [self getSizeFromText:textLab.text]);
    [self addSubview:textLab];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((self.bounds.size.width - 60)/2, self.bounds.size.height - 60 - 60 - 30, 60, 60);
    btn.backgroundColor = BTNCOLOR;
    [btn setTitle:@"参加" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(joinClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //自己发布的聚聚不能点
    if ([[_dataDic objectForKey:@"user_id"] intValue] == [[Global sharedGlobal].user_id intValue]) {
        btn.backgroundColor = COLOR_GRAY2;
        btn.enabled = NO;
    }
    
    //已经参加的聚聚不能点,1参加，0未参加
    int is_joined_gather = [[_dataDic objectForKey:@"is_joined_gather"] intValue];
    
    //已经过时的聚聚不能再参加
    BOOL is_outTime = NO;
    long long endTime = [[_dataDic objectForKey:@"end_time"] longLongValue];
    long long nowTime = [[NSDate date] timeIntervalSince1970];
    if (endTime <= nowTime) {
        is_outTime = YES;
    }
    
    if (is_joined_gather || is_outTime) {
        btn.backgroundColor = COLOR_GRAY2;
        btn.enabled = NO;
    }
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = btn.bounds.size.width/2;
    [btn.layer setMasksToBounds:YES];
    [self addSubview:btn];
    
    RELEASE_SAFE(textLab);
}

//新闻类卡片
-(void) addNews{
    NSLog(@"news");
    
    UIImageView* imageV = [[UIImageView alloc] init];
    imageV.frame = CGRectMake(5, 60 + 5, self.bounds.size.width - 5*2, (self.bounds.size.height - 60 - 60 - 200));
    [imageV setImageWithURL:[NSURL URLWithString:[_dataDic objectForKey:@"image_path"]] placeholderImage:IMG(@"show")];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageV];
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(imageV.frame) + 15 , self.bounds.size.width - 10*2, 40)];
    lab.text = [NSString stringWithFormat:@"%@ | %@",[_dataDic objectForKey:@"title"],[_dataDic objectForKey:@"content"]];
    lab.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_IMPORTANT"];
    lab.font = [UIFont systemFontOfSize:12];
    lab.numberOfLines = 0;
    lab.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:lab];
    
    CGSize size = [lab.text sizeWithFont:lab.font constrainedToSize:CGSizeMake(lab.bounds.size.width, 120) lineBreakMode:NSLineBreakByWordWrapping];
    lab.frame = CGRectMake(lab.frame.origin.x, lab.frame.origin.y, lab.bounds.size.width, size.height + 30);
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(CGRectGetMinX(lab.frame), CGRectGetMaxY(lab.frame) + 5, 60, 30);
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitle:@"查看全文" forState:UIControlStateNormal];
    btn.titleLabel.font = KQLboldSystemFont(13);
    [btn addTarget:self action:@selector(checkFullText) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    RELEASE_SAFE(imageV);
    RELEASE_SAFE(lab);
}

//组织新闻类点击链接
-(void) checkFullText{
    NSLog(@"--to full text--");
    if (_delegate && [_delegate respondsToSelector:@selector(fullTextToWeb:)]) {
        NSString* url_path = [[NSString alloc] initWithFormat:@"%@",[_dataDic objectForKey:@"url_content"]];
        [_delegate fullTextToWeb:url_path];
    }
}

//开放时间类卡片
-(void) addOpenTime{
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 320, self.bounds.size.height - 60 - 60 - 60)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 0;
    lab.lineBreakMode = NSLineBreakByWordWrapping;
    lab.font = KQLSystemFont(20);
    lab.textColor = [UIColor darkGrayColor];
    lab.text = [NSString stringWithFormat:@"%@ -- %@\n%@",[Common makeTime:[[_dataDic objectForKey:@"start_time"] intValue] withFormat:@"MM月dd日 HH:mm"],[Common makeTime:[[_dataDic objectForKey:@"end_time"] intValue] withFormat:@"MM月dd日 HH:mm"],[_dataDic objectForKey:@"title"]];
    [self addSubview:lab];
    RELEASE_SAFE(lab);//add vincent
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((self.bounds.size.width - 120)/2, self.bounds.size.height - 60 - 60 - 30, 120, 60);
    btn.backgroundColor = BTNCOLOR;
    [btn setTitle:@"我也有空" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(responseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = btn.bounds.size.height/2;
    [btn.layer setMasksToBounds:YES];
    [self addSubview:btn];
}

//相应
-(void) responseBtnClick{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(responseButtonClick)]) {
        [_delegate responseButtonClick];
    }
}

//我要
-(void) wantBtnClick:(UIButton*) btn{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(wantButtonClick)]) {
        [_delegate wantButtonClick];
    }
}

//我有
-(void) haveBtnClick:(UIButton*) btn{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(haveButtonClick)]) {
        [_delegate haveButtonClick];
    }
}

//参加聚聚
-(void) joinClick:(UIButton*) btn{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(joinButtonClick:)]) {
        [_delegate joinButtonClick:btn];
    }
}

//根据卡片类型 创建对应的视图
-(void) createMiddleViewWithCardType:(CardType) type{
    switch (type) {
        case CardImage:
            [self addImageViews];
            break;
        case CardLabel:
            [self addLabels];
            break;
        case CardOOXX:
            [self addOOXXs];
            break;
        case CardWantOrHave:
            [self addWantOrHave];
            break;
        case CardNews:
            [self addNews];
            break;
        case CardOpenTime:
            [self addOpenTime];
            break;
        case CardTogether:
            [self addTogether];
            break;
        default:
            break;
    }
}

//创建下部
-(void) createButtomView{
    //底部view
    UIView* buttomView = [[AMBlurView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 60, self.bounds.size.width, 60)];
    buttomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:buttomView];
    
    //点赞
    likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    likeBtn.frame = CGRectMake(15, 10, 60, 40);
    likeBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 30);
    likeBtn.titleEdgeInsets = UIEdgeInsetsMake(8, -10, 0, 0);
    [likeBtn setImage:[[ThemeManager shareInstance] getThemeImage:@"ico_feed_like.png"] forState:UIControlStateNormal];
    
    UIImage *likeImg = [[ThemeManager shareInstance] getThemeImage:@"ico_feed_like_sel.png"];
    
    [likeBtn setImage:likeImg forState:UIControlStateSelected];
    
    [likeBtn setTitle:@"赞" forState:UIControlStateNormal];
    [likeBtn setTitle:@"已赞" forState:UIControlStateSelected];
    likeBtn.titleLabel.font = KQLboldSystemFont(14);
    [likeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [likeBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"] forState:UIControlStateSelected];
    [likeBtn addTarget:self action:@selector(likeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:likeBtn];
    
    if ([[_dataDic objectForKey:@"is_care"] intValue] == 1) {
        likeBtn.selected = YES;
    }
    
    //评论
    UIButton* commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame = CGRectMake(120, 10, 60, 40);
    commentBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 0, 3, 30);
    commentBtn.titleEdgeInsets = UIEdgeInsetsMake(8, -10, 0, 0);
    [commentBtn setImage:[[ThemeManager shareInstance] getThemeImage:@"ico_feed_comment.png"] forState:UIControlStateNormal];
    commentBtn.titleLabel.font = KQLboldSystemFont(14);
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentBtn) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:commentBtn];
    
    //回应数
    _responsLab = [[UILabel alloc] initWithFrame:CGRectMake(buttomView.bounds.size.width - 100, CGRectGetMinY(likeBtn.frame), 100, 40)];
    _responsLab.font = KQLSystemFont(14);
    _responsLab.textAlignment = NSTextAlignmentCenter;
    _responsLab.text = [NSString stringWithFormat:@"%d人回应",[[_dataDic objectForKey:@"response_sum"] intValue]];
    _responsLab.textColor = [UIColor darkGrayColor];
    _responsLab.backgroundColor = [UIColor clearColor];
    _responsLab.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resLabTouch)];
    [_responsLab addGestureRecognizer:tap];
    [tap release];
    
    [buttomView addSubview:_responsLab];
    
    RELEASE_SAFE(buttomView);
    
}

//回应lab相应
-(void) resLabTouch{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(responseLabTouch)]) {
        [_delegate responseLabTouch];
    }
}

#pragma mark - 头像响应

-(void) userImageClick{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(userImageTouch)]) {
        [_delegate userImageTouch];
    }
}

#pragma mark - 图片响应

-(void) midImageClick:(UIGestureRecognizer*) ges{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(middleImageTouch:)]) {
        UIImageView* imageV = (UIImageView*)ges.view;
        [_delegate middleImageTouch:imageV];
    }
}

#pragma mark - 按键响应

-(void) likeBtn:(UIButton*) btn{
    int operation = btn.selected?1:0;
    btn.selected = !btn.selected;
    
    [self accessSupportCommand:operation];
    
}

//评论 add vincent 2014-07-03
-(void) commentBtn{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(commentButtonClick)]) {
        [_delegate commentButtonClick];
    }
}

//初始化卡片
-(id) initWithCardType:(CardType)cardType data:(NSDictionary *)dic frame:(CGRect) frame showType:(CardShowType)showT{
    self = [super initWithFrame:frame];
    if (self) {
        showType = showT;
        _currentType = cardType;
        _dataDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        responseNum = [[_dataDic objectForKey:@"response_sum"] intValue];
        
        [self createMiddleViewWithCardType:cardType];
        [self createHeadView];
        [self createButtomView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - 网络请求

-(void) accessOOXXcommand:(int) choice{
    NSString *reqUrl = @"publish/vote.do?param=";
	
    //type=0投票，type＝1取消投票.  choice:0\1选项1\2
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                  [NSNumber numberWithInt:[[_dataDic objectForKey:@"id"] intValue]],@"publish_id",
                  [NSNumber numberWithInt:0],@"type",
                  [NSNumber numberWithInt:choice],@"choice",
                  [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                  nil];
    
    [[NetManager sharedManager] accessService:requestDic data:nil command:DYNAMIC_OOXX_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
}

-(void) accessCancelOOXXcommand{
    NSString* reqUrl = @"publish/vote.do?param=";
    NSMutableDictionary* requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                                       [NSNumber numberWithInt:[[_dataDic objectForKey:@"id"] intValue]],@"publish_id",
                                       [NSNumber numberWithInt:1],@"type",
//                                       [NSNumber numberWithInt:choice_status - 1],@"choice",
                                       [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                       nil];
    [[NetManager sharedManager] accessService:requestDic data:nil command:DYNAMIC_OOXX_CANCEL_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
}

-(void) accessSupportCommand:(int) operatorType{
    NSString* reqUrl = @"publish/care.do?param=";
    //operator_type,0是赞，1是取消赞
    NSMutableDictionary* requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"from_id",
                                       [NSNumber numberWithInt:[[_dataDic objectForKey:@"type"] intValue]],@"type",
                                       [NSNumber numberWithInt:[[_dataDic objectForKey:@"user_id"] intValue]],@"to_id",
                                       [NSNumber numberWithInt:[[_dataDic objectForKey:@"id"] intValue]],@"publish_id",
                                       [NSNumber numberWithInt:operatorType],@"operator_type",
                                       [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                       nil];
    [[NetManager sharedManager] accessService:requestDic data:nil command:DYNAMIC_SUPPORT_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
}

//请求回调
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
    NSLog(@"did finish");
    
    switch (commandid) {
        case DYNAMIC_SUPPORT_COMMAND_ID:
        {
            //赞
            NSDictionary* dic = [resultArray objectAtIndex:0];
            int ret = [[dic objectForKey:@"ret"] intValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (ret == 1) {
                    //success
                    responseNum += (likeBtn.selected?1:-1);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDyDBData" object:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:likeBtn.selected?1:0],@"is_care",[NSNumber numberWithInt:responseNum],@"id",[NSNumber numberWithInt:responseNum],@"response_sum", nil]];
                    
                    _responsLab.text = [NSString stringWithFormat:@"%d人回应",responseNum];
                    
                }else if (ret == 2) {
                    //already
                    [Common checkProgressHUD:@"赞过了" andImage:nil showInView:self];
                }else{
                    //failure
                    likeBtn.selected = !likeBtn.selected;
                }
            });
        }
            break;
        case DYNAMIC_OOXX_COMMAND_ID:
        {
            //ooxx
            if (resultArray && ![[resultArray objectAtIndex:0] isKindOfClass:[NSString class]]) {
                NSDictionary* dic = [resultArray objectAtIndex:0];
                int ret = [[dic objectForKey:@"ret"] intValue];//0失败，1成功，2已投票
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (ret == 1) {
//                        [Common checkProgressHUD:@"投票成功" andImage:nil showInView:self];
                        [Common checkProgressHUDShowInAppKeyWindow:@"投票成功" andImage:KAccessSuccessIMG];

                        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDyDBData" object:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:choice_status],@"user_choice",[NSNumber numberWithInt:[[_dataDic objectForKey:@"id"] intValue]],@"id",[NSNumber numberWithInt:responseNum + 1],@"response_sum", nil]];
                        _responsLab.text = [NSString stringWithFormat:@"%d人回应",responseNum];
                        
                    }else if (ret == 2) {
//                        [Common checkProgressHUD:@"投过票了" andImage:nil showInView:self];
                        [Common checkProgressHUDShowInAppKeyWindow:@"投过票了" andImage:KAccessFailedIMG];
                    }else{
//                        [Common checkProgressHUD:@"投票失败" andImage:nil showInView:self];
                        [Common checkProgressHUDShowInAppKeyWindow:@"投票失败" andImage:KAccessFailedIMG];
                    }
                });
            }
        }
            break;
        case DYNAMIC_OOXX_CANCEL_COMMAND_ID:
        {
            //ooxx cancel
            if (resultArray && ![[resultArray objectAtIndex:0] isKindOfClass:[NSString class]]) {
                NSDictionary* dic = [resultArray objectAtIndex:0];
                int ret = [[dic objectForKey:@"ret"] intValue];
                if (ret == 1) {
//                    [Common checkProgressHUD:@"投票已取消" andImage:nil showInView:self];
                    [Common checkProgressHUDShowInAppKeyWindow:@"投票已取消" andImage:KAccessSuccessIMG];
                    
                    [_dataDic setObject:[NSNumber numberWithInt:0] forKey:@"is_choice"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDyDBData" object:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"user_choice",[NSNumber numberWithInt:[[_dataDic objectForKey:@"id"] intValue]],@"id",[NSNumber numberWithInt:responseNum - 1],@"response_sum", nil]];
                    
                    _responsLab.text = [NSString stringWithFormat:@"%d人回应",responseNum];
                }else{
                    
                }
            }
        }
            break;
        default:
            break;
    }
    
}

//外部接口，改变回应人数
-(void) changeResponseNum:(int)num{
    responseNum += num;
    _responsLab.text = [NSString stringWithFormat:@"%d人回应",responseNum];
}

-(void) dealloc{
    [_dataDic release];
    [_pageCtl release];
    [_responsLab release];
    [super dealloc];
}

@end
