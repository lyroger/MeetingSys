//
//  MSOrderMeetingButtonView.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/8.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSOrderMeetingButtonView.h"

@interface MSOrderMeetingButtonView()
{
    
}

@end

@implementation MSOrderMeetingButtonView

- (id)init
{
    if (self = [super init]) {
        UIImageView *meetingIcon = [UIImageView new];
        meetingIcon.image = [UIImage imageNamed:@"addmeeting_add"];
        [self addSubview:meetingIcon];
        
        UILabel *tipsLabel = [UILabel new];
        tipsLabel.text = @"新增預約";
        tipsLabel.font = kFontPingFangRegularSize(16);
        tipsLabel.textColor = UIColorHex(0xffffff);
        [self addSubview:tipsLabel];
        
        UIImageView *upIcon = [UIImageView new];
        upIcon.image = [UIImage imageNamed:@"addmeeting_up_icon"];
        [self addSubview:upIcon];
        
        [meetingIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@30);
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.centerY.equalTo(self);
        }];
        
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(meetingIcon.mas_right).mas_offset(10);
            make.centerY.equalTo(self);
        }];
        
        [upIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-30));
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(15, 12));
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)clickAction:(UITapGestureRecognizer*)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOrder:)]) {
        [self.delegate didClickOrder:self];
    }
}
@end
