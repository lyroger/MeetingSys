//
//  MSMeetingDetailCell.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/8.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSMeetingDetailCell.h"

@interface MSMeetingDetailCell()
{
    UIImageView *topShadowImageView;
}

@end

@implementation MSMeetingDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        bgContentView = [UIView new];
//        bgContentView.layer.shadowColor = UIColorHex(0xf6f6f6).CGColor;
//        bgContentView.layer.shadowOffset = CGSizeMake(1, 5);// 阴影的范围
//        bgContentView.layer.shadowOpacity = 0.8;// 阴影透明度
        bgContentView.backgroundColor = UIColorHex(0xffffff);
        [self.contentView addSubview:bgContentView];
        
        contentDetailView = [MSTitleAndDetailView new];
        [bgContentView addSubview:contentDetailView];
        
        beginTimeView = [MSTitleAndDetailView new];
        [bgContentView addSubview:beginTimeView];
        
        endTimeView = [MSTitleAndDetailView new];
        [bgContentView addSubview:endTimeView];
        
        meetindAddressView = [MSTitleAndDetailView new];
        [bgContentView addSubview:meetindAddressView];
        
        memberView = [MSMemberView new];
        [bgContentView addSubview:memberView];
        
        meetingAgendaView = [MSTitleAndDetailView new];
        [bgContentView addSubview:meetingAgendaView];
        
        meetingDemandView = [MSTitleAndDetailView new];
        [bgContentView addSubview:meetingDemandView];
        
        topShadowImageView = [UIImageView new];
//        topShadowImageView.hidden = YES;
        topShadowImageView.image = [UIImage imageNamed:@"shadow_top"];
        [bgContentView addSubview:topShadowImageView];
        
        [bgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(@(-10));
            make.top.bottom.equalTo(@0);
        }];
        
        [contentDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(@0);
            make.bottom.equalTo(beginTimeView.mas_top);
        }];
        
        [topShadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(@0);
            make.height.equalTo(@6);
        }];
        
        [beginTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentDetailView);
            make.top.equalTo(contentDetailView.mas_bottom);
            make.height.equalTo(@70);
            make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.5);
        }];
        
        UILabel *midLine = [UILabel new];
        midLine.backgroundColor = UIColorHex(0xE3E3E3);
        [bgContentView addSubview:midLine];
        [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(contentDetailView.mas_bottom).mas_offset(16);
            make.height.mas_equalTo(70-16*2);
            make.width.mas_equalTo(0.6);
        }];
        
        [endTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentDetailView);
            make.top.equalTo(contentDetailView.mas_bottom);
            make.height.equalTo(@70);
            make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.5);
        }];
        
        [meetindAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(endTimeView.mas_bottom);
            make.height.equalTo(@70);
        }];
        
        [memberView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(meetindAddressView.mas_bottom);
            make.left.right.equalTo(@0);
            make.height.equalTo(@127);
        }];
        
        [meetingAgendaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(memberView.mas_bottom);
            make.bottom.equalTo(meetingDemandView.mas_top);
        }];
        
        [meetingDemandView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(meetingAgendaView.mas_bottom);
            make.bottom.equalTo(self);
        }];
        
    }
    return self;
}

- (void)showTopShadow:(BOOL)show
{
    topShadowImageView.hidden = !show;
}

- (void)data:(MSMeetingDetailModel*)model
{
    beginTimeView.titleLabel.text = @"會議開始時間";
    beginTimeView.detailLabel.text = [model.beginTime dateWithFormat:@"yyyy-MM-dd HH:mm"];
    
    endTimeView.titleLabel.text = @"會議結束時間";
    endTimeView.detailLabel.text = [model.endTime dateWithFormat:@"yyyy-MM-dd HH:mm"];
    
    meetindAddressView.titleLabel.text = @"會議地址";
    meetindAddressView.detailLabel.text = model.address;
    
    [memberView membersData:model.members];
    
    meetingAgendaView.titleLabel.text = @"會議議程";
    meetingAgendaView.detailLabel.attributedText = [self getTextAttributeString:model.agenda];
    
    meetingDemandView.titleLabel.text = @"會議要求";
    meetingDemandView.detailLabel.attributedText = [self getTextAttributeString:model.demand];
}

- (NSMutableAttributedString*)getTextAttributeString:(NSString*)str
{
    if (str.length) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedString addAttribute:NSFontAttributeName value:kFontPingFangRegularSize(14) range:NSMakeRange(0, attributedString.length)];
        //设置行间距
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:8];
        paragraphStyle1.alignment = NSTextAlignmentCenter;//设置对齐方式
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, attributedString.length)];
        
        return attributedString;
    } else {
        return nil;
    }
}

+ (CGFloat)meetingDetailHeight:(MSMeetingDetailModel*)model
{
    CGFloat tottalHeight = 70+70+127+[MSTitleAndDetailView titleAndDetailViewHeight:model.agenda width:kScreenWidth-10*2-10*2]+[MSTitleAndDetailView titleAndDetailViewHeight:model.demand width:kScreenWidth-10*2-10*2];
    return tottalHeight;
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
