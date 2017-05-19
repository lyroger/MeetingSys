//
//  MSMemberView.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/11.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSMeetingDetailModel.h"

@class MSMemberCellView;

typedef void(^MSMemberCellViewClickBlock)(MSMemberCellView* view);
@interface MSMemberCellView : UIView

@property (nonatomic,strong) UIImageView *imageHead;
@property (nonatomic,strong) UILabel     *labelName;
@property (nonatomic,strong) MSMemberModel *memberModel;
@property (nonatomic,copy)   MSMemberCellViewClickBlock clickBlock;

- (void)bindRAC;

@end


@protocol MSMemberCellViewDelegate;
@interface MSMemberView : UIView

@property (nonatomic, strong) UILabel *bottomLine;
@property (nonatomic, weak) id<MSMemberCellViewDelegate> delegate;

- (void)membersData:(NSArray*)datas;

@end

@protocol MSMemberCellViewDelegate <NSObject>

- (void)didClickMemberCell:(MSMemberCellView*)view;

@end
