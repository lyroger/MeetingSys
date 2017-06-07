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
        [sureButton setBackgroundImage:[UIImage imageWithColor:kMainColor] forState:UIControlStateNormal];
        
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

+ (NSString *)getDemandInfo:(MSMeetingDetailModel*)model
{
    NSString *detailInfo = model.demand;
    if (model.meetingType == MeetingType_Validate) {
        detailInfo = [NSString stringWithFormat:@"客人姓名：%@\n客人數目：%zd個\n保單數目：%zd個\n投保類別：%@\n是否及時繳費：%@\n聯絡電話：%@",model.customerName,model.customerNum,model.insuranceNum,model.productType,model.customePay==0?@"是":@"否",model.contactNum];
    }
    return detailInfo;
}

- (void)data:(MSMeetingDetailModel*)model
{
    [super data:model];
    contentDetailView.titleLabel.text = @"提醒內容";
    contentDetailView.detailLabel.attributedText = [self getTextAttributeString:model.remindConent];
    
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
        meetingDemandView.detailLabel.attributedText = [self getTextAttributeString:[MSNoticeDetailCell getDemandInfo:model]];
        
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
    CGFloat agendaHeight = [MSTitleAndDetailView titleAndDetailViewHeight:model.agenda width:kScreenWidth-10*2];
    CGFloat demandHeight = [MSTitleAndDetailView titleAndDetailViewHeight:[MSNoticeDetailCell getDemandInfo:model] width:kScreenWidth-10*2];
    CGFloat remindContentHeight = [MSTitleAndDetailView titleAndDetailViewHeight:model.remindConent width:kScreenWidth-10*2];
       
    CGFloat tottalHeight = remindContentHeight+70+70+127+agendaHeight+demandHeight+114;
    
    if (model.meetingType == MeetingType_Money) {
        tottalHeight = remindContentHeight+70+70+114;
        
    } else if (model.meetingType == MeetingType_Validate) {
        tottalHeight = remindContentHeight+70+70+demandHeight+114;
    }
    
    return tottalHeight;
}

- (void)buttonClickAction:(UIButton*)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickNoticeDetailSureActionCell:)]) {
        [self.delegate didClickNoticeDetailSureActionCell:self];
    }
}

@end
