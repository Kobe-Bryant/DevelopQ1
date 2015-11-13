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
    }else{
        _cardType = TableViewCellCardTypeImage;
    }
}

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
            default:
                break;
        }
        
        [self initHeadView];
        
    }
}

-(void) initHeadView{
    //headView
    AMBlurView* headView = [[AMBlurView alloc] initWithFrame:CGRectMake(0, 0, contrainView.bounds.size.width, 60)];
//    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 60)];
//    headView.backgroundColor = [UIColor whiteColor];
//    headView.alpha = 0.5;
    [contrainView addSubview:headView];
    
    //头像
    UIImageView* userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 40, 40)];
    [userImageView setImageWithURL:[NSURL URLWithString:[_dataDic objectForKey:@"portrait"]] placeholderImage:IMG(@"ico_common_portrait_92") completed:^(UIImage* image,NSError* error,SDImageCacheType SDImageCacheTypeNone){
        if (image) {
            UIImage* newImage = [image imageByScalingAndCroppingForSize:CGSizeMake(40*2, 40*2)];
            userImageView.image = newImage;
        }
    }];
    userImageView.layer.cornerRadius = 5.0;
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
    
    //时间
    UILabel* timeLab = [[UILabel alloc] initWithFrame:CGRectMake(contrainView.bounds.size.width - 100, nameLab.frame.origin.y, 90, 15)];
    timeLab.backgroundColor = [UIColor clearColor];
    timeLab.font = KQLSystemFont(12);
    timeLab.textAlignment = UITextAlignmentRight;
    timeLab.text = [Common makeFriendTime:[[_dataDic objectForKey:@"created"] intValue]];
    timeLab.textColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1.0];
    [headView addSubview:timeLab];
    
    NSArray*pics = [[_dataDic objectForKey:@"pics"] componentsSeparatedByString:@","];
    
    if (pics == nil || pics.count == 0) {
        UIImageView* lineImgV = [[UIImageView alloc] init];
        UIImage* image = nil;
        image = IMG(@"img_feed_line_gray");
        
        lineImgV.frame = CGRectMake(0, CGRectGetMaxY(headView.frame) - 0.5, 320, 0.5);
        lineImgV.image = image;
        [headView addSubview:lineImgV];
        
        RELEASE_SAFE(lineImgV);
    }
    
    RELEASE_SAFE(headView);
    RELEASE_SAFE(userImageView);
    RELEASE_SAFE(nameLab);
    RELEASE_SAFE(timeLab);
}

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

-(void) initOpenTime{
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 + 60, contrainView.bounds.size.width, 80)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 0;
    lab.lineBreakMode = NSLineBreakByWordWrapping;
    lab.font = KQLSystemFont(20);
    lab.textColor = [UIColor darkGrayColor];
    //    lab.text = @"3月13日 15:00-20:00\n深圳市 洲际酒店";
    lab.text = [NSString stringWithFormat:@"%@ -- %@\n",[Common makeTime:[[_dataDic objectForKey:@"start_time"] intValue] withFormat:@"MM月dd日 HH:mm"],[Common makeTime:[[_dataDic objectForKey:@"end_time"] intValue] withFormat:@"MM月dd日 HH:mm"]];
    [contrainView addSubview:lab];
    
    UILabel* titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab.frame), CGRectGetWidth(lab.frame), 60)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.numberOfLines = 0;
    titleLab.lineBreakMode = NSLineBreakByWordWrapping;
    titleLab.textColor = [UIColor darkGrayColor];
    titleLab.font = KQLboldSystemFont(14);
    titleLab.text = [_dataDic objectForKey:@"title"];
    [contrainView addSubview:titleLab];
    
    RELEASE_SAFE(lab);
    RELEASE_SAFE(titleLab);
}

-(void) dealloc{
    RELEASE_SAFE(contrainView);
    RELEASE_SAFE(_dataDic);
    [super dealloc];
}

@end
