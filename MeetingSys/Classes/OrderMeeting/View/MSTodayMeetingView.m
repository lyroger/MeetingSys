//
//  MSTodayMeetingView.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/12.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSTodayMeetingView.h"
#import "HJCarouselViewLayout.h"
#import "CyclicCardCell.h"

@interface MSTodayMeetingView()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    
}

@property (nonatomic,strong) UICollectionView *collectView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation MSTodayMeetingView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        HJCarouselViewLayout *flowLayout = [[HJCarouselViewLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(kScreenWidth-100, 151);
        self.collectView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        [self.collectView registerClass:[CyclicCardCell class] forCellWithReuseIdentifier:NSStringFromClass([CyclicCardCell class])];
        self.collectView.delegate = self;
        self.collectView.dataSource = self;
        self.collectView.backgroundColor = [UIColor whiteColor];
        self.collectView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.collectView];
    }
    return self;
}

- (void)reloadWithDatas:(NSArray*)datas
{
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:datas];
    [self.collectView reloadData];
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了：%zd",indexPath.row);
}

#pragma mark UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CyclicCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CyclicCardCell class]) forIndexPath:indexPath];
    MSMeetingDetailModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell data:model];
    return cell;
}

- (NSMutableArray*)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
