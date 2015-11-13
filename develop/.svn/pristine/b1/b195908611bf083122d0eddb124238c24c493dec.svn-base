//
//  commentView.m
//  ql
//
//  Created by yunlai on 14-4-18.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "commentView.h"

#import "commentCell.h"

#import "UIImageView+WebCache.h"

#import "dynamic_commentList_model.h"
#import "dynamic_support_model.h"

#import "TQRichTextView.h"

#import "NSString+CXAHyperlinkParser.h"
#import "CXAHyperlinkLabel.h"

#define HEADMARGIN 5.0f

#define COMMENTTAG 9999

#define KEYBOARD_HEIGHT 216.0f
#define KEYBOARD_DURATION 0.25f
#define KEYBOARD_CURVE 0.0f

#define kBottomViewHeight 40.0f

#define KNoneCareText @"还没有人点赞哦..."
#define KNoneComText @"深度评论，虚席以待"
#define KNoneOOText @"还没有人OO哦..."
#define KNoneXXText @"还没有人XX哦..."

@interface commentView (){
//    是不是回复
    BOOL isResponse;
//    删除的列
    NSDictionary* delDic;
//    评论的文本
    NSString* sendStr;
    
    int scrflag;//用于下滑退出评论页，防止多次调用
//    列表行高度
    NSMutableArray* cellHeightArr;
//    评论选中的行
    int selectIndex;
//    oo、xx名字集
    NSString* ooNames;
    NSString* xxNames;
//    ooxx数目和，和为0不展示
    int ooxxSum;
    
}

@property(nonatomic,retain) UILabel* responsLab;
@property(nonatomic,retain) UIActivityIndicatorView* actIndicator;

@end

@implementation commentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        cellHeightArr = [[NSMutableArray alloc] init];
        _comType = CommentTypeNomal;
    }
    return self;
}
//初始化数据
-(id) initWithData:(NSDictionary *)dic publishId:(int)pId{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _dataDic= dic;
        _publishId = pId;
        isResponse = NO;
        commentCanLoad = YES;
        supportCanLoad = YES;
        [self setup];
    }
    return self;
}
//注册键盘通知
-(void) resignKeyNotify{
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
//注销键盘通知
-(void) cancelKeyNotify{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

-(void) keyboardWillShow:(NSNotification *)note
{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self convertRect:keyboardBounds toView:nil];
    
    [self containerViewUpAnimation:keyboardBounds withDuration:duration withCurve:curve];
    
    //表情按钮重置
    [self someViewAnimation:faceKeyboardView withUpOrDown:NO];
    [faceButton setSelected:NO];
	
    isKeyboardDown = NO;
}

-(void) keyboardWillHide:(NSNotification *)note
{
    //    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [self hiddenKeyboard];
}

-(void) backGrougBtnClick{
    containerView.hidden = YES;
    [self hiddenKeyboard];
}

//回复bar 往上动画
- (void)containerViewUpAnimation:(CGRect)keyboardBounds withDuration:(NSNumber *)duration withCurve:(NSNumber *)curve
{
    // get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
	
	//新增一个遮罩按钮
    if (backGrougBtn == nil)
    {
        backGrougBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backGrougBtn addTarget:self action:@selector(backGrougBtnClick) forControlEvents:UIControlEventTouchDown];
        [self addSubview:backGrougBtn];
        backGrougBtn.backgroundColor = [UIColor clearColor];
    }
    backGrougBtn.frame = CGRectMake(0, 64.0f, self.frame.size.width, self.frame.size.height - (keyboardBounds.size.height + containerFrame.size.height) - 64.0f);
	
    containerFrame.origin.y = self.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

//回复bar 往下动画
- (void)containerViewDownAnimation:(NSNumber *)duration withCurve:(NSNumber *)curve
{
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.bounds.size.height - fromTypeMargin - containerFrame.size.height;
    
    NSLog(@"==============  %f",containerFrame.origin.y);
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
    
    //移出遮罩按钮
    [backGrougBtn removeFromSuperview];
    backGrougBtn = nil;
}

//关闭键盘
-(void)hiddenKeyboard
{
    //关闭所有
    [self containerViewDownAnimation:[NSNumber numberWithFloat:KEYBOARD_DURATION] withCurve:[NSNumber numberWithFloat:KEYBOARD_CURVE]];
//    [self someViewAnimation:pPView withUpOrDown:NO];
    [self someViewAnimation:faceKeyboardView withUpOrDown:NO];
    
	[textView resignFirstResponder];
    [faceButton setSelected:YES];
    
    [self performSelector:@selector(backReplyTopic) withObject:nil afterDelay:KEYBOARD_DURATION];
}

//点击空白处键盘消失，返回回复话题
-(void)backReplyTopic
{
    if(containerView.frame.origin.y <= self.bounds.size.height - 50.0f - fromTypeMargin && containerView.frame.origin.y > self.bounds.size.height - KEYBOARD_HEIGHT)
    {
//        self.replyIndexPath = nil;
        textView.text = @"";
        isResponse = NO;
        textView.placeholder = @"";
    }
}

//编辑中
-(BOOL)doEditing
{
    BOOL canEdit= NO;
	int textCount = [textView.text length];
	if (textCount > 140)
    {
		remainCountLabel.textColor = [UIColor colorWithRed:1.0 green: 0.0 blue: 0.0 alpha:1.0];
        canEdit = NO;
	}
    else
    {
		remainCountLabel.textColor = [UIColor colorWithRed:0.5 green: 0.5 blue: 0.5 alpha:1.0];
        canEdit = YES;
        remainCountLabel.text = [NSString stringWithFormat:@"%d/140",140 - textCount];
	}
    
    return canEdit;
	
//	remainCountLabel.text = [NSString stringWithFormat:@"%d/140",140 - [textView.text length]];
}

//动画
- (void)someViewAnimation:(UIView *)someView withUpOrDown:(BOOL)upOrDown
{
    CGRect someViewFrame = someView.frame;
    someViewFrame.origin.y = upOrDown ? self.frame.size.height - KEYBOARD_HEIGHT : self.frame.size.height;
    
    [UIView animateWithDuration:KEYBOARD_DURATION animations:^{
        someView.frame = someViewFrame;
    } completion:^(BOOL finished) {
        
    }];
}

//显示表情
-(void)showFace:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
    
    //无论是键盘还是表情 先隐藏图片选择器
//    [self someViewAnimation:pPView withUpOrDown:NO];
    
    if (sender.selected)
    {
        //选择表情 隐藏键盘
        if (textView.isFirstResponder)
        {
            isChangKeyboard = YES;
            [textView resignFirstResponder];
        }
        
        CGRect rect = CGRectMake(0,0,self.frame.size.width,KEYBOARD_HEIGHT);
        [self containerViewUpAnimation:rect withDuration:[NSNumber numberWithFloat:KEYBOARD_DURATION] withCurve:[NSNumber numberWithFloat:KEYBOARD_CURVE]];
        [self someViewAnimation:faceKeyboardView withUpOrDown:YES];
    }
    else
    {
        //选择键盘 隐藏表情
        isChangKeyboard = NO;
        [textView becomeFirstResponder];
        
        //移至 keyboardWillShow 中实现
        //[self someViewAnimation:faceKeyboardView withUpOrDown:NO];
    }
    
}

#pragma mark -
#pragma mark faceViewDelegate 委托
//发表评论
-(void) sendbuttonClick{
    [self sendComment];
}

- (void)faceView:(faceView *)faceView didSelectAtString:(NSString *)faceString
{
    if (textView.text.length >= 140) {
        return;
    }
    
    NSRange range = textView.selectedRange;
    NSMutableString *textString = [NSMutableString stringWithString:textView.text];
    [textString insertString:faceString atIndex:range.location];
    range.location = range.location + faceString.length;
    textView.text = textString;
    if (range.location <= textString.length)
    {
        textView.selectedRange = range;
    }
    
    [self performSelectorOnMainThread:@selector(doEditing) withObject:nil waitUntilDone:NO];
}

