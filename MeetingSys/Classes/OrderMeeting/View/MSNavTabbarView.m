//
//  MSNavTabbarView.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/8.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSNavTabbarView.h"

@interface MSNavTabbarView()
{
    UIButton *leftButton;
    UIButton *rightButton;
    UILabel  *bottomLine;
    CGFloat  lineWidth;
}

@end

@implementation MSNavTabbarView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton.titleLabel setFont:kFontPingFangRegularSize(14)];
        [leftButton setTitleColor:UIColorHex(0xFF7B54) forState:UIControlStateNormal];
        [leftButton setTitle:@"會議提醒" forState:UIControlStateNormal];
        leftButton.tag = 100;
        [leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton];
        
        rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton.titleLabel setFont:kFontPingFangRegularSize(14)];
        [rightButton setTitleColor:UIColorHex(0x999999) forState:UIControlStateNormal];
        [rightButton setTitle:@"全部會議" forState:UIControlStateNormal];
        rightButton.tag = 101;
        [rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightButton];
        
        bottomLine = [UILabel new];
        [bottomLine setFont:kFontPingFangRegularSize(14)];
        bottomLine.backgroundColor = UIColorHex(0xFF7B54);
        CGSize size = [@"會議提醒" sizeWithAttributes:@{NSFontAttributeName:kFontPingFangRegularSize(14)}];
        lineWidth = size.width;
        bottomLine.frame = CGRectMake((self.width/2-lineWidth)/2, self.height-2, lineWidth, 2);
        [self addSubview:bottomLine];
        
        UIView *midLine = [UIView new];
        [self addSubview:midLine];
        midLine.backgroundColor = UIColorHex(0xE3E3E3);
        [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.bottom.equalTo(@(-10));
            make.width.equalTo(@0.5);
            make.centerX.equalTo(self);
        }];
        
        
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(@0);
            make.width.equalTo(@(self.width/2));
        }];
        
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(@0);
            make.width.equalTo(@(self.width/2));
        }];
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = UIColorHex_Alpha(0x000000, 0.05).CGColor;
        self.layer.shadowOffset = CGSizeMake(1, 6);// 阴影的范围
        self.layer.shadowOpacity = 1;// 阴影透明度
    }
    
    return self;
}

- (void)selectedItemIndex:(NSInteger)index
{
    [self updateButtonStatusWithIndex:index];
}

- (void)updateButtonStatusWithIndex:(NSInteger)itemIndex
{
    if (itemIndex == 0) {
        [leftButton setTitleColor:UIColorHex(0xFF7B54) forState:UIControlStateNormal];
        [rightButton setTitleColor:UIColorHex(0x999999) forState:UIControlStateNormal];
    } else {
        [leftButton setTitleColor:UIColorHex(0x999999) forState:UIControlStateNormal];
        [rightButton setTitleColor:UIColorHex(0xFF7B54) forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        if (itemIndex == 0) {
            bottomLine.frame = CGRectMake((self.width/2-lineWidth)/2, self.height-2, lineWidth, 2);
        } else {
            bottomLine.frame = CGRectMake((self.width/2-lineWidth)/2 + self.width/2, self.height-2, lineWidth, 2);
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)buttonClick:(UIButton*)button
{
    [self updateButtonStatusWithIndex:button.tag-100];
    if (self.delegete && [self.delegete respondsToSelector:@selector(didClickNavTabbarView:)]) {
        [self.delegete didClickNavTabbarView:button.tag-100];
    }
}

@end
