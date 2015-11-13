//
//  TalkingMainViewController.m
//  ql
//
//  Created by ChenFeng on 14-1-9.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "TalkingMainViewController.h"
#import "SidebarViewController.h"
#import "SGActionView.h"

#import "UIImageScale.h"
#import "CRNavigationController.h"
#import "assignRangeViewController.h"
#import "AppDelegate.h"

#define QMargin 10.0f
#define QtextViewHeight 180.0f//文本框高度
#define QbuttomView 60.0f//底部高度
#define QimageCount 9//最大图片数
#define QimageMargin 5.0f//图片间隔

//默认文本
#define QADDImageText @"添加图片"
#define QtextPrompt @"说一说此刻的想法.."
#define QOOXXtextPrompt @"发起OOXX.."
#define QWantPrompt @"我要.."
#define QHavePrompt @"我有.."

#define BTNCOLOR [UIColor colorWithRed:0.12 green:0.55 blue:0.89 alpha:1.0]

@interface TalkingMainViewController (){
    //发动态需要传递的参数字典
    NSMutableDictionary* paraDic;
    //下一步按钮
    UIButton* nextBtn;
    //默认文本
    NSString* promptStr;
}

@property(nonatomic,retain) UITextView* textView;//文本框
@property(nonatomic,retain) UIScrollView* imageScroll;//图片容器
@property(nonatomic,retain) UIView* stateView;//位置view
@property(nonatomic,retain) UILabel* stateLab;//位置lab
@property(nonatomic,retain) UIImageView* dtImgV;//位置图标
@property(nonatomic,retain) UIView* btmView;//底部视图

@property(nonatomic,retain) UIImage* defaultImage;//默认添加图片 的图片
@property(nonatomic,assign) CGSize imageSize;//图片size

@property (nonatomic,retain) NSArray *previousSelectedImages;//上一次选择的照片数组

@property(nonatomic) BOOL isDelete;

@end

@implementation TalkingMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _selectedImages = [[NSMutableArray alloc] init];
        
        paraDic = [[NSMutableDictionary alloc] init];
        
        _isDelete = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    switch (_pType) {
        case PublicTypeText:
            self.navigationItem.title = @"文字";
            promptStr = QtextPrompt;
            break;
        case PublicImages:
            self.navigationItem.title = @"图片";
            promptStr = QtextPrompt;
            break;
        case PublicOOXX:
            self.navigationItem.title = @"OOXX";
            promptStr = QOOXXtextPrompt;
            break;
        case PublicWant:
            self.navigationItem.title = @"我要";
            promptStr = QWantPrompt;
            break;
        case PublicHave:
            self.navigationItem.title = @"我有";
            promptStr = QHavePrompt;
            break;
        default:
            break;
    }
	
//    self.view.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    self.view.backgroundColor = COLOR_LIGHTWEIGHT;
    
    //背景添加点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    RELEASE_SAFE(tapGesture);
    
    [self initNavigationBarBtn];
    
    [self initMainView];
    
    [self initButtomView];
    
}

