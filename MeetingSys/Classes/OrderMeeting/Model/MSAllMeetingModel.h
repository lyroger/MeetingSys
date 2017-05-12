//
//  MSAllMeetingModel.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/12.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "BaseModel.h"

@interface MSAllMeetingModel : BaseModel

@property (nonatomic, strong) NSMutableArray *todayList;
@property (nonatomic, strong) NSMutableArray *dayGroupList;

@end

@interface MSDayGroupList : BaseModel

@property (nonatomic, copy) NSString *meetingDate;
@property (nonatomic, strong) NSMutableArray *list;

@end
