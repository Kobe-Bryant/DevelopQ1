//
//  dyCardTableViewCell.m
//  ql
//
//  Created by yunlai on 14-6-6.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "dyCardTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImageScale.h"
#import "AMBlurView.h"

#import "RegexKitLite.h"

@implementation dyCardTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, 320, 320);
        
        contrainView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
        contrainView.backgroundColor = [UIColor whiteColor];
        contrainView.layer.cornerRadius = 5.0;
        contrainView.clipsToBounds = YES;
        contrainView.tag = 1000;
        //边框
        contrainView.layer.borderColor = [UIColor colorWithRed:208/255.0 green:213/255.0 blue:217/255.0 alpha:0.9].CGColor;
        contrainView.layer.borderWidth = 1.0;
        //阴影
//        contrainView.layer.shadowColor = [UIColor colorWithRed:222/255.0 green:227/255.0 blue:232/255.0 alpha:1.0].CGColor;
        
        [self.contentView addSubview:contrainView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//初始化卡片类型
-(void) initCardType{
    int type = [[_dataDic objectForKey:@"type"] intValue];
    
    NSLog(@"type:%d",type);
    
    if (type == 0) {
        _cardType = TableViewCellCardTypeImage;
    }else if (type == 1) {
        _cardType = TableViewCellCardTypeOOXX;
    }else if (type == 2) {
        _cardType = TableViewCellCardTypeOpenTime;
    }else if (type == 3) {
        _cardType = TableViewCellCardTypeImage;
    }else if (type == 4){
        _cardType = TableViewCellCardTypeImage;
    }else if (type == 5){
        _cardType = TableViewCellCardTypeNews;
    }else if (type == 6) {
        _cardType = TableViewCellCardTypeLable;
    }else if (type == 8) {
        _cardType = TableViewCellCardTypeTogether;
    }else{
        _cardType = TableViewCellCardTypeImage;
    }
}
//设置卡片数据
-(void) setDataDic:(NSDictionary *)dataDic{
    if (dataDic) {
        _dataDic = [dataDic copy];
        
        NSString* picstr = [_dataDic objectForKey:@"pics"];
        NSArray* pics = [[_dataDic objectForKey:@"pics"] componentsSeparatedByString:@","];
        
        [self initCardType];
        
        switch (_cardType) {
            case TableViewCellCardTypeLable:
            case TableViewCellCardTypeImage:
            {
                if (picstr.length > 0 && pics && pics.count) {
                    [self initMiddleImage];
                    NSString* titleStr = [_dataDic objectForKey:@"title"];
                    if (titleStr.length) {
                        [self initButtomView];
                    }
                }else{
                    [self initMiddleText];
                }
            }
                break;
            case TableViewCellCardTypeOOXX:
            {
                if (picstr.length > 0 && pics && pics.count) {
                    [self initMiddleImage];
                    [self extraViewWithY:20 + 60 type:0];
                    NSString* titleStr = [_dataDic objectForKey:@"title"];
                    if (titleStr.length) {
                        [self initButtomView];
                    }
                    
                }else{
                    [self initMiddleText];
                    [self extraViewWithY:contrainView.bounds.size.height - 40 type:0];
                }
            }
                break;
            case TableViewCellCardTypeNews:
            {
                [self initOrgNews];
            }
                break;
            case TableViewCellCardTypeOpenTime:
            {
                [self initOpenTime];
            }
                break;
            case TableViewCellCardTypeSecretary:
            {
                
            }
                break;
            case TableViewCellCardTypeTogether:
            {
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
                
                if (picstr.length > 0 && pics && pics.count) {
                    [self initMiddleImage];
                    
                    if (textStr.length) {
                        [self initTogetherButtom:textStr];
                    }
                }else{
                    [self initTogetherText:textStr];
                }
            }
                break;
            default:
                break;
        }
        
        [self initHeadView];
        
    }
}

//聚聚类型底部
-(void) initTogetherButtom:(NSString*) str{
    AMBlurView* buttomView = [[AMBlurView alloc] initWithFrame:CGRectMake(0, contrainView.bounds.size.height - 45, contrainView.bounds.size.width, 45)];
    [contrainView addSubview:buttomView];
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, contrainView.bounds.size.width - 10*2, 40)];
    lab.numberOfLines = 2;
    lab.backgroundColor = [UIColor clearColor];
    lab.lineBreakMode = UITextAlignmentLeft;
    //    lab.text = [_dataDic objectForKey:@"title"];
    lab.text = [str stringByReplacingOccurrencesOfRegex:@"[\n,\r]{2,}" withString:@"\n"];
    lab.textColor = [UIColor darkGrayColor];
    lab.font = KQLboldSystemFont(13);
    [buttomView addSubview:lab];
    
    RELEASE_SAFE(lab);
    RELEASE_SAFE(buttomView);
}

