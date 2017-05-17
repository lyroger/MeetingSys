//
//  MSMeetingDetailModel.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/11.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "BaseModel.h"

@interface MSMemberModel : BaseModel

@property (nonatomic,copy) NSString *memberId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *headURL;

+ (NSURLSessionDataTask *)memberHeadsWithIds:(NSString *)ids
                                  NetworkHUD:(NetworkHUD)hud
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
@property (nonatomic, copy) NSString *others; // 參會人員 id 列表
@property (nonatomic, copy) NSString *othersName; // 參會人員名稱列表
@property (nonatomic, copy) NSString *mtStatus;// 會議狀態  0-初始  1-正常結束  2- No show 3-已確認

@property (nonatomic, copy) NSString *organizerHeadURL;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *organizeName;

@property (nonatomic, assign) BOOL   isDetail;
@property (nonatomic, assign) BOOL   isUnfold;
@property (nonatomic, assign) BOOL   isLoadedHeadURL;


@end
