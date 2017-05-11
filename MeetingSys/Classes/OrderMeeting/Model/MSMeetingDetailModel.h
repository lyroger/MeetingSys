//
//  MSMeetingDetailModel.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/11.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "BaseModel.h"

@interface MSMeetingDetailModel : BaseModel

@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *agenda;
@property (nonatomic, copy) NSString *demand;

@end
