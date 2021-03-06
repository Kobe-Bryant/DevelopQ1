//
//  MeetingMainViewController.m
//  ql
//
//  Created by ChenFeng on 14-1-9.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "MeetingMainViewController.h"
#import "SidebarViewController.h"

#import "assignRangeViewController.h"
#import "choiceCityViewController.h"
#import "CRNavigationController.h"

#import "SetPlaceViewController.h"

#define QtextPrompt @"写点什么吧.."

#define QMargin 10.0f
#define QimageCount 9//最大图片数
#define QimageMargin 5.0f//图片间隔

#define MeetAlertTag 9999
#define PlaceHolderButtonTag 9998

@interface MeetingMainViewController ()<choiceCityDelegate,SetPlaceDelegate>{
    UIDatePicker* datePicker;
//    UIView* contraitV;
    UIToolbar* contraitV;
    
    BOOL isStart;
    
    NSString* selectCity;
    
    //下一步按钮
    UIButton* nextBtn;
    
    NSString* startTimeStr;
    NSString* endTimeStr;
}
//包裹整个的滚动
@property(nonatomic,retain) UIScrollView* wholeScrollView;
@property(nonatomic,retain) UITextView* textView;
@property(nonatomic,retain) UIView* stateAndTimeView;
@property(nonatomic,retain) UILabel* TimeLab;
@property(nonatomic,retain) UILabel* stateLab;
@property(nonatomic,retain) UIScrollView* imageScroll;

@property(nonatomic,retain) UIImage* defaultImage;//默认添加图片 的图片
@property(nonatomic,assign) CGSize imageSize;//图片size

@property (nonatomic,retain) NSMutableArray *selectedImages; //总共选择的照片数组
@property (nonatomic,retain) NSArray *previousSelectedImages;//上一次选择的照片数组

@property(nonatomic,retain) UILabel* timeShowLab;
@property(nonatomic,retain) UIButton* toolBarRightBtn;

@property(nonatomic) BOOL isDelete;

@end

@implementation MeetingMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isStart = YES;
        
        _selectedImages = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.title = @"聚聚";
    
    if (IOS_VERSION_7) {
        self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = COLOR_LIGHTWEIGHT;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnView)];
    [self.view addGestureRecognizer:tap];
    [tap release];
    
    [self initWholeScroll];
    
    [self initNavigationBarBtn];
    
    [self initTextView];
    
    [self initAddPicView];
    
    [self initStateAndTimeView];
}

//初始化wholeScrollView
-(void) initWholeScroll{
    UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KUIScreenWidth, KUIScreenHeight - 44)];
    scroll.delegate = self;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.bounces = NO;
    scroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scroll];
    self.wholeScrollView = scroll;
    
    [scroll release];
}

//添加照片
-(void) initAddPicView{
    _imageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame), self.view.bounds.size.width, 80)];
    _imageScroll.showsHorizontalScrollIndicator = YES;
    _imageScroll.showsVerticalScrollIndicator = NO;
    _imageScroll.delegate = self;
    _imageScroll.backgroundColor = [UIColor whiteColor];
    _imageScroll.pagingEnabled = YES;
    _imageScroll.bounces = NO;
//    [self.view addSubview:_imageScroll];
    [_wholeScrollView addSubview:_imageScroll];
    
    self.imageSize = CGSizeMake((_imageScroll.bounds.size.width - 5 * QimageMargin) / 4.0, (_imageScroll.bounds.size.height - 2*QimageMargin));
    _defaultImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ico_feed_add" ofType:@"png"]];
    
    [self fillImage];
}

-(void) hideKeyboard{
    [_textView resignFirstResponder];
    
    UIButton* btn = (UIButton*)[self.view viewWithTag:PlaceHolderButtonTag];
    [btn removeFromSuperview];
}