//--------------选择图片或水印照片------------------
-(void)addImagePlaceHolder
{
    NSString* textStr = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (_selectedImages.count) {
        nextBtn.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if (([textStr length] > 0 && ![_textView.text isEqualToString:promptStr]) || _selectedImages.count) {
        nextBtn.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
                lab.text = QADDImageText;
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
    _stateView.frame = CGRectMake(0, CGRectGetMaxY(_imageScroll.frame), _stateView.bounds.size.width, _stateView.bounds.size.height);
    
    if(self.selectedImages.count < QimageCount)
    {
//        _imageScroll.contentSize = CGSizeMake(QimageMargin * (_selectedImages.count + 1 + 1) + (_selectedImages.count + 1) * _imageSize.width, _imageSize.height + 2 * QimageMargin);
    }
    else
    {
//        _imageScroll.contentSize = CGSizeMake(QimageMargin * (QimageCount + 1) + QimageCount * _imageSize.width, _imageSize.height + 2 * QimageMargin);
    }
    
    if (_imageScroll.contentSize.width > _imageScroll.bounds.size.width) {
//        [_imageScroll setContentOffset:CGPointMake(_imageScroll.contentSize.width - _imageScroll.bounds.size.width, 0) animated:YES];
    }
    
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

-(void) initMainView{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, QtextViewHeight)];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:14.0f];
    _textView.showsHorizontalScrollIndicator = NO;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.text = promptStr;
//    _textView.textColor = [UIColor darkGrayColor];
    _textView.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_IMPORTANT"];
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    [self.view addSubview:_textView];
    
    _imageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame), self.view.bounds.size.width, 80)];
    _imageScroll.showsHorizontalScrollIndicator = YES;
    _imageScroll.showsVerticalScrollIndicator = NO;
    _imageScroll.delegate = self;
    _imageScroll.backgroundColor = [UIColor whiteColor];
    _imageScroll.pagingEnabled = YES;
    _imageScroll.bounces = NO;
    [self.view addSubview:_imageScroll];
    
    _stateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageScroll.frame), _textView.bounds.size.width, 50)];
    _stateView.backgroundColor = [UIColor whiteColor];
    _stateView.userInteractionEnabled = YES;
    [self.view addSubview:_stateView];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnStateView)];
    [_stateView addGestureRecognizer:tap];
    RELEASE_SAFE(tap);
    
    _dtImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 30, 30)];
    _dtImgV.image = IMG(@"ico_feed_map");
    _dtImgV.highlightedImage = IMG(@"ico_feed_position");
    [_stateView addSubview:_dtImgV];
    
    _stateLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_dtImgV.frame) + 10, CGRectGetMinY(_dtImgV.frame), 200, 30)];
    _stateLab.textColor = [UIColor darkGrayColor];
    _stateLab.font = [UIFont systemFontOfSize:14];
    _stateLab.backgroundColor = [UIColor clearColor];
    _stateLab.text = @"显示我的位置";
    [_stateView addSubview:_stateLab];
    
    UISwitch* sw = [[UISwitch alloc] init];
    if (IOS_VERSION_7) {
        sw.frame = CGRectMake(CGRectGetMaxX(_stateView.frame) - 40 - 20, 10, 40, 30);
    }else{
        sw.frame = CGRectMake(CGRectGetMaxX(_stateView.frame) - 40 - 40, 10, 40, 30);
    }
    sw.on = NO;
    sw.tag = 1000;
    [sw addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
    [_stateView addSubview:sw];
    [sw release];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app getLocation];
    if ([Global sharedGlobal].isLoction) {
        _stateLab.text = [Global sharedGlobal].locationCity;
        _stateLab.textColor = [UIColor blackColor];
        _dtImgV.highlighted = YES;
        [paraDic setObject:[Global sharedGlobal].locationCity forKey:@"city"];
        sw.on = YES;
    }else{
        _stateLab.text = @"显示我的位置";
        _stateLab.textColor = [UIColor darkGrayColor];
        _dtImgV.highlighted = NO;
        [paraDic setObject:@"" forKey:@"city"];
        sw.on = NO;
    }
    
    self.imageSize = CGSizeMake((_imageScroll.bounds.size.width - 5 * QimageMargin) / 4.0, (_imageScroll.bounds.size.height - 2*QimageMargin));
    _defaultImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ico_feed_add" ofType:@"png"]];
    
    [self fillImage];
    
    if (self.selectedImages.count) {
        self.previousSelectedImages = [NSArray arrayWithArray:_selectedImages];
    }
}

-(void) switchClick:(UISwitch*) s{
    if (s.on) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app getLocation];
        if ([Global sharedGlobal].isLoction) {
            _stateLab.text = [Global sharedGlobal].locationCity;
            _stateLab.textColor = [UIColor blackColor];
            _dtImgV.highlighted = YES;
            [paraDic setObject:[Global sharedGlobal].locationCity forKey:@"city"];
        }else{
            _stateLab.text = @"显示我的位置";
            _stateLab.textColor = [UIColor darkGrayColor];
            _dtImgV.highlighted = NO;
            [paraDic setObject:@"" forKey:@"city"];
            
            //            add vicnent 定位失败提示
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"定位未开启" message:@"请在“设置”->“定位服务”中确认“定位”和“云圈”是否为开启状态！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            
            s.on = NO;//如果定位失败的话，修改当前的swith为关闭的
        }
    }else{
        _stateLab.text = @"显示我的位置";
        _stateLab.textColor = [UIColor darkGrayColor];
        _dtImgV.highlighted = NO;
        [paraDic setObject:@"" forKey:@"city"];
    }
}

