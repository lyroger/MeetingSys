//
//  MSSelMemberCell.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/18.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSMeetingDetailModel.h"

@interface MSSelMemberCell : UITableViewCell

- (void)data:(MSMemberModel*)model;
- (void)showSelected:(BOOL)show;
@end
