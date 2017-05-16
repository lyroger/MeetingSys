//
//  MSNewMeetingTimeCell.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/13.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSNewMeetingTimeCell.h"
#import "MSMustInputItemView.h"

@interface MSNewMeetingTimeCell()
{
    MSMustInputItemView *mustView;
    UIButton            *beginTime;
    UIButton            *endTime;
}

@property (nonatomic, strong) UILabel *bottomLine;

@end

@implementation MSNewMeetingTimeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        mustView = [MSMustInputItemView new];
        [self.contentView addSubview:mustView];
        
        [mustView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(@14);
            make.right.equalTo(@(-12));
            make.height.equalTo(@16);
        }];
        
        beginTime = [UIButton buttonWithType:UIButtonTypeCustom];
        [beginTime setTitle:@"請輸入開始時間" forState:UIControlStateNormal];
        beginTime.titleLabel.font = kFontPingFangRegularSize(14);
        [beginTime setTitleColor:UIColorHex(0x888888) forState:UIControlStateNormal];
        [self.contentView addSubview:beginTime];
        
        endTime = [UIButton buttonWithType:UIButtonTypeCustom];
        [endTime setTitle:@"請輸入結束時間" forState:UIControlStateNormal];
        endTime.titleLabel.font = kFontPingFangRegularSize(14);
        [endTime setTitleColor:UIColorHex(0x888888) forState:UIControlStateNormal];
        [self.contentView addSubview:endTime];
        
        [beginTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.mas_equalTo(mustView.mas_bottom).mas_offset(10);
            make.width.mas_equalTo(125);
        }];
        
        [endTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-12));
            make.top.mas_equalTo(mustView.mas_bottom).mas_offset(10);
            make.width.mas_equalTo(beginTime.mas_width);
        }];
        
        UILabel *midLine = [UILabel new];
        midLine.backgroundColor = UIColorHex(0xe3e3e3);
        [self.contentView addSubview:midLine];
        
        [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@10);
            make.height.equalTo(@1);
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(beginTime);
        }];
        
        
        self.bottomLine = [UILabel new];
        self.bottomLine.backgroundColor = UIColorHex(0xE3E3E3);
        [self addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.left.equalTo(@12);
            make.right.equalTo(@(-12));
            make.height.equalTo(@(0.6));
        }];
    }
    return self;
}

- (void)title:(NSString *)title mustItem:(BOOL)must begin:(NSString *)begin end:(NSString*)end
{
    [mustView title:title mustItem:must];
    [beginTime setTitle:begin forState:UIControlStateNormal];
    [endTime setTitle:end forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
