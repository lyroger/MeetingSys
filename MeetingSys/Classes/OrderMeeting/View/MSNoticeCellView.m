//
//  MSNoticeCellView.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/8.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSNoticeCellView.h"

@interface MSNoticeCellView()
{
    UIView      *bgContentView;
    UIImageView *imageIcon;
    UILabel     *titleLabel;
    UILabel     *contentLabel;
    UILabel     *timeLabel;
    UILabel     *noticeTimeLabel;
    
}

@end

@implementation MSNoticeCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        bgContentView = [UIView new];
        bgContentView.layer.shadowColor = UIColorHex(0xf6f6f6).CGColor;
        bgContentView.layer.shadowOffset = CGSizeMake(1, 5);// 阴影的范围
        bgContentView.layer.shadowOpacity = 0.8;// 阴影透明度
        bgContentView.backgroundColor = UIColorHex(0xffffff);
        [self.contentView addSubview:bgContentView];
        
        imageIcon = [UIImageView new];
        [bgContentView addSubview:imageIcon];
        
        titleLabel = [UILabel new];
        titleLabel.font = kFontPingFangRegularSize(16);
        titleLabel.textColor = UIColorHex(0x333333);
        [bgContentView addSubview:titleLabel];
        
        contentLabel = [UILabel new];
        contentLabel.font = kFontPingFangRegularSize(14);
        contentLabel.textColor = UIColorHex(0x888888);
        [bgContentView addSubview:contentLabel];
        
        timeLabel = [UILabel new];
        timeLabel.font = kFontPingFangRegularSize(12);
        timeLabel.textColor = UIColorHex(0x888888);
        [bgContentView addSubview:timeLabel];
        
        noticeTimeLabel = [UILabel new];
        noticeTimeLabel.font = kFontPingFangRegularSize(12);
        noticeTimeLabel.textColor = UIColorHex(0x888888);
        noticeTimeLabel.textAlignment = NSTextAlignmentRight;
        [bgContentView addSubview:noticeTimeLabel];
        
        
        
        [bgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(@(-10));
            make.top.bottom.equalTo(@0);
        }];
        
        [imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(16);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageIcon.mas_right).mas_offset(10);
            make.right.mas_equalTo(noticeTimeLabel.mas_left).mas_offset(5);
            make.top.equalTo(imageIcon);
        }];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(8);
            make.left.mas_equalTo(titleLabel.mas_left);
            make.right.mas_equalTo(bgContentView.mas_right).mas_offset(-10);
        }];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgContentView.mas_right).mas_offset(-10);
            make.top.mas_equalTo(contentLabel.mas_bottom).mas_offset(8);
            make.left.equalTo(titleLabel.mas_left);
        }];
        
        [noticeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgContentView.mas_right).mas_offset(-10);
            make.top.equalTo(titleLabel);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
        
    }
    
    return self;
}

- (void)data:(MSNoticeModel*)dataModel
{
    [imageIcon sd_setImageWithURL:[NSURL URLWithString:dataModel.headURL] placeholderImage:[UIImage imageNamed:@"portrait_xiao"]];
    titleLabel.text = dataModel.noticeTitle;
    contentLabel.text = dataModel.noticeContent;
    timeLabel.text = dataModel.meetingDate;
    noticeTimeLabel.text = dataModel.noticeDate;
}

+ (CGFloat)noticeCellHeight
{
    return 85;
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
