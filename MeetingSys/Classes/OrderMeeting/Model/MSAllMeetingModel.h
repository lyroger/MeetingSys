//
//  MSAllMeetingModel.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/12.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "BaseModel.h"
#import "MSMeetingDetailModel.h"

@interface MSAllMeetingModel : BaseModel


@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) BOOL firstPage;
@property (nonatomic, assign) BOOL lastPage;
@property (nonatomic, assign) BOOL hasNextPage;

@property (nonatomic, strong) NSMutableArray *todayList;
@property (nonatomic, strong) NSMutableArray *dayGroupList;

+ (NSURLSessionDataTask *)meetingListNetworkHUD:(NetworkHUD)hud
                                           page:(NSInteger)page
                                         target:(id)target
                                        success:(NetResponseBlock)success;

@end

@interface MSDayGroupList : BaseModel

@property (nonatomic, copy) NSString *meetingDate;
@property (nonatomic, strong) NSMutableArray *list;

@end
