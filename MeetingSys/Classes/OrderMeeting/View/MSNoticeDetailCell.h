//
//  MSNoticeDetailCell.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/22.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSMeetingDetailCell.h"

@protocol MSNoticeDetailCellDelegate;
@interface MSNoticeDetailCell : MSMeetingDetailCell
{
    UIButton *sureButton;
}

@property (nonatomic, weak) id<MSNoticeDetailCellDelegate> delegate;
- (void)data:(MSMeetingDetailModel*)model;
@end

@protocol MSNoticeDetailCellDelegate <NSObject>

- (void)didClickNoticeDetailSureActionCell:(MSNoticeDetailCell*)cell;

@end
