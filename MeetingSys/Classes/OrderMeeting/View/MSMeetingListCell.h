//
//  MSMeetingListCell.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/8.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSMeetingDetailModel.h"

@interface MSMeetingListCell : UITableViewCell

- (void)data:(MSMeetingDetailModel*)model;
+ (CGFloat)meetingListCellHeight;
@end
