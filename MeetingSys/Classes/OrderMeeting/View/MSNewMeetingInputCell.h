//
//  MSNewMeetingInputCell.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/13.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSNewMeetingInputCell : UITableViewCell

- (void)multipleLineInput:(BOOL)multiple title:(NSString *)title placeholder:(NSString *)placeholder must:(BOOL)must;

@end
