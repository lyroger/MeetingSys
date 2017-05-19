//
//  CSDatePickView.m
//  SellHouseManager
//
//  Created by yangxu on 16/5/19.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import "CSDatePickView.h"

@interface CSDatePickView()
{
    UIButton    *buttonOK;
    UILabel     *titleLabel;
}

@property (nonatomic,strong) UIControl *backShadowView;
@property (nonatomic,strong) UIView *contentView;

@end

@implementation CSDatePickView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        [self loadBackShadowView];
        [self loadContentView];
        
        UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;
        keyWindow.windowLevel = UIWindowLevelNormal;
        [keyWindow addSubview:self];
    }
    return self;
}

- (void)showDatePickerView
{
    self.hidden = NO;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(){
        self.backShadowView.alpha = 0.6;
        self.contentView.frame = CGRectMake(0,
                                            self.frame.size.height - self.contentView.frame.size.height,
                                            self.contentView.frame.size.width,
                                            self.contentView.frame.size.height);
    } completion:nil];
}

- (void)hideSelectActionView
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(){
        self.backShadowView.alpha = 0;
        self.contentView.frame = CGRectMake(0,
                                            self.frame.size.height,
                                            self.contentView.frame.size.width,
                                            self.contentView.frame.size.height);
    } completion:^(BOOL isfinished){
        self.hidden = YES;
    }];
}

- (void)loadBackShadowView
{
    self.backShadowView = [[UIControl alloc] initWithFrame:self.bounds];
    self.backShadowView.backgroundColor = [UIColor blackColor];
    self.backShadowView.alpha = 0.0f;
    [self.backShadowView addTarget:self action:@selector(hideSelectActionView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backShadowView];
}

- (void)loadContentView
{
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 174+44)];
    self.contentView.backgroundColor = UIColorRGB(242, 242, 242);
    [self addSubview:self.contentView];
    
    UIView *navContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    navContentView.backgroundColor = UIColorRGB(242, 242, 242);
    
    
    CGFloat buttonWidth = 80;
    
    UIButton *buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonCancel.frame = CGRectMake(0, 1, 80, 44-2);
    buttonCancel.backgroundColor = UIColorRGB(242, 242, 242);
    buttonCancel.tag = 2;
    [buttonCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
    buttonCancel.titleLabel.font = [UIFont systemFontOfSize:16];
    [buttonCancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [buttonCancel addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [navContentView addSubview:buttonCancel];
    
    
    titleLabel = [UILabel new];
    titleLabel.font = kFontSize16;
    titleLabel.textColor = [UIColor darkTextColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(buttonWidth+10, (navContentView.mj_h-25)/2, navContentView.mj_w-buttonWidth*2-10*2, 25);
    [navContentView addSubview:titleLabel];
    
    
    buttonOK = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonOK.frame = CGRectMake(navContentView.mj_w-81, 1, buttonWidth, 44-2);
    [buttonOK setTitle:@"確定" forState:UIControlStateNormal];
    buttonOK.backgroundColor = UIColorRGB(242, 242, 242);
    buttonOK.tag = 1;
    buttonOK.titleLabel.font = [UIFont systemFontOfSize:16];
    [buttonOK setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonOK setTitleColor:UIColorHex(0xFFB072) forState:UIControlStateNormal];
    [buttonOK addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [navContentView addSubview:buttonOK];
    
    [self.contentView addSubview:navContentView];
    
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.frame = CGRectMake(0, 45, kScreenWidth, 174);
    _datePicker.minuteInterval = 1;
    // 设置时区
//  [_datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    // 设置显示最小时间
    NSDate *minDate = [NSDate date];
    [_datePicker setMinimumDate:minDate];
    // 设置当前显示时间（此处为当前时间）
    [_datePicker setDate:[NSDate date] animated:YES];
    // 设置UIDatePicker的显示模式
    [_datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    // 当值发生改变的时候调用的方法
//    [_datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    _datePicker.backgroundColor = UIColorRGB(242, 242, 242);
    [self.contentView addSubview:_datePicker];
}

- (void)setTitle:(NSString *)title
{
    titleLabel.text = title;
}

- (void)buttonClickAction:(UIButton*)button
{
    if (button.tag == 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPickerDate:)]) {
            [self.delegate didPickerDate:_datePicker.date];
        }

        [self hideSelectActionView];
        
    } else if (button.tag == 2) {
        [self hideSelectActionView];
    }
}


@end
