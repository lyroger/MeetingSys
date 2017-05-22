//
//  MSNewMeetingHeadView.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/13.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSNewMeetingHeadViewDelegate;
@interface MSNewMeetingHeadView : UIView

@property (nonatomic,weak) id<MSNewMeetingHeadViewDelegate> delegate;

- (void)theme:(NSString*)theme hideImage:(BOOL)hide;

- (void)reloadHeadImage:(UIImage*)image;

@end

@protocol MSNewMeetingHeadViewDelegate <NSObject>

- (void)didClickHeadView;

@end
