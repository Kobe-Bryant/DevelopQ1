//
//  SGSheetCell.m
//  SGActionView
//
//  Created by yunlai on 14-2-19.
//  Copyright (c) 2014年 AzureLab. All rights reserved.
//

#import "SGSheetCell.h"

@implementation SGSheetCell
@synthesize setIcon = _setIcon;
@synthesize setField = _setField;
@synthesize setImge = _setImge;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _setIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setIcon setFrame:CGRectMake(10, 5, 40, 40)];
        _setIcon.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_setIcon];
        
        _setImge = [[UIImageView alloc]init];
        [_setImge setFrame:CGRectMake(10, 5, 40, 40)];
        _setImge.backgroundColor = [UIColor redColor];
        _setImge.userInteractionEnabled = NO;
//        [self.contentView addSubview:_setImge];
        
        _setField = [[UITextField alloc]initWithFrame:CGRectMake(55, 5, 200, 40)];
        _setField.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_setField];
        
//        _nullIcon = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_nullIcon setFrame:CGRectMake(10, 50, 40, 40)];
//        _nullIcon.backgroundColor = [UIColor redColor];
//        [self.contentView addSubview:_nullIcon];
//        
//        _nullField = [[UITextField alloc]initWithFrame:CGRectMake(55, 50, 200, 40)];
//        _nullField.backgroundColor = [UIColor grayColor];
//        [self.contentView addSubview:_nullField];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
