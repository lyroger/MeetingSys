//
//  MSMeetingDetailCell.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/8.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSNoticeModel.h"
#import "MSTitleAndDetailView.h"
#import "MSMemberView.h"

@interface MSMeetingDetailCell : UITableViewCell
{
    UIView *bgContentView;
    
    MSTitleAndDetailView *beginTimeView;
    MSTitleAndDetailView *endTimeView;
    
    MSMemberView *memberView;//参会成员
    
    MSTitleAndDetailView *meetindAddressView;//會議地址
    MSTitleAndDetailView *meetingAgendaView;//會議議程
    MSTitleAndDetailView *meetingDemandView;//會議要求
}

- (void)data:(MSNoticeModel*)model;

+ (CGFloat)meetingDetailHeight:(MSNoticeModel*)model;

@end
