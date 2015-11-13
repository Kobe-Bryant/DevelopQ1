//
//  priDetailViewController.m
//  ql
//
//  Created by yunlai on 14-4-26.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "priDetailViewController.h"

#import "UIImageView+WebCache.h"

@interface priDetailViewController (){
    float T_H;
}

@property(nonatomic,retain) UIScrollView* scrollV;

@end

@implementation priDetailViewController

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
    
    self.navigationItem.title = _titleStr;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initScrollV];
    [self initHeadV];
    [self initImageV];
    [self initInstructions];
    
	// Do any additional setup after loading the view.
}
//初始化滚动
-(void) initScrollV{
    _scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _scrollV.showsVerticalScrollIndicator = NO;
    _scrollV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollV];
    
}

//初始化头部UI
-(void) initHeadV{
    //250/2
    UIView* headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 250/2)];
    headV.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:headV];
    [self.view addSubview:headV];
    
    UIImageView* bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headV.bounds.size.width, headV.bounds.size.height)];
    bgImgV.image = IMG(@"bg_tool_pd");
    bgImgV.backgroundColor = COLOR_LIGHTWEIGHT;
    [headV addSubview:bgImgV];
    RELEASE_SAFE(bgImgV);
    
    UIImage* tagImage = IMG(@"ico_tool_discount");
    UIImageView* tagImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, (80 - tagImage.size.height)/2, tagImage.size.width, tagImage.size.height)];
    tagImgV.image = tagImage;
    [headV addSubview:tagImgV];
    
    UILabel* titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tagImgV.frame) + 10, 10, self.view.bounds.size.width - (CGRectGetMaxX(tagImgV.frame) + 10), 25)];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = KQLboldSystemFont(16);
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textAlignment = UITextAlignmentLeft;
    titleLab.text = [_pdDataDic objectForKey:@"title"];
    [headV addSubview:titleLab];
    
    UILabel* indateLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tagImgV.frame) + 10, CGRectGetMaxY(titleLab.frame) + 10, self.view.bounds.size.width - (CGRectGetMaxX(tagImgV.frame) + 10), 25)];
    indateLab.textColor = [UIColor whiteColor];
    indateLab.font = KQLboldSystemFont(13);
    indateLab.backgroundColor = [UIColor clearColor];
    indateLab.textAlignment = UITextAlignmentLeft;
    NSString* stStr = [self dateIntToStr:[[_pdDataDic objectForKey:@"start_time"] intValue]];
    NSString* endStr = [self dateIntToStr:[[_pdDataDic objectForKey:@"end_time"] intValue]];
    indateLab.text = [NSString stringWithFormat:@"有效期：%@－%@",stStr,endStr];
    [headV addSubview:indateLab];
    
    UIImageView* lineImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, 1)];
    lineImgV.image = IMG(@"img_feed_line");
    [headV addSubview:lineImgV];
    
    UILabel* LAB = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, 45)];
    LAB.text = [_pdDataDic objectForKey:@"desc"];
    LAB.backgroundColor = [UIColor clearColor];
    LAB.textAlignment = UITextAlignmentCenter;
    LAB.textColor = [UIColor whiteColor];
    LAB.font = KQLboldSystemFont(13);
    [headV addSubview:LAB];
    
    RELEASE_SAFE(headV);
    RELEASE_SAFE(tagImgV);
    RELEASE_SAFE(titleLab);
    RELEASE_SAFE(indateLab);
    RELEASE_SAFE(lineImgV);
    RELEASE_SAFE(LAB);
}

//时间转化yyyy-MM-dd格式
-(NSString*) dateIntToStr:(int) d{
    NSDateFormatter* format = [[[NSDateFormatter alloc] init] autorelease];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [[[NSDate alloc] initWithTimeIntervalSince1970:d] autorelease];
    
    return [format stringFromDate:date];
}

//添加imageV
-(void) initImageV{
    UIImageView* midImgV = [[UIImageView alloc] init];
    [midImgV setImageWithURL:[NSURL URLWithString:[_pdDataDic objectForKey:@"image_path"]] placeholderImage:IMG(@"default_600")];
    midImgV.frame = CGRectMake(0, 125, self.view.bounds.size.width, 200);
    [_scrollV addSubview:midImgV];
    
    T_H = CGRectGetMaxY(midImgV.frame);
    
    RELEASE_SAFE(midImgV);
}

//介绍页UI布置
-(void) initInstructions{
    
    UILabel* lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(10, T_H, 100, 30);
    lab.font = KQLboldSystemFont(15);
    lab.textColor = [UIColor darkGrayColor];
    lab.text = @"使用说明";
    lab.backgroundColor = [UIColor whiteColor];
    [_scrollV addSubview:lab];
    
    UITextView* textV = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMinX(lab.frame), CGRectGetMaxY(lab.frame), self.view.bounds.size.width - 20, 88)];
    textV.userInteractionEnabled = NO;
    textV.backgroundColor = [UIColor whiteColor];
    textV.font = KQLboldSystemFont(13);
    textV.textColor = [UIColor darkGrayColor];
    textV.text = [_pdDataDic objectForKey:@"use_explain"];
    [_scrollV addSubview:textV];
    
    CGSize size = [textV.text sizeWithFont:textV.font constrainedToSize:CGSizeMake(self.view.bounds.size.width, 2000) lineBreakMode:NSLineBreakByWordWrapping];
    textV.frame = CGRectMake(CGRectGetMinX(lab.frame), CGRectGetMaxY(lab.frame), self.view.bounds.size.width - 20, size.height + 60);
    
    _scrollV.contentSize = CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(textV.frame) + 64 + 40);
    
    RELEASE_SAFE(lab);
    RELEASE_SAFE(textV);
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    [_pdDataDic release];
    [_scrollV release];
    [super dealloc];
}

@end
