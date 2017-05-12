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

- (id)copyWithZone:(NSZone *)zone
{
    //实现自定义浅拷贝
    MSMeetingDetailModel *detail = [[MSMeetingDetailModel allocWithZone:zone] init];
    detail.beginTime = self.beginTime;
    detail.endTime = self.endTime;
    detail.address = self.address;
    detail.agenda = self.agenda;
    detail.demand = self.demand;
    detail.members = self.members;
    detail.organizerHeadURL = self.organizerHeadURL;
    detail.title = self.title;
    detail.organizeName = self.organizeName;
    detail.isDetail = self.isDetail;
    
    return detail;
}

@end
