//
//  MSAllMeetingDetailCell.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/12.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSMeetingDetailCell.h"
#import "MSMeetingDetailModel.h"

@protocol MSAllMeetingDetailCellDelegate;

@interface MSAllMeetingDetailCell : MSMeetingDetailCell
{
    UIButton *sureButton;
    UIButton *cancelButton;
}

@property (nonatomic,weak) id<MSAllMeetingDetailCellDelegate> delegate;

- (void)data:(MSMeetingDetailModel*)model;
+ (CGFloat)meetingDetailHeight:(MSMeetingDetailModel*)model;
@end

@protocol MSAllMeetingDetailCellDelegate <NSObject>

- (void)didClickMeetingDetailActionCell:(MSAllMeetingDetailCell*)cell action:(NSInteger)action;

@end
