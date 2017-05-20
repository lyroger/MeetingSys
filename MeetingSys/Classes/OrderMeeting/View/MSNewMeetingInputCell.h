//
//  MSNewMeetingInputCell.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/13.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MeetingInputBlock)(NSString *inputText);

@interface MSNewMeetingInputCell : UITableViewCell

@property (nonatomic,copy) MeetingInputBlock inputBlock;

- (void)multipleLineInput:(BOOL)multiple title:(NSString *)title placeholder:(NSString *)placeholder must:(BOOL)must;

- (void)contentText:(NSString*)text multipleLine:(BOOL)multiple;
@end
