//
//  CyclicCardCell.h
//  DemoList
//
//  Created by luoyan on 17/2/22.
//  Copyright © 2017年 luoyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSMeetingDetailModel.h"

@interface CyclicCardCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

- (void)data:(MSMeetingDetailModel*)model;

@end
