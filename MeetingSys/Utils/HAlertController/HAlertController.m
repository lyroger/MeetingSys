//
//  HAlertController.m
//  HuiXin
//
//  Created by wj on 15/11/10.
//  Copyright © 2015年 . All rights reserved.
//

#import "HAlertController.h"
#import <objc/runtime.h>
static NSMutableArray *SAlertControllerArray;
@interface HAlertController () <UIAlertViewDelegate, UIActionSheetDelegate>
@property (nonatomic, strong) NSArray<NSString *> *buttonArray;
@end
@implementation HAlertController {

	//id<HAlertControllerDelegate> _delegate;
	HAlertControllerType _type;
	NSString *_title;
	NSString *_message;
	UIAlertView *_alertView;
	UIActionSheet *_actionSheet;
	UIAlertController *_alertController;
	NSArray *_buttonArray;
	NSUInteger _textFiledNumber;
	HActionSheetWeChat *_actionSheetWeChat;
	HAlertControllerComplete _complete;
    NSMutableArray *_textFileds;
}

- (instancetype)initWithdDelegate:(id<HAlertControllerDelegate>)delegate
							 type:(HAlertControllerType)type
							title:(NSString *)title
						  message:(NSString *)message {

	title = title ?: @"";
	message = message ?: @"";
	_delegate = delegate;
	_type = type;
	_title = title;
	_message = message;
	self = [super init];
	if (self) {
		[self _init];
	}
	return self;
}

- (instancetype)initWithdDelegate:(id<HAlertControllerDelegate>)delegate
							 type:(HAlertControllerType)type
							title:(NSString *)title
						  message:(NSString *)message
						  buttons:(NSArray *)buttons
						 complete:(HAlertControllerComplete)complete {

	title = title ?: @"";
	message = message ?: @"";
    self = [super init];
	if (self) {
		_delegate = delegate;
		_type = type;
		_title = title;
		_message = message;
		self.buttonArray = buttons;
		_complete = complete;
		[self _init];
	}
	return self;
}

