//
//  OrgMainCell.h
//  ql
//
//  Created by yunlai on 14-3-13.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrgMainCellDelegate <NSObject>

- (void)selectButtonIndex:(UIButton *)sender;

@end

@interface OrgMainCell : UITableViewCell
{
    UIButton *_iconOrgBtn;
    UILabel *_orgName;
    UILabel *_orgNum;
    id<OrgMainCellDelegate>delegate;
}

- (void)setOrgLayout:(NSArray *)orgArray;

@property(nonatomic,assign) id<OrgMainCellDelegate>delegate;


@end
