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
        UIImageView *bgIcon = [UIImageView new];
        bgIcon.image = [UIImage imageNamed:@"new_bg"];
        [self addSubview:bgIcon];
        
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
        
        [bgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@(-5));
            make.right.bottom.equalTo(@5);
        }];
        
        [meetingIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@30);
            make.size.mas_equalTo(CGSizeMake(24, 24));
            make.centerY.equalTo(self);
        }];
        
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(meetingIcon.mas_right).mas_offset(15);
            make.centerY.equalTo(self);
        }];
        
        [upIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-30));
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(15, 10));
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