//--------------选择图片或水印照片------------------
-(void)addImagePlaceHolder
{
    NSString* textStr = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (([textStr length] > 0 && ![_textView.text isEqualToString:QtextPrompt])) {
        nextBtn.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [nextBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
    }else{
        nextBtn.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [nextBtn setTitleColor:COLOR_GRAY2 forState:UIControlStateNormal];
    }
    
    if(self.selectedImages.count <= QimageCount)
    {
        int temp = 0;
        if(_selectedImages.count == 0)
        {
            temp = 0;
        }
        else if(_selectedImages.count > 0 && self.isDelete == NO)
        {
            temp = _previousSelectedImages.count + 1;
        }
        else
        {
            temp = 0;
        }
        for (int i = temp; i <= _selectedImages.count; i++)
        {
            //达到最大图片数后，停止创建
            if(i == QimageCount)
            {
                break;
            }
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(QimageMargin + (QimageMargin + _imageSize.width) * (i%4), QimageMargin + (QimageMargin + _imageSize.height) * (i/4), _imageSize.width, _imageSize.height)];
            imageView.userInteractionEnabled = YES;
            imageView.image = _defaultImage;
            imageView.tag = 2000 + i;
            [_imageScroll addSubview:imageView];
            
            if (i == _selectedImages.count) {
                UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0, (_imageSize.height - 20)/2, _imageSize.width, 20)];
                lab.text = @"添加图片";
                lab.font = KQLboldSystemFont(13);
                lab.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
                lab.textAlignment = UITextAlignmentCenter;
                lab.backgroundColor = [UIColor clearColor];
                [imageView addSubview:lab];
                RELEASE_SAFE(lab);
                
            }
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToSelect:)];
            [imageView addGestureRecognizer:tap];
            [tap release];
            [imageView release];
        }
    }
    
    _imageScroll.contentSize = CGSizeMake(_imageScroll.bounds.size.width, QimageMargin + (QimageMargin + _imageSize.height) * ((_selectedImages.count)/4 + 1));
    _imageScroll.frame = CGRectMake(0, CGRectGetMaxY(_textView.frame), _imageScroll.bounds.size.width, 80 * ((_selectedImages.count)/4 + 1));
    _stateAndTimeView.frame = CGRectMake(0, CGRectGetMaxY(_imageScroll.frame), _stateAndTimeView.bounds.size.width, _stateAndTimeView.bounds.size.height);
    
    _wholeScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(_stateAndTimeView.frame));
    
}

//点击图片
-(void)tapToSelect:(UITapGestureRecognizer *)tapGesture
{
    [self hideKeyboard];
    
    UIImageView *imgView = (UIImageView *)tapGesture.view;
    //弹出actionSheet选择图片
    if([imgView.image isEqual:self.defaultImage])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"从相册选取", nil];
        [actionSheet showInView:self.view];
        [actionSheet release];
    }
    else
    {
        //预览图片
        previewImageViewController *previewController = [[previewImageViewController alloc]init];
        previewController.imagesArray = _selectedImages;
        previewController.chooseIndex = imgView.tag - 2000;
        previewController.delegate = self;
        
        CRNavigationController *previewNav = [[CRNavigationController alloc]initWithRootViewController:previewController];
        [self presentViewController:previewNav animated:YES completion:nil];
        [previewNav release];
        [previewController release];
    }
}

//预览图片回调
#pragma mark -PreviewImageViewControllerDelegate
-(void)imagesDidRemain:(NSArray *)remainImages
{
    self.isDelete = YES;
    
    [_selectedImages removeAllObjects];
    if(remainImages != nil)
    {
        [_selectedImages addObjectsFromArray:remainImages];
    }
    self.previousSelectedImages = remainImages;
    [self deleteImage];
}

//删除图片   刷新界面
-(void)deleteImage
{
    for (UIView *view in _imageScroll.subviews)
    {
        [view removeFromSuperview];
    }
    
    [self addImagePlaceHolder];
    
    for (int i = 0; i < _selectedImages.count; i++)
    {
        UIImageView *imageView = (UIImageView *)[_imageScroll viewWithTag:2000 + i];
        imageView.image = [_selectedImages objectAtIndex:i];
    }
}
//------------end---------------//

#pragma mark -UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self showCameraView];
        }else{
            NSLog(@"don't support camera");
        }
        
    }
    else if (buttonIndex == 1)
    {
        [self showSelectImageView];
    }
}

