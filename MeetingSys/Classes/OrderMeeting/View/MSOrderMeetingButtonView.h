//
//  MSOrderMeetingButtonView.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/8.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MSOrderMeetingButtonViewDelegate;

@interface MSOrderMeetingButtonView : UIView

@property (nonatomic, weak) id<MSOrderMeetingButtonViewDelegate> delegate;

@end

@protocol MSOrderMeetingButtonViewDelegate <NSObject>

- (void)didClickOrder:(MSOrderMeetingButtonView*)view;

@end
