//
//  MSNewMeetingTimeCell.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/13.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSNewMeetingTimeCell : UITableViewCell

- (void)title:(NSString *)title mustItem:(BOOL)must begin:(NSString *)begin end:(NSString*)end;

@end