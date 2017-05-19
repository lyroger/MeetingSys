//
//  MSNewMeetingTimeCell.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/13.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSNewMeetingTimeCellDelegate;

@interface MSNewMeetingTimeCell : UITableViewCell

@property (nonatomic, weak) id<MSNewMeetingTimeCellDelegate> delegate;

- (void)title:(NSString *)title mustItem:(BOOL)must begin:(NSString *)begin end:(NSString*)end;

@end

@protocol MSNewMeetingTimeCellDelegate <NSObject>

- (void)didClickSelectDateTimeView:(MSNewMeetingTimeCell*)cell itemIndex:(NSInteger)index;

@end
