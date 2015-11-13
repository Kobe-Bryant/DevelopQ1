//
//  circleMainPageCell.m
//  ql
//
//  Created by yunlai on 14-3-11.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "circleMainPageCell.h"

#define kMargin 15.f
#define kTopMargin 10.f
#define kIconWidth 90.f
#define kIconHeight 120.f
#define kCellHeight 150.f
#define kSmallIconWH 25.f
#define spacW 12.f

@implementation circleMainPageCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

/**
 *  布局按钮的点击事件
 *
 *  @param sender 点击的按钮
 */
- (void)iconClick:(UIButton *)sender{

    if ([self.delegate respondsToSelector:@selector(selectButtonIndex:)]) {
        [self.delegate performSelector:@selector(selectButtonIndex:) withObject:sender];
    }
    
}

/**
 *  根据数组来排版布局
 *
 *  @param dataArray 圈子数组
 *  @param whether   是否是创建圈子还是加入的圈子
 */
- (void)setCircleLayout:(NSArray *)dataArray isAddIcon:(BOOL)whether inSection:(int)section{

    if (dataArray.count == 0 && whether == YES) {
        
        UIButton *iconImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconImageBtn setFrame:CGRectMake(spacW, kTopMargin, kIconWidth, kIconHeight)];
        [iconImageBtn setTag:100];
        [iconImageBtn addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:iconImageBtn];
        
        
        if (_iconImage == nil) {
            _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, 0.f, kIconWidth, kIconWidth)];
            _iconImage.layer.cornerRadius = 45;
            _iconImage.clipsToBounds = YES;
            _iconImage.image = [UIImage imageNamed:@"eatShow_addPic_icon@2x"];
            
        }
        
        [iconImageBtn addSubview:_iconImage];
    
        
        if (_circleName == nil) {
            _circleName = [[UILabel alloc]initWithFrame:CGRectMake(3.f, CGRectGetMaxY(_iconImage.frame) + 5.f, 80.f, 25.f)];
            _circleName.font = KQLSystemFont(15);
            _circleName.text = @"创建圈子";
            _circleName.textAlignment = NSTextAlignmentCenter;
        }
        
        [iconImageBtn addSubview:_circleName];
        
        iconImageBtn.titleLabel.font = KQLboldSystemFont(30);
        iconImageBtn.titleEdgeInsets = UIEdgeInsetsMake(0.f, 0.f, 25.f, 0.f);
        
    }else{
        int arryNum;
        if (whether == YES) {
            arryNum = dataArray.count + 1;
        }else{
            arryNum = dataArray.count;
        }
        
        for (int i =0; i < arryNum; i++ ) {
            CGRect rect;
            
            if (i < 3 ) {
                rect = CGRectMake(spacW + (kIconWidth + spacW) * i, kTopMargin, kIconWidth, kIconHeight);
                
            }else if(i >=3 && i < 6){
                rect = CGRectMake(spacW + (kIconWidth + spacW) * (i-3), kTopMargin + kCellHeight, kIconWidth, kIconHeight);
                
            }else if(i >=6 && i < 9){
                rect = CGRectMake(spacW + (kIconWidth + spacW) * (i-6), kTopMargin + kCellHeight * 2, kIconWidth, kIconHeight);
            }else if (i >9 ){
                rect = CGRectMake(spacW + (kIconWidth + spacW) * (i-9), kTopMargin + kCellHeight * 3, kIconWidth, kIconHeight);
            }
            
            UIButton *iconImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [iconImageBtn setFrame:rect];
            
            [iconImageBtn addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.contentView addSubview:iconImageBtn];
            
            _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, 0.f, kIconWidth, kIconWidth)];
            _iconImage.layer.cornerRadius = 45;
            _iconImage.clipsToBounds = YES;
            [iconImageBtn addSubview:_iconImage];
            
            _circleName = [[UILabel alloc]initWithFrame:CGRectMake(3.f, CGRectGetMaxY(_iconImage.frame) + 5.f, 80.f, 25.f)];
            _circleName.font = KQLSystemFont(15);
           
            _circleName.textAlignment = NSTextAlignmentCenter;
            [iconImageBtn addSubview:_circleName];
    
            
            if (whether == YES && i == dataArray.count) {
                
                _iconImage.image = [UIImage imageNamed:@"eatShow_addPic_icon@2x"];
                _circleName.text = @"创建圈子";
                [iconImageBtn setTag:100];
                
            }else{
                // 随机颜色
                float red=20 * (i + 5)/255.0;
                float green=(i* 40) % 60 * (i + 3)/255.0;
                float blue=(i * 70) % 160 * i/255.0;
                UIColor *coverColor=[UIColor colorWithRed:red green:green blue:blue alpha:0.7];
                
                _iconImage.backgroundColor = coverColor;
                _circleName.text = [dataArray objectAtIndex:i];
                
                NSArray *arry = [NSArray arrayWithObjects:@"11.jpg",@"12.jpg",@"13.jpg",@"14.jpg",@"15.jpg",@"16.jpg",@"17.jpg",@"18.jpg",@"19.jpg",@"20.jpg",@"21.jpg",@"22.jpg",@"23.jpg",@"24.jpg",@"25.jpg",@"26.jpg", nil];
                
                for (int i = 0; i < arry.count; i++) {
                    CGRect rectSmall;
                    
                    if (i < 4 ) {
                        rectSmall = CGRectMake(kSmallIconWH * i, 0.f, kSmallIconWH, kSmallIconWH);
                        
                    }else if(i >=4 && i < 8){
                        rectSmall = CGRectMake(kSmallIconWH * (i-4), kSmallIconWH * 1, kSmallIconWH, kSmallIconWH);
                        
                    }else if(i >=8 && i < 12){
                        
                        rectSmall = CGRectMake(kSmallIconWH * (i-8), kSmallIconWH * 2, kSmallIconWH, kSmallIconWH);
                    }else if (i >12 ){
                        
                        rectSmall = CGRectMake(kSmallIconWH * (i-12), kSmallIconWH * 3, kSmallIconWH, kSmallIconWH);
                    }
                    
                    UIImageView *headV = [[UIImageView alloc]initWithFrame:rectSmall];
                    headV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[arry objectAtIndex:i]]];
                    headV.alpha = 0.2;
                    [_iconImage addSubview:headV];
                    RELEASE_SAFE(headV);
                }
                
                NSString *titles = [_circleName.text substringToIndex:1];
                
                if (section == 0) {
                    [iconImageBtn setTag:i];
                }else{
                    [iconImageBtn setTag:i + 200];
                }
                
                [iconImageBtn setTitle:titles forState:UIControlStateNormal];
                iconImageBtn.titleLabel.font = KQLboldSystemFont(30);
                iconImageBtn.titleEdgeInsets = UIEdgeInsetsMake(0.f, 0.f, 25.f, 0.f);
            }
            
        }
    
    }
    
}

- (void)dealloc
{
    RELEASE_SAFE(_iconImage);
    RELEASE_SAFE(_circleName);
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
