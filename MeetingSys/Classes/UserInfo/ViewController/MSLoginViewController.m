//
//  MNLoginViewController.m
//  MeNote
//
//  Created by luoyan on 2017/4/21.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSLoginViewController.h"
#import "MNBottomTitleButton.h"
#import "MSAgreementViewController.h"

@interface MSLoginViewController ()<UITextFieldDelegate>
{
    UIControl *loginContentView;
    UIView *accountInputContent;
    UITextField *userTextField;
    UITextField *pwdTextField;
    
    UIView *loginActionContentView;
    UIButton *loginButton;
    
    UIView *loginOtherContentView;
    
    UIButton *agreeButton;
    BOOL isAgreement;
    
}

@property (nonatomic, strong) UIButton *btnLogin;

@end

@implementation MSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    [self notificationRegister];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)loadSubView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //加载页面布局的父容器
    loginContentView = [UIControl new];
    loginContentView.frame = self.view.bounds;
    [loginContentView addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginContentView];
    
    //加载logo
    UIImageView *logoImage = [[UIImageView alloc] init];
    logoImage.contentMode = UIViewContentModeScaleAspectFit;
    logoImage.image = [UIImage imageNamed:@"login_logo"];
    [loginContentView addSubview:logoImage];
    
    //加载账号密码输入框
    accountInputContent = [UIView new];
    accountInputContent.backgroundColor = [UIColor whiteColor];
    [loginContentView addSubview:accountInputContent];
    
    UIView *accountLine = [UIView new];
    accountLine.backgroundColor = UIColorHex(0xE5E5E5);
    [accountInputContent addSubview:accountLine];
    
    UIView *pwdLine = [UIView new];
    pwdLine.backgroundColor = UIColorHex(0xE5E5E5);
    [accountInputContent addSubview:pwdLine];
    
    UIImageView *accountImage = [UIImageView new];
    accountImage.image = [UIImage imageNamed:@"login_account"];
    [accountInputContent addSubview:accountImage];
    
    UIImageView *pwdImage = [UIImageView new];
    pwdImage.image = [UIImage imageNamed:@"login_password"];
    [accountInputContent addSubview:pwdImage];
    
    NSString *username = [MSUserInfo shareUserInfo].userAcount;
    userTextField = [UITextField new];
    userTextField.placeholder = @"請輸入賬號";
    userTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    userTextField.returnKeyType = UIReturnKeyNext;
    userTextField.delegate = self;
    userTextField.text = username;
    userTextField.tintColor = UIColorHex(0xFF7B54);
    userTextField.font = kFontPingFangRegularSize(16);
    userTextField.textColor = UIColorHex(0x666666);
    [accountInputContent addSubview:userTextField];
    
    
    NSString *password = [[MSUserInfo shareUserInfo] getPassword];
    pwdTextField = [UITextField new];
    pwdTextField.placeholder = @"請輸入密碼（8﹣12位）";
    pwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdTextField.secureTextEntry = YES;
    pwdTextField.returnKeyType = UIReturnKeyDone;
    pwdTextField.delegate = self;
    pwdTextField.text = password;
    pwdTextField.tintColor = UIColorHex(0xFF7B54);
    pwdTextField.font = kFontPingFangRegularSize(16);
    pwdTextField.textColor = UIColorHex(0x666666);
    [accountInputContent addSubview:pwdTextField];
    
    
    //加载登录按钮
    loginActionContentView = [UIView new];
    loginActionContentView.backgroundColor = self.view.backgroundColor;
    [loginContentView addSubview:loginActionContentView];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(0xE3E3E3)] forState:UIControlStateDisabled];
    [loginButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(0xFF7B54)] forState:UIControlStateNormal];
    
    loginButton.layer.cornerRadius = 4;
    loginButton.layer.borderColor = [UIColor clearColor].CGColor;
    loginButton.layer.borderWidth = 1;
    loginButton.layer.masksToBounds = YES;
    
    [loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"登錄" forState:UIControlStateNormal];
    loginButton.enabled = NO;
    loginButton.titleLabel.font = kFontPingFangMediumSize(18);
    [loginActionContentView addSubview:loginButton];
    
    if (username.length > 0 && password.length > 0) {
        loginButton.enabled = YES;
    } else {
        loginButton.enabled = NO;
    }
    
    
    //协议
    agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeButton.tag = 100;
    [agreeButton setImage:[UIImage imageNamed:@"login_agreement_off"] forState:UIControlStateNormal];
    [agreeButton addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginActionContentView addSubview:agreeButton];
    
    UILabel *labelAgree = [UILabel new];
    labelAgree.text = @"同意";
    labelAgree.font = kFontSize(12);
    labelAgree.textColor = UIColorHex(0xCACACA);
    [loginActionContentView addSubview:labelAgree];
    
    UIButton *agreeDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeDetailButton.tag = 101;
    agreeDetailButton.titleLabel.font = kFontSize(12);
    [agreeDetailButton setTitleColor:UIColorHex(0xFFA200) forState:UIControlStateNormal];
    [agreeDetailButton setTitle:@"《協議》" forState:UIControlStateNormal];
    [agreeDetailButton addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginActionContentView addSubview:agreeDetailButton];
    /**
     *  布局
     */
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(100*ScreenMutiple6));
        make.size.mas_equalTo(CGSizeMake(230, 82));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [accountInputContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(40));
        make.right.equalTo(@(-40));
        make.top.mas_equalTo(logoImage.mas_bottom).mas_offset(40);
        make.height.equalTo(@(140));
    }];
    
    [accountLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.right.equalTo(@(-10));
        make.centerY.mas_equalTo(accountInputContent.mas_centerY);
        make.height.mas_equalTo(@(1));
    }];
    
    [pwdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.right.equalTo(@(-10));
        make.bottom.mas_equalTo(-1);
        make.height.mas_equalTo(@(1));
    }];
    
    [accountImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(12));
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.top.equalTo(@(24));
    }];
    
    [pwdImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(12));
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.bottom.mas_equalTo(-24);
    }];
    
    [userTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountImage.mas_right).offset(12);
        make.centerY.equalTo(accountImage).offset(2);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(-12);
    }];
    
    [pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pwdImage.mas_right).offset(12);
        make.centerY.equalTo(pwdImage).offset(1);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(-12);
    }];
    
    //登录按钮及记住密码层
    [loginActionContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(accountInputContent.mas_bottom).offset(50);
        make.left.equalTo(accountInputContent);
        make.right.equalTo(accountInputContent);
        make.height.mas_equalTo(90);
    }];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    
    //同意協議
    [agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginButton);
        make.top.mas_equalTo(loginButton.mas_bottom).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [labelAgree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(agreeButton.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(agreeButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(25, 22));
    }];
    
    [agreeDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelAgree.mas_right).mas_offset(0);
        make.centerY.mas_equalTo(agreeButton.mas_centerY);
    }];
}