+ (instancetype)alertControllerWithTitle:(NSString *)title
								 message:(NSString *)message
								delegate:(id<HAlertControllerDelegate>)delegate
							cannelButton:(NSString *)cannelButton
							 otherButton:(NSString *)otherButton {

	NSMutableArray *buttons = [NSMutableArray array];
	HArrayAddObject (otherButton, buttons);
	HArrayAddObject (cannelButton, buttons);
	HAlertController *alertController =
		[[HAlertController alloc] initWithdDelegate:delegate
												type:HAlertControllerTypeAlertView
											   title:title
											 message:message
											 buttons:buttons
											complete:nil];
	return alertController;
}
+ (instancetype)alertControllerWithTitle:(NSString *)title
								 message:(NSString *)message
							cannelButton:(NSString *)cannelButton
							otherButtons:(NSArray *)otherButtons
									type:(HAlertControllerType)type
								complete:(HAlertControllerComplete)complete {
	NSMutableArray *buttons = [NSMutableArray array];
	if (otherButtons) {
		[buttons addObjectsFromArray:otherButtons];
	}
	HArrayAddObject (cannelButton, buttons);
	HAlertController *alertController = [[HAlertController alloc] initWithdDelegate:nil
																				 type:type
																				title:title
																			  message:message
																			  buttons:buttons
																			 complete:complete];
	return alertController;
}
- (void)_init {
	if (!SAlertControllerArray) {
		SAlertControllerArray = [NSMutableArray array];
	}
	[SAlertControllerArray addObject:self];
	_alertController = nil;
	if (!self.buttonArray) {
		self.buttonArray = [_delegate buttonNamesWithAlertController:self];
	}
	if (_delegate && [_delegate respondsToSelector:@selector (textFiledsWithAlertController:)]) {
		_textFiledNumber = [_delegate textFiledsWithAlertController:self];
	}
	if (_type == HAlertControllerTypeAlertView) {
		[self _initAlertView];
	} else if (_type == HAlertControllerTypeActionSheet) {
		[self _initAlertSheet];
	} else if (_type == HAlertControllerTypeCustomValue1) {
		NSString *cannelButton = ({
			cannelButton = nil;
			if (self.buttonArray.count > 0) {
				cannelButton = self.buttonArray[self.buttonArray.count - 1];
			}
			cannelButton;
		});
		NSArray *otherButtons = ({
			otherButtons = nil;
			if (self.buttonArray.count > 1) {
				otherButtons = [self.buttonArray
					subarrayWithRange:NSMakeRange (0, self.buttonArray.count - 1)];
			}
			otherButtons;
		});
		kSelfWeak;
		_actionSheetWeChat = [HActionSheetWeChat
			actionSheetWithTitle:_title
						 message:_message
					cannelButton:cannelButton
					otherButtons:otherButtons
						complete:^(NSInteger buttonIndex, HActionSheetWeChat *actionSheet) {
							kSelfStrong;
							if (strongSelf) {
								NSInteger index = buttonIndex;
								if (strongSelf->_complete) {
									strongSelf->_complete (index, strongSelf);
								}
								[strongSelf removeSelf];
							}
						}];
	}
}
-(void)setDelegate:(id<HAlertControllerDelegate>)delegate{
    _delegate=delegate;
    if (_delegate && [_delegate respondsToSelector:@selector(textFiledsWithAlertController:)]) {
        _textFiledNumber=[_delegate textFiledsWithAlertController:self];
    }
    if (_textFiledNumber==0) {
        return;
    }
    if (!_textFileds) {
        _textFileds=[NSMutableArray array];
    }
    if (ISIOS8) {
        for (NSUInteger i = 0; i < _textFiledNumber; i++) {
            @weakify(self);
            [_alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                @strongify(self);
                if (self->_textFileds) {
                    [self->_textFileds addObject:textField];
                }
            }];
        }

    }else
    {
        
    }
    
}
- (void)_initAlertView {
	if (ISIOS8) {
		_alertController = [UIAlertController alertControllerWithTitle:_title
															   message:_message
														preferredStyle:UIAlertControllerStyleAlert];
		for (NSUInteger i = 0; i < _buttonArray.count; i++) {
			UIAlertActionStyle style = UIAlertActionStyleDefault;
			if (i == _buttonArray.count - 1) {
				style = UIAlertActionStyleCancel;
			}
			UIAlertAction *action =
				[UIAlertAction actionWithTitle:_buttonArray[i]
										 style:style
									   handler:^(UIAlertAction *_Nonnull actionButton) {
										   [self didSelectButtonAtIndex:actionButton.tag];
									   }];
			action.tag = i;
			[_alertController addAction:action];
		}

		
	} else {

		_alertView = [[UIAlertView alloc] init];
		_alertView.delegate = self;
		_alertView.title = _title;
		_alertView.message = _message;
        for (NSUInteger i = 0; i < _buttonArray.count; i++) {
            [_alertView addButtonWithTitle:_buttonArray[i]];
        }
		_alertView.cancelButtonIndex = _buttonArray.count - 1;
		_alertView.alertViewStyle = self.alertViewStyle;
	}
}
- (void)_initAlertSheet {

	if (ISIOS8) {

		_alertController =
			[UIAlertController alertControllerWithTitle:_title
												message:_message
										 preferredStyle:UIAlertControllerStyleActionSheet];
		for (NSUInteger i = 0; i < _buttonArray.count; i++) {
			UIAlertActionStyle style = UIAlertActionStyleDefault;
			if (i == _buttonArray.count - 1) {
				style = UIAlertActionStyleCancel;
			}
			@weakify (self);
			UIAlertAction *action =
				[UIAlertAction actionWithTitle:_buttonArray[i]
										 style:style
									   handler:^(UIAlertAction *_Nonnull actionButton) {
										   @strongify (self);
										   [self didSelectButtonAtIndex:actionButton.tag];
									   }];
			action.tag = i;
			[_alertController addAction:action];
			for (NSUInteger i = 0; i < _textFiledNumber; i++) {
				[_alertController addTextFieldWithConfigurationHandler:nil];
			}
		}

	} else {

		_actionSheet = [[UIActionSheet alloc] init];
		_actionSheet.title = _title;
		_actionSheet.delegate = self;
		for (NSUInteger i = 0; i < _buttonArray.count; i++) {
			[_actionSheet addButtonWithTitle:_buttonArray[i]];
		}
		_actionSheet.cancelButtonIndex = _buttonArray.count - 1;
		_actionSheet.actionSheetStyle = self.actionSheetStyle;
	}
}

