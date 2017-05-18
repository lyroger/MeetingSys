//
//  MSMeetingDetailModel.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/11.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSMeetingDetailModel.h"


@implementation MSMemberModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"memberId":@"id",
             @"headURL" : @"avater",
             @"name":@"nickName"};
}

+ (NSURLSessionDataTask *)memberHeadsWithIds:(NSString *)ids
                                  NetworkHUD:(NetworkHUD)hud
                                      target:(id)target
                                     success:(NetResponseBlock)success
{
    CreateParamsDic;
    DicValueSet(ids, @"ids");
    return [self dataTaskMethod:HTTPMethodPOST path:@"api/user/getusersavater" params:ParamsDic networkHUD:hud target:target success:success];
}


+ (NSURLSessionDataTask *)getuserlistKeywords:(NSString *)keywords
                                         page:(NSInteger)page
                                   networkHUD:(NetworkHUD)hud
                                       target:(id)target
                                      success:(NetResponseBlock)success
{
    CreateParamsDic;
    DicObjectSet(keywords, @"keywords");
    DicObjectSet(@(page), @"page");
    DicObjectSet(@(15), @"rows");
    return [self dataTaskMethod:HTTPMethodPOST path:@"api/user/getuserlist" params:ParamsDic networkHUD:hud target:target success:success];
}

@end

@implementation MSMeetingDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"beginTime":@"stTime",
             @"demand" : @"requirement",
             @"organizeName":@"organizerName",
             @"address":@"mName",
             @"organizerHeadURL":@"orgAvater"
             };
}

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
