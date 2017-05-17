//
//  MSMemberView.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/11.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSMeetingDetailModel.h"
//#import "MSMemberModel.h"

@interface MSMemberCellView : UIView

@property (nonatomic,strong) UIImageView *imageHead;
@property (nonatomic,strong) UILabel     *labelName;
@property (nonatomic,strong) MSMemberModel *memberModel;

- (void)bindRAC;

@end

@interface MSMemberView : UIView

@property (nonatomic, strong) UILabel *bottomLine;

- (void)membersData:(NSArray*)datas;

@end
