//
//  personalmessageCell.m
//  ql
//
//  Created by yunlai on 14-3-3.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "PersonalmessageCell.h"
#import "UIImageView+WebCache.h"
#import "SBJson.h"

@interface PersonalMessageCell ()
{
    
}
@property (nonatomic, assign) SDImageCache * imageCache;

@end

@implementation PersonalMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.imageCache = [SDImageCache sharedImageCache];
    return self;
}

- (void)freshWithInfoDic:(NSDictionary *)messageDic
{
    [super freshWithInfoDic:messageDic];
    
    //加载头像数据
    NSString *portraitStr = nil;
    NSString *portraitArrJsonStr = [messageDic objectForKey:@"icon_path"];
    NSArray * portraitArr = [portraitArrJsonStr JSONValue];
    if (portraitArr.count >0) {
        portraitStr = [portraitArr firstObject];
        UIImage *image = [self.imageCache imageFromDiskCacheForKey:portraitStr];
        if (image != nil) {
            _headView.image = image;
        } else {
            NSURL * portraitUrl = [NSURL URLWithString:portraitStr];
            [_headView setImageWithURL:portraitUrl placeholderImage:[UIImage imageNamed:DEFAULT_MALE_PORTRAIT_NAME]options:SDWebImageProgressiveDownload];
        }
    } else {
        UIImage *image = [UIImage imageCwNamed:DEFAULT_FEMALE_PORTRAIT_NAME];
        _headView.image = image;
    }
}

@end