- (void)agreeAction:(UIButton*)button
{
    if (button.tag == 100) {
        //複選框
        isAgreement = !isAgreement;
        if (isAgreement) {
            [agreeButton setImage:[UIImage imageNamed:@"login_agreement_on"] forState:UIControlStateNormal];
        } else {
            [agreeButton setImage:[UIImage imageNamed:@"login_agreement_off"] forState:UIControlStateNormal];
        }
        [self textFieldTextDidChange:nil];
    } else if (button.tag == 101) {
        //進入協議詳情
        MSAgreementViewController *agreeVC = [[MSAgreementViewController alloc] init];
        [self.navigationController pushViewController:agreeVC animated:YES];
    }
}

/**
 *   隐藏键盘
 */
- (void)hideKeyboard
{
    [userTextField resignFirstResponder];
    [pwdTextField resignFirstResponder];
}

- (void)loginAction:(UIButton*)button
{
    [self hideKeyboard];
    
    if (![self verifyEnableLogin]) {
        [HUDManager alertWithTitle:@"输入信息不正确!"];
        return;
    }
    
    NSString *username = [userTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [pwdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (username.length > 0 && password.length > 0) {
        DLog(@"账号密码格式正确");
        [MSUserInfo loginWithLoginId:username password:password networkHUD:NetworkHUDLockScreenAndError target:self success:^(StatusModel *data) {
            if (data.code == 0) {
                //登录成功
                MSUserInfo *userInfo = data.data;
                userInfo.token = data.token;
                userInfo.username = username;
                userInfo.userAcount = username;
                [[MSUserInfo shareUserInfo] setUserInfo:userInfo];
                [[MSUserInfo getUsingLKDBHelper] insertToDB:userInfo callback:^(BOOL result) {
                    NSLog(@"result = %zd",result);
                }];
                
                [[NSUserDefaults standardUserDefaults] setObject:userInfo.userAcount forKey:kLastUserAcount];
                
                if (self.loginCompleteBlock) {
                    self.loginCompleteBlock(YES);
                }
                
            }
        }];
    } else {
        DLog(@"请输入8位长度的密码");
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:pwdTextField]) {
        [pwdTextField resignFirstResponder];
    } else if ([textField isEqual:userTextField]) {
        [pwdTextField becomeFirstResponder];
    }
    return YES;
}

- (void)textFieldTextDidChange:(NSNotification *)note
{
    loginButton.enabled = [self verifyEnableLogin];
}

- (BOOL)verifyEnableLogin
{
    NSString *username = [userTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [pwdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (username.length > 0 && password.length > 0 && isAgreement) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Keyboard Methods
- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillHidden:(NSNotification *)note
{
    [UIView animateWithDuration:0.3f animations:^{
        loginContentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (void)keyboardWillShown:(NSNotification *)note
{
    CGFloat height = 0;
    NSDictionary *info = [note userInfo];
    NSInteger keyboardHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    height = accountInputContent.mj_origin.y+pwdTextField.mj_origin.y+pwdTextField.mj_h;
    
    CGFloat offsetY;
    
    if (loginContentView.frame.size.height - keyboardHeight <= height)
        offsetY = height - loginContentView.size.height + keyboardHeight + 10;
    else
        return;
    
    NSNumber *number = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    double duration = [number doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        loginContentView.frame = CGRectMake(0, -offsetY, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
