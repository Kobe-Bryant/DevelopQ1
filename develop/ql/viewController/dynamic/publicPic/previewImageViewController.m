//
//  PreviewImageViewController.m
//  JWProject
//
//  Created by 云来ios－04 on 13-10-25.
//  Copyright (c) 2013年 云来ios－04. All rights reserved.
//

#import "previewImageViewController.h"
#import "myImageView.h"
#import "UIImageScale.h"
#import "CRNavigationController.h"

#define kToolbarSize CGSizeMake(self.view.bounds.size.width,60.0f)
#define kWinSize [UIScreen mainScreen].bounds.size

@interface previewImageViewController ()

@property (nonatomic,retain) UIScrollView *showPicScrollView;
@property (nonatomic,retain) UIPageControl *pageControl;

@property (nonatomic,retain) NSMutableArray *showImagesArray;
@property (nonatomic,retain) UILabel *titleLabel;

@end

@implementation previewImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    if (IOS_VERSION_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.navigationController.navigationBar setTranslucent:YES];
    
    //标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80.0f, 40.0f)];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.text = [NSString stringWithFormat:@"%d / %d",_chooseIndex + 1,_imagesArray.count];
    _titleLabel.backgroundColor = [UIColor clearColor];
//    _titleLabel.textColor = [UIColor colorWithRed:102.0 /255.0 green:102.0 /255.0 blue:102.0 /255.0 alpha:1.0];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = _titleLabel;
	
    //返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40.0f, 40.0f);
//    [backBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ico_common_return_white" ofType:@"png"]] forState:UIControlStateNormal];
    [backBtn setImage:[[ThemeManager shareInstance] getThemeImage:@"ico_common_return.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    [backItem release];
    
    //删除按钮
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(0, 0, 40.0f, 40.f);
//    [deleteBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"eatShow_previewImage_btn_delete_normal" ofType:@"png"]] forState:UIControlStateNormal];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
//    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = KQLboldSystemFont(14);
    [deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc]initWithCustomView:deleteBtn];
    self.navigationItem.rightBarButtonItem = deleteItem;
    [deleteItem release];
    
    if(self.imagesArray != nil || self.imagesArray.count > 0)
    {
        [self setup];
    }
}

-(void)setup
{   
    int pageCount = _imagesArray.count;
    //图片scrollview
	if (self.showPicScrollView == nil && _imagesArray != nil && pageCount > 0)
	{
        self.showPicScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
		_showPicScrollView.contentSize = CGSizeMake(pageCount * _showPicScrollView.bounds.size.width, _showPicScrollView.bounds.size.height);
		_showPicScrollView.pagingEnabled = YES;
		_showPicScrollView.delegate = self;
		_showPicScrollView.showsHorizontalScrollIndicator = NO;
		_showPicScrollView.showsVerticalScrollIndicator = NO;
		_showPicScrollView.tag = 100;
        
        [self updatePhotosWithCount:pageCount];
    }
	[self.view addSubview:self.showPicScrollView];
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 120.0f) / 2.0f, self.view.bounds.size.height - 40.0f - 64, 120.0f, 20.0f)];
    _pageControl.numberOfPages = pageCount;
    _pageControl.hidesForSinglePage = YES;
    if([_pageControl respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)])
    {
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    }
    if([_pageControl respondsToSelector:@selector(sizeForNumberOfPages:)])
    {
        [_pageControl sizeForNumberOfPages:pageCount];
    }
    [self.view addSubview:_pageControl];
}