//调用水印相机
-(void) showCameraView{
    
    WatermarkCameraViewController *watermarkCamera = [[WatermarkCameraViewController alloc]init];
    watermarkCamera.type = 1;
    watermarkCamera.currentImageCount = _selectedImages.count;
    watermarkCamera.delegate = self;
    [self presentViewController:watermarkCamera animated:YES completion:nil];
    [watermarkCamera release];
}

//水印相机回调
#pragma mark -watermarkCameraViewControllerDelegate
-(void)didSelectImages:(NSArray *)images
{
    NSArray *array = [_selectedImages arrayByAddingObjectsFromArray:images];
    [_selectedImages addObjectsFromArray:images];
    [self fillImage];
    self.previousSelectedImages = array;
}

//从相册选择的图片数组中提取图片
-(NSArray *)getImagesFromArray:(NSArray *)array
{
    NSMutableArray *imageList = [NSMutableArray array];
    for (NSDictionary *dic in array)
    {
        UIImage *image = [dic objectForKey:UIImagePickerControllerOriginalImage];
        [imageList addObject:image];
    }
    return imageList;
}

//选择相册照片回调
#pragma mark -QBImagePickerControllerDelegate,UIImagePickerControllerDelegate
-(void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    if([imagePickerController isKindOfClass:[QBImagePickerController class]])
    {
        self.isDelete = NO;
        if(imagePickerController.allowsMultipleSelection)
        {
            NSArray *mediaInfoArray = [self getImagesFromArray:info];
            NSArray *array = [_selectedImages arrayByAddingObjectsFromArray:mediaInfoArray];
            [_selectedImages addObjectsFromArray:mediaInfoArray];
            [self fillImage];
            self.previousSelectedImages = array;
        }
        [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
    else if ([imagePickerController isKindOfClass:[UIImagePickerController class]])
    {//拍照
        //        self.isDelete = NO;
        //        UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
        //        NSArray *array = [_selectedImages arrayByAddingObject:photo];
        //        [_selectedImages addObject:photo];
        //
        //        [self fillImage];
        //        self.previousSelectedImages = array;
        //        [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}


//选择本地图片
-(void)showSelectImageView
{
    QBImagePickerController *imagePicker = [[QBImagePickerController alloc]init];
    imagePicker.showsCancelButton = YES;
    imagePicker.filterType = QBImagePickerFilterTypeAllPhotos;
    imagePicker.fullScreenLayoutEnabled = YES;
    imagePicker.allowsMultipleSelection = YES;
    imagePicker.limitsMaximumNumberOfSelection = YES;
    imagePicker.maximumNumberOfSelection = QimageCount - _selectedImages.count;
    imagePicker.delegate = self;
    
    CRNavigationController *nav = [[CRNavigationController alloc]initWithRootViewController:imagePicker];
    [self presentViewController:nav animated:YES completion:nil];
    [nav release];
    [imagePicker release];
}

//添加选择图片框
-(void)fillImage
{
    NSLog(@"--selectedImages:%@--",_selectedImages);
    
    [self addImagePlaceHolder];
    
    int count = 0;
    if(_selectedImages.count == 0)
    {
        count = 1;
    }
    else
    {
        count = _selectedImages.count;
    }
    
    if(_selectedImages.count > 0)
    {
        for (int i = _previousSelectedImages.count; i < count; i++)
        {
            UIImageView *imageView = (UIImageView *)[_imageScroll viewWithTag:2000 + i];
            
            UIImage *image = [_selectedImages objectAtIndex:i];
            imageView.image = [image fillSize:_imageSize];
            
            for (UILabel* lab in imageView.subviews) {
                [lab removeFromSuperview];
            }
        }
    }
}

-(void) tapOnView{
    [_textView resignFirstResponder];
    [self hideDatePicker];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [_textView resignFirstResponder];
//    [self hideDatePicker];
}

/**
 *  实例化导航栏按钮
 */
- (void)initNavigationBarBtn{

    //取消
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(0, 30, 30, 30);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    RELEASE_SAFE(leftItem);
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.backgroundColor = [UIColor clearColor];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = KQLboldSystemFont(14);
    [nextBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
    nextBtn.frame = CGRectMake(0, 30, 60, 30);
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:nextBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    RELEASE_SAFE(rightItem);
    
}

-(void) cancelBtnClick{
    NSString* str = _textView.text;
    if (([str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0 && ![str isEqualToString:QtextPrompt]) || _selectedImages.count != 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要取消发布吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        alert.tag = MeetAlertTag;
        [alert release];
        
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - alertview
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != alertView.cancelButtonIndex) {
        switch (alertView.tag) {
            case MeetAlertTag:
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

-(void) nextBtnClick{
    NSUInteger length = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
    if (length <= 0 || [_textView.text isEqualToString:QtextPrompt]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:QtextPrompt delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    if (length > 140) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"字数不得超过140" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    if ([_TimeLab.text isEqualToString:@"  设置时间"]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"请设置时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([_stateLab.text isEqualToString:@"  选择地点"]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择地点" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
//    UILabel* slab = (UILabel*)[contraitV viewWithTag:1002];
//    UILabel* elab = (UILabel*)[contraitV viewWithTag:1001];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"MM-dd HH:mm";
    formatter.dateFormat = @"YYYY/MM/dd HH:mm";
    
    NSMutableArray* arr = [NSMutableArray arrayWithArray:_selectedImages];
    NSString* addressStr = selectCity;
//    NSNumber* startNum = [NSNumber numberWithInt:[[formatter dateFromString:slab.text] timeIntervalSince1970]];
//    NSNumber* endNum = [NSNumber numberWithInt:[[formatter dateFromString:elab.text] timeIntervalSince1970]];
    NSNumber* startNum = [NSNumber numberWithInt:[[formatter dateFromString:startTimeStr] timeIntervalSince1970]];
    NSNumber* endNum = [NSNumber numberWithInt:[[formatter dateFromString:endTimeStr] timeIntervalSince1970]];
    
    NSString* title = _textView.text;
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                startNum,@"start_time",
                                endNum,@"end_time",
                                addressStr,@"address",
                                title,@"title",
                                [Global sharedGlobal].locationCity,@"city",
                                nil];
    if (arr.count) {
        [dic setObject:arr forKey:@"images"];
    }
    
    assignRangeViewController* rangeVC = [[assignRangeViewController alloc] init];
    rangeVC.type = 8;
    rangeVC.paraDic = dic;
    [self.navigationController pushViewController:rangeVC animated:YES];
    RELEASE_SAFE(rangeVC);
    
    [formatter release];
}

-(void) initTextView{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 140)];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:14.0f];
    _textView.showsHorizontalScrollIndicator = NO;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.text = QtextPrompt;
    _textView.textColor = [UIColor darkGrayColor];
    _textView.returnKeyType = UIReturnKeyDone;
//    [self.view addSubview:_textView];
    [_wholeScrollView addSubview:_textView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textviewDelegate

-(void) textViewDidBeginEditing:(UITextView *)textView{
    [self hideDatePicker];
    textView.textColor = [UIColor blackColor];
    if ([textView.text isEqualToString:QtextPrompt]) {
        textView.text = @"";
    }
    
//    [self addPlaceHolderBtn];
}

-(void) textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        textView.text = QtextPrompt;
        textView.textColor = [UIColor darkGrayColor];
     
        nextBtn.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [nextBtn setTitleColor:COLOR_GRAY2 forState:UIControlStateNormal];
    }
    
    UIButton* btn = (UIButton*)[self.view viewWithTag:PlaceHolderButtonTag];
    [btn removeFromSuperview];
}

-(void) addPlaceHolderBtn{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, KUIScreenWidth, KUIScreenHeight - 216);
    btn.backgroundColor = [UIColor clearColor];
    btn.tag = PlaceHolderButtonTag;
    [btn addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 140) {
        //字数检测
        textView.text = [textView.text substringToIndex:140];
    }
    
    if (textView.text.length || _selectedImages.count) {
        nextBtn.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [nextBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
    }else{
        nextBtn.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [nextBtn setTitleColor:COLOR_GRAY2 forState:UIControlStateNormal];
    }
    
    if (range.location || _selectedImages.count) {
        nextBtn.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [nextBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
    }else{
        nextBtn.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [nextBtn setTitleColor:COLOR_GRAY2 forState:UIControlStateNormal];
    }
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView{
    
}

-(void) initStateAndTimeView{
    _stateAndTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageScroll.frame), self.view.bounds.size.width, 110)];
    _stateAndTimeView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_stateAndTimeView];
    [_wholeScrollView addSubview:_stateAndTimeView];
    
    UIImageView* TimeImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 45)];
    UIImage* normolImg = IMG(@"btn_feed_time");
    TimeImageV.image = [normolImg stretchableImageWithLeftCapWidth:50 topCapHeight:0];
    [_stateAndTimeView addSubview:TimeImageV];
    
    UITapGestureRecognizer* timeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapOn:)];
    TimeImageV.tag = 1000;
    TimeImageV.userInteractionEnabled = YES;
    [TimeImageV addGestureRecognizer:timeTap];
    RELEASE_SAFE(timeTap);
    
    _TimeLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(TimeImageV.frame) + 45, 5, _stateAndTimeView.bounds.size.width - 10*2 - (CGRectGetMinX(TimeImageV.frame) + 45), 45)];
    _TimeLab.backgroundColor = COLOR_LIGHTWEIGHT;
    _TimeLab.font = [UIFont systemFontOfSize:15];
    _TimeLab.textColor = [UIColor blackColor];
    _TimeLab.textAlignment = NSTextAlignmentLeft;
    _TimeLab.text = @"  设置时间";
    [_stateAndTimeView addSubview:_TimeLab];
    
    UIImageView* rightCellImgV = [[UIImageView alloc] init];
    UIImage* rightImg = IMG(@"btn_feed_drop");
    rightCellImgV.frame = CGRectMake(CGRectGetMaxX(TimeImageV.frame) - 20 - rightImg.size.width, CGRectGetMinY(TimeImageV.frame) + (50 - rightImg.size.height)/2, rightImg.size.width, rightImg.size.height);
    rightCellImgV.image = rightImg;
    [_stateAndTimeView addSubview:rightCellImgV];
    
    UIImageView* stateImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(TimeImageV.frame) + 5, 300, 45)];
    UIImage* sNormolImg = IMG(@"btn_feed_address");
    stateImageV.image = [sNormolImg stretchableImageWithLeftCapWidth:50 topCapHeight:0];
    [_stateAndTimeView addSubview:stateImageV];
    
    UITapGestureRecognizer* stateTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapOn:)];
    stateImageV.tag = 1001;
    stateImageV.userInteractionEnabled = YES;
    [stateImageV addGestureRecognizer:stateTap];
    RELEASE_SAFE(stateTap);
    
    _stateLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(stateImageV.frame) + 45, CGRectGetMinY(stateImageV.frame), _stateAndTimeView.bounds.size.width - 10*2 - (CGRectGetMinX(stateImageV.frame) + 45), 45)];
    _stateLab.backgroundColor = COLOR_LIGHTWEIGHT;
    _stateLab.font = [UIFont systemFontOfSize:15];
    _stateLab.textColor = [UIColor blackColor];
    _stateLab.textAlignment = NSTextAlignmentLeft;
    _stateLab.text = @"  选择地点";
    [_stateAndTimeView addSubview:_stateLab];
    
    UIImageView* stateRightImgV = [[UIImageView alloc] init];
    UIImage* stateRightImg = IMG(@"btn_feed_drop");
    stateRightImgV.frame = CGRectMake(CGRectGetMaxX(stateImageV.frame) - 20 - stateRightImg.size.width, CGRectGetMinY(stateImageV.frame) + (50 - stateRightImg.size.height)/2, stateRightImg.size.width, stateRightImg.size.height);
    stateRightImgV.image = stateRightImg;
    [_stateAndTimeView addSubview:stateRightImgV];
    
    UIView* openTimeV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_stateAndTimeView.frame) + 20, self.view.bounds.size.width, self.view.bounds.size.height - (CGRectGetMaxY(_stateAndTimeView.frame) + 20) - 64)];
    [self.view insertSubview:openTimeV atIndex:0];
    
    UIImageView* haveImgV = [[UIImageView alloc] initWithFrame:CGRectMake((openTimeV.frame.size.width - 60)/2, (openTimeV.frame.size.height - 60)/2, 60, 60)];
    haveImgV.image = IMG(@"ico_feed_party");
    haveImgV.alpha = 0.7;
    [openTimeV addSubview:haveImgV];
    
    RELEASE_SAFE(haveImgV);
    RELEASE_SAFE(openTimeV);
    
    RELEASE_SAFE(TimeImageV);
    RELEASE_SAFE(rightCellImgV);
    RELEASE_SAFE(stateImageV);
    RELEASE_SAFE(stateRightImgV);
    
}

