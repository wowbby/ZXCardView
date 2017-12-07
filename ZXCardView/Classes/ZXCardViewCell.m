//
//  ZXCardViewCell.m
//  CardScrollView
//
//  Created by 郑振兴 on 2017/12/7.
//Copyright © 2017年 郑振兴. All rights reserved.
//

#import "ZXCardViewCell.h"
#import "Masonry.h"
@implementation ZXCardViewCell
@synthesize cardView = _cardView;
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        [self.contentView addSubview:self.cardView];
    }
    return self;
}
- (void)setCardView:(UIView *)cardView
{
    cardView.frame = _cardView.frame;
    _cardView = cardView;
    [self addSubview:self.cardView];
    _cardView.layer.masksToBounds = YES;
    _cardView.layer.cornerRadius = 5.0f;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_cardView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
- (UIView *)cardView
{
    if (!_cardView) {
        _cardView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor redColor];
            view;
        });
    }

    return _cardView;
}
@end
