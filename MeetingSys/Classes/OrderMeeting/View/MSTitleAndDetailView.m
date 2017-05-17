//
//  MSTitleAndDetailView.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/11.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSTitleAndDetailView.h"

@implementation MSTitleAndDetailView

- (id)init
{
    if (self = [super init]) {
        self.titleLabel = [UILabel new];
        self.titleLabel.font = kFontPingFangRegularSize(14);
        self.titleLabel.textColor = UIColorHex(0x888888);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.detailLabel = [UILabel new];
        self.detailLabel.numberOfLines = 0;
        self.detailLabel.font = kFontPingFangRegularSize(14);
        self.detailLabel.textColor = UIColorHex(0x333333);
        self.detailLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.detailLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.mas_equalTo(16);
            make.left.right.equalTo(@0);
            make.height.equalTo(@14);
        }];
        
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.left.right.equalTo(@0);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(10);
            make.bottom.equalTo(@(-14));
        }];
        
        self.bottomLine = [UILabel new];
        self.bottomLine.backgroundColor = UIColorHex(0xE3E3E3);
        [self addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            make.height.equalTo(@(0.6));
        }];
    }
    
    return self;
}

+ (CGFloat)titleAndDetailViewHeight:(NSString*)detail width:(CGFloat)width
{
    CGFloat detailHeight = [detail heightWithFont:kFontPingFangRegularSize(14) constrainedToWidth:width];
    CGFloat totalHeight = 16 + 14 + 10 + detailHeight + 16;
    return totalHeight;
}

@end