- (void)showInController:(UIViewController *)controller {

	if (_alertController) {
		[controller presentViewController:_alertController animated:YES completion:nil];
	} else {

		if (_type == HAlertControllerTypeAlertView) {
			[_alertView show];
		} else if (_type == HAlertControllerTypeActionSheet) {
			[_actionSheet showInView:controller.view];
		} else if (_type == HAlertControllerTypeCustomValue1) {
			[_actionSheetWeChat show];
		}
	}
}
- (NSArray<UIButton *> *)buttonArrayWithCustomValue1 {
	NSMutableArray *buttons = [NSMutableArray arrayWithArray:_actionSheetWeChat->_otherButtons];
	[buttons addObject:_actionSheetWeChat->_cannelButton];
	return buttons;
}
-(UITextField *)textFiledWithTag:(NSUInteger)tag {
    UITextField *textfiled;
    if (ISIOS8) {
        if (_textFileds.count>tag) {
            textfiled=_textFileds[tag];
        }
    }else{
       textfiled= [_alertView textFieldAtIndex:tag];
    }
    return textfiled;
}
- (void)didSelectButtonAtIndex:(NSUInteger)buttonIndex {
	if (_complete) {
		_complete (buttonIndex, self);
	}

	if (_delegate &&
		[_delegate
			respondsToSelector:@selector (alertControllerDidSelectButtonIndex:alertController:)]) {
		[_delegate alertControllerDidSelectButtonIndex:buttonIndex alertController:self];
	}
	[self removeSelf];
}
- (void)removeSelf {
	if ([SAlertControllerArray containsObject:self]) {
		[SAlertControllerArray removeObject:self];
	}
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

	[self didSelectButtonAtIndex:buttonIndex];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

	[self didSelectButtonAtIndex:buttonIndex];
}

@end

@implementation UIAlertAction (Tag)

