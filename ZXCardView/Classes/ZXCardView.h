//
//  ZXCardView.h
//  CardScrollView
//
//  Created by 郑振兴 on 2017/12/7.
//Copyright © 2017年 郑振兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXCardView;

@protocol ZXCardViewDelegate <NSObject>
- (void)cardView:(ZXCardView *)cardView didScrollToIndex:(NSInteger)index;
@end

@interface ZXCardView : UIView
@property (nonatomic, weak) id<ZXCardViewDelegate> delegate;
@property (nonatomic, strong) NSArray<UIView *> *subCardViews;
@end