- (void)delFaceString
{
    NSRange range = textView.selectedRange;
    if (range.location > 0)
    {
        NSMutableString *textString = [NSMutableString stringWithString:textView.text];
        
        //先判断是否是系统表情
        range.length = 2;
        range.location = range.location - 2;
        NSString *emojiString = [textString substringWithRange:range];
        NSRange currentRange;
        NSRange delRange = range;
        
        if (![[emoji getEmoji] containsObject:emojiString])
        {
            range.length = 1;
            range.location = textView.selectedRange.location - 1;
            delRange = range;
            
            NSString *rightBracket = [textString substringWithRange:range];
            
            //判断是否是自定义表情
            if ([rightBracket isEqualToString:@"]"])
            {
                if (textString.length >= 3)
                {
                    NSRange range1 = (NSRange){range.location - 2, 1};
                    NSString *leftBracket1 = [textString substringWithRange:range1];
                    if ([leftBracket1 isEqualToString:@"["])
                    {
                        delRange = range1;
                        delRange.length = 3;
                        //currentRange = (NSRange){delRange.location, 0};
                    }
                    else
                    {
                        if (textString.length >= 4)
                        {
                            NSRange range2 = (NSRange){range.location - 3, 1};
                            NSString *leftBracket2 = [textString substringWithRange:range2];
                            if([leftBracket2 isEqualToString:@"["])
                            {
                                delRange = range2;
                                delRange.length = 4;
                                //currentRange = (NSRange){delRange.location, 0};
                            }
                            else
                            {
                                if (textString.length >= 5)
                                {
                                    NSRange range3 = (NSRange){range.location - 4, 1};
                                    NSString *leftBracket3 = [textString substringWithRange:range3];
                                    if([leftBracket3 isEqualToString:@"["])
                                    {
                                        delRange = range3;
                                        delRange.length = 5;
                                        //currentRange = (NSRange){delRange.location, 0};
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        
        currentRange = (NSRange){delRange.location, 0};
        
        [textString deleteCharactersInRange:delRange];
        textView.text = textString;
        if (currentRange.location < textString.length)
        {
            textView.selectedRange = currentRange;
        }
    }
    [self performSelectorOnMainThread:@selector(doEditing) withObject:nil waitUntilDone:NO];
}

#pragma mark -
#pragma mark HPGrowingTextView 委托
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
    
    backGrougBtn.frame = CGRectMake(backGrougBtn.frame.origin.x, backGrougBtn.frame.origin.y, backGrougBtn.frame.size.width, backGrougBtn.frame.size.height + diff);
    
    if (height > 45.0f)
    {
        remainCountLabel.hidden = NO;
    }
    else
    {
        remainCountLabel.hidden = YES;
    }
}

- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
	return YES;
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
    
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self sendComment];
    }
    
    if ([self doEditing]) {
        return YES;
    }else{
        return NO;
    }
	return YES;
}

//初始化主视图
-(void) setup{
    
    commentArr = [[NSMutableArray alloc] init];
    careArr = [[NSMutableArray alloc] init];
    
    ooArr = [[NSMutableArray alloc] init];
    xxArr = [[NSMutableArray alloc] init];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    self.frame = CGRectMake(0, 0, size.width, size.height);
    
    self.backgroundColor = [UIColor clearColor];

    self.tag = COMMENTTAG;
    
    scImgHeight = (self.bounds.size.width - 7*HEADMARGIN)/6;
    
    if (_fromType == CommentFromTypeCom) {
        [self addbuttomView];
        fromTypeMargin = 60;
    }else{
        fromTypeMargin = 0;
    }
    
    [self addTableVIew];
    
    _darkCircleDot = [[TYDotIndicatorView alloc] initWithFrame:CGRectMake(0, 20.f, KUIScreenWidth, KUIScreenHeight) dotStyle:TYDotIndicatorViewStyleCircle dotColor:[UIColor colorWithWhite:1.0 alpha:1.0] dotSize:CGSizeMake(10, 10)];
    _darkCircleDot.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.3];
    [_darkCircleDot startAnimating];
    [self addSubview:_darkCircleDot];
    
//    请求评论数据
    [self accessCommentList];
}

//增加底部空视图，起遮罩作用
-(void) addbuttomView{
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 60, self.bounds.size.width, 60)];
    v.backgroundColor = [UIColor clearColor];
    [self addSubview:v];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCommentView)];
    [v addGestureRecognizer:tap];
    
    [tap release];
    [v release];
}

-(void) addTableVIew{
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.bounds.size.width, KUIScreenHeight - 20) style:UITableViewStylePlain];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.bounds.size.width, self.bounds.size.height - 20 - fromTypeMargin - 50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = COLOR_LIGHTWEIGHT;
    _tableView.separatorColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
    if (IOS_VERSION_7) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self addSubview:_tableView];
    
    footerView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, 50)];
    footerView.delegate = self;
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
    
    footerView.hidden = YES;
    
    [self addContainerView];
}

//启用键盘
-(void) showKeyBoard{
    [textView becomeFirstResponder];
    containerView.hidden = NO;
}

//添加底部bar 用于唤醒键盘
-(void)addContainerView
{
    [self resignKeyNotify];
    
    UIView* keyLabBGView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 50 - fromTypeMargin, self.frame.size.width, 50)];
    keyLabBGView.backgroundColor = COLOR_LIGHTWEIGHT;
    [self addSubview:keyLabBGView];
    
    UILabel* Keylab = [[UILabel alloc] init];
    Keylab.frame = CGRectMake(15, 15/2, self.frame.size.width - 15*2, 35);
    Keylab.backgroundColor = [UIColor whiteColor];
    Keylab.text = @"   说点什么吧...";
    Keylab.textColor = [UIColor grayColor];
    Keylab.font = KQLboldSystemFont(14);
    Keylab.layer.cornerRadius = 5.0;
    Keylab.userInteractionEnabled = YES;
    [keyLabBGView addSubview:Keylab];
    
    UITapGestureRecognizer* tapKey = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyBoard)];
    [Keylab addGestureRecognizer:tapKey];
    [tapKey release];
    [Keylab release];
    [keyLabBGView release];
    
    //底部工具栏
	containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 50 - fromTypeMargin, self.frame.size.width, 50)];
    containerView.backgroundColor = [UIColor whiteColor];
    
	textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(15, 10, 240, 40)];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 3;
	textView.returnKeyType = UIReturnKeyDefault; //just as an example
	textView.font = [UIFont systemFontOfSize:14.0f];
	textView.textColor = [UIColor grayColor];
	textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 0, 0);
//    textView.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_LIGHTWEIGHT"];
    textView.backgroundColor = COLOR_LIGHTWEIGHT;
	textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	textView.text = @"";
    textView.returnKeyType = UIReturnKeySend;
    textView.placeholder = @"说点什么吧...";
    
    //表情键盘
    faceKeyboardView = [[faceView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, KEYBOARD_HEIGHT)];
    faceKeyboardView.delegate = self;
    [self addSubview:faceKeyboardView];
    
	//工具栏背景
    UIImageView *toolBackground = [[UIImageView alloc] init];
    toolBackground.backgroundColor = [UIColor whiteColor];
    toolBackground.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    toolBackground.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	
	//文本框