//聚聚类型文本
-(void) initTogetherText:(NSString*) str{
    UITextView* textLab = [[UITextView alloc] initWithFrame:CGRectMake(5, 60 + 10, contrainView.bounds.size.width - 5*2, contrainView.bounds.size.height - 60 - 2*10)];
    textLab.textColor = [UIColor darkGrayColor];
    textLab.font = KQLboldSystemFont(15);
    //    textLab.text = [_dataDic objectForKey:@"title"];
    textLab.text = [str stringByReplacingOccurrencesOfRegex:@"[\n,\r]{2,}" withString:@"\n"];
    textLab.userInteractionEnabled = NO;
    textLab.showsHorizontalScrollIndicator = NO;
    textLab.showsVerticalScrollIndicator = NO;
    textLab.scrollEnabled = NO;
    textLab.backgroundColor = [UIColor clearColor];
    [contrainView addSubview:textLab];
    
    RELEASE_SAFE(textLab);
}

//卡片头部
-(void) initHeadView{
    //headView
    AMBlurView* headView = [[AMBlurView alloc] initWithFrame:CGRectMake(0, 0, contrainView.bounds.size.width, 60)];
//    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 60)];
//    headView.backgroundColor = [UIColor whiteColor];
//    headView.alpha = 0.5;
    [contrainView addSubview:headView];
    
    //头像
    UIImageView* userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 40, 40)];
    UIImage* placeHolderImg = nil;
    if ([[_dataDic objectForKey:@"sex"] intValue] == 1) {
        placeHolderImg = IMGREADFILE(DEFAULT_FEMALE_PORTRAIT_NAME);
    }else{
        placeHolderImg = IMGREADFILE(DEFAULT_MALE_PORTRAIT_NAME);
    }
    [userImageView setImageWithURL:[NSURL URLWithString:[_dataDic objectForKey:@"portrait"]] placeholderImage:placeHolderImg completed:^(UIImage* image,NSError* error,SDImageCacheType SDImageCacheTypeNone){
        if (image) {
            UIImage* newImage = [image imageByScalingAndCroppingForSize:CGSizeMake(40*2, 40*2)];
            userImageView.image = newImage;
        }
    }];
    userImageView.layer.cornerRadius = 20;
    [userImageView.layer setMasksToBounds:YES];
    userImageView.userInteractionEnabled = YES;
    
    [headView addSubview:userImageView];
    
    //名字
    UILabel* nameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImageView.frame) + 10, CGRectGetMidY(userImageView.frame) - 7, 200, 15)];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.font = KQLSystemFont(14);
    nameLab.text = [_dataDic objectForKey:@"realname"];
//    nameLab.textColor = [UIColor colorWithRed:44/255.0 green:44/255.0 blue:44/255.0 alpha:1.0];
    nameLab.textColor = [[ThemeManager shareInstance] getColorWithName:@"COLOR_THEME"];
    
    [headView addSubview:nameLab];
    
    NSString* cityStr = [_dataDic objectForKey:@"city"];
    if (cityStr.length && _cardType != TableViewCellCardTypeTogether) {
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
    UILabel* timeLab = [[UILabel alloc] initWithFrame:CGRectMake(contrainView.bounds.size.width - 100, nameLab.frame.origin.y, 90, 15)];
    timeLab.backgroundColor = [UIColor clearColor];
    timeLab.font = KQLSystemFont(12);
    timeLab.textAlignment = UITextAlignmentRight;
    timeLab.text = [Common makeFriendTime:[[_dataDic objectForKey:@"created"] intValue]];
    timeLab.textColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1.0];
    [headView addSubview:timeLab];
    
//    NSArray*pics = [[_dataDic objectForKey:@"pics"] componentsSeparatedByString:@","];
//    
//    if (pics == nil || pics.count == 0) {
        UIImageView* lineImgV = [[UIImageView alloc] init];
        UIImage* image = nil;
        image = IMG(@"img_feed_line_gray");
        
        lineImgV.frame = CGRectMake(0, CGRectGetMaxY(headView.frame) - 0.5, 320, 0.5);
        lineImgV.image = image;
        [headView addSubview:lineImgV];
        
        RELEASE_SAFE(lineImgV);
