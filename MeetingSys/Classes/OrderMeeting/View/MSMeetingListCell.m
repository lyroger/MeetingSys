//
//  MSMeetingListCell.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/8.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSMeetingListCell.h"

@interface MSMeetingListCell()
{
    UIView      *bgContentView;
    UIImageView *imageIcon;
    UILabel     *titleLabel;
    UILabel     *timeLabel;
    UILabel     *organizerLabel;
    
}

@end

@implementation MSMeetingListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        bgContentView = [UIView new];
        bgContentView.backgroundColor = UIColorHex(0xffffff);
        [self.contentView addSubview:bgContentView];
        
        imageIcon = [UIImageView new];
        imageIcon.layer.cornerRadius = 18;
        imageIcon.layer.masksToBounds = YES;
        [bgContentView addSubview:imageIcon];
        
        titleLabel = [UILabel new];
        titleLabel.font = kFontPingFangRegularSize(16);
        titleLabel.textColor = UIColorHex(0x333333);
        [bgContentView addSubview:titleLabel];
        
        timeLabel = [UILabel new];
        timeLabel.font = kFontPingFangRegularSize(14);
        timeLabel.textColor = UIColorHex(0x888888);
        [bgContentView addSubview:timeLabel];
        
        organizerLabel = [UILabel new];
        organizerLabel.font = kFontPingFangRegularSize(14);
        organizerLabel.textColor = UIColorHex(0x888888);
        organizerLabel.textAlignment = NSTextAlignmentRight;
        [bgContentView addSubview:organizerLabel];
        
        [bgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@(0));
            make.top.bottom.equalTo(@0);
        }];
        
        [imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(16);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageIcon.mas_right).mas_offset(10);
            make.right.mas_equalTo(organizerLabel.mas_left).mas_offset(-5);
            make.top.equalTo(imageIcon);
        }];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(8);
            make.left.mas_equalTo(titleLabel.mas_left);
            make.right.mas_equalTo(organizerLabel.mas_left).mas_offset(-5);
        }];
        
        
        [organizerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgContentView.mas_right).mas_offset(-10);
            make.centerY.equalTo(bgContentView);
            make.width.lessThanOrEqualTo(@100);
            make.height.mas_equalTo(25);
        }];
        
        UILabel *bottomLine = [UILabel new];
        bottomLine.backgroundColor = kSplitLineColor;
        [self.contentView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0.6));
            make.width.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
        
    }
    
    return self;
}

- (void)data:(MSMeetingDetailModel*)model
{
    [imageIcon sd_setImageWithURL:kImageURLWithLastString(model.organizerHeadURL) placeholderImage:[UIImage imageNamed:@"portrait_xiao"]];
    titleLabel.text = model.title;
    timeLabel.text = [NSString stringWithFormat:@"%@-%@",[model.beginTime dateWithFormat:@"HH:mm"],[model.endTime dateWithFormat:@"HH:mm"]];
    organizerLabel.text = model.organizeName;
}

+ (CGFloat)meetingListCellHeight
{
    return 67;
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
