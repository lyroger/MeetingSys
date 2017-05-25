//
//  MSSearchHeadMemberView.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/25.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSMemberCollectionCell.h"

@protocol MSMemberCollectionCellViewDelegate;

@interface MSSearchHeadMemberView : UIView

@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, weak) id<MSMemberCollectionCellViewDelegate> delegate;

- (void)reloadView;

@end


@protocol MSMemberCollectionCellViewDelegate <NSObject>

- (void)didClickMemberCollectionCell:(MSMemberCollectionCell*)view;

@end
