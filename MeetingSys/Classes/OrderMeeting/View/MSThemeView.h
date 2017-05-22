//
//  MSThemeView.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/22.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didClickHeadImageBlock)();

@interface MSThemeView : UIView

@property (nonatomic, strong) UIButton *portraitView;
@property (nonatomic, strong) UIImageView *inuseImage;

@property (nonatomic, copy) didClickHeadImageBlock clickHeadBlock;

@end
