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
    UILabel             *beginTime;
    UILabel             *endTime;
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
        
        UITapGestureRecognizer *beginTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDate:)];
        
        UITapGestureRecognizer *endTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDate:)];
        
        beginTime = [UILabel new];
        beginTime.font = kFontPingFangRegularSize(14);
        beginTime.textColor = UIColorHex(0x888888);
        beginTime.tag = 100;
        beginTime.userInteractionEnabled = YES;
        [beginTime addGestureRecognizer:beginTap];
        [self.contentView addSubview:beginTime];
        
        endTime = [UILabel new];
        endTime.font = kFontPingFangRegularSize(14);
        endTime.textColor = UIColorHex(0x888888);
        endTime.textAlignment = NSTextAlignmentRight;
        endTime.tag = 101;
        endTime.userInteractionEnabled = YES;
        [endTime addGestureRecognizer:endTap];
        [self.contentView addSubview:endTime];
        
        UILabel *midLine = [UILabel new];
        midLine.backgroundColor = UIColorHex(0xe3e3e3);
        [self.contentView addSubview:midLine];
        
        [beginTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.mas_equalTo(mustView.mas_bottom).mas_offset(10);
            make.right.mas_equalTo(midLine.mas_left).mas_offset(-10);
        }];
        
        [endTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-12));
            make.top.mas_equalTo(mustView.mas_bottom).mas_offset(10);
            make.left.mas_equalTo(midLine.mas_right).mas_offset(10);
        }];
        
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
    beginTime.text = begin;
    endTime.text = end;
}

- (void)selectDate:(UIGestureRecognizer*)gesture
{
    UIView *view = gesture.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickSelectDateTimeView:itemIndex:)]) {
        [self.delegate didClickSelectDateTimeView:self itemIndex:view.tag-100];
    }
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
