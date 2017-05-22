//
//  MSNewMeetingONOffCell.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/16.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MeetingONOffCellActionBlock)(BOOL isON);

@interface MSNewMeetingONOffCell : UITableViewCell

@property (nonatomic,copy) MeetingONOffCellActionBlock actionBlock;

- (void)title:(NSString *)title mustItem:(BOOL)must on:(BOOL)on;

- (void)setSwitchEnble:(BOOL)enble;

@end
