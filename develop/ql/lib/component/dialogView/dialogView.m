//
//  dialogView.m
//  jw
//
//  Created by 云来ios－04 on 13-12-19.
//
//

#import "dialogView.h"
#import "config.h"

@interface dialogView ()

@property (nonatomic,retain) UIView *overlayView;
@property (nonatomic,assign) BOOL animation;

@end

@implementation dialogView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = kColorRGB(0.0, 0.0, 0.0, 1.0);
        self.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}

-(void)show
{
    _overlayView.center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
    if(_animation)
    {
        _overlayView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        _overlayView.alpha = 0;
        [UIView animateWithDuration:0.3f animations:^{
            _overlayView.alpha = 1.0;
            _overlayView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        }];
    }
    
    [self addSubview:_overlayView];
    self.backgroundColor = kColorRGB(0.0, 0.0, 0.0, 0.5f);
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

-(void)showWithAnimation:(BOOL)animation
{
    if(_delegate && [_delegate respondsToSelector:@selector(viewForShow)])
    {
        self.overlayView = [_delegate viewForShow];
        self.animation = animation;
        
        [self show];
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(backgroundShouldTouchCancel)])
    {
        BOOL shouldCancel = [_delegate backgroundShouldTouchCancel];
        if(shouldCancel)
        {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToClose:)];
            [self addGestureRecognizer:tapGesture];
            [tapGesture release];
        }
    }
}

-(void)hideAfterDelay:(NSTimeInterval)interval animation:(BOOL)animation
{
    self.animation = animation;
    if(_animation)
    {
        [UIView animateWithDuration:interval animations:^{
            _overlayView.alpha = 0;
            _overlayView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        } completion:^(BOOL isFinished){
            if(isFinished)
            {
                [_overlayView removeFromSuperview];
                [self removeFromSuperview];
            }
        }];
    }
    else
    {
        [_overlayView removeFromSuperview];
        [self removeFromSuperview];
    }
}

-(void)tapToClose:(UITapGestureRecognizer *)tapGestureRecognizer
{
    CGPoint location = [tapGestureRecognizer locationInView:_overlayView];
    location = [self convertPoint:location fromView:_overlayView];
    if(CGRectContainsPoint(_overlayView.frame, location))
    {//触摸点在弹出框内
        return;
    }
    else
    {
        [self hideAfterDelay:0.3f animation:NO];
    }
}

//成功的提示
-(void)dialogSuccessWithText:(NSString *)text animation:(BOOL)animation
{
    self.animation = animation;
    
    UIImage *backImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"other_success_bg" ofType:@"png"]];
    UIImage *closeImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"other_icon_close_black" ofType:@"png"]];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backImg.size.width + closeImg.size.width / 2.0f, backImg.size.height + closeImg.size.height / 2.0f)];
    self.overlayView = view;
    [view release];
    _overlayView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, closeImg.size.height / 2.0f, backImg.size.width, backImg.size.height)];
    imageView.image = backImg;
    [_overlayView addSubview:imageView];
    
    if(text && text.length > 0)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 25.0f, imageView.bounds.size.width - 2 * 10.0f, 30.0f)];
        label.font = [UIFont systemFontOfSize:15.0f];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.text = text;
        [imageView addSubview:label];
        [label release];
    }
    [imageView release];
    
    //关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(_overlayView.bounds.size.width - closeImg.size.width, 0, closeImg.size.width, closeImg.size.height);
    [closeBtn setImage:closeImg forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [_overlayView addSubview:closeBtn];
    
    [self show];
}

