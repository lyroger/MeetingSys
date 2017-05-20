//
//  SHMSelectActionView.h
//  SellHouseManager
//
//  Created by luoyan on 16/5/11.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHMSelectActionViewDelegate;

@interface SHMSelectActionView : UIView

/**
 *  选项数据源
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 *  选中选项的索引集合，用于初始化默认选项
 */
@property (nonatomic, strong) NSMutableArray *selectedIndexs;

/**
 *  是否为多选
 */
@property (nonatomic, assign) BOOL isMutibleSelect;

/**
 *  主标题
 */
@property (nonatomic, strong) NSString *title;

/**
 *  副标题
 */
@property (nonatomic, strong) NSString *subTitle;
/**
 *  选择view的代理
 */
@property (nonatomic, weak) id<SHMSelectActionViewDelegate> delegate;

#pragma mark SHMSelectAction method
/**
 *  弹出选择页面
 */
- (void)showSelectActionView;

/**
 *  隐藏选择页面
 */
- (void)hideSelectActionView;

- (void)showLoading:(BOOL)show;
@end


@protocol SHMSelectActionViewDelegate <NSObject>
@optional
/**
 *  选择完选项代理方法
 *
 *  @param view   返回操作的视图对象
 *  @param indexs 返回选择操作的数据索引，若是单选，数组只包含一个索引，若为多选是选中的数据索引集合。
 */
- (void)didSelectItemWithView:(SHMSelectActionView*)view itemIndexs:(NSArray*)indexs;

/**
 *  视图隐藏完成时调用的代理方法
 *
 *  @param view 返回操作的视图对象
 */
- (void)didHideSelectItemView:(SHMSelectActionView*)view;

@end
