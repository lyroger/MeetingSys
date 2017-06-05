//
//  MSNavBarView.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/6/5.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSNavBarView.h"

@implementation MSNavBarView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeButton setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeButton];
        
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.centerY.equalTo(self).offset(10);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = kNavTitleFont;
        self.titleLabel.textColor = UIColorHex(0xffffff);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(10);
        }];
        
        self.navRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.navRightButton.titleLabel.font = kFontPingFangRegularSize(16);
        [self.navRightButton setTitle:@"確認" forState:UIControlStateNormal];
        [self.navRightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.navRightButton];
        
        [self.navRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(0));
            make.centerY.equalTo(self).offset(10);
            make.size.mas_equalTo(CGSizeMake(60, 36));
        }];
        
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    }
    
    return self;
}


- (void)closeView
{
    if (self.actionBlock) {
        self.actionBlock(0);
    }
}

- (void)rightAction
{
    if (self.actionBlock) {
        self.actionBlock(1);
    }
}
@end
