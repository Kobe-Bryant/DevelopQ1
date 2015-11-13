//
//  personalCell.h
//  ql
//
//  Created by yunlai on 14-3-4.
//  Copyright (c) 2014年 ChenFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "CircleCellEditButton.h"

@interface personalCell : UITableViewCell
{
    UIImageView *_headView;
    UILabel *_markLabel;
    UILabel *_userName;
    UILabel *_positionLabel;
    UILabel *_companyLabel;
}
@property (nonatomic , retain) UIImageView *headView;
@property (nonatomic , retain) UILabel *markLabel;
@property (nonatomic , retain) UILabel *userName;
@property (nonatomic , retain) UILabel *positionLabel;
@property (nonatomic , retain) CircleCellEditButton *inviteBtn;
@property (nonatomic , retain) UILabel *companyLabel;

- (void)setButtonTitleType:(MemberlistType)type isInvite:(BOOL)mark;

- (void)setCellStyleShowMsg:(int)messages company:(NSString *)companys tips:(NSString *)markTitle;

- (void)inviteButtonIsHidden:(BOOL)hidden;

@end