-(void) imageViewTapOn:(UITapGestureRecognizer*) ges{
    [_textView resignFirstResponder];
    UIImageView* imgV = (UIImageView*)ges.view;
    if (imgV.tag == 1000) {
        //set time
        NSLog(@"time==");
        [self choiceTime];
    }else{
        //choice state
        NSLog(@"state==");
        
        [self hideDatePicker];
        
//        choiceCityViewController* choiceCtVC = [[choiceCityViewController alloc] init];
//        choiceCtVC.delegate = self;
//        choiceCtVC.cityType = CityTableTypeSingle;
//        CRNavigationController* crnav = [[CRNavigationController alloc] initWithRootViewController:choiceCtVC];
//        [self presentViewController:crnav animated:YES completion:nil];
//        RELEASE_SAFE(crnav);
//        RELEASE_SAFE(choiceCtVC);
        
        SetPlaceViewController* placeVC = [[SetPlaceViewController alloc] init];
        placeVC.delegate = self;
        if (selectCity) {
            placeVC.placeStr = selectCity;
        }
        
        CRNavigationController* crnav = [[CRNavigationController alloc] initWithRootViewController:placeVC];
        [self presentViewController:crnav animated:YES completion:nil];
        
        [placeVC release];
        [crnav release];
    }
}

