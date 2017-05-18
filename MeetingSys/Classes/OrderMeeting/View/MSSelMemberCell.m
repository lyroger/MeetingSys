//
//  MSSelMemberCell.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/18.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSSelMemberCell.h"

@interface MSSelMemberCell()
{
    UIImageView *selectedImage;
    UIImageView *memberHeadImage;
    UILabel     *nameLabel;
    UILabel     *titleLabel;
}

@end

@implementation MSSelMemberCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        selectedImage = [UIImageView new];
        selectedImage.image = [UIImage imageNamed:@"people_selected"];
        selectedImage.hidden = YES;
        [self.contentView addSubview:selectedImage];
        
        memberHeadImage = [UIImageView new];
        memberHeadImage.layer.cornerRadius = 18;
        memberHeadImage.layer.masksToBounds = YES;
        [self.contentView addSubview:memberHeadImage];

        nameLabel = [UILabel new];
        nameLabel.font = kFontPingFangRegularSize(14);
        nameLabel.textColor = UIColorHex(0x888888);
        [self.contentView addSubview:nameLabel];
        
        titleLabel = [UILabel new];
        titleLabel.font = kFontPingFangRegularSize(14);
        titleLabel.textColor = UIColorHex(0x888888);
        titleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:titleLabel];
        
        [selectedImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.left.mas_equalTo(15);
            make.centerY.equalTo(self.contentView);
        }];
        
        [memberHeadImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(36, 36));
            make.left.mas_equalTo(46);
            make.centerY.equalTo(self.contentView);
        }];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(96);
            make.centerY.equalTo(self.contentView);
            make.right.mas_equalTo(titleLabel.mas_left).mas_offset(-10);
            make.height.equalTo(@22);
        }];

        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(nameLabel.mas_right).mas_offset(10);
            make.centerY.equalTo(self.contentView);
            make.height.equalTo(@22);
        }];
        
    }
    
    return self;
}

- (void)showSelected:(BOOL)show
{
    selectedImage.hidden = !show;
}

- (void)data:(MSMemberModel*)model
{
    [memberHeadImage sd_setImageWithURL:kImageURLWithLastString(model.headURL) placeholderImage:[UIImage imageNamed:@"portrait_xiao"]];
    nameLabel.text = model.name;
    titleLabel.text = model.title;
    selectedImage.hidden = !model.isSelected;
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