//    }
    
    RELEASE_SAFE(headView);
    RELEASE_SAFE(userImageView);
    RELEASE_SAFE(nameLab);
    RELEASE_SAFE(timeLab);
}
//初始化图片
-(void) initMiddleImage{
    NSArray*pics = [[_dataDic objectForKey:@"pics"] componentsSeparatedByString:@","];
    
    UIImageView* midImagev = [[UIImageView alloc] init];
    midImagev.contentMode = UIViewContentModeScaleAspectFill;
    midImagev.clipsToBounds = YES;//不超过边界
    midImagev.frame = CGRectMake(0, 0, contrainView.bounds.size.width, contrainView.bounds.size.height);
    
    __block UIImageView* mImagev = midImagev;
    
    [midImagev setImageWithURL:[NSURL URLWithString:[pics firstObject]] placeholderImage:IMG(@"default_600") completed:^(UIImage* image,NSError* error,SDImageCacheType SDImageCacheTypeNone){
        if (image) {
            CGSize size;
            if (image.size.height > image.size.width) {
                size = [UIImage fitsize:image.size height:mImagev.bounds.size.height*2];
            }else{
                size = [UIImage fitsize:image.size width:mImagev.bounds.size.width*2];
            }
            UIImage* newImage = [image imageByScalingAndCroppingForSize:size];
            NSLog(@"newsize:%@，imageSize:%@",NSStringFromCGSize(newImage.size),NSStringFromCGSize(image.size));
            mImagev.image = newImage;
        }else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage* downImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[pics firstObject]]]];
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
    
    [contrainView addSubview:midImagev];
    
    RELEASE_SAFE(midImagev);
    
}
//初始化文本
-(void) initMiddleText{
    UITextView* textLab = [[UITextView alloc] initWithFrame:CGRectMake(5, 60 + 10, contrainView.bounds.size.width - 5*2, contrainView.bounds.size.height - 60 - 2*10)];
    textLab.textColor = [UIColor darkGrayColor];
    textLab.font = KQLboldSystemFont(15);
//    textLab.text = [_dataDic objectForKey:@"title"];
    textLab.text = [[_dataDic objectForKey:@"title"] stringByReplacingOccurrencesOfRegex:@"[\n,\r]{2,}" withString:@"\n"];
    textLab.userInteractionEnabled = NO;
    textLab.showsHorizontalScrollIndicator = NO;
    textLab.showsVerticalScrollIndicator = NO;
    textLab.scrollEnabled = NO;
    textLab.backgroundColor = [UIColor clearColor];
    [contrainView addSubview:textLab];
    
    RELEASE_SAFE(textLab);
}
//初始化底部
-(void) initButtomView{
    AMBlurView* buttomView = [[AMBlurView alloc] initWithFrame:CGRectMake(0, contrainView.bounds.size.height - 45, contrainView.bounds.size.width, 45)];
    [contrainView addSubview:buttomView];
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, contrainView.bounds.size.width - 10*2, 40)];
    lab.numberOfLines = 2;
    lab.backgroundColor = [UIColor clearColor];
    lab.lineBreakMode = UITextAlignmentLeft;