#pragma mark - setPlace
-(void) setOpenTimePlace:(NSString *)str{
    if (str && str.length > 0) {
        selectCity = [str copy];
        NSString* subStr = nil;
        
        if ([Global sharedGlobal].isLoction) {
            subStr = [NSString stringWithFormat:@"%@%@",[Global sharedGlobal].locationCity,selectCity];
        }else{
            subStr = selectCity;
        }
        
        if (subStr.length > 12) {
            subStr = [NSString stringWithFormat:@"%@...",[subStr substringToIndex:12]];
        }
        
        _stateLab.text = [NSString stringWithFormat:@"  %@",subStr];
    }
}

-(void) didSelectedCity:(NSArray *)cityName{
    if (cityName && cityName.count > 0) {
        selectCity = [cityName lastObject];
        _stateLab.text = [NSString stringWithFormat:@"  %@",selectCity];
    }
}

-(void) cancelCTClick{
    
}

-(void) choiceTime{
    if (datePicker == nil) {
        
        contraitV = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 40)];
//        contraitV = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 30)];
        contraitV.backgroundColor = COLOR_LIGHTWEIGHT;
        
        UILabel* startLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
        startLab.textColor = [UIColor redColor];
        startLab.backgroundColor = [UIColor clearColor];
//        startLab.text = @"开始时间";
        startLab.textAlignment = UITextAlignmentCenter;
        startLab.tag = 1002;
        startLab.userInteractionEnabled = YES;
        [contraitV addSubview:startLab];
        
        self.timeShowLab = startLab;
