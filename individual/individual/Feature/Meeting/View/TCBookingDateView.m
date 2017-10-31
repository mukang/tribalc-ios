//
//  TCBookingDateView.m
//  individual
//
//  Created by 穆康 on 2017/10/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBookingDateView.h"
#import "TCBookingDateCell.h"
#import "TCBookingDateViewLayout.h"

@interface TCBookingDateView () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate
>

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) NSDate *selecteDate;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) NSUInteger currentIndex;

@property (nonatomic) NSInteger dayCount;
@property (strong, nonatomic) NSMutableArray *bookingDateArray;

@property (strong, nonatomic) NSCalendar *currentCalendar;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (weak, nonatomic) UICollectionView *collectionView;

@end

@implementation TCBookingDateView

- (instancetype)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate selectedDate:(NSDate *)selectedDate {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _startDate = startDate;
        _endDate = endDate;
        _selecteDate = selectedDate;
        [self setupData];
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Privite Methods

- (void)setupData {
    self.bookingDateArray = [NSMutableArray array];
    
    NSDateComponents *comp = [self.currentCalendar components:NSCalendarUnitDay fromDate:_startDate toDate:_endDate options:0];
    _dayCount = comp.day + 1;
    
    _selectedIndex = -1;
    for (int i=0; i<_dayCount; i++) {
        NSDate *date = [self.currentCalendar dateByAddingUnit:NSCalendarUnitDay value:i toDate:_startDate options:0];
        TCBookingDate *bookingDate = [[TCBookingDate alloc] init];
        bookingDate.date = date;
        bookingDate.dateStr = [self.dateFormatter stringFromDate:date];
        if ([self.currentCalendar isDate:date equalToDate:_selecteDate toUnitGranularity:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay]) {
            bookingDate.isSelected = YES;
            _selectedIndex = i;
        }
        [self.bookingDateArray addObject:bookingDate];
    }
}

- (void)setupSubviews {
    TCBookingDateViewLayout *layout = [[TCBookingDateViewLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[TCBookingDateCell class] forCellWithReuseIdentifier:@"TCBookingDateCell"];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCRGBColor(243, 87, 90);
    [self addSubview:lineView];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 2));
        make.centerX.bottom.equalTo(self);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.selectedIndex >= 0) {
        self.currentIndex = self.selectedIndex;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.selectedIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:NO];
    }
    
    if ([self.delegate respondsToSelector:@selector(bookingDateView:didScrollToNewBookingDate:)]) {
        TCBookingDate *bookingDate = self.bookingDateArray[self.currentIndex];
        [self.delegate bookingDateView:self didScrollToNewBookingDate:bookingDate];
    }
}

- (void)fetchCurrentIndexWithScrollView:(UIScrollView *)scrollView {
    int index = (int)roundf(scrollView.contentOffset.x / (TCScreenWidth / 3.0));
    if (self.currentIndex == index) {
        return;
    }
    
    self.currentIndex = index;
    if ([self.delegate respondsToSelector:@selector(bookingDateView:didScrollToNewBookingDate:)]) {
        TCBookingDate *bookingDate = self.bookingDateArray[index];
        [self.delegate bookingDateView:self didScrollToNewBookingDate:bookingDate];
    }
}

#pragma mark - Public Methods

- (void)setNewSelectedDate:(NSDate *)date {
    if (self.selectedIndex >= 0) {
        TCBookingDate *bookingDate = self.bookingDateArray[self.selectedIndex];
        if ([date isEqualToDate:bookingDate.date]) {
            return;
        }
        bookingDate.isSelected = NO;
    }
    
    if (date) {
        for (int i=0; i<self.bookingDateArray.count; i++) {
            TCBookingDate *bookingDate = self.bookingDateArray[i];
            if ([date isEqualToDate:bookingDate.date]) {
                bookingDate.isSelected = YES;
                self.selectedIndex = i;
            }
        }
    } else {
        self.selectedIndex = -1;
    }
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bookingDateArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCBookingDateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TCBookingDateCell" forIndexPath:indexPath];
    cell.bookingDate = self.bookingDateArray[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView scrollToItemAtIndexPath:indexPath
                           atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                   animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self fetchCurrentIndexWithScrollView:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self fetchCurrentIndexWithScrollView:scrollView];
}

#pragma mark - Override Methods

- (NSCalendar *)currentCalendar {
    if (_currentCalendar == nil) {
        _currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _currentCalendar;
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.calendar = self.currentCalendar;
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

@end
