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
        [sureButton setTitleEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
        [sureButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(0xE3E3E3)] forState:UIControlStateDisabled];
        [sureButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(0xFF7B54)] forState:UIControlStateNormal];
        
        sureButton.layer.cornerRadius = 4;
        sureButton.layer.borderColor = [UIColor clearColor].CGColor;
        sureButton.layer.borderWidth = 1;
        sureButton.layer.masksToBounds = YES;
        
        [sureButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [sureButton setTitle:@"確認" forState:UIControlStateNormal];
        sureButton.titleLabel.font = kFontPingFangMediumSize(18);
        
        [bgContentView addSubview:sureButton];
        
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(meetingDemandView.mas_bottom).mas_offset(35);
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(44);
        }];
    }
    return self;
}

- (void)buttonClickAction:(UIButton*)button
{
    
}

- (void)data:(MSMeetingDetailModel*)model
{
    beginTimeView.titleLabel.text = @"會議開始時間";
    beginTimeView.detailLabel.text = model.beginTime;
    
    endTimeView.titleLabel.text = @"會議結束時間";
    endTimeView.detailLabel.text = model.endTime;
    
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
    CGFloat tottalHeight = 70+70+127+[MSTitleAndDetailView titleAndDetailViewHeight:model.agenda width:kScreenWidth-10*2-10*2]+[MSTitleAndDetailView titleAndDetailViewHeight:model.demand width:kScreenWidth-10*2-10*2] + 114;
    return tottalHeight;
}

@end