//        
//        UILabel* midLab = [[UILabel alloc] initWithFrame:CGRectMake(130, 5, 60, 20)];
//        midLab.textAlignment = UITextAlignmentCenter;
//        midLab.text = @" ---- ";
//        midLab.textColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1.0];
//        midLab.backgroundColor = [UIColor clearColor];
//        [contraitV addSubview:midLab];
        
//        UILabel* endLab = [[UILabel alloc] initWithFrame:CGRectMake(190, 5, 130, 20)];
//        endLab.textColor = [UIColor blackColor];
//        endLab.backgroundColor = [UIColor clearColor];
//        endLab.text = @"结束时间";
//        endLab.textAlignment = UITextAlignmentCenter;
//        endLab.tag = 1001;
//        endLab.userInteractionEnabled = YES;
//        [contraitV addSubview:endLab];
        
        UIButton* endLab = [UIButton buttonWithType:UIButtonTypeCustom];
        endLab.backgroundColor = [UIColor clearColor];
        endLab.frame = CGRectMake(240, 0, 80, 40);
        endLab.tag = 1004;
        [endLab setTitle:@"下一步" forState:UIControlStateNormal];
        [endLab setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        endLab.enabled = NO;
        [endLab addTarget:self action:@selector(endButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [contraitV addSubview:endLab];
        
        self.toolBarRightBtn = endLab;
        
//        UITapGestureRecognizer* stap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labTimeTap:)];
//        [startLab addGestureRecognizer:stap];
//        [stap release];
        
//        UITapGestureRecognizer* etap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labTimeTap:)];
//        [endLab addGestureRecognizer:etap];
//        [etap release];
        
        RELEASE_SAFE(startLab);
//        RELEASE_SAFE(midLab);
        RELEASE_SAFE(endLab);
        
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height + 20, self.view.bounds.size.width - 40, 0)];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [datePicker addTarget:self action:@selector(dateDidChange) forControlEvents:UIControlEventValueChanged];
        datePicker.date = [NSDate date];
        datePicker.backgroundColor = COLOR_LIGHTWEIGHT;
        datePicker.tag = 1000;
        
        UIButton* placeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        placeButton.backgroundColor = [UIColor clearColor];
        [placeButton addTarget:self action:@selector(placeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        placeButton.frame = CGRectMake(0, 0, KUIScreenWidth, KUIScreenHeight - 256 - 44);
        placeButton.tag = 999;
        [self.view addSubview:placeButton];
        
        self.timeShowLab.text = [Common makeTime:[datePicker.date timeIntervalSince1970] withFormat:@"YYYY/MM/dd HH:mm"];
    }
    
    [self.view addSubview:contraitV];
    [self.view addSubview:datePicker];
    
    [UIView animateWithDuration:0.3 animations:^{
        UIButton* btn = (UIButton*)[self.view viewWithTag:999];
        btn.hidden = NO;
        
        contraitV.frame = CGRectMake(0, self.view.bounds.size.height - 256, self.view.bounds.size.width, 40);
        datePicker.frame = CGRectMake(0, self.view.bounds.size.height - 216, 0, 0);
        
        _wholeScrollView.frame = CGRectMake(0, - 246 + KUIScreenHeight - 44 - CGRectGetMaxY(_stateAndTimeView.frame), KUIScreenWidth, KUIScreenHeight - 44);
    }];
}

-(void) placeButtonClick{
    [self hideDatePicker];
}

-(void) endButtonClick:(UIButton*) btn{
//    btn.enabled = NO;
//    [btn setTitleColor:COLOR_GRAY2 forState:UIControlStateNormal];
    
    if (btn.tag == 1004) {
//        self.timeShowLab.text = @"结束时间";
        long long startInt = [Common timeIntervalFromString:startTimeStr andFormat:@"YYYY/MM/dd HH:mm"];
        long long nowInt = [[NSDate date] timeIntervalSince1970];
        if (startInt < nowInt) {
            [Common checkProgressHUDShowInAppKeyWindow:@"开始时间不能小于当前时间" andImage:nil];
            return;
        }
        
        self.timeShowLab.text = startTimeStr;
        [self.toolBarRightBtn setTitle:@"确定" forState:UIControlStateNormal];
        
        self.timeShowLab.tag = 1001;
        self.toolBarRightBtn.tag = 1003;
        
    }else if (btn.tag == 1003) {
        long long startInt = [Common timeIntervalFromString:startTimeStr andFormat:@"YYYY/MM/dd HH:mm"];
        long long endInt = [Common timeIntervalFromString:endTimeStr andFormat:@"YYYY/MM/dd HH:mm"];
        if (startInt < endInt) {
            _TimeLab.text = [NSString stringWithFormat:@"  %@ -- %@",[startTimeStr substringFromIndex:5],[endTimeStr substringFromIndex:5]];
            
            [self hideDatePicker];
        }else{
            [Common checkProgressHUDShowInAppKeyWindow:@"您设置的聚聚时间不合适" andImage:nil];
        }
        
    }
}

-(void) labTimeTap:(UIGestureRecognizer*) tap{
    
    UILabel* lab = (UILabel*)tap.view;
    lab.textColor = [UIColor redColor];
    
    if (lab.tag == 1001) {
        isStart = NO;
        UILabel* elab = (UILabel*)[contraitV viewWithTag:1002];
        elab.textColor = [UIColor blackColor];
    }else if (lab.tag == 1002) {
        isStart = YES;
        UILabel* slab = (UILabel*)[contraitV viewWithTag:1001];
        slab.textColor = [UIColor blackColor];
    }
    
}

-(void) hideDatePicker{
    
    [UIView animateWithDuration:0.3 animations:^{
        UIButton* btn = (UIButton*)[self.view viewWithTag:999];
//        btn.hidden = YES;
        [btn removeFromSuperview];
        
        _wholeScrollView.frame = CGRectMake(0, 0, KUIScreenWidth, KUIScreenHeight - 44);
        
        contraitV.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 40);
        datePicker.frame = CGRectMake(0, self.view.bounds.size.height + 20, 0, 0);
        
    }];
    
    [contraitV removeFromSuperview];
    [datePicker removeFromSuperview];
    
    datePicker = nil;
}