//弹出提示框
-(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate  buttonTitles:(NSArray *)titles
{
    self.animation = YES;
    self.delegate = delegate;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    self.overlayView = view;
    [view release];
    
    _overlayView.frame = CGRectMake(0, 0, self.bounds.size.width - 2 * 30.0f, 0);
    _overlayView.backgroundColor = [UIColor colorWithRed:0.95 green: 0.95 blue: 0.95 alpha:1.0];
    _overlayView.layer.cornerRadius = 4.0f;
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:15.0f]];
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((_overlayView.bounds.size.width - 2 * 10.0f - titleSize.width) / 2.0f + 10.0f, 5.0f, titleSize.width, titleSize.height)];
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRed:0.6 green: 0.6 blue: 0.6 alpha:1.0];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = title;
    [_overlayView addSubview:titleLabel];
    
    //消息
    CGSize containerSize = CGSizeMake(_overlayView.bounds.size.width - 2 * 20.0f, 20000.0f);
    CGSize messageSize = [message sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:containerSize];
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake((_overlayView.bounds.size.width - 2 * 10.0f - messageSize.width) / 2.0f + 10.0f, CGRectGetMaxY(titleLabel.frame) + 5.0f, messageSize.width, messageSize.height)];
    msgLabel.font = [UIFont systemFontOfSize:14.0f];
    msgLabel.backgroundColor = [UIColor clearColor];
    msgLabel.numberOfLines = 0;
    msgLabel.textColor = [UIColor colorWithRed:0.6 green: 0.6 blue: 0.6 alpha:1.0];
    msgLabel.textAlignment = UITextAlignmentCenter;
    msgLabel.text = message;
    [_overlayView addSubview:msgLabel];
    [titleLabel release];
    
    //按钮
    CGSize buttonSize = CGSizeMake(60.0f, 25.0f);
    float margin = (_overlayView.bounds.size.width - 2 * 10.0f - buttonSize.width * titles.count) / (titles.count + 1);
    UIImage *normalImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"eatShow_point_selected" ofType:@"png"]];
    normalImage = [normalImage stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0];
    UIImage *selectImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"eatShow_point_normal" ofType:@"png"]];
    selectImage = [selectImage stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0];
    for (NSString *buttonTitle in titles)
    {
        int index = [titles indexOfObject:buttonTitle];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10.0f + margin * (index + 1) + index * buttonSize.width, CGRectGetMaxY(msgLabel.frame) + 10.0f, buttonSize.width, buttonSize.height);
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [btn setTitle:buttonTitle forState:UIControlStateNormal];
        [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [btn setBackgroundImage:selectImage forState:UIControlStateHighlighted];
        btn.tag = 100 + index;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_overlayView addSubview:btn];
    }
    _overlayView.frame = CGRectMake(0, 0, self.bounds.size.width - 2 * 30.0f, CGRectGetMaxY(msgLabel.frame) + buttonSize.height + 2 * 10.0f);
    [msgLabel release];
    
    [self show];
}

-(void)buttonClick:(id)sender
{
    UIButton *btn = sender;
    int index = btn.tag - 100;
    if(_delegate && [_delegate respondsToSelector:@selector(buttonDidSelectAtIndex:)])
    {
        [_delegate buttonDidSelectAtIndex:index];
    }
    [self closeView];
}

//发送等待效果
-(void)showWaitingView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    self.overlayView = view;
    [view release];
    
    _overlayView.frame = CGRectMake(0, 0, self.bounds.size.width - 2 * 30.0f, 0);
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"other_wait240" ofType:@"png"]];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((_overlayView.bounds.size.width - image.size.width) / 2.0f, 0, image.size.width, image.size.height)];
    imageView.image = image;
    [_overlayView addSubview:imageView];
    [imageView release];
    
    //加loading的point
    NSArray *imagesArray = [NSArray arrayWithObjects:
                            [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"other_point1" ofType:@"png"]],
                            [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"other_point2" ofType:@"png"]],
                            [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"other_point3" ofType:@"png"]],
                            [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"other_point4" ofType:@"png"]],
                            [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"other_point5" ofType:@"png"]],
                            [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"other_point6" ofType:@"png"]],
                            nil];
    UIImageView *loadingImgView = [[UIImageView alloc]initWithFrame:CGRectMake((_overlayView.bounds.size.width - 80.0f) / 2.0f, image.size.height + 10.0f, 80.0f, 10.0f)];
    loadingImgView.animationImages = imagesArray;
    loadingImgView.animationDuration = 5;
    [loadingImgView startAnimating];
    [_overlayView addSubview:loadingImgView];
    
    _overlayView.frame = CGRectMake(0, 0, self.bounds.size.width - 2 * 30.0f, CGRectGetMaxY(loadingImgView.frame) + 10.0f);
    [loadingImgView release];
    
    [self show];
}

