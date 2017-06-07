//
//  MSUpdatePwdViewController.m
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/17.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSUpdatePwdViewController.h"
#import "MSInputView.h"

@interface MSUpdatePwdViewController ()
{
    MSInputView *oldPwdView;
    MSInputView *newPwdView;
    MSInputView *repeatPwdView;
}

@end

@implementation MSUpdatePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    // Do any additional setup after loading the view.
}

- (void)loadSubView
{
    self.title = @"修改密碼";
    [self rightBarButtonWithName:@"保存" normalColor:kMainColor disableColor:UIColorHex_Alpha(0xDF1B20, 0.6) target:self action:@selector(updatePwd)];
    
    CGFloat height = 90;
    
    oldPwdView = [[MSInputView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    [oldPwdView title:@"舊密碼" placeholder:@"請輸入舊密碼"];
    newPwdView = [[MSInputView alloc] initWithFrame:CGRectMake(0, height, kScreenWidth, height)];
    [newPwdView title:@"新密碼" placeholder:@"請輸入新密碼"];
    repeatPwdView  = [[MSInputView alloc] initWithFrame:CGRectMake(0, height*2, kScreenWidth, height)];
    [repeatPwdView title:@"確認密碼" placeholder:@"請確認密碼"];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, repeatPwdView.origin.y+repeatPwdView.height+30, kScreenWidth-15*2, 25)];
    tipsLabel.text = @"注意事項：密碼長度為1到20位長度";
    tipsLabel.font = kFontPingFangRegularSize(12);
    tipsLabel.textColor = UIColorHex(0xbbbbbb);
    [self.view addSubview:tipsLabel];
    [self.view addSubview:oldPwdView];
    [self.view addSubview:newPwdView];
    [self.view addSubview:repeatPwdView];
    
    [self racForNavRightBt];
}

- (void)updatePwd
{
    [MSUserInfo updatePwd:newPwdView.textField.text oldPwd:oldPwdView.textField.text hud:NetworkHUDLockScreen target:self success:^(StatusModel *data) {
        if (0 == data.code) {
            [self.navigationController popViewControllerAnimated:YES];
        } 
    }];
}

- (void)racForNavRightBt
{
    //满足条件的情况才使得按钮可用
    UIBarButtonItem *navRightItem = self.navigationItem.rightBarButtonItem;
    RAC(navRightItem, enabled) = [RACSignal combineLatest:@[oldPwdView.textField.rac_textSignal,
                                                            newPwdView.textField.rac_textSignal,
                                                            repeatPwdView.textField.rac_textSignal]
                                                   reduce:^(NSString *oldPwd,
                                                            NSString *newPwd,
                                                            NSString *repeatPwd
                                                            ){

                                                       if (   oldPwd.length >= 1
                                                           && oldPwd.length <= 20
                                                           && newPwd.length >= 1
                                                           && newPwd.length <= 20
                                                           && repeatPwd.length >=1
                                                           && repeatPwd.length <= 20
                                                           && [newPwd isEqualToString:repeatPwd]) {
                                                           return @(YES);
                                                       } else {
                                                           return @(NO);
                                                       }
                                                   }];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
