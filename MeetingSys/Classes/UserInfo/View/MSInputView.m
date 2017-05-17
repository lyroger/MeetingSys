//
//  MSInputView.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/17.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSInputView.h"

@interface MSInputView()
{
    UILabel *titleLabel;
}

@end

@implementation MSInputView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        titleLabel = [UILabel new];
        titleLabel.font = kFontPingFangRegularSize(16);
        titleLabel.textColor = UIColorHex(0x333333);
        [self addSubview:titleLabel];
        
        self.textField = [UITextField new];
        self.textField.font = kFontPingFangRegularSize(16);
        self.textField.textColor = UIColorHex(0xbbbbbb);
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.secureTextEntry = YES;
        
        [self addSubview:self.textField];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(@15);
            make.right.equalTo(@(-15));
            make.bottom.mas_equalTo(self.textField.mas_top).mas_offset(-20);
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.right.equalTo(titleLabel);
            make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(20);
            make.bottom.mas_equalTo(-15);
        }];
    
    }
    
    return self;
}
- (void)title:(NSString *)title placeholder:(NSString*)placeholder
{
    titleLabel.text = title;
    self.textField.placeholder = placeholder;
}
@end
