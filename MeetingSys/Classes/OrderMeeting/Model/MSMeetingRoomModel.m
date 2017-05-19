//
//  MSMeetingRoomModel.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/19.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSMeetingRoomModel.h"

@implementation MSMeetingRoomModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"roomId":@"id"};
}

+ (NSURLSessionDataTask *)getRoomsWithMeetingType:(NSInteger)type
                                        beginTime:(NSDate*)begin
                                          endTime:(NSDate*)end
                                       networkHUD:(NetworkHUD)hud
                                           target:(id)target
                                          success:(NetResponseBlock)success
{
    CreateParamsDic;
    DicValueSet(@(type), @"meetingType");
    DicValueSet([begin dateWithFormat:@"yyyy-MM-dd HH:mm"], @"stTime");
    DicValueSet([end dateWithFormat:@"yyyy-MM-dd HH:mm"], @"endTime");
    return [self dataTaskMethod:HTTPMethodPOST path:@"api/meeting/getroombytimeandtype" params:ParamsDic networkHUD:hud target:target success:success];
}
@end
