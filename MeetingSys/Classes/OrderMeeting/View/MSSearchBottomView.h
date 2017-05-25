//
//  MSSearchBottomView.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/25.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSSearchBottomViewDelegate;

@interface MSSearchBottomView : UIView

@property (nonatomic, weak) id<MSSearchBottomViewDelegate> delegate;
@property (nonatomic, assign) BOOL isSelectedAll;

- (void)setSelectedAllStatus:(BOOL)seletedAll;

@end

@protocol MSSearchBottomViewDelegate <NSObject>

- (void)didClickAllSelected:(MSSearchBottomView*)view;

@end
