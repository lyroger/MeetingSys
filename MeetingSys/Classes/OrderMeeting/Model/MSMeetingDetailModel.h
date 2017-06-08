//
//  MSMeetingDetailModel.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/11.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSInteger, MeetingOrder_Type)
{
    MeetingType_Train       = 1,      //理财培训学院
    MeetingType_Money       = 2,      //理财中心
    MeetingType_Validate    = 3,      //验证中心
};

@interface MSMemberModel : BaseModel

@property (nonatomic,copy) NSString *memberId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *headURL;

@property (nonatomic,assign) BOOL isSelected;

+ (NSURLSessionDataTask *)memberHeadsWithIds:(NSString *)ids
                                  NetworkHUD:(NetworkHUD)hud
                                      target:(id)target
                                     success:(NetResponseBlock)success;

+ (NSURLSessionDataTask *)getuserlistKeywords:(NSString *)keywords
                                       dpName:(NSString *)dpName
                                         page:(NSInteger)page
                                   networkHUD:(NetworkHUD)hud
                                       target:(id)target
                                      success:(NetResponseBlock)success;

@end

@interface MSMeetingDetailModel : BaseModel<NSCopying>

@property (nonatomic, strong) NSDate *beginTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *agenda;
@property (nonatomic, copy) NSString *demand;
@property (nonatomic, strong) NSMutableArray *members;
@property (nonatomic, assign) NSInteger meetingType;//會議類型；
@property (nonatomic, copy) NSString *roomId;//會議室ID
@property (nonatomic, copy) NSString *roomTheme;//主题
@property (nonatomic, copy) NSString *roomTimeTips;//最大时长提示
@property (nonatomic, copy) NSString *others; // 參會人員 id 列表
@property (nonatomic, copy) NSString *othersName; // 參會人員名稱列表
@property (nonatomic, copy) NSString *mtStatus;// 會議狀態  0-初始  1-正常結束  2- No show 3-已確認 4-取消 5-正在进行

@property (nonatomic, copy) NSString *remindConent;//提醒內容
@property (nonatomic, assign) NSInteger remindType;//提醒类型
@property (nonatomic,strong) NSDate  *sendDate;//發送時間
@property (nonatomic, copy) NSString *remindId;//提醒ID；

@property (nonatomic, copy) NSString *meetingDay;       //验证类型预约日期
@property (nonatomic, copy) NSString *meetingTime;      //验证类型预约时间段
@property (nonatomic, copy) NSString *customerName;     //客戶姓名
@property (nonatomic, assign) NSInteger customerNum;    //客人數
@property (nonatomic, assign) NSInteger insuranceNum;   //保单数
@property (nonatomic, copy) NSString *productType;      //产品类别
@property (nonatomic, assign) NSInteger customePay;     //是否即时缴费 0是，1否
@property (nonatomic, copy) NSString *contactNum;       //联系电话；

@property (nonatomic, copy) NSString *organizerHeadURL;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *organizeName;
@property (nonatomic, copy) NSString *organizeId;

@property (nonatomic, assign) BOOL   isDetail;
@property (nonatomic, assign) BOOL   isUnfold;
@property (nonatomic, assign) BOOL   isLoadedHeadURL;
@property (nonatomic, assign) NSInteger hideThemeHead;

+ (NSURLSessionDataTask *)submitOrderMeetingInfo:(MSMeetingDetailModel*)model
                                      networkHUD:(NetworkHUD)hud
                                          target:(id)target
                                         success:(NetResponseBlock)success;

+ (NSURLSessionDataTask *)getNoticesNetworkHUD:(NetworkHUD)hud
                                        target:(id)target
                                       success:(NetResponseBlock)success;

+ (NSURLSessionDataTask *)didReadNoticeInfo:(NSString*)infoId
                                 networkHUD:(NetworkHUD)hud
                                     target:(id)target
                                    success:(NetResponseBlock)success;

+ (NSURLSessionDataTask *)cancelMeetingInfo:(NSString*)meetingId
                                 networkHUD:(NetworkHUD)hud
                                     target:(id)target
                                    success:(NetResponseBlock)success;

+ (NSURLSessionDataTask *)getHolidayInfoNetworkHUD:(NetworkHUD)hud
                                            target:(id)target
                                           success:(NetResponseBlock)success;


@end