//	UIImage *rawEntryBackground = [[UIImage imageNamed:@"MessageEntryInputField.png"]  stretchableImageWithLeftCapWidth:18 topCapHeight:22];
//    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:rawEntryBackground];
//    entryImageView.frame = CGRectMake(10, 0, 250, 45);
//    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    
	[containerView addSubview:toolBackground];
    [toolBackground release];
	[containerView addSubview:textView];
	
	//表情按钮
    UIImage *faceImage = [[ThemeManager shareInstance] getThemeImage:@"ico_common_expression.png"];
    
    UIImage *selectedFaceImage = [[ThemeManager shareInstance] getThemeImage:@"ico_common_keyboard.png"];
	faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	faceButton.frame = CGRectMake(CGRectGetMaxX(entryImageView.frame) + 15.0f , 5.0f , 35.0f, 35.0f);
    faceButton.frame = CGRectMake(CGRectGetMaxX(textView.frame) + 15 , 10.0f , 30.0f, 30.0f);
	[faceButton addTarget:self action:@selector(showFace:) forControlEvents:UIControlEventTouchUpInside];
    [faceButton setBackgroundImage:faceImage forState:UIControlStateNormal];
    [faceButton setBackgroundImage:selectedFaceImage forState:UIControlStateSelected];
    faceButton.tag = 200;
	[containerView addSubview:faceButton];

//    //发送按钮
//	UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	sendButton.frame = CGRectMake(CGRectGetMaxX(entryImageView.frame) + 5.0f , 5.0f , 55.0f, 35.0f);
//	[sendButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
//    sendButton.backgroundColor = [UIColor colorWithRed:0.1961 green:0.6941 blue:0.4235 alpha:1.0];
//    sendButton.layer.masksToBounds = YES;
//    sendButton.layer.cornerRadius = 17.5f;
//    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
//    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
//    [sendButton setTitleColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0] forState:UIControlStateNormal];
//    [sendButton setTitleColor:[UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0] forState:UIControlStateHighlighted];
//    
//	[containerView addSubview:sendButton];
	
	//字数统计
	remainCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textView.frame) + 5.0f, 45.0f, 55.0f, 10.0f)];
	[remainCountLabel setFont:[UIFont systemFontOfSize:11.0f]];
	remainCountLabel.textColor = [UIColor colorWithRed:0.5 green: 0.5 blue: 0.5 alpha:1.0];
	remainCountLabel.text = @"140/140";
	remainCountLabel.hidden = YES;
	remainCountLabel.backgroundColor = [UIColor clearColor];
	remainCountLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
	remainCountLabel.textAlignment = UITextAlignmentCenter;
	[containerView addSubview:remainCountLabel];
	
	[self addSubview:containerView];
    
    containerView.hidden = YES;
}

//发送评论 做字数检测
-(void)sendComment{
    containerView.hidden = YES;
    
    NSString* textStr = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (textStr.length == 0) {
        [self hiddenKeyboard];
        isResponse = NO;
        return;
    }else if (textStr.length > 140) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"字数不要超过140" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [self hiddenKeyboard];
        isResponse = NO;
        return;
    }
    
    NSString* str = [[NSString alloc] initWithString:textView.text];
    
    [self hiddenKeyboard];
    
    if (isResponse) {
        [self accessResponseComment:str];
    }else{
        [self accessPublishComment:str];
    }
    
}

//刷新评论列表，拼接数据
-(void) refreshCommentList{
    NSDictionary* dic = nil;
    if (!isResponse) {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               @"0",@"id",
               [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"from_id",
               [[Global sharedGlobal].userInfo objectForKey:@"realname"],@"from_name",
               [[Global sharedGlobal].userInfo objectForKey:@"portrait"],@"from_portrait",
               [NSNumber numberWithInt:[[_dataDic objectForKey:@"user_id"] intValue]],@"to_id",
               [_dataDic objectForKey:@"realname"],@"to_name",
               [_dataDic objectForKey:@"portrait"],@"to_portrait",
               [NSString stringWithString:sendStr],@"content",
               [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]],@"created",
               nil];
    }else{
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               @"0",@"id",
               [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"from_id",
               [[Global sharedGlobal].userInfo objectForKey:@"realname"],@"from_name",
               [[Global sharedGlobal].userInfo objectForKey:@"portrait"],@"from_portrait",
               [NSNumber numberWithInt:[[delDic objectForKey:@"from_id"] intValue]],@"to_id",
               [delDic objectForKey:@"from_name"],@"to_name",
               [delDic objectForKey:@"from_portrait"],@"to_portrait",
               [NSString stringWithString:sendStr],@"content",
               [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]],@"created",
               nil];
    }
    
    [commentArr insertObject:dic atIndex:0];
    CGFloat height = 30 + [TQRichTextView getRechTextViewHeightWithText:sendStr viewWidth:200 font:KQLboldSystemFont(13) lineSpacing:1.2];
    [cellHeightArr insertObject:[NSNumber numberWithFloat:height] atIndex:0];
    [_tableView beginUpdates];
    if (_comType == CommentTypeOOXX && ooxxSum != 0) {
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [_tableView endUpdates];
}

-(void) backTo{
//    if (_delegate != nil && [_delegate respondsToSelector:@selector(cancelButonClick)]) {
//        [_delegate cancelButonClick];
//        [self removeFromSuperview];
//    }
    [self removeFromSuperview];
}

//头像点击
-(void) headClick:(UITapGestureRecognizer*) tap{
    UIImageView* headV = (UIImageView*)tap.view;
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(headViewTouch:)]) {
        [_delegate headViewTouch:headV.tag];
    }
}

-(void) showCommentView{
    
    UIViewController *appRootViewController;
    UIWindow *window;
    
    window = [UIApplication sharedApplication].keyWindow;
    
    appRootViewController = window.rootViewController;
    
    UIViewController *topViewController = appRootViewController;
    while (topViewController.presentedViewController != nil)
    {
        topViewController = topViewController.presentedViewController;
    }
    
    if ([topViewController.view viewWithTag:COMMENTTAG]) {
        [[topViewController.view viewWithTag:COMMENTTAG] removeFromSuperview];
    }
    
//    self.frame = topViewController.view.bounds;
    [topViewController.view addSubview:self];

}

-(void) hideCommentView{
    [textView resignFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished){
       [self removeFromSuperview];
    }];
}

#pragma mark - tableview

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if (_comType == CommentTypeOOXX && ooxxSum != 0) {
        return 4;
    }
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        
        if (_comType == CommentTypeOOXX && ooxxSum != 0) {
            if (section == 3) {
                if (commentArr.count) {
                    return commentArr.count;
                }
                return 1;
            }else{
                return 1;
            }
        }else{
            if (commentArr.count) {
                return commentArr.count;
            }else{
                return 1;
            }
        }
    }
