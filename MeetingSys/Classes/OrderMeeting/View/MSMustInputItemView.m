//
//  MSMustInputItemView.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/15.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSMustInputItemView.h"

@interface MSMustInputItemView()
{
    UILabel *titleLabel;
    UIImageView *tipsImage;
}

@end

@implementation MSMustInputItemView

- (id)init
{
    if (self = [super init]) {
        titleLabel = [UILabel new];
        titleLabel.font = kFontPingFangRegularSize(16);
        titleLabel.textColor = UIColorHex(0x333333);
        [self addSubview:titleLabel];
        
        
        
        tipsImage = [UIImageView new];
        tipsImage.image = [UIImage imageNamed:@"star"];
        [self addSubview:tipsImage];
        
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@0);
        make.right.mas_equalTo(tipsImage.mas_left).mas_offset(-2);
    }];
    
    [tipsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_right).mas_offset(2);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
}

- (void)title:(NSString*)title mustItem:(BOOL)must;
{
    titleLabel.text = title;
    tipsImage.hidden = !must;
}
@end
