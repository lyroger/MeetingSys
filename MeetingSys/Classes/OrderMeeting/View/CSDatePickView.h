//
//  CSDatePickView.h
//  SellHouseManager
//
//  Created by yangxu on 16/5/19.
//  Copyright © 2016年 JiCe. All rights reserved.
//

/* 时间选择视图类 */

#import <UIKit/UIKit.h>

@protocol CSDatePickViewDelegate<NSObject>

- (void)didPickerDate:(NSDate *)date;

@end

@interface CSDatePickView : UIView

@property (nonatomic, weak) id<CSDatePickViewDelegate> delegate;

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, copy) NSString *title;

- (void)showDatePickerView;

@end