//    return 3;
    return commentArr.count;
}
//初始化高度并存储
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return (scImgHeight + 2*HEADMARGIN);
    }else{
        if (_comType == CommentTypeOOXX && ooxxSum != 0) {
            if (indexPath.section == 1) {
                if (ooArr.count) {
                    NSString* str = nil;
                    for (NSDictionary* dic in ooArr) {
                        if (str == nil) {
                            str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"realname"]];
                        }else{
                            str = [str stringByAppendingFormat:@"、%@",[dic objectForKey:@"realname"]];
                        }
                    }
                    ooNames = [[NSString alloc] initWithString:str];
                    CGSize size = [str sizeWithFont:KQLboldSystemFont(13) constrainedToSize:CGSizeMake(self.bounds.size.width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
                    return size.height>20?(size.height + 20):30;
                }
                return 30;
            }else if (indexPath.section == 2) {
                if (xxArr.count) {
                    NSString* str = nil;
                    for (NSDictionary* dic in xxArr) {
                        if (str == nil) {
                            str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"realname"]];
                        }else{
                            str = [str stringByAppendingFormat:@"、%@",[dic objectForKey:@"realname"]];
                        }
                    }
                    xxNames = [[NSString alloc] initWithString:str];
                    CGSize size = [str sizeWithFont:KQLboldSystemFont(13) constrainedToSize:CGSizeMake(self.bounds.size.width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    return size.height>20?(size.height + 20):30;
                }
                return 30;
            }else{
                if (commentArr.count) {
                    CGFloat height = 30 + [TQRichTextView getRechTextViewHeightWithText:[[commentArr objectAtIndex:indexPath.row] objectForKey:@"content"] viewWidth:180 font:KQLboldSystemFont(13) lineSpacing:1.2];
                    [cellHeightArr addObject:[NSNumber numberWithFloat:height]];
                    return [cellHeightArr[indexPath.row] floatValue]>60?[cellHeightArr[indexPath.row] floatValue]:60;
                }else{
                    return 80;
                }
            }
            
        }else{
            if (commentArr.count) {
                CGFloat height = 30 + [TQRichTextView getRechTextViewHeightWithText:[[commentArr objectAtIndex:indexPath.row] objectForKey:@"content"] viewWidth:180 font:KQLboldSystemFont(13) lineSpacing:1.2];
                [cellHeightArr addObject:[NSNumber numberWithFloat:height]];
                return [cellHeightArr[indexPath.row] floatValue]>60?[cellHeightArr[indexPath.row] floatValue]:60;
            }else{
                return 200;
            }
        }
    }
    return 60;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* v = [[[UIView alloc] init] autorelease];
    v.backgroundColor = [UIColor whiteColor];
    v.frame = CGRectMake(0, 0, tableView.bounds.size.width, 15);
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 100, 15)];
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor darkGrayColor];
    lab.font = KQLboldSystemFont(13);
    lab.textAlignment = UITextAlignmentLeft;
    if (_comType == CommentTypeOOXX && ooxxSum != 0) {
        if (section == 0) {
            lab.text = @"   点赞";
        }else if (section == 1) {
            lab.text = @"    OO";
        }else if (section == 2) {
            lab.text = @"    XX";
        }else if (section == 3) {
            lab.text = @"   评论";
        }
      }else{
        if (section == 0) {
            lab.text = @"   点赞";
        }else{
            lab.text = @"   评论";
        }
    }
    [v addSubview:lab];
    [lab release];
    
    if (_comType == CommentTypeOOXX && ooxxSum != 0) {
        if (section == 1 || section == 2) {
            UILabel* sumLab = [[UILabel alloc] initWithFrame:CGRectMake(tableView.bounds.size.width - 100, 5, 80, 15)];
            sumLab.backgroundColor = [UIColor clearColor];
            sumLab.textColor = [UIColor darkGrayColor];
            sumLab.font = KQLboldSystemFont(13);
            sumLab.textAlignment = UITextAlignmentRight;
            if (section == 1) {
                if (ooArr.count) {
                    sumLab.text = [NSString stringWithFormat:@"%d人",ooArr.count];
                }
                
            }else if (section == 2) {
                if (xxArr.count) {
                    sumLab.text = [NSString stringWithFormat:@"%d人",xxArr.count];
                }
                
            }
            [v addSubview:sumLab];
            [sumLab release];
        }
    }
    
    return v;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = nil;
    if (_comType == CommentTypeOOXX && ooxxSum != 0) {
        if (indexPath.section == 0) {
            if (careArr.count) {
                identifier = @"suppCell";
            }else{
                identifier = @"noneSuppCell";
            }
        }else if (indexPath.section == 1) {
            if (ooArr.count) {
                identifier = @"ooCell";
            }else{
                identifier = @"noneOOCell";
            }
        }else if (indexPath.section == 2) {
            if (xxArr.count) {
                identifier = @"xxCell";
            }else{
                identifier = @"noneXXCell";
            }
        }else if (indexPath.section == 3) {
            if (commentArr.count) {
                identifier = @"commentCell";
            
            }else{
                identifier = @"noneCommentCell";
            }
        }
    }else{
        if (indexPath.section == 0) {
            if (careArr.count) {
                identifier = @"suppCell";
            }else{
                identifier = @"noneSuppCell";
            }
            
        }else{
            if (commentArr.count) {
                identifier = @"commentCell";
            }else{
                identifier = @"noneCommentCell";
            }
            
        }
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        if (_comType == CommentTypeOOXX && ooxxSum != 0) {
            if (indexPath.section == 0) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                
                if (careArr.count) {
                    UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, scImgHeight + 2*HEADMARGIN)];
                    scroll.showsHorizontalScrollIndicator = NO;
                    scroll.pagingEnabled = NO;
                    scroll.tag = 1000;
                    scroll.delegate = self;
                    scroll.backgroundColor = [UIColor clearColor];
                    [cell.contentView addSubview:scroll];
                    
                    RELEASE_SAFE(scroll);
                }else{
                    
                    UIImageView* careNoneImgV = [[UIImageView alloc] init];
//                    careNoneImgV.image = IMG(@"bg_group_dotted_square");
                    careNoneImgV.image = [[ThemeManager shareInstance] getThemeImage:@"bg_group_dotted_box.png"];
                    careNoneImgV.frame = CGRectMake(HEADMARGIN, HEADMARGIN, scImgHeight, scImgHeight);
                    [cell.contentView addSubview:careNoneImgV];
                    
                    [careNoneImgV release];
                    
                }
            }else if (indexPath.section == 1) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                if (ooArr.count) {
                    CXAHyperlinkLabel* ooLab = [[CXAHyperlinkLabel alloc] init];
                    ooLab.frame = CGRectMake(10, 5, tableView.bounds.size.width - 10*2, cell.frame.size.height);
                    ooLab.textAlignment = UITextAlignmentLeft;
                    ooLab.tag = 10010;
                    ooLab.textColor = [UIColor clearColor];
                    ooLab.backgroundColor = [UIColor clearColor];
                    ooLab.font = KQLboldSystemFont(14);
                    ooLab.numberOfLines = 0;
                    ooLab.lineBreakMode = UILineBreakModeWordWrap;
                    
                    NSArray *URLs;
                    NSArray *URLRanges;
                    NSAttributedString* as = [self attributedString:&URLs URLRanges:&URLRanges text:ooNames DataArr:ooArr];
                    ooLab.attributedText = as;
                    [ooLab setURLs:URLs forRanges:URLRanges];
                    ooLab.URLClickHandler = ^(CXAHyperlinkLabel *label, NSURL *URL, NSRange range, NSArray *textRects){
                        int user_id = [[URL.absoluteString stringByReplacingOccurrencesOfString:@"/" withString:@""] intValue];
                        [_delegate headViewTouch:user_id];
                        
                    };
                    
                    [cell.contentView addSubview:ooLab];
                    [ooLab release];
                    
                }else{
                    UILabel* careNoneLab = [[UILabel alloc] init];
                    careNoneLab.frame = CGRectMake(0, 0, tableView.bounds.size.width, 30);
                    careNoneLab.textAlignment = UITextAlignmentCenter;
                    careNoneLab.text = KNoneOOText;
                    careNoneLab.textColor = [UIColor darkGrayColor];
                    careNoneLab.font = KQLboldSystemFont(14);
                    [cell.contentView addSubview:careNoneLab];
                    
                    RELEASE_SAFE(careNoneLab);
                }
            }else if (indexPath.section == 2) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                if (xxArr.count) {
                    CXAHyperlinkLabel* xxLab = [[CXAHyperlinkLabel alloc] init];
                    xxLab.frame = CGRectMake(10, 5, tableView.bounds.size.width - 10*2, cell.frame.size.height);
                    xxLab.textAlignment = UITextAlignmentLeft;
                    xxLab.tag = 10086;
                    xxLab.textColor = [UIColor clearColor];
                    xxLab.backgroundColor = [UIColor clearColor];
                    xxLab.font = KQLboldSystemFont(14);
                    xxLab.numberOfLines = 0;
                    xxLab.lineBreakMode = UILineBreakModeWordWrap;
                    
                    NSArray *URLs;
                    NSArray *URLRanges;
                    NSAttributedString* as = [self attributedString:&URLs URLRanges:&URLRanges text:xxNames DataArr:xxArr];
                    xxLab.attributedText = as;
                    [xxLab setURLs:URLs forRanges:URLRanges];
                    xxLab.URLClickHandler = ^(CXAHyperlinkLabel *label, NSURL *URL, NSRange range, NSArray *textRects){
                        int user_id = [[URL.absoluteString stringByReplacingOccurrencesOfString:@"/" withString:@""] intValue];
                        
                        [_delegate headViewTouch:user_id];
                        
                    };
                    
                    [cell.contentView addSubview:xxLab];
                    [xxLab release];
                    
                }else{
                    UILabel* careNoneLab = [[UILabel alloc] init];
                    careNoneLab.frame = CGRectMake(0, 0, tableView.bounds.size.width, 30);
                    careNoneLab.textAlignment = UITextAlignmentCenter;
                    careNoneLab.text = KNoneXXText;
                    careNoneLab.textColor = [UIColor darkGrayColor];
                    careNoneLab.font = KQLboldSystemFont(14);
                    [cell.contentView addSubview:careNoneLab];
                    
                    RELEASE_SAFE(careNoneLab);
                }
            }else{
                
                if (commentArr.count) {
                    cell = [[[commentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                }else{
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    
                    UILabel* comNoneCell = [[UILabel alloc] init];
                    comNoneCell.frame = CGRectMake(0, 0, tableView.bounds.size.width, 80);
                    comNoneCell.textColor = [UIColor darkGrayColor];
                    comNoneCell.textAlignment = UITextAlignmentCenter;
                    comNoneCell.text = KNoneComText;
                    [cell.contentView addSubview:comNoneCell];
                    
                    RELEASE_SAFE(comNoneCell);
                }
            }
        }else{
            if (indexPath.section == 0) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                
                if (careArr.count) {
                    UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, scImgHeight + 2*HEADMARGIN)];
                    scroll.showsHorizontalScrollIndicator = NO;
                    scroll.pagingEnabled = NO;
                    scroll.tag = 1000;
                    scroll.delegate = self;
                    scroll.backgroundColor = [UIColor clearColor];
                    [cell.contentView addSubview:scroll];
                    
                    RELEASE_SAFE(scroll);
                }else{
                    
                    UIImageView* careNoneImgV = [[UIImageView alloc] init];
//                    careNoneImgV.image = IMG(@"bg_group_dotted_square");
                    careNoneImgV.image = [[ThemeManager shareInstance] getThemeImage:@"bg_group_dotted_box.png"];
                    careNoneImgV.frame = CGRectMake(HEADMARGIN, HEADMARGIN, scImgHeight, scImgHeight);
                    [cell.contentView addSubview:careNoneImgV];
                    
                    [careNoneImgV release];
                    
                }
                
            }else{
                
                if (commentArr.count) {
                    cell = [[[commentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    
                }else{
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    
                    UILabel* comNoneCell = [[UILabel alloc] init];
                    comNoneCell.frame = CGRectMake(0, 0, tableView.bounds.size.width, 200);
                    comNoneCell.textColor = [UIColor darkGrayColor];
                    comNoneCell.textAlignment = UITextAlignmentCenter;
                    comNoneCell.text = KNoneComText;
                    [cell.contentView addSubview:comNoneCell];
                    
                    RELEASE_SAFE(comNoneCell);
                }
            }
        }
    }
    
    for (UIView* v in cell.contentView.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            [v removeFromSuperview];
        }
    }
    
    NSDictionary* dic = nil;
    
    if (_comType == CommentTypeOOXX && ooxxSum != 0) {
        if (indexPath.section == 0) {
            if (careArr.count) {
                UIScrollView* sv = (UIScrollView*)[cell.contentView viewWithTag:1000];
                for (UIView* v in sv.subviews) {
                    [v removeFromSuperview];
                }
                
                CGFloat offx = HEADMARGIN;
                
                for (int i = 0; i < careArr.count; i++) {
                    
                    dic = [careArr objectAtIndex:i];
                    
                    UIImageView* imgV = [[UIImageView alloc] init];
                    imgV.frame = CGRectMake(offx, HEADMARGIN, scImgHeight, scImgHeight);
                    imgV.layer.cornerRadius = scImgHeight/2;
                    imgV.clipsToBounds = YES;
                    
                    UIImage* placeHolderImg = nil;
                    if ([[dic objectForKey:@"sex"] intValue] == 1) {
                        placeHolderImg = IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME);
                    }else{
                        placeHolderImg = IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME);
                    }
                    
                    [imgV setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"portrait"]] placeholderImage:placeHolderImg];
                    imgV.tag = [[dic objectForKey:@"user_id"] intValue];;
                    imgV.userInteractionEnabled = YES;
                    [sv addSubview:imgV];
                    
                    offx += HEADMARGIN + imgV.bounds.size.width;
                    
                    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick:)];
                    [imgV addGestureRecognizer:tap];
                    RELEASE_SAFE(tap);
                    
                    RELEASE_SAFE(imgV);
                }
                
                UIView* v = [[UIView alloc] initWithFrame:CGRectMake(offx, HEADMARGIN, scImgHeight, scImgHeight)];
                v.backgroundColor = [UIColor clearColor];
                [sv addSubview:v];
                
                _actIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                _actIndicator.frame = CGRectMake((scImgHeight - 30)/2, (scImgHeight - 30)/2, 30, 30);
                [v addSubview:_actIndicator];
                
                RELEASE_SAFE(v);
                
                [sv setContentSize:CGSizeMake(offx>self.bounds.size.width?offx:self.bounds.size.width, sv.bounds.size.height)];
            }else{
                
            }
        }else if (indexPath.section == 1) {
            if (ooArr.count) {
//                cell.textLabel.text = ooNames;
            }
            
        }else if (indexPath.section == 2) {
            if (xxArr.count) {
//                cell.textLabel.text = xxNames;
            }
            
        }else{
            if (commentArr.count) {
                dic = [commentArr objectAtIndex:indexPath.row];
                
                UIImage* placeHolderImg = nil;
                if ([[dic objectForKey:@"sex"] intValue] == 1) {
                    placeHolderImg = IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME);
                }else{
                    placeHolderImg = IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME);
                }
                
                [((commentCell*)cell).headImgV setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"from_portrait"]] placeholderImage:placeHolderImg];
                
                ((commentCell*)cell).headImgV.tag = [[dic objectForKey:@"from_id"] intValue];
                ((commentCell*)cell).headImgV.userInteractionEnabled = YES;
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick:)];
                [((commentCell*)cell).headImgV addGestureRecognizer:tap];
                RELEASE_SAFE(tap);
                
                ((commentCell*)cell).userNameLab.text = [dic objectForKey:@"from_name"];
                ((commentCell*)cell).userNameLab.tag = [[dic objectForKey:@"from_id"] intValue];
                ((commentCell*)cell).userNameLab.userInteractionEnabled = YES;
                //给名字加上点击事件
                UITapGestureRecognizer* nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick:)];
                [((commentCell*)cell).userNameLab addGestureRecognizer:nameTap];
                [nameTap release];
                
                CGRect conentframe = ((commentCell*)cell).contentLab.frame;
                
                ((commentCell*)cell).contentLab.frame = CGRectMake(conentframe.origin.x, conentframe.origin.y, 200, [cellHeightArr[indexPath.row] floatValue]);
                
                if ([[dic objectForKey:@"parent_comment_id"] intValue] != 0) {
                    ((commentCell*)cell).contentLab.text = [NSString stringWithFormat:@"回复 %@ :%@",[dic objectForKey:@"to_name"],[dic objectForKey:@"content"]];
                    
                    //在名字上加上button盖住名字
                    [((commentCell*)cell).contentView addSubview:[self addNameBtnOnTextWith:[dic objectForKey:@"to_name"] frame:conentframe tag:[[dic objectForKey:@"to_id"] intValue]]];
                }else{
                    ((commentCell*)cell).contentLab.text = [dic objectForKey:@"content"];
                }
                
                ((commentCell*)cell).timeLab.text = [Common makeFriendTime:[[dic objectForKey:@"created"] intValue]];
                
                if ([[dic objectForKey:@"from_id"] intValue] == [[Global sharedGlobal].user_id intValue]) {
                    ((commentCell*)cell).delLab.hidden = NO;
                    
                    ((commentCell*)cell).delLab.userInteractionEnabled = YES;
                    UITapGestureRecognizer* deltap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delTapOnComment:)];
                    [((commentCell*)cell).delLab addGestureRecognizer:deltap];
                    [deltap release];
                    
                }else{
                    ((commentCell*)cell).delLab.hidden = YES;
                }
            }
        }
    }else{
        if (indexPath.section == 0) {
            
            if (careArr.count) {
                UIScrollView* sv = (UIScrollView*)[cell.contentView viewWithTag:1000];
                for (UIView* v in sv.subviews) {
                    [v removeFromSuperview];
                }
                
                CGFloat offx = HEADMARGIN;
                
                for (int i = 0; i < careArr.count; i++) {
                    
                    dic = [careArr objectAtIndex:i];
                    
                    UIImage* placeHolderImg = nil;
                    if ([[dic objectForKey:@"sex"] intValue] == 1) {
                        placeHolderImg = IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME);
                    }else{
                        placeHolderImg = IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME);
                    }
                    
                    UIImageView* imgV = [[UIImageView alloc] init];
                    imgV.frame = CGRectMake(offx, HEADMARGIN, scImgHeight, scImgHeight);
                    imgV.layer.cornerRadius = scImgHeight/2;
                    imgV.clipsToBounds = YES;
                    
                    [imgV setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"portrait"]] placeholderImage:placeHolderImg];
                    imgV.tag = [[dic objectForKey:@"user_id"] intValue];;
                    imgV.userInteractionEnabled = YES;
                    [sv addSubview:imgV];
                    
                    offx += HEADMARGIN + imgV.bounds.size.width;
                    
                    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick:)];
                    [imgV addGestureRecognizer:tap];
                    RELEASE_SAFE(tap);
                    
                    RELEASE_SAFE(imgV);
                }
                
                UIView* v = [[UIView alloc] initWithFrame:CGRectMake(offx, HEADMARGIN, scImgHeight, scImgHeight)];
                v.backgroundColor = [UIColor clearColor];
                [sv addSubview:v];
                
                _actIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                _actIndicator.frame = CGRectMake((scImgHeight - 30)/2, (scImgHeight - 30)/2, 30, 30);
                [v addSubview:_actIndicator];
                
                RELEASE_SAFE(v);
                
                [sv setContentSize:CGSizeMake(offx>self.bounds.size.width?offx:self.bounds.size.width, sv.bounds.size.height)];
            }else{
                
            }
            
        }else{
            if (commentArr.count) {
                dic = [commentArr objectAtIndex:indexPath.row];
                
                UIImage* placeHolderImg = nil;
                if ([[dic objectForKey:@"sex"] intValue] == 1) {
                    placeHolderImg = IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME);
                }else{
                    placeHolderImg = IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME);
                }
                [((commentCell*)cell).headImgV setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"from_portrait"]] placeholderImage:placeHolderImg];
                
                ((commentCell*)cell).headImgV.tag = [[dic objectForKey:@"from_id"] intValue];
                ((commentCell*)cell).headImgV.userInteractionEnabled = YES;
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick:)];
                [((commentCell*)cell).headImgV addGestureRecognizer:tap];
                RELEASE_SAFE(tap);
                
                ((commentCell*)cell).userNameLab.text = [dic objectForKey:@"from_name"];
                ((commentCell*)cell).userNameLab.tag = [[dic objectForKey:@"from_id"] intValue];
                ((commentCell*)cell).userNameLab.userInteractionEnabled = YES;
                //给名字加上点击事件
                UITapGestureRecognizer* nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick:)];
                [((commentCell*)cell).userNameLab addGestureRecognizer:nameTap];
                [nameTap release];
                
                CGRect conentframe = ((commentCell*)cell).contentLab.frame;
                
                ((commentCell*)cell).contentLab.frame = CGRectMake(conentframe.origin.x, conentframe.origin.y, 200, [cellHeightArr[indexPath.row] floatValue]);
                
                if ([[dic objectForKey:@"parent_comment_id"] intValue] != 0) {
                    ((commentCell*)cell).contentLab.text = [NSString stringWithFormat:@"回复 %@ :%@",[dic objectForKey:@"to_name"],[dic objectForKey:@"content"]];
                    
                    //在名字上加上button盖住名字
                    [((commentCell*)cell).contentView addSubview:[self addNameBtnOnTextWith:[dic objectForKey:@"to_name"] frame:conentframe tag:[[dic objectForKey:@"to_id"] intValue]]];
                }else{
                    ((commentCell*)cell).contentLab.text = [dic objectForKey:@"content"];
                }
                
                ((commentCell*)cell).timeLab.text = [Common makeFriendTime:[[dic objectForKey:@"created"] intValue]];
                
                if ([[dic objectForKey:@"from_id"] intValue] == [[Global sharedGlobal].user_id intValue]) {
                    ((commentCell*)cell).delLab.hidden = NO;
                    
                    ((commentCell*)cell).delLab.userInteractionEnabled = YES;
                    ((commentCell*)cell).delLab.tag = indexPath.row;
                    UITapGestureRecognizer* deltap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delTapOnComment:)];
                    [((commentCell*)cell).delLab addGestureRecognizer:deltap];
                    [deltap release];
                    
                }else{
                    ((commentCell*)cell).delLab.hidden = YES;
                }
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

