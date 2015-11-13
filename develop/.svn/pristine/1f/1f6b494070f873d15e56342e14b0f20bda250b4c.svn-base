//
//  circleMainPageCell.h
//  ql
//
//  Created by yunlai on 14-3-11.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol circleMainCellDelegate <NSObject>

- (void)selectButtonIndex:(UIButton *)sender;

@end

@interface circleMainPageCell : UITableViewCell
{
    UILabel *_circleName;
    UIImageView *_iconImage;
    id<circleMainCellDelegate>delegate;
}
@property(nonatomic,assign) id<circleMainCellDelegate>delegate;

- (void)setCircleLayout:(NSArray *)dataArray isAddIcon:(BOOL)whether inSection:(int)section;

@end
