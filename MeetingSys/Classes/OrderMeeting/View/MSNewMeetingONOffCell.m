//
//  MSNewMeetingONOffCell.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/16.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSNewMeetingONOffCell.h"
#import "MSMustInputItemView.h"

@interface MSNewMeetingONOffCell()
{
    MSMustInputItemView *mustView;
    UISwitch            *switchOnOff;
}

@property (nonatomic, strong) UILabel *bottomLine;

@end

@implementation MSNewMeetingONOffCell

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
        
        switchOnOff = [UISwitch new];
        [switchOnOff setOn:NO];
        [switchOnOff addTarget:self action:@selector(onOffAction:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:switchOnOff];
        
        [switchOnOff mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).mas_offset(-12);
            make.centerY.equalTo(self.contentView);
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

- (void)onOffAction:(UISwitch*)switchView
{
    if (self.actionBlock) {
        self.actionBlock(switchOnOff.isOn);
    }
}

- (void)setSwitchEnble:(BOOL)enble
{
    switchOnOff.enabled = enble;
}

- (void)title:(NSString *)title mustItem:(BOOL)must on:(BOOL)on
{
    [mustView title:title mustItem:must];
    [switchOnOff setOn:on];
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