#pragma mark - privates
//可点击富文本初始化
- (NSAttributedString *)attributedString:(NSArray *__autoreleasing *)outURLs
                               URLRanges:(NSArray *__autoreleasing *)outURLRanges
                                    text:(NSString*) text
                                     DataArr:(NSArray*) arr
{
    NSArray* namesArr = [text componentsSeparatedByString:@"、"];
    NSString *HTMLText = nil;
    
    for (int i = 0; i < namesArr.count; i++) {
        if (HTMLText == nil) {
            HTMLText = [NSString stringWithFormat:@"<a href='%d'>%@</a>",[[[arr objectAtIndex:i] objectForKey:@"user_id"] intValue],[namesArr objectAtIndex:i]];
        }else{
            HTMLText = [NSString stringWithFormat:@"%@、%@",HTMLText,[NSString stringWithFormat:@"<a href='%d'>%@</a>",[[[arr objectAtIndex:i] objectForKey:@"user_id"] intValue],[namesArr objectAtIndex:i]]];
        }
        
    }
    
    NSArray *URLs;
    NSArray *URLRanges;
    UIColor* color = [UIColor colorWithRed:0.13 green:0.58 blue:0.90 alpha:1.0];
    UIFont* font = KQLboldSystemFont(14);
    NSMutableParagraphStyle *mps = [[NSMutableParagraphStyle alloc] init];
    mps.lineSpacing = ceilf(font.pointSize * .5);
    NSString *str = [NSString stringWithHTMLText:HTMLText baseURL:[NSURL URLWithString:@""] URLs:&URLs URLRanges:&URLRanges];
    
    NSLog(@"---str:%@---",str);
    
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString:str attributes:@
                                      {
                                          NSForegroundColorAttributeName : color,
                                          NSFontAttributeName            : font,
                                          NSParagraphStyleAttributeName  : mps,
                                      }];
    [URLRanges enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [mas addAttributes:@
         {
             NSForegroundColorAttributeName : [UIColor colorWithRed:0.13 green:0.58 blue:0.90 alpha:1.0],
         } range:[obj rangeValue]];
    }];
    
    *outURLs = URLs;
    *outURLRanges = URLRanges;
    
    return [mas copy];
}

