//
//  MSThemeView.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/22.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSThemeView.h"

@interface MSThemeView()
{
    
}


@end

@implementation MSThemeView

- (id)init
{
    if (self = [super init]) {
        UIImageView *titleImage = [UIImageView new];
        titleImage.image = [UIImage imageNamed:@"display_title"];
        [self addSubview:titleImage];
        
        UIImageView *menuImage = [UIImageView new];
        menuImage.image = [UIImage imageNamed:@"display_menu"];
        [self addSubview:menuImage];
        
        self.portraitView = [UIImageView new];
        self.portraitView.contentMode = UIViewContentModeScaleAspectFill;
        self.portraitView.clipsToBounds = YES;
        self.portraitView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadAction)];
        [self.portraitView addGestureRecognizer:tap];
        [self addSubview:self.portraitView];

        
        self.inuseImage = [UIImageView new];
        self.inuseImage.userInteractionEnabled = NO;
        self.inuseImage.image = [UIImage imageNamed:@"display_inuse"];
        [self addSubview:self.inuseImage];
        
        [titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@0);
            make.height.equalTo(@20);
            make.width.equalTo(@158);
        }];
        
        [menuImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(@0);
            make.width.equalTo(@87);
        }];
        
        [self.portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@20);
            make.left.bottom.equalTo(@0);
            make.right.equalTo(menuImage.mas_left);
        }];
        
        [self.inuseImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.left.equalTo(self.portraitView);
            make.right.equalTo(self.portraitView);
            make.top.equalTo(self.portraitView).mas_offset(10);
        }];
    }
    
    return self;
}

- (void)tapHeadAction
{
    if (self.clickHeadBlock) {
        self.clickHeadBlock();
    }
}

@end
