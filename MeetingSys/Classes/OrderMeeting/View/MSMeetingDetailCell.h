//
//  MSMeetingDetailCell.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/8.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSNoticeModel.h"

@interface MSMeetingDetailCell : UITableViewCell

- (void)data:(MSNoticeModel*)model;

+ (CGFloat)meetingDetailHeight:(MSNoticeModel*)model;

@end
