//
//  ZXCardView.m
//  CardScrollView
//
//  Created by 郑振兴 on 2017/12/7.
//Copyright © 2017年 郑振兴. All rights reserved.
//

#import "ZXCardView.h"
#import "ZXCardViewCell.h"
#import "Masonry.h"
NSString *const CellIdentifier = @"CardCellIdentifier";

CGFloat const HorizontalMargin = 15.0;
CGFloat const ItemMargin = 8.0;

@interface ZXCardView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *panScrollView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger index;
@end

@implementation ZXCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        [self addSubview:self.panScrollView];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
      ;
    }];
    CGFloat panScrollWidth = self.frame.size.width - HorizontalMargin * 2 + ItemMargin;
    NSLog(@"%f", panScrollWidth);
    [_panScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(0, (self.frame.size.width - panScrollWidth) / 2, 0, (self.frame.size.width - panScrollWidth) / 2));
      ;
    }];
    _panScrollView.contentSize = CGSizeMake(panScrollWidth * _subCardViews.count, self.frame.size.height);
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = ({
            [self layoutIfNeeded];
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.minimumLineSpacing = ItemMargin;
            layout.sectionInset = UIEdgeInsetsMake(0, HorizontalMargin, 0, HorizontalMargin);

            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            [self addSubview:collectionView];
            collectionView.backgroundColor = [UIColor clearColor];
            collectionView.showsHorizontalScrollIndicator = NO;
            collectionView.alwaysBounceHorizontal = YES;
            collectionView.clipsToBounds = NO;

            collectionView.dataSource = self;
            collectionView.delegate = self;

            [collectionView registerClass:[ZXCardViewCell class] forCellWithReuseIdentifier:CellIdentifier];
            [collectionView addGestureRecognizer:self.panScrollView.panGestureRecognizer];
            collectionView.panGestureRecognizer.enabled = NO;
            collectionView;
        });
    }
    return _collectionView;
}
- (UIScrollView *)panScrollView
{
    if (!_panScrollView) {
        _panScrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.hidden = YES;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.alwaysBounceHorizontal = YES;
            scrollView.pagingEnabled = YES;
            scrollView.delegate = self;
            scrollView;

        });
    }

    return _panScrollView;
}
- (void)setSubCardViews:(NSArray<UIView *> *)subCardViews
{
    _subCardViews = [subCardViews copy];
    [self.collectionView reloadData];
    [self.panScrollView scrollsToTop];
}
- (void)setIndex:(NSInteger)index
{
    _index = index;
    if (self.[delegate && self.delegate respondsToSelector:@selector(cardView:didScrollToIndex:)]) {
        [self.delegate cardView:self didScrollToIndex:_index];
    }
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    _panScrollView.contentSize = CGSizeMake(_panScrollView.frame.size.width * _subCardViews.count, 0);
    return _subCardViews.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXCardViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    if (indexPath.item < _subCardViews.count) {
        UIView *subCardView = _subCardViews[indexPath.item];
        cell.cardView = subCardView;
    }

    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = self.frame.size.width - HorizontalMargin * 2;
    return CGSizeMake(itemWidth, self.frame.size.height);
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _panScrollView) {
        _collectionView.contentOffset = _panScrollView.contentOffset;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    if (scrollView == _panScrollView) {
        NSInteger index = _panScrollView.contentOffset.x / _panScrollView.frame.size.width;
        if (self.index != index) {
            self.index = index;
        }
    }
}
@end
