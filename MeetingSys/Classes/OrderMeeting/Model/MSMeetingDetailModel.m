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

//@property (nonatomic, copy) NSString *beginTime;
//@property (nonatomic, copy) NSString *endTime;
//@property (nonatomic, copy) NSString *address;
//@property (nonatomic, copy) NSString *agenda;
//@property (nonatomic, copy) NSString *demand;
//@property (nonatomic, strong) NSMutableArray *members;
//
//@property (nonatomic, copy) NSString *organizerHeadURL;
//@property (nonatomic, copy) NSString *title;
//@property (nonatomic, copy) NSString *organizeName;
//
//@property (nonatomic, assign) BOOL   isDetail;

- (id)copyWithZone:(NSZone *)zone
{
    //实现自定义浅拷贝
    MSMeetingDetailModel *detail = [[self class] allocWithZone:zone];
    detail.beginTime =_beginTime;
    detail.endTime =_endTime;
    detail.address =_address;
    detail.agenda =_agenda;
    detail.demand =_demand;
    detail.members =_members;
    detail.organizerHeadURL =_organizerHeadURL;
    detail.title =_title;
    detail.organizeName =_organizeName;
    detail.isDetail = _isDetail;
    
    return detail;
}

@end
