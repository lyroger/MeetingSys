//
//  MSTitleAndDetailView.h
//  MeetingSys
//
//  Created by 罗琰 on 2017/5/11.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSTitleAndDetailView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *bottomLine;

+ (CGFloat)titleAndDetailViewHeight:(NSString*)detail width:(CGFloat)width;
@end
