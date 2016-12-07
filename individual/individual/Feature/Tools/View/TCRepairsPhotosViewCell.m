//
//  TCRepairsPhotosViewCell.m
//  individual
//
//  Created by 穆康 on 2016/12/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRepairsPhotosViewCell.h"

#import "TCRepairsPhotoViewCell.h"

static NSInteger const kMaxPhotoItems = 3;

@interface TCRepairsPhotosViewCell () <UICollectionViewDataSource, UICollectionViewDelegate, TCRepairsPhotoViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation TCRepairsPhotosViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setupSubviews];
}

- (void)setupSubviews {
    CGFloat margin = 20;
    CGFloat itemWH = floorf((TCScreenWidth - (kMaxPhotoItems - 1) * margin) / kMaxPhotoItems);
    self.flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
    self.flowLayout.minimumInteritemSpacing = margin;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    
    self.collectionView.scrollEnabled = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:@"TCRepairsPhotoViewCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"TCRepairsPhotoViewCell"];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.selectedPhotos.count < 3) {
        return self.selectedPhotos.count + 1;
    }
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCRepairsPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TCRepairsPhotoViewCell" forIndexPath:indexPath];
    if (indexPath.item == self.selectedPhotos.count) {
        cell.hideAddButton = NO;
    } else {
        cell.hideAddButton = YES;
        cell.imageView.image = self.selectedPhotos[indexPath.item];
    }
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - TCRepairsPhotoViewCellDelegate

- (void)didClickAddButtonInRepairsPhotoViewCell:(TCRepairsPhotoViewCell *)cell {
    if ([self.delegate respondsToSelector:@selector(didClickAddButtonInRepairsPhotosViewCell:)]) {
        [self.delegate didClickAddButtonInRepairsPhotosViewCell:self];
    }
}

- (void)didClickDeleteButtonInRepairsPhotoViewCell:(TCRepairsPhotoViewCell *)cell {
    if ([self.delegate respondsToSelector:@selector(didClickDeleteButtonInRepairsPhotosViewCell:)]) {
        [self.delegate didClickDeleteButtonInRepairsPhotosViewCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
