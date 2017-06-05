//
//  MSNavBarView.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/6/5.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NavTapActionBlock)(NSInteger actionType);

@interface MSNavBarView : UIView

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIButton *navRightButton;
@property (nonatomic, copy)   NavTapActionBlock actionBlock;

@end