-(void) tapOnStateView{
//    [self hideKeyboard];
//    //显示我的位置
//    _stateLab.text = [Global sharedGlobal].locationCity;
//    _stateLab.textColor = [UIColor blackColor];
//    _dtImgV.highlighted = YES;
//    
//    UISwitch* s = (UISwitch*)[_stateLab.superview viewWithTag:1000];
//    s.on = YES;
}

-(void) hideKeyboard{
    [_textView resignFirstResponder];
}

//初始化底部图标
-(void) initButtomView{
    
    switch (_pType) {
        case PublicOOXX:
        {
            UIView* ooxxV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageScroll.frame) + 20 + 50, self.view.bounds.size.width, self.view.bounds.size.height - (CGRectGetMaxY(_imageScroll.frame) + 20 + 50) - 64)];
            [self.view insertSubview:ooxxV atIndex:0];
            
            UIImageView* haveImgV = [[UIImageView alloc] initWithFrame:CGRectMake((ooxxV.frame.size.width - 60)/2, (ooxxV.frame.size.height - 60)/2, 60, 60)];
            haveImgV.image = IMG(@"ico_feed_ox");
            haveImgV.alpha = 0.7;
            [ooxxV addSubview:haveImgV];
            
            RELEASE_SAFE(haveImgV);
            RELEASE_SAFE(ooxxV);
            
        }
            break;
        case PublicHave:
        {
            UIView* ooxxV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageScroll.frame) + 20 + 50, self.view.bounds.size.width, self.view.bounds.size.height - (CGRectGetMaxY(_imageScroll.frame) + 20 + 50) - 64)];
            [self.view insertSubview:ooxxV atIndex:0];
            
            UIImageView* haveImgV = [[UIImageView alloc] initWithFrame:CGRectMake((ooxxV.frame.size.width - 60)/2, (ooxxV.frame.size.height - 60)/2, 60, 60)];
            haveImgV.image = IMG(@"ico_feed_have");
            haveImgV.alpha = 0.7;
            [ooxxV addSubview:haveImgV];
            
            RELEASE_SAFE(haveImgV);
            RELEASE_SAFE(ooxxV);
        }
            break;
        case PublicWant:
        {
            UIView* ooxxV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageScroll.frame) + 20 + 50, self.view.bounds.size.width, self.view.bounds.size.height - (CGRectGetMaxY(_imageScroll.frame) + 20 + 50) - 64)];
            [self.view insertSubview:ooxxV atIndex:0];
            
            UIImageView* wantImgV = [[UIImageView alloc] initWithFrame:CGRectMake((ooxxV.frame.size.width - 60)/2, (ooxxV.frame.size.height - 60)/2, 60, 60)];
            wantImgV.image = IMG(@"ico_feed_want");
            wantImgV.alpha = 0.7;
            [ooxxV addSubview:wantImgV];
            
            RELEASE_SAFE(wantImgV);
            RELEASE_SAFE(ooxxV);
        }
            break;
        case PublicTypeText:
        {
            UIView* ooxxV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageScroll.frame) + 20 + 50, self.view.bounds.size.width, self.view.bounds.size.height - (CGRectGetMaxY(_imageScroll.frame) + 20 + 50) - 64)];
            [self.view insertSubview:ooxxV atIndex:0];
            
            UIImageView* wantImgV = [[UIImageView alloc] initWithFrame:CGRectMake((ooxxV.frame.size.width - 60)/2, (ooxxV.frame.size.height - 60)/2, 60, 60)];
            wantImgV.image = IMG(@"ico_feed_text");
            wantImgV.alpha = 0.7;
            [ooxxV addSubview:wantImgV];
            
            RELEASE_SAFE(wantImgV);
            RELEASE_SAFE(ooxxV);
        }
            break;
        case PublicImages:
        {
            UIView* ooxxV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageScroll.frame) + 20 + 50, self.view.bounds.size.width, self.view.bounds.size.height - (CGRectGetMaxY(_imageScroll.frame) + 20 + 50) - 64)];
            [self.view insertSubview:ooxxV atIndex:0];
            
            UIImageView* wantImgV = [[UIImageView alloc] initWithFrame:CGRectMake((ooxxV.frame.size.width - 60)/2, (ooxxV.frame.size.height - 60)/2, 60, 60)];
            wantImgV.image = IMG(@"ico_feed_pic");
            wantImgV.alpha = 0.7;
            [ooxxV addSubview:wantImgV];
            
            RELEASE_SAFE(wantImgV);
            RELEASE_SAFE(ooxxV);
        }
            break;
        default:
            break;
    }
}

