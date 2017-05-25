//
//  MSSearchBottomView.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/25.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSSearchBottomView.h"

@interface MSSearchBottomView()
{
    UIImageView *meetingIcon;
}

@end

@implementation MSSearchBottomView

- (id)init
{
    if (self = [super init]) {
        self.isSelectedAll = NO;
        
        meetingIcon = [UIImageView new];
        meetingIcon.image = [UIImage imageNamed:@"people_selected_off"];
        [self addSubview:meetingIcon];
        
        UILabel *tipsLabel = [UILabel new];
        tipsLabel.text = @"全選";
        tipsLabel.font = kFontPingFangRegularSize(16);
        tipsLabel.textColor = UIColorHex(0xFF7B54);
        [self addSubview:tipsLabel];
        
        
        [meetingIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.size.mas_equalTo(CGSizeMake(18, 18));
            make.centerY.equalTo(self);
        }];
        
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(meetingIcon.mas_right).mas_offset(15);
            make.centerY.equalTo(self);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)setSelectedAllStatus:(BOOL)seletedAll
{
    self.isSelectedAll = seletedAll;
    if (self.isSelectedAll) {
        meetingIcon.image = [UIImage imageNamed:@"people_selected"];
    } else {
        meetingIcon.image = [UIImage imageNamed:@"people_selected_off"];
    }
}

- (void)clickAction:(UITapGestureRecognizer*)gesture
{
    self.isSelectedAll = !self.isSelectedAll;
    if (self.isSelectedAll) {
        meetingIcon.image = [UIImage imageNamed:@"people_selected"];
    } else {
        meetingIcon.image = [UIImage imageNamed:@"people_selected_off"];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAllSelected:)]) {
        [self.delegate didClickAllSelected:self];
    }
}
@end
