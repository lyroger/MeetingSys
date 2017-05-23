//
//  MSUserInfoCell.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/9.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSUserInfoCell.h"

@interface MSUserInfoCell()
{
    
}

@end

@implementation MSUserInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imageIcon = [UIImageView new];
        self.imageIcon.contentMode = UIViewContentModeScaleAspectFill;
        self.imageIcon.layer.cornerRadius = 30;
        self.imageIcon.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageIcon];
        
        [self.imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        self.labelTitle = [UILabel new];
        self.labelTitle.font = kFontPingFangRegularSize(14);
        self.labelTitle.textColor = UIColorHex(0x888888);
        self.labelTitle.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.labelTitle];
        
        [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.equalTo(@22);
        }];
        
    }
    
    return self;
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
