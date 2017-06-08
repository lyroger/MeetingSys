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
        [sureButton setBackgroundImage:[UIImage imageWithColor:kMainColor] forState:UIControlStateNormal];
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
        [cancelButton setBackgroundImage:[UIImage imageWithColor:kMainColor] forState:UIControlStateNormal];
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
    contentDetailView.detailLabel.attributedText = [self getTextAttributeString:[MSAllMeetingDetailCell getTitleDetailInfo:model]];
    
    beginTimeView.titleLabel.text = @"會議開始時間";
    beginTimeView.detailLabel.text = [model.beginTime dateWithFormat:@"HH:mm"];
    
    endTimeView.titleLabel.text = @"會議結束時間";
    endTimeView.detailLabel.text = [model.endTime dateWithFormat:@"HH:mm"];
    
    meetindAddressView.titleLabel.text = @"會議地址";
    meetindAddressView.detailLabel.text = model.address;
    
    [memberView membersData:model.members];
    
    meetingAgendaView.titleLabel.text = @"會議議程";
    meetingAgendaView.detailLabel.attributedText = [self getTextAttributeString:model.agenda];
    
    meetingDemandView.titleLabel.text = @"會議要求";
    meetingDemandView.detailLabel.attributedText = [self getTextAttributeString:[MSAllMeetingDetailCell getDemandInfo:model]];
    
    
    if (model.meetingType == MeetingType_Money) {
        memberView.hidden = YES;
        meetingAgendaView.hidden = YES;
        meetingDemandView.hidden = YES;
        [sureButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(meetindAddressView.mas_bottom).mas_offset(35);
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(44);
        }];
    } else if (model.meetingType == MeetingType_Validate) {
        memberView.hidden = YES;
        meetingAgendaView.hidden = YES;
        meetingDemandView.hidden = NO;
        meetingDemandView.titleLabel.text = @"驗證信息";
        meetingDemandView.detailLabel.attributedText = [self getTextAttributeString:[MSAllMeetingDetailCell getDemandInfo:model]];
        
        [meetingDemandView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(meetindAddressView.mas_bottom);
            make.bottom.equalTo(sureButton.mas_top).offset(-35);
        }];
        
        [sureButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(meetingDemandView.mas_bottom).mas_offset(35);
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(44);
        }];
    } else {
        memberView.hidden = NO;
        meetingAgendaView.hidden = NO;
        meetingDemandView.hidden = NO;
        
        [meetingDemandView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(meetingAgendaView.mas_bottom);
            make.bottom.equalTo(sureButton.mas_top).offset(-35);
        }];
        
        [sureButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(meetingDemandView.mas_bottom).mas_offset(35);
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(44);
        }];
    }
    
    //如果是组织者，可以取消
    cancelButton.hidden = YES;
    if ([model.organizeId isEqualToString:[MSUserInfo shareUserInfo].userId]) {
        NSInteger status = [model.mtStatus integerValue];
        if (status == 0 || status == 3 || status == 5) {
            cancelButton.hidden = NO;
        }
    }
}

+ (NSString *)getTitleDetailInfo:(MSMeetingDetailModel*)model
{
    NSString *detailInfo = model.title;
    if (model.meetingType == MeetingType_Money) {
        detailInfo = [NSString stringWithFormat:@"理財中心"];
    } else if (model.meetingType == MeetingType_Validate) {
        detailInfo = [NSString stringWithFormat:@"驗證中心"];
    }
    return detailInfo;
}

+ (NSString *)getDemandInfo:(MSMeetingDetailModel*)model
{
    NSString *detailInfo = model.demand;
    if (model.meetingType == MeetingType_Validate) {
        detailInfo = [NSString stringWithFormat:@"客人姓名：%@\n客人數目：%zd個\n保單數目：%zd個\n投保類別：%@\n是否即时缴费：%@\n聯絡電話：%@",model.customerName,model.customerNum,model.insuranceNum,model.productType,model.customePay==0?@"是":@"否",model.contactNum];
    }
    return detailInfo;
}

+ (CGFloat)meetingDetailHeight:(MSMeetingDetailModel*)model
{
    CGFloat agendaHeight = [MSTitleAndDetailView titleAndDetailViewHeight:model.agenda width:kScreenWidth-10*2];
    CGFloat demandHeight = [MSTitleAndDetailView titleAndDetailViewHeight:[MSAllMeetingDetailCell getDemandInfo:model] width:kScreenWidth-10*2];
    CGFloat contentHeight = [MSTitleAndDetailView titleAndDetailViewHeight:[MSAllMeetingDetailCell getTitleDetailInfo:model] width:kScreenWidth-10*2];
    
    
    CGFloat tottalHeight = contentHeight+70+70+120+agendaHeight+demandHeight + 114;
    
    if (model.meetingType == MeetingType_Money) {
        tottalHeight = contentHeight+70+70 + 114;
        
    } else if (model.meetingType == MeetingType_Validate) {
        tottalHeight = contentHeight+70+70+demandHeight + 114;
    }
    
    
    //如果是组织者，可以取消
    if ([model.organizeId isEqualToString:[MSUserInfo shareUserInfo].userId]) {
        NSInteger status = [model.mtStatus integerValue];
        if (status == 0 || status == 3 || status ==5) {
//            tottalHeight = contentHeight+70+70+120+agendaHeight+demandHeight + 105*2;
            tottalHeight += 96;
        }
    }
    return tottalHeight;
}

@end
