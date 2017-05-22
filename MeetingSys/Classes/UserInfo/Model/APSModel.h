//
//  APSModel.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/22.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "BaseModel.h"

@class APSInfo;
@interface APSModel : BaseModel

@property (nonatomic, copy) NSString *_j_msgid;
@property (nonatomic, assign) NSInteger appId;
@property (nonatomic, copy) NSString *appVer;
@property (nonatomic, strong) APSInfo *aps;
@property (nonatomic, copy) NSString *extras;
@property (nonatomic, assign) NSInteger msgId;
@property (nonatomic, assign) NSInteger msgReqId;
@property (nonatomic, assign) NSInteger msgType;
@property (nonatomic, assign) double timestamp;

@end

@interface APSInfo : BaseModel

@property (nonatomic, copy) NSString *alert;
@property (nonatomic, assign) NSInteger badge;
@property (nonatomic, copy) NSString *sound;

@end
