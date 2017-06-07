//
//  MSNewMeetingHeadView.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/13.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSNewMeetingHeadView.h"
#import "MSThemeView.h"

@interface MSNewMeetingHeadView()
{
    UIView *bgView;
    UIImageView *themeClassics;
    MSThemeView *themeNoPictures;
    MSThemeView *themeLegend;
    
    UIImageView *portraitView;
}

@end

@implementation MSNewMeetingHeadView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, -1000, frame.size.width, frame.size.height+1000)];
        bgView.backgroundColor = UIColorHex(0xFFFFFF);
        [self addSubview:bgView];
        
        UIImageView *bgImageView = [UIImageView new];
        bgImageView.image = [UIImage imageNamed:@"bg_cai"];
        [self addSubview:bgImageView];
        
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.top.equalTo(@0);
//            make.size.mas_equalTo(CGSizeMake(165, 150));
        }];
        
        UIImageView *borderBgView = [UIImageView new];
        borderBgView.userInteractionEnabled = YES;
        borderBgView.image = [UIImage imageNamed:@"display_bg"];
        [self addSubview:borderBgView];
        
        [borderBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(260, 200));
            make.centerX.equalTo(self);
            make.top.equalTo(@64);
        }];
        
        themeClassics = [UIImageView new];
        themeClassics.image = [UIImage imageNamed:@"Classic"];
        [borderBgView addSubview:themeClassics];
        
        [themeClassics mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(@12);
            make.right.equalTo(@(-15));
            make.bottom.equalTo(@(-18));
        }];
        
        themeNoPictures = [MSThemeView new];
        themeNoPictures.portraitView.image = [UIImage imageNamed:@"display_portrait_off"];
        [borderBgView addSubview:themeNoPictures];
        
        [themeNoPictures mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(@12);
            make.right.equalTo(@(-15));
            make.bottom.equalTo(@(-18));
        }];
        
        themeLegend = [MSThemeView new];
        [themeLegend.portraitView sd_setImageWithURL:kImageURLWithLastString([MSUserInfo shareUserInfo].headerImg) placeholderImage:[UIImage imageNamed:@"display_portrait"]];
        @weakify(self)
        themeLegend.clickHeadBlock = ^{
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(didClickHeadView)]) {
                [self.delegate didClickHeadView];
            }
        };
        [borderBgView addSubview:themeLegend];
        
        [themeLegend mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(@12);
            make.right.equalTo(@(-15));
            make.bottom.equalTo(@(-18));
        }];
    }
    
    return self;
}

- (void)reloadHeadImage:(UIImage*)image
{
    themeLegend.portraitView.image = image;
}

- (void)theme:(NSString*)theme hideImage:(BOOL)hide
{
    if ([theme isEqualToString:@"Classic"]) {
        //金典主题
        themeClassics.hidden = NO;
        themeNoPictures.hidden = YES;
        themeLegend.hidden = YES;
    } else if ([theme isEqualToString:@"Legend"] || theme.length==0) {
        //legend主题
        themeClassics.hidden = YES;
        themeNoPictures.hidden = !hide;
        themeLegend.hidden = hide;
    }
}

@end
