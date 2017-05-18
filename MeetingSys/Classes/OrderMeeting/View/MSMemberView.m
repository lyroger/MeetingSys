//
//  MSMemberView.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/11.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSMemberView.h"

@interface MSMemberCellView()
{
    
}
@end


@implementation MSMemberCellView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageHead = [UIImageView new];
        self.imageHead.layer.cornerRadius = 26;
        self.imageHead.layer.masksToBounds = YES;
        self.imageHead.contentMode = UIViewContentModeScaleAspectFill;
        self.imageHead.userInteractionEnabled = YES;
        [self addSubview:self.imageHead];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteMember)];
        [self.imageHead addGestureRecognizer:tap];
        
        self.labelName = [UILabel new];
        self.labelName.font = kFontPingFangRegularSize(10);
        self.labelName.textColor =  UIColorHex(0x888888);
        self.labelName.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.labelName];
        
        [self.imageHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [self.labelName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageHead.mas_bottom).mas_offset(8);
            make.left.right.mas_equalTo(0);
            make.height.equalTo(@14);
        }];
        
    }
    return self;
}

- (void)bindRAC
{
    [RACObserve(self,self.memberModel.headURL) subscribeNext:^(NSString *headURL) {
        [self.imageHead sd_setImageWithURL:kImageURLWithLastString(headURL) placeholderImage:[UIImage imageNamed:@"portrait_xiao"]];
    }];
}

- (void)deleteMember
{
    if (self.clickBlock) {
        self.clickBlock(self);
    }
}

@end

@interface MSMemberView()
{
    UILabel  *titleLabel;
    UIScrollView *memberScrollView;
}

@end

@implementation MSMemberView

- (id)init
{
    if (self = [super init]) {
        titleLabel = [UILabel new];
        titleLabel.font = kFontPingFangRegularSize(14);
        titleLabel.textColor = UIColorHex(0x888888);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        memberScrollView = [UIScrollView new];
        memberScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:memberScrollView];
        
        self.bottomLine = [UILabel new];
        self.bottomLine.backgroundColor = UIColorHex(0xE3E3E3);
        [self addSubview:self.bottomLine];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.left.equalTo(@10);
            make.right.equalTo(@(-10));
            make.height.equalTo(@14);
        }];
        
        [memberScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(10);
            make.height.mas_equalTo(97);
        }];
        
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            make.height.equalTo(@(0.6));
        }];
    }
    
    return self;
}

- (void)membersData:(NSArray*)datas
{
    titleLabel.text = @"參與人員";
    CGFloat width = 60;
    CGFloat marginWidth = 10;
    
    [memberScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < datas.count; i++) {
        MSMemberModel *member = [datas objectAtIndex:i];
        
        MSMemberCellView *memberCell = [[MSMemberCellView alloc] initWithFrame:CGRectMake(10 + (width+marginWidth)*i, 0, width, 97)];
        [memberCell.imageHead sd_setImageWithURL:kImageURLWithLastString(member.headURL) placeholderImage:[UIImage imageNamed:@"portrait_xiao"]];
        memberCell.memberModel = member;
        [memberCell bindRAC];
        memberCell.labelName.text = member.name;
        [memberScrollView addSubview:memberCell];
        
        memberCell.clickBlock = ^(MSMemberCellView *view) {
            [self deleteMember:view];
        };
    }
    
    [memberScrollView setContentSize:CGSizeMake(10 + (width+marginWidth)*datas.count, memberScrollView.height)];
}

- (void)deleteMember:(MSMemberCellView*)cell
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickMemberCell:)]) {
        [self.delegate didClickMemberCell:cell];
    }
}
@end
