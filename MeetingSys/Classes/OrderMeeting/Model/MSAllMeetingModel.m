//
//  MSAllMeetingModel.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/12.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSAllMeetingModel.h"

@implementation MSAllMeetingModel

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

@end


@implementation MSDayGroupList

- (NSMutableArray*)list
{
    if (!_list) {
        _list = [[NSMutableArray alloc] init];
    }
    return _list;
}

@end
