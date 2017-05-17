//
//  MSMeetingUserCenterView.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/9.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSMeetingUserCenterViewDelegate;

@interface MSMeetingUserCenterView : UIControl

@property (nonatomic, weak) id<MSMeetingUserCenterViewDelegate> delegate;

- (void)showUserCenterView;

- (void)hideUserCenterView;

@end

@protocol MSMeetingUserCenterViewDelegate <NSObject>

- (void)didClickMeetingUserCenterViewItem:(NSInteger)itemIndex;

@end
