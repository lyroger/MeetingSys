//
//  MSNewMeetingHeadView.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/13.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSNewMeetingHeadView.h"

@interface MSNewMeetingHeadView()
{
    UIView *bgView;
    UIImageView *themeClassics;
    UIImageView *themeNoPictures;
    UIView *themeLegend;
    
    UIImageView *portraitView;
}

@end

@implementation MSNewMeetingHeadView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, -1000, frame.size.width, frame.size.height+1000)];
        bgView.backgroundColor = UIColorHex(0xFF845F);
        [self addSubview:bgView];
        
        UIImageView *bgImageView = [UIImageView new];
        bgImageView.image = [UIImage imageNamed:@"bg_cai"];
        [self addSubview:bgImageView];
        
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(165, 150));
        }];
        
        UIImageView *borderBgView = [UIImageView new];
        borderBgView.image = [UIImage imageNamed:@"display_bg"];
        [self addSubview:borderBgView];
        
        [borderBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(260, 200));
            make.centerX.equalTo(self);
            make.top.equalTo(@10);
        }];
        
        themeClassics = [UIImageView new];
        themeClassics.image = [UIImage imageNamed:@"display_portrait"];
        [borderBgView addSubview:themeClassics];
        
        [themeClassics mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(@12);
            make.right.equalTo(@(-15));
            make.bottom.equalTo(@(-18));
        }];
        
        themeNoPictures = [UIImageView new];
        themeNoPictures.image = [UIImage imageNamed:@"display_portrait"];
        [borderBgView addSubview:themeNoPictures];
        
        [themeNoPictures mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(@12);
            make.right.equalTo(@(-15));
            make.bottom.equalTo(@(-18));
        }];
        
        themeLegend = [UIView new];
        [borderBgView addSubview:themeLegend];
        
        UIImageView *titleImage = [UIImageView new];
        titleImage.image = [UIImage imageNamed:@"display_title"];
        [themeLegend addSubview:titleImage];
        
        UIImageView *menuImage = [UIImageView new];
        menuImage.image = [UIImage imageNamed:@"display_menu"];
        [themeLegend addSubview:menuImage];
        
        portraitView = [UIImageView new];
        portraitView.image = [UIImage imageNamed:@"display_portrait"];
        [themeLegend addSubview:portraitView];
        
        [themeLegend mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(@12);
            make.right.equalTo(@(-15));
            make.bottom.equalTo(@(-18));
        }];
        
        [titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@0);
            make.height.equalTo(@20);
            make.width.equalTo(@158);
        }];
        
        [menuImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(@0);
            make.width.equalTo(@87);
        }];
        
        [portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@20);
            make.left.bottom.equalTo(@0);
            make.right.equalTo(menuImage.mas_left);
        }];
    }
    
    return self;
}

- (void)theme:(NSString*)theme hideImage:(BOOL)hide
{
    if ([theme isEqualToString:@""]) {
        //金典主题
        themeClassics.hidden = NO;
        themeNoPictures.hidden = YES;
        themeLegend.hidden = YES;
    } else if ([theme isEqualToString:@""]) {
        //legend主题
        themeClassics.hidden = YES;
        themeNoPictures.hidden = !hide;
        themeLegend.hidden = hide;
    }
}

@end