//创建名字按钮盖在名字的位置，使其能点击跳转
-(UIButton*) addNameBtnOnTextWith:(NSString*) name frame:(CGRect) frame tag:(int) tag{
    UIButton* nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nameBtn setTitle:name forState:UIControlStateNormal];
    [nameBtn setTitleColor:[UIColor colorWithRed:0.25 green:0.66 blue:0.90 alpha:1.0] forState:UIControlStateNormal];
    [nameBtn addTarget:self action:@selector(nameBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    nameBtn.titleLabel.font = KQLboldSystemFont(13);
    
    CGSize size = [name sizeWithFont:KQLboldSystemFont(13) constrainedToSize:CGSizeMake(200, 60) lineBreakMode:UILineBreakModeWordWrap];
    nameBtn.frame = CGRectMake(25 + frame.origin.x, frame.origin.y, size.width + 10, 16);
    nameBtn.backgroundColor = COLOR_LIGHTWEIGHT;
    
    nameBtn.tag = tag;
    
    return nameBtn;
}

#pragma mark - 点击名字处理
-(void) nameBtnClick:(UIButton*) btn{
    if (_delegate && [_delegate respondsToSelector:@selector(headViewTouch:)]) {
        [_delegate headViewTouch:btn.tag];
    }
}

//删除评论
-(void) delTapOnComment:(UIGestureRecognizer*) ges{
    UIImageView* imagev = (UIImageView*)ges.view;
    delDic = [commentArr objectAtIndex:imagev.tag];
    
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除这条评论？" otherButtonTitles:nil, nil];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - tableDidSelect
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_comType == CommentTypeOOXX && ooxxSum != 0) {
        if (indexPath.section == 3 && commentArr.count) {
            selectIndex = indexPath.row;
            
            delDic = [commentArr objectAtIndex:indexPath.row];
            NSLog(@"==%@==",delDic);
            if ([[delDic objectForKey:@"from_id"] intValue] == [[Global sharedGlobal].user_id intValue]) {
                
            }else{
                isResponse = YES;
                commentCell* cell = (commentCell*)[tableView cellForRowAtIndexPath:indexPath];
                textView.placeholder = [NSString stringWithFormat:@"回复%@",cell.userNameLab.text];
                [self showKeyBoard];
            }
        }
    }else{
        if (indexPath.section > 0 && commentArr.count) {
            selectIndex = indexPath.row;
            
            delDic = [commentArr objectAtIndex:indexPath.row];
            NSLog(@"==%@==",delDic);
            if ([[delDic objectForKey:@"from_id"] intValue] == [[Global sharedGlobal].user_id intValue]) {
                
            }else{
                isResponse = YES;
                commentCell* cell = (commentCell*)[tableView cellForRowAtIndexPath:indexPath];
                textView.placeholder = [NSString stringWithFormat:@"回复%@",cell.userNameLab.text];
                [self showKeyBoard];
            }
        }
    }
}

