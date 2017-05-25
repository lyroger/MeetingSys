//
//  MSMemberCollectionCell.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/25.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSMemberCollectionCell.h"

@implementation MSMemberCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageHead = [UIImageView new];
        self.imageHead.layer.cornerRadius = 25;
        self.imageHead.layer.masksToBounds = YES;
        self.imageHead.contentMode = UIViewContentModeScaleAspectFill;
        self.imageHead.userInteractionEnabled = YES;
        [self.contentView addSubview:self.imageHead];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteMember)];
        [self.imageHead addGestureRecognizer:tap];
        
        self.labelName = [UILabel new];
        self.labelName.font = kFontPingFangRegularSize(10);
        self.labelName.textColor =  UIColorHex(0x888888);
        self.labelName.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.labelName];
        
        [self.imageHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [self.labelName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageHead.mas_bottom).mas_offset(8);
            make.left.right.mas_equalTo(0);
            make.height.equalTo(@14);
        }];
    }
    
    return self;
}

- (void)bindRAC
{
    [RACObserve(self,self.memberModel.headURL) subscribeNext:^(NSString *headURL) {
        [self.imageHead sd_setImageWithURL:kImageURLWithLastString(headURL) placeholderImage:[UIImage imageNamed:@"portrait_xiao"]];
    }];
}

- (void)deleteMember
{
    if (self.clickBlock) {
        self.clickBlock(self);
    }
}

@end
