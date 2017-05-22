//
//  MSTodayMeetingView.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/12.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAllMeetingDetailCell.h"

@protocol MSToDayMeetingViewDelegate;

@interface MSTodayMeetingView : UIView

@property (nonatomic, weak) id<MSToDayMeetingViewDelegate> delegate;

- (void)reloadWithDatas:(NSArray*)datas;
@end

@protocol MSToDayMeetingViewDelegate <NSObject>

- (void)didClickToDayMeetingView:(MSTodayMeetingView*)view itemIndex:(NSInteger)index;
- (void)scrollEndToDayMeetingView:(MSTodayMeetingView*)view itemIndex:(NSInteger)index;

@end