#pragma mark - actionsheet
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
//        [_delegate deleteComment:[[delDic objectForKey:@"id"] intValue]];
        [self accessDeleteComment:[[delDic objectForKey:@"id"] intValue]];
        
    }
}

#pragma mark - loadMore

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag != 1000) {
        [footerView egoRefreshScrollViewDidScroll:scrollView];
        
        if (scrollView.contentOffset.y < -80) {
            scrflag += 1;
            if (scrflag > 1) {
                scrflag = 0;
                return;
            }
            [self hideCommentView];
        }
    }else{
        if (scrollView.contentOffset.x > scrollView.contentSize.width + 30) {
            scrflag += 1;
            NSLog(@"------");
            if (scrflag > 1) {
                scrflag = 0;
                return;
            }
            [self loadMoreSupportData];
        }
    }
    
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [footerView egoRefreshScrollViewDidEndDragging:scrollView];
}

-(void) loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view{
    [self loadMoreCommentData];
}

-(void) loadMoreCommentData{
    if (commentCanLoad) {
        [self accessCommentMore:[[[commentArr lastObject] objectForKey:@"id"] intValue]];
        
    }
}

-(void) refreshCommentMore{
    if (_comType == CommentTypeOOXX && ooxxSum != 0) {
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void) loadMoreSupportData{
    if (careArr.count != 0) {
        [_actIndicator startAnimating];
        [self accessSupportMore:[[[careArr lastObject] objectForKey:@"id"] intValue]];
    }
}

//刷新点赞视图
-(void) refreshSupportList{
    UITableViewCell* cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIScrollView* sv = (UIScrollView*)[cell.contentView viewWithTag:1000];
    for (UIView* v in sv.subviews) {
        [v removeFromSuperview];
    }
    
    CGFloat offx = HEADMARGIN;
    NSDictionary* dic = nil;
    
    for (int i = 0; i < careArr.count; i++) {
        
        dic = [careArr objectAtIndex:i];
        
        UIImageView* imgV = [[UIImageView alloc] init];
        imgV.frame = CGRectMake(offx, HEADMARGIN, scImgHeight, scImgHeight);
        imgV.layer.cornerRadius = scImgHeight/2;
        imgV.clipsToBounds = YES;
        
        UIImage* placeHolderImg = nil;
        if ([[dic objectForKey:@"sex"] intValue] == 1) {
            placeHolderImg = IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME);
        }else{
            placeHolderImg = IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME);
        }
        
        [imgV setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"portrait"]] placeholderImage:placeHolderImg];
        imgV.tag = [[dic objectForKey:@"user_id"] intValue];
        imgV.userInteractionEnabled = YES;
        [sv addSubview:imgV];
        
        offx += HEADMARGIN + imgV.bounds.size.width;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick:)];
        [imgV addGestureRecognizer:tap];
        RELEASE_SAFE(tap);
        
        RELEASE_SAFE(imgV);
    }
    
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(offx, HEADMARGIN, scImgHeight, scImgHeight)];
    v.backgroundColor = [UIColor clearColor];
    [sv addSubview:v];
    
    _actIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _actIndicator.frame = CGRectMake((scImgHeight - 30)/2, (scImgHeight - 30)/2, 30, 30);
    [v addSubview:_actIndicator];
    
    RELEASE_SAFE(v);
    
    [sv setContentSize:CGSizeMake(offx>self.bounds.size.width?offx:self.bounds.size.width, sv.bounds.size.height)];
    
    [_actIndicator stopAnimating];
}

