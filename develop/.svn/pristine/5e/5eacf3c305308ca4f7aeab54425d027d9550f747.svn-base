//
//  MajorListCell.m
//  ql
//
//  Created by Dream on 14-8-26.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "MajorListCell.h"

@implementation MajorListCell

@synthesize companyLable;
@synthesize nameLable;
@synthesize listNameImage;
@synthesize lineImage;
@synthesize positionLable;
@synthesize sendBtn;
@synthesize inviteLable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        //层级名字
        self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(82, 15.0, 250.f, 30.f)];
        self.nameLable.backgroundColor = [UIColor clearColor];
        self.nameLable.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
        self.nameLable.font = [UIFont systemFontOfSize:17.0];
        [self addSubview:self.nameLable];
        
         //公司名字
        self.companyLable = [[UILabel alloc]initWithFrame:CGRectMake(60.f, 22.0, 250.f, 30.f)];
        self.companyLable.backgroundColor = [UIColor clearColor];
        self.companyLable.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        self.companyLable.font = [UIFont systemFontOfSize:12.0];
        self.companyLable.text = @"云来网络有限公司";
        [self addSubview:self.companyLable];
        
        //职位名字
        self.positionLable = [[UILabel alloc]initWithFrame:CGRectMake(115.f, 2.0, 250.f, 30.f)];
        self.positionLable.backgroundColor = [UIColor clearColor];
        self.positionLable.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        self.positionLable.font = [UIFont systemFontOfSize:12.0];
        self.positionLable.text = @"产品总监";
        [self addSubview:self.positionLable];
        
        //头像
        self.listNameImage = [[UIImageView alloc]initWithFrame:CGRectMake(10.f, 5.f, 42.f, 42.f)];
        [self addSubview:self.listNameImage];
        
        //直线
        UIImage *lineImg = [UIImage imageNamed:@"img_group_underline.png"];
        self.lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, 320, 0.5)];
        self.lineImage.image = lineImg;
        [self addSubview:self.lineImage];
        
        self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sendBtn.hidden = YES;
        self.sendBtn.frame = CGRectMake(250, 13, 50, 28);
        self.sendBtn.layer.borderWidth = 0.5f;
        self.sendBtn.layer.borderColor = [UIColor colorWithRed:48/255.0 green:122/255.0 blue:208/255.0 alpha:1].CGColor;
        self.sendBtn.layer.cornerRadius = 3.0;
        self.sendBtn.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
        [self.sendBtn setTitleColor:[UIColor colorWithRed:48/255.0 green:122/255.0 blue:208/255.0 alpha:1] forState:UIControlStateNormal];
        self.sendBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [self addSubview:self.sendBtn];
        
        self.inviteLable = [[UILabel alloc]initWithFrame:CGRectMake(255.f, 13.0, 60.f, 28.f)];
        self.inviteLable.backgroundColor = [UIColor clearColor];
        self.inviteLable.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        self.inviteLable.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:self.inviteLable];
    
    }
    return self;
}

- (void)dealloc
{
    self.listNameImage = nil;
    self.companyLable = nil;
    self.nameLable = nil;
    self.lineImage = nil;
    self.sendBtn = nil;
    self.inviteLable = nil;
    [super dealloc];
}


@end
