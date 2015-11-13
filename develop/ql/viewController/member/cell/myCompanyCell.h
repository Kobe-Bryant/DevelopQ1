//
//  myCompanyCell.h
//  ql
//
//  Created by yunlai on 14-4-16.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myCompanyCell : UITableViewCell
{
    UIImageView *_iconV;
    UILabel *_companyT;
    UILabel *_browseCount;
    
}
@property (nonatomic ,retain) UIImageView *iconV;
@property (nonatomic ,retain) UILabel *companyT;
@property (nonatomic ,retain) UILabel *browseCount;
@property (nonatomic ,retain) UIButton *dredgeBtn;

//未开通公司轻APP
- (void)noDredgeCompanyLightApp:(int)type;

- (void)hiddenNoDredgeCompanyLightApp;

@end