//请求评论列表
-(void) accessCommentList{
    NSString* reqUrl = @"write/commentlist.do?param=";
    
    NSMutableDictionary* requestDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [NSNumber numberWithInt:_publishId],@"publish_id",
                                       [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                       nil];
    [[NetManager sharedManager] accessService:requestDic data:nil command:DYNAMIC_COMMENTLIST_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
    [requestDic release];
}

//发布评论
-(void) accessPublishComment:(NSString*) str{
    
    sendStr = str;
    
    NSString* reqUrl = @"publish/comment.do?param=";
    
    NSMutableDictionary* requestDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"from_id",
                                       str,@"content",
                                       [NSNumber numberWithInt:[[_dataDic objectForKey:@"user_id"] intValue]],@"to_id",
                                       [NSNumber numberWithInt:0],@"comment_id",
                                       [NSNumber numberWithInt:[[_dataDic objectForKey:@"type"] intValue]],@"type",
                                       [NSNumber numberWithInt:_publishId],@"publish_id",
                                       [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                       nil];
    [[NetManager sharedManager] accessService:requestDic data:nil command:DYNAMIC_PUBLISH_COMMENT_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
    [requestDic release];
}

//发表回应
-(void) accessResponseComment:(NSString*) str{
    
//    sendStr = str;
    sendStr = [[NSString alloc] initWithString:str];
    
    NSString* reqUrl = @"publish/comment.do?param=";
    NSMutableDictionary* requestDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"from_id",
                                       str,@"content",
                                       [NSNumber numberWithInt:[[delDic objectForKey:@"from_id"] intValue]],@"to_id",
                                       [delDic objectForKey:@"id"],@"comment_id",
                                       [NSNumber numberWithInt:[[_dataDic objectForKey:@"type"] intValue]],@"type",
                                       [NSNumber numberWithInt:_publishId],@"publish_id",
                                       [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                       nil];
    [[NetManager sharedManager] accessService:requestDic data:nil command:DYNAMIC_PUBLISH_COMMENT_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
    [requestDic release];
}

//删除评论
-(void) accessDeleteComment:(int) comId{
    NSString* reqUrl = @"publish/delcomment.do?param=";
    NSMutableDictionary* requestDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [NSNumber numberWithInt:[[Global sharedGlobal].user_id intValue]],@"user_id",
                                       [NSNumber numberWithInt:comId],@"comment_id",
                                       [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                       nil];
    [[NetManager sharedManager] accessService:requestDic data:nil command:DYNAMIC_DELETECOMMENT_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
    [requestDic release];
}

//加载更多评论
-(void) accessCommentMore:(int) comId{
    NSLog(@"==more comment==");
    NSString* reqUrl = @"write/commentlist.do?param=";
    NSMutableDictionary* requestDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [NSNumber numberWithInt:_publishId],@"publish_id",
//                                       [NSNumber numberWithInt:comId],@"comment_id",
                                       [NSNumber numberWithInt:commentPage + 1],@"page",
                                       [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                       nil];
    [[NetManager sharedManager] accessService:requestDic data:nil command:DYNAMIC_COMMENTLIST_MORE_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
    [requestDic release];
}

//点赞加载更多
-(void) accessSupportMore:(int) supId{
    NSLog(@"==more support==");
    NSString* reqUrl = @"write/commentlist.do?param=";
    NSMutableDictionary* requestDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [NSNumber numberWithInt:_publishId],@"publish_id",
                                       [NSNumber numberWithInt:supId],@"care_id",
                                       [NSNumber numberWithInt:[[Global sharedGlobal].org_id intValue]],@"org_id",
                                       nil];
    [[NetManager sharedManager] accessService:requestDic data:nil command:DYNAMIC_SUPPORTLIST_MORE_COMMAND_ID accessAdress:reqUrl delegate:self withParam:nil];
    [requestDic release];
}

//请求回调
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
    
    [_darkCircleDot removeFromSuperview];
    
    NSLog(@"--result:%@--",resultArray);
    if (resultArray && ![[resultArray lastObject] isKindOfClass:[NSString class]]) {
        switch (commandid) {
            case DYNAMIC_COMMENTLIST_COMMAND_ID:
            {
                if (resultArray.count) {
                    //重新计算高度
                    [cellHeightArr removeAllObjects];
                    [commentArr removeAllObjects];
                    [careArr removeAllObjects];
                    [commentArr addObjectsFromArray:[resultArray objectAtIndex:0]];
                    if (commentArr.count < 7) {
                        footerView.hidden = YES;
                        commentCanLoad = NO;
                    }else{
                        footerView.hidden = NO;
                        commentCanLoad = YES;
                    }
                    [careArr addObjectsFromArray:[resultArray objectAtIndex:1]];
                    if (careArr.count >= 6) {
                        supportCanLoad = YES;
                    }else{
                        supportCanLoad = NO;
                    }
                    
                    if (_comType == CommentTypeOOXX) {
                        [ooArr removeAllObjects];
                        [xxArr removeAllObjects];
                        [ooArr addObjectsFromArray:[resultArray objectAtIndex:2]];
                        [xxArr addObjectsFromArray:[resultArray objectAtIndex:3]];
                        
                        ooxxSum = ooArr.count + xxArr.count;
                    }
                    
                    commentPage = [[resultArray objectAtIndex:4] intValue];
                    
                    [self performSelectorOnMainThread:@selector(freshCommentData) withObject:nil waitUntilDone:NO];
                }
            }
                break;
            case DYNAMIC_PUBLISH_COMMENT_COMMAND_ID:
            {
                if ([[[resultArray lastObject] objectForKey:@"ret"] intValue] == 1) {
                    [self performSelectorOnMainThread:@selector(publishSuccess) withObject:nil waitUntilDone:NO];
//                    [self accessCommentList];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateResponseNum" object:[NSNumber numberWithInt:1]];
                }
            }
                break;
            case DYNAMIC_DELETECOMMENT_COMMAND_ID:
            {
                if ([[[resultArray lastObject] objectForKey:@"ret"] intValue] == 1) {
                    [self performSelectorOnMainThread:@selector(delCommentSuccess) withObject:nil waitUntilDone:NO];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateResponseNum" object:[NSNumber numberWithInt:-1]];
                }
            }
                break;
            case DYNAMIC_COMMENTLIST_MORE_COMMAND_ID:
            {
                [footerView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
                NSArray* arr = [resultArray objectAtIndex:1];
                if (arr.count) {
                    [cellHeightArr removeAllObjects];
                    [commentArr addObjectsFromArray:[resultArray objectAtIndex:0]];
                    if (commentArr.count < 7) {
                        footerView.hidden = YES;
                        commentCanLoad = NO;
                    }else{
                        footerView.hidden = NO;
                        commentCanLoad = YES;
                    }
                    
                    commentPage = [[resultArray objectAtIndex:4] intValue];
                    
                    [self performSelectorOnMainThread:@selector(refreshCommentMore) withObject:nil waitUntilDone:NO];
                }else{
                    [Common checkProgressHUD:@"没有更多了" andImage:nil showInView:self];
                }
            }
                break;
            case DYNAMIC_SUPPORTLIST_MORE_COMMAND_ID:
            {
                NSArray* arr = [resultArray objectAtIndex:0];
                if (arr.count) {
                    [careArr addObjectsFromArray:[resultArray objectAtIndex:1]];
                    [self performSelectorOnMainThread:@selector(refreshSupportList) withObject:nil waitUntilDone:NO];
                }else{
                    [Common checkProgressHUD:@"没有更多了" andImage:nil showInView:self];
                }
            }
                break;
            default:
                break;
        }
    }
}

//刷新评论数据
-(void) freshCommentData{
//    [self addTableVIew];
    [_tableView reloadData];
    
    if (_comeBtnType == 0) {
        [self showKeyBoard];
        _comeBtnType = 1;
    }
}

//评论、回复成功
-(void) publishSuccess{
    [self accessCommentList];
}

//评论、回复删除成功
-(void) delCommentSuccess{
    [self accessCommentList];
}

-(void) dealloc{
    [cellHeightArr release];
    [_darkCircleDot release];
    [self cancelKeyNotify];
    RELEASE_SAFE(_tableView);
    
    RELEASE_SAFE(containerView);
    RELEASE_SAFE(textView);
    RELEASE_SAFE(faceKeyboardView);
    
    RELEASE_SAFE(remainCountLabel);
    
    RELEASE_SAFE(commentArr);
    RELEASE_SAFE(careArr);
    
    RELEASE_SAFE(_responsLab);
    RELEASE_SAFE(_actIndicator);
    
    [super dealloc];
}

@end
