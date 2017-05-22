//
//  MSNoticeCellView.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/8.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSMeetingDetailModel.h"

@interface MSNoticeCellView : UITableViewCell

- (void)data:(MSMeetingDetailModel*)dataModel;
+ (CGFloat)noticeCellHeight;
@end