-(void) dateDidChange{
    NSString* dateStr = [Common makeTime:[datePicker.date timeIntervalSince1970] withFormat:@"YYYY/MM/dd HH:mm"];
    
//    self.toolBarRightBtn.enabled = YES;
//    [self.toolBarRightBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"] forState:UIControlStateNormal];
    
    if (self.timeShowLab.tag == 1002) {
        startTimeStr = [dateStr copy];
    }else if (self.timeShowLab.tag == 1001) {
        endTimeStr = [dateStr copy];
    }
    
    self.timeShowLab.text = dateStr;
    
    
//    NSString* dateStr = [Common makeTime:[datePicker.date timeIntervalSince1970] withFormat:@"MM-dd HH:mm"];
//    if (isStart) {
//        UILabel* sLab = (UILabel*)[contraitV viewWithTag:1002];
//        sLab.text = dateStr;
//    }else{
//        UILabel* eLab = (UILabel*)[contraitV viewWithTag:1001];
//        eLab.text = dateStr;
//    }
//    
//    UILabel* startLab = (UILabel*)[contraitV viewWithTag:1002];
//    UILabel* endLab = (UILabel*)[contraitV viewWithTag:1001];
//    if (![startLab.text isEqualToString:@"开始时间"]) {
//        if (![endLab.text isEqualToString:@"结束时间"]) {
//            NSString* startStr = startLab.text;
//            NSString* endStr = endLab.text;
//            long long startInt = [Common timeIntervalFromString:startStr andFormat:@"MM-dd HH:mm"];
//            long long endInt = [Common timeIntervalFromString:endStr andFormat:@"MM-dd HH:mm"];
//            if (startInt < endInt) {
//                _TimeLab.text = [NSString stringWithFormat:@"  %@ -- %@",startLab.text,endLab.text];
//            }else{
//                [Common checkProgressHUDShowInAppKeyWindow:@"您设置的聚聚时间不合适" andImage:nil];
//            }
//
//        }
//    }
}

-(void) choiceCity{
    
}

-(void) dealloc{
    RELEASE_SAFE(_wholeScrollView);
    RELEASE_SAFE(_previousSelectedImages);
    RELEASE_SAFE(_selectedImages);
    RELEASE_SAFE(_defaultImage);
    RELEASE_SAFE(_imageScroll);
    
    RELEASE_SAFE(contraitV);
    RELEASE_SAFE(datePicker);
    
    RELEASE_SAFE(_stateAndTimeView);
    RELEASE_SAFE(_TimeLab);
    RELEASE_SAFE(_stateLab);
    RELEASE_SAFE(_textView);
    [super dealloc];
}

@end
