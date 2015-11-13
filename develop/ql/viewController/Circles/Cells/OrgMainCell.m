//
//  OrgMainCell.m
//  ql
//
//  Created by yunlai on 14-3-13.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import "OrgMainCell.h"

#define kIconWH 120.f
#define kTopMargin 10.f
#define spacW 26.f
#define kCellHeight 150.f
#define kSmallIconWH 30.f

@implementation OrgMainCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)iconClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(selectButtonIndex:)]) {
        [self.delegate performSelector:@selector(selectButtonIndex:) withObject:sender];
    }
    
}

- (void)setOrgLayout:(NSArray *)orgArray{
    

    for (int i =0; i < orgArray.count; i++ ) {
        CGRect rect;
        
        if (i < 2 ) {
            rect = CGRectMake(spacW + (kIconWH + spacW) * i, kTopMargin, kIconWH, kIconWH);
            
        }else if(i >=2 && i < 4){
            rect = CGRectMake(spacW + (kIconWH + spacW) * (i-2), kTopMargin + kCellHeight, kIconWH, kIconWH);
            
        }else if(i >=6 && i < 8){
            rect = CGRectMake(spacW + (kIconWH + spacW) * (i-4), kTopMargin + kCellHeight * 2, kIconWH, kIconWH);
        }else if (i >10 ){
            rect = CGRectMake(spacW + (kIconWH + spacW) * (i-6), kTopMargin + kCellHeight * 3, kIconWH, kIconWH);
        }
        
        // 图标
        _iconOrgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconOrgBtn setFrame:rect];
        [_iconOrgBtn setTag:i];
        [_iconOrgBtn addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_iconOrgBtn];
    
        // 组织名称
        _orgName = [[UILabel alloc]initWithFrame:CGRectMake(0.f, CGRectGetMaxY(_iconOrgBtn.frame) /2 - 20.f, kIconWH , 25.f)];
        _orgName.font = KQLboldSystemFont(15);
        _orgName.textAlignment = NSTextAlignmentCenter;
        _orgName.textColor = [UIColor whiteColor];
        [_iconOrgBtn addSubview:_orgName];
        
        // 组织人数
        _orgNum = [[UILabel alloc]initWithFrame:CGRectMake(0.f, CGRectGetMaxY(_orgName.frame), kIconWH , 25.f)];
        _orgNum.font = KQLSystemFont(14);
        _orgNum.textColor = [UIColor whiteColor];
        _orgNum.textAlignment = NSTextAlignmentCenter;
        [_iconOrgBtn addSubview:_orgNum];
        
        
        _iconOrgBtn.layer.cornerRadius = 5;
        _iconOrgBtn.backgroundColor = RGBACOLOR(32, 141, 226, 1);
        _orgName.text = [orgArray objectAtIndex:i];
        _orgNum.text = @"111人";
        
        NSArray *arry = [NSArray arrayWithObjects:@"11.jpg",@"12.jpg",@"13.jpg",@"14.jpg",@"15.jpg",@"16.jpg",@"17.jpg",@"18.jpg",@"19.jpg",@"20.jpg",@"21.jpg",@"22.jpg",@"23.jpg",@"24.jpg",@"28.jpg",@"26.jpg", nil];
        
        for (int i = 0; i < arry.count; i++) {
            CGRect rectSmall;
            
            if (i < 4 ) {
                rectSmall = CGRectMake(kSmallIconWH * i, 0.f, kSmallIconWH, kSmallIconWH);
                
            }else if(i >=4 && i < 8){
                rectSmall = CGRectMake(kSmallIconWH * (i-4), kSmallIconWH * 1, kSmallIconWH, kSmallIconWH);
                
            }else if(i >=8 && i < 12){
                
                rectSmall = CGRectMake(kSmallIconWH * (i-8), kSmallIconWH * 2, kSmallIconWH, kSmallIconWH);
            }else if (i >=12 && i < 16 ){
                
                rectSmall = CGRectMake(kSmallIconWH * (i-12), kSmallIconWH * 3, kSmallIconWH, kSmallIconWH);
            }
            
            UIImageView *headV = [[UIImageView alloc]initWithFrame:rectSmall];
            headV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[arry objectAtIndex:i]]];
            headV.alpha = 0.2;
            [_iconOrgBtn addSubview:headV];
            RELEASE_SAFE(headV);
        }
        
    }
    
}

- (void)dealloc
{
    
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
