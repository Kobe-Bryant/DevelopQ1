//
//  aboutCompanyCell.h
//  ql
//
//  Created by yunlai on 14-2-28.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface aboutCompanyCell : UITableViewCell
{
    UIView *_bgView;
    UITextView *_textView;
    UILabel *_contentLabel;
}
@property (nonatomic ,retain) UITextView *textView;
@property (nonatomic ,retain) UILabel *contentLabel;
@end
