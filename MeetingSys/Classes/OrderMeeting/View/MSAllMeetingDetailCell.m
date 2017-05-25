//
//  MSAllMeetingDetailCell.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/12.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSAllMeetingDetailCell.h"

@implementation MSAllMeetingDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(0xFFB072)] forState:UIControlStateNormal];
        sureButton.layer.cornerRadius = 4;
        sureButton.layer.borderColor = [UIColor clearColor].CGColor;
        sureButton.layer.borderWidth = 1;
        sureButton.layer.masksToBounds = YES;
        sureButton.tag = 100;
        [sureButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [sureButton setTitle:@"確認" forState:UIControlStateNormal];
        sureButton.titleLabel.font = kFontPingFangMediumSize(18);
        [bgContentView addSubview:sureButton];
        
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(0xFFB072)] forState:UIControlStateNormal];
        cancelButton.layer.cornerRadius = 4;
        cancelButton.layer.borderColor = [UIColor clearColor].CGColor;
        cancelButton.layer.borderWidth = 1;
        cancelButton.layer.masksToBounds = YES;
        cancelButton.tag = 101;
        [cancelButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"取消會議" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = kFontPingFangMediumSize(18);
        [bgContentView addSubview:cancelButton];
        
        
        [meetingDemandView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(meetingAgendaView.mas_bottom);
            make.bottom.equalTo(sureButton.mas_top).offset(-35);
        }];
        
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(meetingDemandView.mas_bottom).mas_offset(35);
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(44);
        }];
        
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(sureButton.mas_bottom).mas_offset(35);
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(44);
        }];
        
    }
    return self;
}

- (void)buttonClickAction:(UIButton*)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickMeetingDetailActionCell:action:)]) {
        [self.delegate didClickMeetingDetailActionCell:self action:button.tag-100];
    }
}

- (void)data:(MSMeetingDetailModel*)model
{
    contentDetailView.titleLabel.text = @"會議主題";
    contentDetailView.detailLabel.text = model.title;
    
    beginTimeView.titleLabel.text = @"會議開始時間";
    beginTimeView.detailLabel.text = [model.beginTime dateWithFormat:@"HH:mm"];
    
    endTimeView.titleLabel.text = @"會議結束時間";
    endTimeView.detailLabel.text = [model.endTime dateWithFormat:@"HH:mm"];
    
    meetindAddressView.titleLabel.text = @"會議地址";
    meetindAddressView.detailLabel.text = model.address;
    
    [memberView membersData:model.members];
    
    meetingAgendaView.titleLabel.text = @"會議議程";
    meetingAgendaView.detailLabel.text = model.agenda;
    
    meetingDemandView.titleLabel.text = @"會議要求";
    meetingDemandView.detailLabel.text = model.demand;
}

+ (CGFloat)meetingDetailHeight:(MSMeetingDetailModel*)model
{
    CGFloat agendaHeight = [MSTitleAndDetailView titleAndDetailViewHeight:model.agenda width:kScreenWidth-10*2];
    CGFloat demandHeight = [MSTitleAndDetailView titleAndDetailViewHeight:model.demand width:kScreenWidth-10*2];
    CGFloat contentHeight = [MSTitleAndDetailView titleAndDetailViewHeight:model.title width:kScreenWidth-10*2];
    
//    agendaHeight = agendaHeight<70?70:agendaHeight;
//    demandHeight = demandHeight<70?70:demandHeight;
//    contentHeight = contentHeight<70?70:contentHeight;
    CGFloat tottalHeight = contentHeight+70+70+120+agendaHeight+demandHeight + 114*2;
    return tottalHeight;
}

@end
