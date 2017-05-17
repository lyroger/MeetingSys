//
//  MSInputView.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/17.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSInputView : UIView

@property (nonatomic, strong) UITextField *textField;

- (void)title:(NSString *)title placeholder:(NSString*)placeholder;


@end