-(void)showSingleText:(NSString *)text
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    self.overlayView = view;
    [view release];
    _overlayView.frame = CGRectMake(0, 0, self.bounds.size.width - 2 * 30.0f, 0);
    _overlayView.layer.cornerRadius = 4.0f;
    _overlayView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 20.0f, _overlayView.bounds.size.width - 2 * 20.0f, 25.0f)];
    label.font = [UIFont systemFontOfSize:15.0f];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.text = text;
    [_overlayView addSubview:label];
    
    //横线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(label.frame) + 20.0f, _overlayView.bounds.size.width, 1.0f)];
    lineView.backgroundColor = [UIColor grayColor];
    [_overlayView addSubview:lineView];
    
    //按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0.0f, CGRectGetMaxY(lineView.frame), _overlayView.bounds.size.width, 40.0f);
    btn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [btn setTitle:@"我知道了" forState:UIControlStateNormal];
    [btn setTitleColor:kColorRGB(0, 123.0 / 255.0, 255.0 / 255.0, 1.0) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [_overlayView addSubview:btn];
    
    _overlayView.frame = CGRectMake(0, 0, self.bounds.size.width - 2 * 30.0f, CGRectGetMaxY(btn.frame) + 10.0f);
    [lineView release];
    [label release];
    
    [self show];
}

//升级的弹出框提示
-(void)showUpgradeViewWithLevel:(int)level animation:(BOOL)animation
{
    self.animation = animation;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    self.overlayView = view;
    [view release];
    
    _overlayView.frame = CGRectMake(0, 0, self.bounds.size.width - 2 * 45.0f, 160.0f);
    _overlayView.layer.cornerRadius = 4.0f;
    _overlayView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 0, _overlayView.bounds.size.width - 2 * 20.0f, 40.0f)];
    label.font = [UIFont systemFontOfSize:18.0f];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"升级啦!";
    [_overlayView addSubview:label];
    
    //横线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10.0f, CGRectGetMaxY(label.frame), _overlayView.bounds.size.width - 2 * 10.0f, 1.0f)];
    lineView.backgroundColor = kColorRGB(226.0f / 255.0f, 226.0f / 255.0f, 226.0f / 255.0f, 1.0);
    [_overlayView addSubview:lineView];
    
    UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(lineView.frame) + 10.0f, _overlayView.bounds.size.width - 2 * 20.0f, 25.0f)];
    levelLabel.font = [UIFont systemFontOfSize:16.0f];
    levelLabel.backgroundColor = [UIColor clearColor];
    levelLabel.textColor = kColorRGB(249.0f / 255.0f, 79.0f / 255.0f, 82.0f / 255.0f, 1.0);
    levelLabel.textAlignment = UITextAlignmentCenter;
    levelLabel.text = [NSString stringWithFormat:@"晋升LV%d",level];
    [_overlayView addSubview:levelLabel];

    NSString *textStr = @"真开森啊~我就是吃货圈冉冉升起的新星啊！";
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.numberOfLines = 2;
    textLabel.textColor = kColorRGB(73.0f / 255.0f, 73.0f / 255.0f, 73.0f / 255.0f, 1.0);
    textLabel.textAlignment = UITextAlignmentCenter;
    textLabel.text = textStr;
    
    CGSize constrainSize = CGSizeMake(_overlayView.bounds.size.width - 2 * 40.0f, 20000.0f);
    CGSize textSize = [textStr sizeWithFont:textLabel.font constrainedToSize:constrainSize lineBreakMode:NSLineBreakByWordWrapping];
    textLabel.frame = CGRectMake(40.0f, CGRectGetMaxY(levelLabel.frame) + 10.0f, textSize.width, textSize.height);
    [_overlayView addSubview:textLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((_overlayView.bounds.size.width - 100.0f) / 2.0f, CGRectGetMaxY(textLabel.frame) + 20.0f, 100.0f, 30.0f);
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btn setTitle:@"低调低调" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:kColorRGB(64.0f / 255.0f, 177.0f / 255.0f, 99.0f / 255.0f, 1.0)];
    [_overlayView addSubview:btn];
    
    [textLabel release];
    [levelLabel release];
    [lineView release];
    [label release];
    
    _overlayView.frame = CGRectMake(0, 0, self.bounds.size.width - 2 * 45.0f, CGRectGetMaxY(btn.frame) + 10.0f);
    [self show];
}

-(void)closeView
{
    [self hideAfterDelay:0.3f animation:_animation];
}

-(void)dealloc
{
    self.delegate = nil;
    self.overlayView = nil; [_overlayView release];
    
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
