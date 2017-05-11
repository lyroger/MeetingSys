//
//  MSMeetingDetailModel.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/11.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSMeetingDetailModel.h"

@implementation MSMemberModel


@end

@implementation MSMeetingDetailModel

- (NSMutableArray*)members
{
    if (!_members) {
        _members = [[NSMutableArray alloc] init];
    }
    return _members;
}

@end
