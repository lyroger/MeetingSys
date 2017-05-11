//
//  MSMeetingDetailCell.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/8.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSMeetingDetailCell.h"
#import "MSTitleAndDetailView.h"

@interface MSMeetingDetailCell()
{
    UIView *bgContentView;
    
    MSTitleAndDetailView *beginTimeView;
    MSTitleAndDetailView *endTimeView;
    
    MSTitleAndDetailView *meetindAddressView;//會議地址
    MSTitleAndDetailView *meetingAgendaView;//會議議程
    MSTitleAndDetailView *meetingDemandView;//會議要求
}

@end

@implementation MSMeetingDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        bgContentView = [UIView new];
        bgContentView.layer.shadowColor = UIColorHex(0xf6f6f6).CGColor;
        bgContentView.layer.shadowOffset = CGSizeMake(1, 5);// 阴影的范围
        bgContentView.layer.shadowOpacity = 0.8;// 阴影透明度
        bgContentView.backgroundColor = UIColorHex(0xffffff);
        [self.contentView addSubview:bgContentView];
        
        beginTimeView = [MSTitleAndDetailView new];
        [bgContentView addSubview:beginTimeView];
        
        endTimeView = [MSTitleAndDetailView new];
        [bgContentView addSubview:endTimeView];
        
        meetindAddressView = [MSTitleAndDetailView new];
        [bgContentView addSubview:meetindAddressView];
        
        meetingAgendaView = [MSTitleAndDetailView new];
        [bgContentView addSubview:meetingAgendaView];
        
        meetingDemandView = [MSTitleAndDetailView new];
        [bgContentView addSubview:meetingDemandView];
        
        [bgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(@(-10));
            make.top.bottom.equalTo(@0);
        }];
        
        [beginTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@0);
            make.height.equalTo(@70);
            make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.5);
        }];
        
        UILabel *midLine = [UILabel new];
        midLine.backgroundColor = UIColorHex(0xE3E3E3);
        [bgContentView addSubview:midLine];
        [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.mas_equalTo(16);
            make.height.mas_equalTo(70-16*2);
            make.width.mas_equalTo(0.6);
        }];
        
        [endTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(@0);
            make.height.equalTo(@70);
            make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.5);
        }];
        
        [meetindAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(endTimeView.mas_bottom);
            make.height.equalTo(@70);
        }];
        
        [meetingAgendaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(meetindAddressView.mas_bottom);
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

- (void)data:(MSNoticeModel*)model
{
    beginTimeView.titleLabel.text = @"會議開始時間";
    beginTimeView.detailLabel.text = model.meetingDetailModel.beginTime;
    
    endTimeView.titleLabel.text = @"會議結束時間";
    endTimeView.detailLabel.text = model.meetingDetailModel.endTime;
    
    meetindAddressView.titleLabel.text = @"會議地址";
    meetindAddressView.detailLabel.text = model.meetingDetailModel.address;
    
    meetingAgendaView.titleLabel.text = @"會議議程";
    meetingAgendaView.detailLabel.text = model.meetingDetailModel.agenda;
    
    meetingDemandView.titleLabel.text = @"會議要求";
    meetingDemandView.detailLabel.text = model.meetingDetailModel.demand;
}

+ (CGFloat)meetingDetailHeight:(MSNoticeModel*)model
{
    CGFloat tottalHeight = 70+70+[MSTitleAndDetailView titleAndDetailViewHeight:model.meetingDetailModel.agenda width:kScreenWidth-10*2-10*2]+[MSTitleAndDetailView titleAndDetailViewHeight:model.meetingDetailModel.demand width:kScreenWidth-10*2-10*2];
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