- (void)setTag:(NSUInteger)tag {
	objc_setAssociatedObject (self, @selector (tag), @(tag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSUInteger)tag {
	return [objc_getAssociatedObject (self, @selector (tag)) unsignedIntegerValue];
}
@end

@interface HActionSheetWeChat ()

@end

@implementation HActionSheetWeChat {

	UIView *_actionSheetView;
	UILabel *_titleLabel;
	UILabel *_messageLabel;
	UIView *_spanceView;
	HActionSheetWeChatComplete _complete;
}
+ (instancetype)actionSheetWithTitle:(NSString *)title
							 message:(NSString *)message
						cannelButton:(NSString *)cannelButton
						otherButtons:(NSArray *)otherButton
							complete:(HActionSheetWeChatComplete)complete {
	NSParameterAssert (complete);
	return [[HActionSheetWeChat alloc] initActionSheetWithTitle:title
														 message:message
													cannelButton:cannelButton
													otherButtons:otherButton
														complete:complete];
}
- (instancetype)initActionSheetWithTitle:(NSString *)title
								 message:(NSString *)message
							cannelButton:(NSString *)cannelButton
							otherButtons:(NSArray *)otherButton
								complete:(HActionSheetWeChatComplete)complete {
	if (!cannelButton) {
		return nil;
	}
	_complete = complete;
	self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
	if (self) {
		self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
		_otherButtons = [NSMutableArray array];
        CGFloat titleHeight=({
            if ([NSString isNull:title] && [NSString isNull:message]) {
                titleHeight=0;
            }else{
                titleHeight=49;
            }
            titleHeight;
        });
		_actionSheetView = ({

			CGFloat actionSheetViewHeight = titleHeight +
											0.5 * otherButton.count + 49 * otherButton.count + 5.5 +
											49;
			_actionSheetView =
				[[UIView alloc] initWithFrame:CGRectMake (0, self.height - actionSheetViewHeight,
														  self.width, actionSheetViewHeight)];
			_actionSheetView.backgroundColor = [UIColor whiteColor];
			_actionSheetView;
		});
		[self addSubview:_actionSheetView];

		_titleLabel = ({
			_titleLabel = nil;
			if (![NSString isNull:title]) {
				_titleLabel =
					[[UILabel alloc] initWithFrame:CGRectMake (25, 1.5, self.width - 50, 15)];
				_titleLabel.font = [UIFont systemFontOfSize:14];
				_titleLabel.textAlignment = NSTextAlignmentCenter;
				_titleLabel.textColor = [UIColor blackColor];
			}
            if ([NSString isNull:message]) {
                _titleLabel.frame=CGRectMake(25, 17, _titleLabel.width, _titleLabel.height);
            }
			_titleLabel;
		});
		if (_titleLabel) {
			[_actionSheetView addSubview:_titleLabel];
			_titleLabel.text = title;
		}

		_messageLabel = ({
			_messageLabel = nil;
			if (![NSString isNull:message]) {
				_messageLabel = [[UILabel alloc]
					initWithFrame:CGRectMake (25, 9.5, self.width - 50, 30)];
				_messageLabel.textAlignment = NSTextAlignmentCenter;
				_messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
				_messageLabel.numberOfLines = 2;
				_messageLabel.font = [UIFont systemFontOfSize:12];
				_messageLabel.textColor =
					[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:1.00];
			}
            if (_titleLabel) {
                _messageLabel.frame=CGRectMake(_messageLabel.left, _titleLabel.bottom+1.5, _messageLabel.width, _messageLabel.height);
            }
			_messageLabel;
		});
		if (_messageLabel) {
			[_actionSheetView addSubview:_messageLabel];
			_messageLabel.text = message;
		}

		NSInteger buttonIndex = 0;

		_cannelButton = ({
			_cannelButton = [UIButton buttonWithType:UIButtonTypeCustom];
			_cannelButton.frame = CGRectMake (0, _actionSheetView.height - 49, self.width, 49);
			[_cannelButton setTitle:cannelButton forState:UIControlStateNormal];
			[_cannelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			_cannelButton.tag = buttonIndex;
            _cannelButton.titleLabel.font=[UIFont systemFontOfSize:16];
			[_cannelButton addTarget:self
							  action:@selector (buttonClick:)
					forControlEvents:UIControlEventTouchUpInside];
			_cannelButton;
		});
		[_actionSheetView addSubview:_cannelButton];

		_spanceView = ({
			_spanceView = [[UIView alloc]
				initWithFrame:CGRectMake (0, _cannelButton.top - 5.5, self.width, 5.5)];
			_spanceView.backgroundColor =
				[UIColor colorWithRed:0.898 green:0.898 blue:0.914 alpha:1.00];
			_spanceView;
		});
		[_actionSheetView addSubview:_spanceView];
		NSUInteger buttonY = _spanceView.top - 49;
		if (otherButton.count > 0) {
			
			for (NSUInteger i = 0; i < otherButton.count; i++) {
                buttonIndex++;
				UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
				[button setTitleColor:[UIColor colorWithRed:0.863 green:0.000 blue:0.000 alpha:1.00]
							 forState:UIControlStateNormal];
				[button setTitle:otherButton[i] forState:UIControlStateNormal];
				button.frame = CGRectMake (0, buttonY, self.width, 49);
				button.tag = buttonIndex;
				[button addTarget:self
							  action:@selector (buttonClick:)
					forControlEvents:UIControlEventTouchUpInside];
                button.titleLabel.font=[UIFont systemFontOfSize:16];

				[_actionSheetView addSubview:button];

				[_otherButtons addObject:button];

                
                UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake (0, button.top - 0.5, self.width, 0.5)];
                lineView.backgroundColor = [UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1.00];
				[_actionSheetView addSubview:lineView];

				buttonY = lineView.top - 49;
			}
		}
		kSelfWeak;
		[self addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
			[weakSelf hide];
		}];
        
        
	}
	return self;
}
- (void)show {
	CGRect oldFrame = _actionSheetView.frame;
	[[UIApplication sharedApplication].keyWindow addSubview:self];
	_actionSheetView.frame = CGRectMake (0, self.bottom, self.width, self.height);
	kSelfWeak;
    [UIView animateWithDuration:0.25 animations:^{
        kSelfStrong;
        if (strongSelf) {
            strongSelf->_actionSheetView.frame = oldFrame;
        }
    }];
}
- (void)buttonClick:(UIButton *)button {
	if (_complete) {
		_complete (button.tag, self);
	}
	[self hide];
}
- (void)hide {
	kSelfWeak;
	
    [UIView animateWithDuration:0.25 animations:^{
        kSelfStrong;
        if (strongSelf) {
            strongSelf->_actionSheetView.frame =
            CGRectMake (0, self.bottom, self.width, self.height);
        }
    }completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}
@end
