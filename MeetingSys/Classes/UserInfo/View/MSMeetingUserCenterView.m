//
//  MSMeetingUserCenterView.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/9.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSMeetingUserCenterView.h"
#import "MSUserInfoCell.h"

@interface MSMeetingUserCenterView()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *userInfoTableView;
}

@end

@implementation MSMeetingUserCenterView

- (id)init
{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        [self addTarget:self action:@selector(hideUserCenterView) forControlEvents:UIControlEventTouchUpInside];

        userInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(-kScreenWidth*2/3, 0, kScreenWidth*2/3, kScreenHeight) style:UITableViewStyleGrouped];
        userInfoTableView.scrollEnabled = NO;
        userInfoTableView.delegate = self;
        userInfoTableView.dataSource = self;
        userInfoTableView.backgroundColor = UIColorHex(0xffffff);
        userInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        userInfoTableView.layer.shadowOffset = CGSizeMake(5, 0);
        userInfoTableView.layer.shadowColor = UIColorHex_Alpha(0x000000, 0.5).CGColor;
        userInfoTableView.layer.shadowOpacity = 0.5;
        [userInfoTableView registerClass:[MSUserInfoCell class] forCellReuseIdentifier:@"MSUserInfoCell"];
        [self addSubview:userInfoTableView];
    }
    return self;
}

- (void)showUserCenterView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = UIColorHex_Alpha(0x000000, 0.35);
        userInfoTableView.frame = CGRectMake(0, 0, kScreenWidth*2/3, kScreenHeight);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideUserCenterView
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [UIColor clearColor];
        userInfoTableView.frame = CGRectMake(-kScreenWidth*2/3 ,0 , kScreenWidth*2/3, kScreenHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark UItableviewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
    } else if (indexPath.row > 0 && indexPath.row <= 4) {
        return 32;
    } else if (indexPath.row == 5){
        return 10;
    } else {
        return 46;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= 5) {
        MSUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSUserInfoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorHex(0xffffff);
        if (indexPath.row == 0) {
            cell.labelTitle.hidden = YES;
            cell.imageIcon.hidden = NO;
            [cell.imageIcon sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"notice_icon_1"]];
        } else if (indexPath.row>0 && indexPath.row <= 4){
            cell.imageIcon.hidden = YES;
            cell.labelTitle.hidden = NO;
            if (indexPath.row == 1) {
                cell.labelTitle.font = kFontPingFangRegularSize(18);
                cell.labelTitle.textColor = UIColorHex(0x333333);
                cell.labelTitle.text = @"Mancy Wong";
            } else {
                cell.labelTitle.font = kFontPingFangRegularSize(14);
                cell.labelTitle.textColor = UIColorHex(0x888888);
            }
            cell.labelTitle.text = @"會議系統";
        } else {
            cell.labelTitle.text = 0;
            cell.labelTitle.hidden = YES;
            cell.imageIcon.hidden = YES;
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.backgroundColor = UIColorHex(0xffffff);
            cell.textLabel.font = kFontPingFangRegularSize(16);
            cell.textLabel.textColor = UIColorHex(0x333333);
        }
        
        NSArray *datas = @[@"修改密碼",@"檢查更新",@"退出"];
        NSArray *images = @[@"me_password",@"me_update",@"me_out"];
        
        NSString *image = images[indexPath.row-6];
        cell.imageView.image = [UIImage imageNamed:image];
        cell.textLabel.text = datas[indexPath.row-6];
        return cell;
    }
}
@end
