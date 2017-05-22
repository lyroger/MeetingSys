//
//  MSNoticeDetailCell.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/22.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSNoticeDetailCell.h"

@implementation MSNoticeDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(0xFFB072)] forState:UIControlStateNormal];
        
        sureButton.layer.cornerRadius = 4;
        sureButton.layer.borderColor = [UIColor clearColor].CGColor;
        sureButton.layer.borderWidth = 1;
        sureButton.layer.masksToBounds = YES;
        
        [sureButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [sureButton setTitle:@"我知道了" forState:UIControlStateNormal];
        sureButton.titleLabel.font = kFontPingFangMediumSize(18);
        
        [bgContentView addSubview:sureButton];
        
        
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
        
    }
    return self;
}

+ (CGFloat)meetingDetailHeight:(MSMeetingDetailModel*)model
{
    CGFloat agendaHeight = [MSTitleAndDetailView titleAndDetailViewHeight:model.agenda width:kScreenWidth-10*2];
    CGFloat tottalHeight = 70+70+127+agendaHeight+[MSTitleAndDetailView titleAndDetailViewHeight:model.demand width:kScreenWidth-10*2] + 114;
    return tottalHeight;
}

- (void)buttonClickAction:(UIButton*)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickNoticeDetailSureActionCell:)]) {
        [self.delegate didClickNoticeDetailSureActionCell:self];
    }
}

@end
