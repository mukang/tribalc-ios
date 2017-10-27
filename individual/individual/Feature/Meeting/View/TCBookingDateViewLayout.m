//
//  TCBookingDateViewLayout.m
//  individual
//
//  Created by 穆康 on 2017/10/25.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBookingDateViewLayout.h"

@implementation TCBookingDateViewLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat itemW = TCScreenWidth / 3.0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = CGSizeMake(itemW, 38);
    self.minimumLineSpacing = 0;
    self.sectionInset = UIEdgeInsetsMake(0, itemW, 0, itemW);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    // 计算最终的可见范围
    CGRect rect;
    rect.origin = proposedContentOffset;
    rect.size = self.collectionView.size;
    
    // 计算collectionView最终中间的x
    CGFloat centerX = proposedContentOffset.x + TCScreenWidth * 0.5;
    // 取得 cell 的布局属性
    NSArray *array = [self layoutAttributesForElementsInRect:rect];
    // 计算最小的间距值
    CGFloat minMargin = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        CGFloat margin = attrs.center.x - centerX;
        if (ABS(minMargin) > ABS(margin)) {
            minMargin = margin;
        }
    }
    
    return CGPointMake(proposedContentOffset.x + minMargin, proposedContentOffset.y);
}

@end
