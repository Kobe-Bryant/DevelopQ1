//
//  CustomEmoticonView.m
//  ql
//
//  Created by LazySnail on 14-9-14.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "CustomEmoticonView.h"
#import "EmoticonItemData.h"
#import "UIImageView+WebCache.h"

@interface CustomEmoticonView () <UIScrollViewDelegate>
{
    
}

@property (nonatomic, retain) UIScrollView * mainScrollView;

@property (nonatomic, retain) UIPageControl * pageControl;

@end

@implementation CustomEmoticonView

const int cloumnNumber = 2;
const int rowNumber = 4;
const float pageControlHeight = 20;

+ (UIView *)getFirstEmoticonViewWithEmoticonArray:(NSArray *)emoticonArr andFrame:(CGRect)frame
{
    UIView * resultView = [CustomEmoticonView emoticonViewWithFrame:frame fromNumber:0 toNumber:(cloumnNumber * rowNumber) andEmotionArr:emoticonArr];
    
    return resultView;
}

+ (UIView *)getLastEmoticonViewWithEmoticonArray:(NSArray *)emoticonArr andFrame:(CGRect)frame
{
    NSInteger complateIndicate = emoticonArr.count % (cloumnNumber * rowNumber);
    NSInteger complatePageNumber = emoticonArr.count/(cloumnNumber * rowNumber);
    NSInteger fromNumber = 0;
    NSInteger toNumber = emoticonArr.count;
    
    if (complateIndicate > 0) {
        fromNumber = complatePageNumber * (cloumnNumber * rowNumber) + 1;
    } else {
        fromNumber = emoticonArr.count - (cloumnNumber * rowNumber);
    }
    
    UIView * lastResultView = [CustomEmoticonView emoticonViewWithFrame:frame fromNumber:fromNumber toNumber:toNumber andEmotionArr:emoticonArr];
    return lastResultView;
}

+ (UIView *)emoticonViewWithFrame:(CGRect)frame fromNumber:(NSInteger)frontNumber toNumber:(NSInteger)lastNumber andEmotionArr:(NSArray *)emoticonArr
{
    UIView * emoticonView = [[UIView alloc]initWithFrame:frame];
    float emoticonViewWidth = emoticonView.frame.size.width;
    float emoticonViewHeight = emoticonView.frame.size.height - pageControlHeight;
    
    
    for (int i = 0; i < cloumnNumber * rowNumber; i ++) {
        EmoticonItemData * itemData = [emoticonArr objectAtIndex:i];
        
        NSInteger row = i % rowNumber;
        NSInteger rank = (i / rowNumber) % cloumnNumber;
        
        NSInteger xCoordinate = row * emoticonViewWidth/rowNumber;
        NSInteger yCoordinate = rank * emoticonViewHeight /2;
        float itemWidth = emoticonViewWidth / rowNumber;
        float itemheight = emoticonViewHeight / cloumnNumber;
        
        CGRect buttonRect = CGRectMake(xCoordinate, yCoordinate, itemWidth, itemheight);
        UIImageView * itemImg = [[UIImageView alloc]initWithFrame:buttonRect];
        itemImg.contentMode = UIViewContentModeScaleAspectFit;
        [itemImg setImageWithURL:[NSURL URLWithString:itemData.previewIcon] placeholderImage:nil];
        itemImg.tag = i;
        itemImg.backgroundColor = [UIColor clearColor];
        [emoticonView addSubview:itemImg];
    }
    return emoticonView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithFrontView:(UIView *)frontView lastView:(UIView *)lastView andFrame:(CGRect)frame
{
    self = [self initWithFrame:frame];
    self.userInteractionEnabled = YES;
    
    UIScrollView *mainScrollView = [[UIScrollView alloc]initWithFrame:frame];
    mainScrollView.pagingEnabled = YES;
    mainScrollView.delegate = self;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.userInteractionEnabled = YES;
    
    self.mainScrollView = mainScrollView;
    [self addSubview:mainScrollView];
    RELEASE_SAFE(mainScrollView);
    self.frontView = frontView;
    self.lastView = lastView;
    
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, frame.size.height - pageControlHeight, frame.size.width, pageControlHeight)];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.471 alpha:1.000];
    pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.678 alpha:1.000];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    RELEASE_SAFE(pageControl);
    
    return self;
}

