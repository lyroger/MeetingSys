//
//  MSAllMeetingModel.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/12.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSAllMeetingModel.h"

@implementation MSAllMeetingModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"todayList" : [MSMeetingDetailModel class],
             @"dayGroupList" : [MSDayGroupList class]};
}

- (NSMutableArray*)dayGroupList
{
    if (!_dayGroupList) {
        _dayGroupList = [[NSMutableArray alloc] init];
    }
    return _dayGroupList;
}

- (NSMutableArray*)todayList
{
    if (!_todayList) {
        _todayList = [[NSMutableArray alloc] init];
    }
    return _todayList;
}

+ (NSURLSessionDataTask *)meetingListNetworkHUD:(NetworkHUD)hud
                                           page:(NSInteger)page
                                         target:(id)target
                                        success:(NetResponseBlock)success
{
    CreateParamsDic;
    DicObjectSet(@(page), @"page");
    DicObjectSet(@(5), @"rows");
    return [self dataTaskMethod:HTTPMethodPOST path:@"api/meeting/listMeetings" params:ParamsDic networkHUD:hud target:target success:success];
}

@end


@implementation MSDayGroupList

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list" : [MSMeetingDetailModel class]};
}

- (NSMutableArray*)list
{
    if (!_list) {
        _list = [[NSMutableArray alloc] init];
    }
    return _list;
}

@end