-(void)updatePhotosWithCount:(NSInteger)pageCount
{
    for(int i = 0; i < pageCount; i++)
    {
        UIImage *image = [_imagesArray objectAtIndex:i];
        CGSize photoSize = image.size;
        if(photoSize.width > self.view.bounds.size.width || photoSize.height > self.view.bounds.size.width)
        {
            float widthHeightScale = photoSize.width / photoSize.height; //宽高比
            float width = self.view.bounds.size.width;
            float height = width / widthHeightScale;
        
            photoSize = CGSizeMake(width, height);
        }
        CGFloat fixHeight = (photoSize.height + (photoSize.height/2));
        
        UIScrollView *tmpImageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(i * _showPicScrollView.bounds.size.width, (_showPicScrollView.bounds.size.height - fixHeight) / 2 ,photoSize.width, fixHeight)];
        tmpImageScroll.contentSize = CGSizeMake(photoSize.width, photoSize.height);
        tmpImageScroll.pagingEnabled = NO;
        tmpImageScroll.delegate = self;
        tmpImageScroll.maximumZoomScale = 2.0;
        tmpImageScroll.minimumZoomScale = 1.0;
        tmpImageScroll.showsHorizontalScrollIndicator = NO;
        tmpImageScroll.showsVerticalScrollIndicator = NO;
        tmpImageScroll.backgroundColor = [UIColor clearColor];
        tmpImageScroll.tag = 200 + i;
        
        myImageView *myiv = [[myImageView alloc]initWithFrame:
                             CGRectMake(0.0f , (tmpImageScroll.frame.size.height - photoSize.height) / 2.0f,photoSize.width, photoSize.height) withImageId:[NSString stringWithFormat:@"%d",i]];
        
        myiv.image = image;
        myiv.mydelegate = self;
        myiv.tag = 2000;
        myiv.clipsToBounds = YES;
        
        [tmpImageScroll addSubview:myiv];
        [myiv release];
        [_showPicScrollView addSubview:tmpImageScroll];
        [tmpImageScroll release];
    }
    self.showPicScrollView.contentSize = CGSizeMake(pageCount * _showPicScrollView.bounds.size.width, _showPicScrollView.bounds.size.height);

    [self.showPicScrollView scrollRectToVisible:CGRectMake(_showPicScrollView.bounds.size.width * _chooseIndex, 0, _showPicScrollView.bounds.size.width, _showPicScrollView.bounds.size.height) animated:YES];
    
	_titleLabel.text = [NSString stringWithFormat:@"%d / %d",_chooseIndex + 1,[_imagesArray count]];
    _pageControl.numberOfPages = pageCount;
    _pageControl.currentPage = _chooseIndex;
}

-(void)delete:(id)sender
{
    if(_imagesArray.count == 1)
    {//删除最后一张
        self.imagesArray = nil;
        [self back];
        return;
    }
    self.showImagesArray = [NSMutableArray arrayWithArray:_imagesArray];
    [_showImagesArray removeObjectAtIndex:_chooseIndex];
    
    //删除最后一张的时候 应改变chooseIndex
    if(self.chooseIndex == _imagesArray.count - 1)
    {
        self.chooseIndex --;
    }
    
    self.imagesArray = _showImagesArray;
    
    for (UIView *view in self.showPicScrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    [self updatePhotosWithCount:_imagesArray.count];//刷新预览效果
}

-(void)back
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(imagesDidRemain:)])
    {
        [self.delegate imagesDidRemain:_imagesArray];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 图片滚动委托
- (void)imageViewTouchesEnd:(NSString *)picId
{
//	BOOL navBarState = [self.navigationController.navigationBar isHidden];
//	[self.navigationController setNavigationBarHidden:!navBarState animated:YES];
}

- (void)imageViewDoubleTouchesEnd:(NSString *)picId
{
    UIScrollView *imageScroll = (UIScrollView *)[_showPicScrollView viewWithTag:200 + [picId intValue]];

    CGFloat zs = imageScroll.zoomScale;
	zs = (zs == imageScroll.minimumZoomScale) ? imageScroll.maximumZoomScale : imageScroll.minimumZoomScale;

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	imageScroll.zoomScale = zs;
	[UIView commitAnimations];
}

#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    if (aScrollView.tag == 100)
    {
		CGPoint offset = aScrollView.contentOffset;
		int currentPage = offset.x / _showPicScrollView.frame.size.width;
        _chooseIndex = currentPage;
		_titleLabel.text = [NSString stringWithFormat:@"%d / %d",currentPage+1,[_imagesArray count]];
        _pageControl.currentPage = _chooseIndex;

        int pageCount = [_imagesArray count];
		for(int i = 0; i < pageCount; i++)
		{
            UIScrollView *imageScroll = (UIScrollView *)[self.showPicScrollView viewWithTag:200+i];
            imageScroll.zoomScale = imageScroll.minimumZoomScale;
        }
	}
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)aScrollView
{
    if (aScrollView.tag != 100)
    {
        UIImageView *imageview = (UIImageView *)[aScrollView viewWithTag:2000];
        return imageview;
    }
    return nil;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)aScrollView withView:(UIView *)view atScale:(float)scale
{
	if (aScrollView.tag != 100)
    {
		float pwidth = aScrollView.frame.size.width*scale;
		float pheigth = aScrollView.frame.size.height*scale;
		aScrollView.contentSize = CGSizeMake(pwidth,pheigth);
	}
}

-(void)dealloc
{
    self.delegate = nil;
    
    self.showPicScrollView = nil; [_showPicScrollView release];
    self.titleLabel = nil; [_titleLabel release];
    
    self.showImagesArray = nil; [_showImagesArray release];
    self.imagesArray = nil; [_imagesArray release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
