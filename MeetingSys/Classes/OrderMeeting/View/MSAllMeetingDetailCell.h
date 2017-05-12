//
//  MSAllMeetingDetailCell.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/12.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSMeetingDetailCell.h"
#import "MSMeetingDetailModel.h"

@interface MSAllMeetingDetailCell : MSMeetingDetailCell
{
    UIButton *sureButton;
}

- (void)data:(MSMeetingDetailModel*)model;
+ (CGFloat)meetingDetailHeight:(MSMeetingDetailModel*)model;
@end
