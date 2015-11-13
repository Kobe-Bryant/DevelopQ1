//
//  dyCardCollectionCell.m
//  ql
//
//  Created by yunlai on 14-5-12.
//  Copyright (c) 2014年 LuoHui. All rights reserved.
//

#import "dyCardCollectionCell.h"

#import "DynamicCardView.h"

@implementation dyCardCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGSize size = [UIScreen mainScreen].bounds.size;
        self.contentView.frame = CGRectMake(0, 0, size.width, size.height - 64);
        self.contentView.backgroundColor = [UIColor clearColor];

        self.contentView.layer.cornerRadius = 5.0;
//        self.contentView.layer.borderColor = [UIColor darkGrayColor].CGColor;
//        self.contentView.layer.borderWidth = 0.1;
        
        self.contentView.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView.transform = CGAffineTransformMakeScale(0.95, 0.95);
        
        [self setup];
    }
    return self;
}

-(void) setup{
//    _cardView = [[UIImageView alloc] init];
//    _cardView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
//    [self.contentView addSubview:_cardView];
}

-(void) setCardV:(UIView *)cardV{
    //阴影
    UIImageView* textBg = [[UIImageView alloc] init];
    textBg.image = IMG(@"img_feed_up_shadow");
    textBg.frame = CGRectMake(self.bounds.size.width*(1-0.95)/2, -17, self.bounds.size.width*0.95, 30);
    textBg.alpha = 0.3;
    [self addSubview:textBg];
    [textBg release];
    
    [self.contentView addSubview:cardV];
    
    UIView* v = [[UIView alloc] init];
    v.frame = self.bounds;
    v.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:v];
    [v release];
}

-(void) setDataDic:(NSDictionary *)dataDic{
    //阴影
    UIImageView* textBg = [[UIImageView alloc] init];
    textBg.image = IMG(@"img_feed_up_shadow");
    textBg.frame = CGRectMake(self.bounds.size.width*(1-0.95)/2, -17, self.bounds.size.width*0.95, 30);
    textBg.alpha = 0.3;
    [self addSubview:textBg];
    [textBg release];
    
    int type = [[dataDic objectForKey:@"type"] intValue];
    
    NSLog(@"type:%d",type);
    CardType cardT;
    if (type == 0) {
        cardT = CardImage;
    }else if (type == 1) {
        cardT = CardOOXX;
    }else if (type == 2) {
        cardT = CardOpenTime;
    }else if (type == 3) {
        cardT = CardWantOrHave;
    }else if (type == 4){
        cardT = CardWantOrHave;
    }else if (type == 5){
        cardT = CardNews;
    }else if (type == 6) {
        cardT = CardLabel;
    }else{
        cardT = CardImage;
    }
    
    DynamicCardView* cardv = [[DynamicCardView alloc] initWithCardType:cardT data:dataDic frame:self.bounds showType:CardShowTypeThum];
    
    [self.contentView addSubview:cardv];
    RELEASE_SAFE(cardv);
    
    UIView* v = [[UIView alloc] init];
    v.frame = self.bounds;
    v.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:v];
    [v release];
}

-(void) dealloc{
    [_dataDic release];
    [_cardView release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
