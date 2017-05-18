//
//  SHMSelectActionCell.m
//  SellHouseManager
//
//  Created by luoyan on 16/5/11.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import "SHMSelectActionCell.h"

@interface SHMSelectActionCell()
{
    UIImageView *selectImageView;
}
@end

@implementation SHMSelectActionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        selectImageView = [UIImageView new];
//        selectImageView.image = [UIImage imageNamed:@"icon_select"];
        [self.contentView addSubview:selectImageView];
        
        [selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        selectImageView.hidden = YES;
        self.textLabel.font = kTitleTextFont;
        self.textLabel.textColor = UIColorHex(0x333333);
    }
    
    return self;
}

/**
 *  显示选中状态
 */
- (void)showSelected
{
    selectImageView.hidden = NO;
    self.textLabel.textColor = UIColorHex(0x02B0F0);
    if (self.isMultipleSelect) {
        selectImageView.image = [UIImage imageNamed:@"login_icon_select"];
//        [selectImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(16, 16));
//        }];
    } else {
//        selectImageView.image = [UIImage imageNamed:@"icon_select"];
//        [selectImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(21, 13));
//        }];
        selectImageView.hidden = YES;
    }
    
}
/**
 *  隐藏选中状态
 */
- (void)hideSelected
{
    selectImageView.hidden = YES;
    self.textLabel.textColor = UIColorHex(0x333333);
    if (self.isMultipleSelect) {
        selectImageView.hidden = NO;
        selectImageView.image = [UIImage imageNamed:@"login_icon_unselect"];
//        [selectImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(16, 16));
//        }];
    }
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
