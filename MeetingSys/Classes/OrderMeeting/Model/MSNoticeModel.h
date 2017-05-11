//
//  MSNoticeModel.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/11.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "BaseModel.h"
#import "MSMeetingDetailModel.h"

@interface MSNoticeModel : BaseModel

@property (nonatomic, copy) NSString *headURL;
@property (nonatomic, copy) NSString *noticeTitle;
@property (nonatomic, copy) NSString *noticeContent;
@property (nonatomic, copy) NSString *meetingDate;
@property (nonatomic, copy) NSString *noticeDate;

@property (nonatomic, strong) MSMeetingDetailModel *meetingDetailModel;

//附加屬性
@property (nonatomic, assign) BOOL isUnfold;//是否展開

@end
