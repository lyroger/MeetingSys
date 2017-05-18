//
//  SHMSelectActionCell.h
//  SellHouseManager
//
//  Created by luoyan on 16/5/11.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHMSelectActionCell : UITableViewCell

@property (nonatomic, assign) BOOL isMultipleSelect;

/**
 *  显示选中状态
 */
- (void)showSelected;
/**
 *  隐藏选中状态
 */
- (void)hideSelected;

@end
