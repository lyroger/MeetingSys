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
             @"organizerHeadURL":@"orgAvater",
             @"sendDate":@"createDate",
             @"remindId":@"id"};
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

+ (NSURLSessionDataTask *)submitOrderMeetingInfo:(MSMeetingDetailModel*)model
                                      networkHUD:(NetworkHUD)hud
                                          target:(id)target
                                         success:(NetResponseBlock)success
{
    CreateParamsDic;
    DicValueSet(@(model.hideThemeHead), @"disImg");
    DicValueSet(model.title, @"title");
    DicValueSet(@(model.meetingType), @"meetingType");
    DicValueSet([model.beginTime dateWithFormat:@"yyyy-MM-dd HH:mm"], @"stTime");
    DicValueSet([model.endTime dateWithFormat:@"yyyy-MM-dd HH:mm"], @"endTime");
    DicValueSet(model.roomId, @"roomId");
    DicValueSet(model.organizeId, @"organizer");
    DicValueSet(model.organizeName, @"organizerName");
    DicValueSet(model.others, @"others");
    DicValueSet(model.othersName, @"othersName");
    DicValueSet(model.agenda, @"agenda");
    DicValueSet(model.demand, @"requirement");
    return [self dataTaskMethod:HTTPMethodPOST path:@"api/meeting/saveorupdate" params:ParamsDic networkHUD:hud target:target success:success];
}

+ (NSURLSessionDataTask *)getNoticesNetworkHUD:(NetworkHUD)hud
                                        target:(id)target
                                       success:(NetResponseBlock)success
{
    return [self dataTaskMethod:HTTPMethodPOST path:@"api/remind/userreminds" params:nil networkHUD:hud target:target success:success];
}

+ (NSURLSessionDataTask *)didReadNoticeInfo:(NSString*)infoId
                                 networkHUD:(NetworkHUD)hud
                                     target:(id)target
                                    success:(NetResponseBlock)success
{
    CreateParamsDic;
    DicValueSet(infoId, @"id");
    return [self dataTaskMethod:HTTPMethodPOST path:@"api/remind/setread" params:ParamsDic networkHUD:hud target:target success:success];
}

+ (NSURLSessionDataTask *)cancelMeetingInfo:(NSString*)meetingId
                                 networkHUD:(NetworkHUD)hud
                                     target:(id)target
                                    success:(NetResponseBlock)success
{
    CreateParamsDic;
    DicValueSet(meetingId, @"id");
    return [self dataTaskMethod:HTTPMethodPOST path:@"" params:ParamsDic networkHUD:hud target:target success:success];
}

@end
