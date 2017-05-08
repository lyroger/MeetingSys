//
//  MSNavTabbarView.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/8.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSNavTabbarViewDelegete;

@interface MSNavTabbarView : UIView

@property (nonatomic,weak) id<MSNavTabbarViewDelegete> delegete;


- (void)selectedItemIndex:(NSInteger)index;

@end

@protocol MSNavTabbarViewDelegete <NSObject>

- (void)didClickNavTabbarView:(NSInteger)itemIndex;

@end
