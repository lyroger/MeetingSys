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
                                       dpName:(NSString *)dpName
                                         page:(NSInteger)page
                                   networkHUD:(NetworkHUD)hud
                                       target:(id)target
                                      success:(NetResponseBlock)success
{
    CreateParamsDic;
    DicValueSet(keywords, @"keywords");
    DicValueSet(dpName, @"dpName");
    DicValueSet(@(page), @"page");
    DicValueSet(@(15), @"rows");
    return [self dataTaskMethod:HTTPMethodPOST path:@"api/user/getuserlist" params:ParamsDic networkHUD:hud target:target success:success];
}

@end

@implementation MSMeetingDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"beginTime":@"stTime",
             @"demand" : @"requirement",
             @"organizeName":@"organizerName",
             @"organizeId":@"organizer",
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
    detail.organizeId = self.organizeId;
    detail.isDetail = self.isDetail;
    detail.remindId = self.remindId;
    
    return detail;
}

+ (NSURLSessionDataTask *)submitOrderMeetingInfo:(MSMeetingDetailModel*)model
                                      networkHUD:(NetworkHUD)hud
                                          target:(id)target
                                         success:(NetResponseBlock)success
{
    CreateParamsDic;
    DicValueSet(@(model.hideThemeHead), @"disImg");
    DicValueSet(@(model.meetingType), @"meetingType");
    DicValueSet(model.roomId, @"roomId");
    DicValueSet(model.organizeId, @"organizer");
    DicValueSet(model.organizeName, @"organizerName");
    DicValueSet(model.title, @"title");
    DicValueSet(model.agenda, @"agenda");
    DicValueSet(model.demand, @"requirement");
    DicValueSet(model.others, @"others");
    DicValueSet(model.othersName, @"othersName");
    
    DicValueSet(model.customerName, @"customeName");
    DicValueSet(@(model.customerNum), @"customeNum");
    DicValueSet(@(model.insuranceNum), @"customePolicyNum");
    DicValueSet(model.productType, @"customePolicy");
    DicValueSet(@(model.customePay), @"customePay");
    DicValueSet(model.contactNum, @"customeConTel");
    
    if (model.meetingType == MeetingType_Validate) {
        NSString *beginTime = [NSString stringWithFormat:@"%@ %@",model.meetingDay,model.meetingTime];
        DicValueSet(beginTime, @"stTime");
    } else {
        DicValueSet([model.beginTime dateWithFormat:@"yyyy-MM-dd HH:mm"], @"stTime");
        DicValueSet([model.endTime dateWithFormat:@"yyyy-MM-dd HH:mm"], @"endTime");
    }

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
    return [self dataTaskMethod:HTTPMethodPOST path:@"api/meeting/cancel" params:ParamsDic networkHUD:hud target:target success:success];
}

+ (NSURLSessionDataTask *)getHolidayInfoNetworkHUD:(NetworkHUD)hud
                                            target:(id)target
                                           success:(NetResponseBlock)success
{
    return [self dataTaskMethod:HTTPMethodPOST path:@"api/holiday/list" params:nil networkHUD:hud target:target success:success];
}

@end
