//
//  MSNewMeetingSelectCell.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/13.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSNewMeetingSelectCell.h"
#import "MSMustInputItemView.h"

@interface MSNewMeetingSelectCell()
{
    MSMustInputItemView *mustView;
    UILabel *textLabel;
    UIImageView *accessView;
}

@property (nonatomic, strong) UILabel *bottomLine;

@end

@implementation MSNewMeetingSelectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        mustView = [MSMustInputItemView new];
        [self.contentView addSubview:mustView];
        
        textLabel = [UILabel new];
        textLabel.font = kFontPingFangRegularSize(14);
        textLabel.textColor = UIColorHex(0x888888);
        [self.contentView addSubview:textLabel];
        
        accessView = [UIImageView new];
        accessView.image = [UIImage imageNamed:@"right"];
        [self.contentView addSubview:accessView];
        
        [mustView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(@14);
            make.right.equalTo(@(-12));
            make.height.equalTo(@16);
        }];
        
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mustView);
            make.top.equalTo(mustView.mas_bottom).offset(10);
            make.right.equalTo(accessView.mas_left).offset(-5);
            make.height.equalTo(@(20));
        }];
        
        [accessView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(textLabel);
            make.right.equalTo(@(-12));
            make.size.mas_equalTo(CGSizeMake(8, 20));
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

- (void)title:(NSString*)title placeholder:(NSString*)placeholder mustItem:(BOOL)must rightView:(BOOL)hide
{
    [mustView title:title mustItem:must];
    textLabel.text = placeholder;
    accessView.hidden = hide;
}

- (void)contentText:(NSString*)text
{
    if (text.length) {
        textLabel.text = text;
        textLabel.textColor = UIColorHex(0x333333);
    } else {
        textLabel.text = @"請選擇";
        textLabel.textColor = UIColorHex(0x888888);
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
