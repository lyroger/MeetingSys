//
//  CyclicCardCell.m
//  DemoList
//
//  Created by luoyan on 17/2/22.
//  Copyright © 2017年 luoyan. All rights reserved.
//

#import "CyclicCardCell.h"

@interface CyclicCardCell()
{
    
}

@end

@implementation CyclicCardCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = kMainColor;
//        self.layer.masksToBounds = true;
//        self.layer.cornerRadius = 2.0;
        
        UIImageView *bgImage = [UIImageView new];
        bgImage.image = [UIImage imageNamed:@"card_bg"];
        [self.contentView addSubview:bgImage];
        
        self.imageView = [UIImageView new];
        self.imageView.layer.cornerRadius = 18;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imageView];
        
        self.nameLabel = [UILabel new];
        self.nameLabel.font = kFontPingFangRegularSize(14);
        self.nameLabel.textColor = UIColorHex(0xffffff);
        [self.contentView addSubview:self.nameLabel];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = kFontPingFangRegularSize(16);
        self.titleLabel.textColor = UIColorHex(0xffffff);
        [self.contentView addSubview:self.titleLabel];
        
        self.timeLabel = [UILabel new];
        self.timeLabel.font = kFontPingFangRegularSize(16);
        self.timeLabel.textColor = UIColorHex(0xffffff);
        [self.contentView addSubview:self.timeLabel];
        
        self.statusLabel = [UILabel new];
        self.statusLabel.font = kFontPingFangRegularSize(12);
        self.statusLabel.textColor = kMainColor;
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.backgroundColor = UIColorHex(0xffffff);
        self.statusLabel.layer.cornerRadius = 3;
        self.statusLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:self.statusLabel];
        
        [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(-3));
            make.right.equalTo(@(10));
            make.left.equalTo(@(-10));
            make.bottom.equalTo(@(15));
        }];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(36, 36));
            make.left.top.equalTo(@12);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.imageView);
            make.left.mas_equalTo(self.imageView.mas_right).mas_offset(10);
            make.right.mas_equalTo(self.statusLabel.mas_left).mas_offset(-10);
            make.height.equalTo(@25);
        }];
        
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(64, 26));
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView);
            make.bottom.mas_equalTo(-26);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(8);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(self.timeLabel.mas_top).mas_offset(-8);
        }];
        
    }
    return self;
}

- (void)data:(MSMeetingDetailModel*)model
{
    [self.imageView sd_setImageWithURL:kImageURLWithLastString(model.organizerHeadURL) placeholderImage:[UIImage imageNamed:@"portrait_xiao"]];
    self.nameLabel.text = model.organizeName;
    
    NSString *detailInfo = model.title;
    if (model.meetingType == MeetingType_Money) {
        detailInfo = [NSString stringWithFormat:@"理財中心-%@",model.address];
    } else if (model.meetingType == MeetingType_Validate) {
        detailInfo = [NSString stringWithFormat:@"驗證中心-%@",model.address];
    }
    self.titleLabel.text = detailInfo;
    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",[model.beginTime dateWithFormat:@"HH:mm"],[model.endTime dateWithFormat:@"HH:mm"]];
    self.statusLabel.text = [self getStatusStringWithStatus:[model.mtStatus integerValue]];
}

- (NSString *)getStatusStringWithStatus:(NSInteger)status
{
    switch (status) {
        case 0:
            return @"未开始";
            break;
        case 1:
            return @"已结束";
            break;
        case 2:
            return @"no show";
            break;
        case 3:
            return @"已确认";
            break;
        case 4:
            return @"已取消";
            break;
        case 5:
            return @"正在进行";
            break;
        default:
            return @"未开始";
            break;
    }
}

@end