//    lab.text = [_dataDic objectForKey:@"title"];
    lab.text = [[_dataDic objectForKey:@"title"] stringByReplacingOccurrencesOfRegex:@"[\n,\r]{2,}" withString:@"\n"];
    lab.textColor = [UIColor darkGrayColor];
    lab.font = KQLboldSystemFont(13);
    [buttomView addSubview:lab];
    
    RELEASE_SAFE(lab);
    RELEASE_SAFE(buttomView);
}
//初始化组织新闻
-(void) initOrgNews{
    [self initHeadView];
    
    UIImageView* imageV = [[UIImageView alloc] init];
    imageV.frame = CGRectMake(10, 60 + 10, contrainView.bounds.size.width - 10*2, (contrainView.bounds.size.height - 60 - 150));
    __block UIImageView* mImagev = imageV;
    
    [imageV setImageWithURL:[NSURL URLWithString:[_dataDic objectForKey:@"image_path"]] placeholderImage:IMG(@"default_600") completed:^(UIImage* image,NSError* error,SDImageCacheType SDImageCacheTypeNone){
        if (image) {
            CGSize size;
            if (image.size.height > image.size.width) {
                size = [UIImage fitsize:image.size height:mImagev.bounds.size.height];
            }else{
                size = [UIImage fitsize:image.size width:mImagev.bounds.size.width];
            }
            UIImage* newImage = [image imageByScalingAndCroppingForSize:size];
            NSLog(@"newsize:%@",NSStringFromCGSize(newImage.size));
            mImagev.image = newImage;
        }else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage* downImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_dataDic objectForKey:@"image_path"]]]];
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
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [contrainView addSubview:imageV];
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(imageV.frame) + 15 , contrainView.bounds.size.width - 10*2, 70)];
    //    lab.text = @"长江荣誉｜9位长江校友当选2013年度最具影响力企业领袖";
    lab.text = [NSString stringWithFormat:@"%@ | %@",[_dataDic objectForKey:@"title"],[_dataDic objectForKey:@"content"]];
    lab.textColor = [UIColor darkGrayColor];
    lab.font = [UIFont systemFontOfSize:12];
    lab.numberOfLines = 0;
    lab.lineBreakMode = NSLineBreakByWordWrapping;
    [contrainView addSubview:lab];
    
    CGSize size = [lab.text sizeWithFont:lab.font constrainedToSize:CGSizeMake(lab.bounds.size.width, 70) lineBreakMode:NSLineBreakByWordWrapping];
    lab.frame = CGRectMake(lab.frame.origin.x, lab.frame.origin.y, lab.bounds.size.width, size.height + 30);
    
    RELEASE_SAFE(imageV);
    RELEASE_SAFE(lab);
}
//小秘书、ooxx提醒条
-(void) extraViewWithY:(CGFloat) y type:(int) type{
    //type:0 ooxx type:1 小秘书
    
    UIView* v = [[UIView alloc] init];
    v.backgroundColor = [UIColor blackColor];
    v.alpha = 0.5;
    [contrainView addSubview:v];
    
    UIImageView* imagev = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 20)];
    imagev.image = IMG(@"ico_feed_hot.png");
    [v addSubview:imagev];
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imagev.frame), 0, 0, 0)];
    lab.backgroundColor = [UIColor clearColor];
    if (type == 0) {
        int choice1_sum = [[_dataDic objectForKey:@"choice1_sum"] intValue];
        int choice2_sum = [[_dataDic objectForKey:@"choice2_sum"] intValue];
        lab.text = [NSString stringWithFormat:@"%d人参与了此ooxx",choice2_sum + choice1_sum];
    }else{
        lab.text = @"";
    }
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = UITextAlignmentCenter;
    lab.font = KQLboldSystemFont(10);
    [v addSubview:lab];
    
    CGSize size = [lab.text sizeWithFont:lab.font constrainedToSize:CGSizeMake(contrainView.bounds.size.width, 20) lineBreakMode:NSLineBreakByCharWrapping];
    v.frame = CGRectMake(contrainView.bounds.size.width/2 - (size.width + 60)/2, y, size.width + 60, 20);
    lab.frame = CGRectMake(lab.frame.origin.x, lab.frame.origin.y, v.bounds.size.width - 30, v.bounds.size.height);
    v.layer.cornerRadius = v.bounds.size.height/2;
    
    RELEASE_SAFE(lab);
    RELEASE_SAFE(imagev);
    RELEASE_SAFE(v);
}
//初始化开放时间
-(void) initOpenTime{
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 + 60, contrainView.bounds.size.width, 60)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 0;
    lab.lineBreakMode = NSLineBreakByWordWrapping;
    lab.font = KQLSystemFont(20);
    lab.textColor = [UIColor darkGrayColor];
    lab.text = [NSString stringWithFormat:@"%@ -- %@\n",[Common makeTime:[[_dataDic objectForKey:@"start_time"] intValue] withFormat:@"MM月dd日 HH:mm"],[Common makeTime:[[_dataDic objectForKey:@"end_time"] intValue] withFormat:@"MM月dd日 HH:mm"]];
    [contrainView addSubview:lab];
    
    UILabel* addressLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab.frame), CGRectGetWidth(lab.frame), 60)];
    addressLab.textAlignment = NSTextAlignmentCenter;
    addressLab.numberOfLines = 0;
    addressLab.lineBreakMode = NSLineBreakByWordWrapping;
    addressLab.textColor = [UIColor darkGrayColor];
    addressLab.font = KQLboldSystemFont(20);
    addressLab.text = [_dataDic objectForKey:@"address"];
    [contrainView addSubview:addressLab];
    
    CGSize size = [[_dataDic objectForKey:@"title"] sizeWithFont:KQLboldSystemFont(14) constrainedToSize:CGSizeMake(CGRectGetWidth(addressLab.frame), MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel* titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(addressLab.frame), CGRectGetWidth(addressLab.frame), size.height + 20)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.numberOfLines = 0;
    titleLab.lineBreakMode = NSLineBreakByWordWrapping;
    titleLab.textColor = [UIColor darkGrayColor];
    titleLab.font = KQLboldSystemFont(14);
    titleLab.text = [_dataDic objectForKey:@"title"];
    [contrainView addSubview:titleLab];
    
    RELEASE_SAFE(lab);
    RELEASE_SAFE(addressLab);
    RELEASE_SAFE(titleLab);
}

-(void) dealloc{
    RELEASE_SAFE(contrainView);
    RELEASE_SAFE(_dataDic);
    [super dealloc];
}

@end
