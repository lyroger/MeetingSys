//
//  MSMeetingRoomModel.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/19.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "BaseModel.h"

@interface MSMeetingRoomModel : BaseModel

@property (nonatomic, copy) NSString *buildName;
@property (nonatomic, copy) NSString *mMemo;
@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, copy) NSString *mName;
@property (nonatomic, copy) NSString *roomStyle;
@property (nonatomic, assign) NSInteger floor;
@property (nonatomic, assign) NSInteger maxMinutes;

+ (NSURLSessionDataTask *)getRoomsWithMeetingType:(NSInteger)type
                                        beginTime:(NSDate*)begin
                                          endTime:(NSDate*)end
                                       networkHUD:(NetworkHUD)hud
                                           target:(id)target
                                          success:(NetResponseBlock)success;

@end
