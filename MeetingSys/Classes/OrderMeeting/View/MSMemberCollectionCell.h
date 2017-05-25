//
//  MSMemberCollectionCell.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/25.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSMeetingDetailModel.h"

@class MSMemberCollectionCell;

typedef void(^MSMemberCollectionCellViewClickBlock)(MSMemberCollectionCell *view);

@interface MSMemberCollectionCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *imageHead;
@property (nonatomic,strong) UILabel     *labelName;
@property (nonatomic,strong) MSMemberModel *memberModel;
@property (nonatomic,copy)   MSMemberCollectionCellViewClickBlock clickBlock;

- (void)bindRAC;
@end
