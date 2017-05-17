//
//  HAlertController.h
//  HuiXin
//
//  Created by wj on 15/11/10.
//  Copyright © 2015年 . All rights reserved.
//

/*
 example1:
 如果只想提示错误信息
 HAlertControllerShow(text,controller) text代表错误信息 controller代表所在的UIViewController
 example2:
 只想有标题 详情信息 并且按钮最多两个的可以这个 不用实现代理方法
 [[HAlertController   alertControllerWithTitle:(NSString *)title
					 message:(NSString *)message
					 delegate:(id<HAlertControllerDelegate>)delegate
					 cannelButton:(NSString *)cannelButton
					 otherButton:(NSString *)otherButton]showInController:controller]

 example3:
 如果带有输入框 多个按钮 或者是UIActionSheet
 [[HAlertController alloc]initWithdDelegate:(id<HAlertControllerDelegate>)delegate
						  type:(HAlertControllerType)type
						  title:(NSString *)title
						  message:(NSString *)message]showInController:controller]



 */

#import <UIKit/UIKit.h>
@class HActionSheetWeChat;
@class HAlertController;
@protocol HAlertControllerDelegate;

typedef void (^HActionSheetWeChatComplete) (NSInteger buttonIndex,
											 HActionSheetWeChat *actionSheet);
typedef void (^HAlertControllerComplete) (NSUInteger buttonIndex,
										   HAlertController *actionController);

typedef NS_ENUM (NSUInteger, HAlertControllerType) {

	HAlertControllerTypeAlertView,
	HAlertControllerTypeActionSheet,
	///仿照微信的做的
	HAlertControllerTypeCustomValue1
};

///封装系统的UIAlertView UIActionSheet
@interface HAlertController : NSObject

- (instancetype)initWithdDelegate:(id<HAlertControllerDelegate>)delegate
							 type:(HAlertControllerType)type
							title:(NSString *)title
						  message:(NSString *)message
	__deprecated_msg (
		"alertControllerWithTitle: message: cannelButton: otherButtons: type: complete:");
//用户系统的提示框
+ (instancetype)alertControllerWithTitle:(NSString *)title
								 message:(NSString *)message
								delegate:(id<HAlertControllerDelegate>)delegate
							cannelButton:(NSString *)cannelButton
							 otherButton:(NSString *)otherButton
	__deprecated_msg (
		"alertControllerWithTitle: message: cannelButton: otherButtons: type: complete:");
/*!
 *  唯一的初始化方法
 *
 *  @param title        标题
 *  @param message      内容
 *  @param cannelButton 取消按钮 index=0
 *  @param otherButtons 其他按钮的数组 index=1...
 *  @param type         类型 HAlertControllerTypeCustomValue1仿照微信
 *  @param complete     回调
 *
 *  @return
 */
+ (instancetype)alertControllerWithTitle:(NSString *)title
								 message:(NSString *)message
							cannelButton:(NSString *)cannelButton
							otherButtons:(NSArray *)otherButtons
									type:(HAlertControllerType)type
								complete:(HAlertControllerComplete)complete;

@property (nonatomic, assign) UIAlertViewStyle alertViewStyle;
@property (nonatomic, assign) UIActionSheetStyle actionSheetStyle;
@property (nonatomic, assign) NSUInteger tag;
@property (nonatomic, assign) id<HAlertControllerDelegate>delegate;

- (void)showInController:(UIViewController *)controller;
///获取HAlertControllerTypeCustomValue1所有的按钮 用于自定义字体的颜色
- (NSArray<UIButton *> *)buttonArrayWithCustomValue1;

- (UITextField *)textFiledWithTag:(NSUInteger)tag;

@end

@protocol HAlertControllerDelegate <NSObject>
@required
- (NSArray<NSString *> *)buttonNamesWithAlertController:(HAlertController *)alertController;

@optional
- (NSUInteger)textFiledsWithAlertController:(HAlertController *)alertController;

- (void)alertControllerDidSelectButtonIndex:(NSUInteger)buttonIndex
							alertController:(HAlertController *)alertController;

@end

@interface UIAlertAction (Tag)
@property (nonatomic, assign) NSUInteger tag;
@end
///仿微信界面的样式
@interface HActionSheetWeChat : UIView {

  @public
	UIButton *_cannelButton;
	NSMutableArray *_otherButtons;
}
+ (instancetype)actionSheetWithTitle:(NSString *)title
							 message:(NSString *)message
						cannelButton:(NSString *)cannelButton
						otherButtons:(NSArray *)otherButton
							complete:(HActionSheetWeChatComplete)complete;
- (void)show;
@end

NS_INLINE void HArrayAddObject (id object, NSMutableArray *array) {

	if (object)
		[array addObject:object];
}