- (void)reloadView
{
    for (UIView * subView in [self.mainScrollView subviews]) {
        [subView removeFromSuperview];
    }
    
    NSInteger frontOffSet = 0;
    NSInteger emoticonViewOffSet = 0;
    NSInteger lastViewOffSet = 0;
    float emoticonViewWidth = self.frame.size.width;
    float emoticonViewHeight = self.frame.size.height - pageControlHeight;
    
    if (self.frontView != nil) {
        frontOffSet = self.frame.size.width;
        [self.mainScrollView addSubview:self.frontView];
    }
    
    if (self.lastView != nil) {
        lastViewOffSet = self.frame.size.width;
        [self.mainScrollView addSubview:self.lastView];
    }
    
    NSInteger pageCount = ceil(self.emoticonDataArray.count / 8.0);
    emoticonViewOffSet = self.frame.size.width * pageCount;
    self.pageControl.numberOfPages = pageCount;
    self.pageControl.currentPage = 0;
    
    if (pageCount == 1) {
        self.pageControl.hidden = YES;
    } else {
        self.pageControl.hidden = NO;
    }
    
    self.mainScrollView.contentSize = CGSizeMake(frontOffSet + lastViewOffSet + emoticonViewOffSet, self.frame.size.height);
    if (self.lastView != nil) {
        self.lastView.frame = CGRectMake(frontOffSet + emoticonViewOffSet, 0, self.lastView.frame.size.width, self.lastView.frame.size.height);
    }
    
    self.mainScrollView.contentOffset = CGPointMake(frontOffSet, 0);
    
    for (int i = 0;i < self.emoticonDataArray.count;i++)
    {
        EmoticonItemData * itemData = [self.emoticonDataArray objectAtIndex:i];
        
        NSInteger pageNumber = i / (cloumnNumber * rowNumber) + frontOffSet/emoticonViewWidth;
        NSInteger row = i % rowNumber;
        NSInteger rank = (i / rowNumber) % cloumnNumber;
        
        NSInteger xCoordinate = pageNumber * emoticonViewWidth + row * emoticonViewWidth/rowNumber;
        NSInteger yCoordinate = rank * emoticonViewHeight /2;
        float itemWidth = emoticonViewWidth / rowNumber;
        float itemheight = emoticonViewHeight / cloumnNumber;
        
        CGRect buttonRect = CGRectMake(xCoordinate, yCoordinate, itemWidth, itemheight);
        UIImageView * itemImg = [[UIImageView alloc]initWithFrame:buttonRect];
        itemImg.userInteractionEnabled = YES;
        itemImg.contentMode = UIViewContentModeScaleAspectFit;
        [itemImg setImageWithURL:[NSURL URLWithString:itemData.previewIcon] placeholderImage:nil];
        itemImg.tag = i;
        itemImg.backgroundColor = [UIColor clearColor];
        [self.mainScrollView addSubview:itemImg];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(emoticonItemHaveSelectWithSender:)];
        tapGesture.numberOfTapsRequired = 1;
        [itemImg addGestureRecognizer:tapGesture];
        RELEASE_SAFE(tapGesture);
    }
}

- (void)emoticonItemHaveSelectWithSender:(UITapGestureRecognizer *)sender
{
    NSInteger index =  sender.view.tag;
    EmoticonItemData * selectData = [self.emoticonDataArray objectAtIndex:index];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(emoticonSelectEmotionWithData:)]) {
        [self.delegate emoticonSelectEmotionWithData:selectData];
    }
}

#pragma mark - ScrollViewDelegate 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    NSInteger pageNum = offset.x / self.frame.size.width;
    if (pageNum <= self.pageControl.numberOfPages) {
        self.pageControl.currentPage = pageNum;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    NSInteger pageNum = offset.x / self.frame.size.width;
    if (pageNum == self.pageControl.numberOfPages + 1) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(emoticonViewShouldTurnToNextEmoticon)]) {
            scrollView.contentOffset = CGPointMake(offset.x - self.frame.size.width, 0);
            [self.delegate emoticonViewShouldTurnToNextEmoticon];
        }
    }
    
    if (pageNum == 0) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(emoticonViewShouldTurnToLastEmoticon)]) {
            [self.delegate emoticonViewShouldTurnToLastEmoticon];
        }
    }
}

- (void)dealloc
{
    self.pageControl = nil;
    self.mainScrollView = nil;
    self.emoticonDataArray = nil;
    self.lastView = nil;
    self.frontView = nil;
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
