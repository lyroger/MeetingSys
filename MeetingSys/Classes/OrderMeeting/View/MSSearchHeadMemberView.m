//
//  MSSearchHeadMemberView.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/25.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSSearchHeadMemberView.h"
#import "MSMemberCollectionCell.h"

@interface MSSearchHeadMemberView()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    
}
@property (nonatomic, strong) UILabel          *titleLabel;
@property (nonatomic, strong) UICollectionView *myCollectionView;

@end

@implementation MSSearchHeadMemberView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = UIColorHex(0x333333);
        self.titleLabel.font = kFontPingFangRegularSize(16);
        self.titleLabel.text = @"參與人員";
        [self addSubview:self.titleLabel];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.titleLabel.height, self.width, frame.size.height-self.titleLabel.height) collectionViewLayout:flowLayout];
        self.myCollectionView.backgroundColor = UIColorHex(0xffffff);
        self.myCollectionView.showsHorizontalScrollIndicator = NO;
        self.myCollectionView.showsVerticalScrollIndicator = NO;
        [self.myCollectionView registerClass:[MSMemberCollectionCell class] forCellWithReuseIdentifier:@"MSMemberCollectionCell"];
        self.myCollectionView.dataSource = self;
        self.myCollectionView.delegate = self;
        self.myCollectionView.scrollsToTop = NO;
        [self addSubview:self.myCollectionView];
    }
    return self;
}

- (void)reloadView
{
    [self.myCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSMemberCollectionCell *memberCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSMemberCollectionCell" forIndexPath:indexPath];
    
    MSMemberModel *member = [self.dataSources objectAtIndex:indexPath.row];
    
    [memberCell.imageHead sd_setImageWithURL:kImageURLWithLastString(member.headURL) placeholderImage:[UIImage imageNamed:@"portrait_xiao"]];
    memberCell.memberModel = member;
//    [memberCell bindRAC];
    memberCell.labelName.text = member.name;
    @weakify(self)
    memberCell.clickBlock = ^(MSMemberCollectionCell *view) {
        @strongify(self)
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickMemberCollectionCell:)]) {
            [self.delegate didClickMemberCollectionCell:view];
        }
    };
    
    return memberCell;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 90);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