#define MAXTEXTLENGTH 140
#define MAXTEXTALERT @"不要超过140字哦"

#pragma mark - 下一步
-(void) nextBtnClick{
    
    NSString* textStr = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (([textStr length] > 0 && ![_textView.text isEqualToString:promptStr]) || _selectedImages.count) {
        
        if ([textStr length] > MAXTEXTLENGTH) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:MAXTEXTALERT delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        
        //url encode
        NSURL* url = [NSURL URLWithString:textStr];
        NSLog(@"%@",[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil]);
        
        [self hideKeyboard];
        
        if ([_textView.text isEqualToString:promptStr]) {
            [paraDic setObject:@"" forKey:@"title"];
        }else{
            [paraDic setObject:_textView.text forKey:@"title"];
        }
        
        NSMutableArray* arr = [NSMutableArray arrayWithArray:_selectedImages];
//        [paraDic setObject:arr forKey:@"images"];
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithDictionary:paraDic];
        [dic setObject:arr forKey:@"images"];
        
        //下一步
        assignRangeViewController* assignVC = [[assignRangeViewController alloc] init];
        if (_pType == PublicImages) {
            assignVC.type = 0;
        }else if (_pType == PublicTypeText) {
            assignVC.type = 0;
        }else if (_pType == PublicOOXX) {
            assignVC.type = 1;
        }else if (_pType == PublicWant){
            assignVC.type = 4;
        }else if (_pType == PublicHave){
            assignVC.type = 3;
        }
//        assignVC.paraDic = paraDic;
        assignVC.paraDic = dic;
        [self.navigationController pushViewController:assignVC animated:YES];
        RELEASE_SAFE(assignVC);
        RELEASE_SAFE(dic);
    }else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:promptStr delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
}

/**
 *  实例化导航栏按钮
 */
- (void)initNavigationBarBtn{
    //取消
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:BTNCOLOR forState:UIControlStateNormal];
    UIImage* image = [[ThemeManager shareInstance] getThemeImage:@"ico_common_return.png"];
    [cancelButton setImage:image forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(0, 30, image.size.width, image.size.height);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    if (IOS_VERSION_7) {
        cancelButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    }
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    RELEASE_SAFE(leftItem);
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.backgroundColor = [UIColor clearColor];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = KQLboldSystemFont(14);
    [nextBtn setTitleColor:COLOR_GRAY2 forState:UIControlStateNormal];
    nextBtn.frame = CGRectMake(0, 30, 60, 30);
    nextBtn.enabled = NO;
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:nextBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    RELEASE_SAFE(rightItem);
}

#pragma mark - textviewDelegate
-(void) textViewDidBeginEditing:(UITextView *)textView{
    textView.textColor = [UIColor blackColor];
    if ([textView.text isEqualToString:promptStr]) {
        textView.text = @"";
    }
}

-(void) textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        textView.text = promptStr;
        textView.textColor = [UIColor darkGrayColor];
    }else{
        nextBtn.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [nextBtn setTitleColor:[[ThemeManager shareInstance] getColorWithName:@"COLOR_TOPBARTXT"] forState:UIControlStateNormal];
    }
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
//    if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 140) {
//        return;
//    }
}

#pragma mark - event Method

-(void) cancelBtnClick{
    if (nextBtn.enabled || _selectedImages.count) {
        UIAlertView* alertV = [[UIAlertView alloc] initWithTitle:nil message:@"确定要取消发布吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertV.tag = 100;
        [alertV show];
        [alertV release];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - alertview
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    RELEASE_SAFE(_stateView);
    RELEASE_SAFE(_dtImgV);
    RELEASE_SAFE(paraDic);
    RELEASE_SAFE(_imageScroll);
    RELEASE_SAFE(_defaultImage);
    RELEASE_SAFE(_textView);
    RELEASE_SAFE(_stateLab);
    RELEASE_SAFE(_btmView);
    RELEASE_SAFE(_previousSelectedImages);
    RELEASE_SAFE(_selectedImages);
    [super dealloc];
    
}

@end
