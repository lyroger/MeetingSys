//
//  AppDelegate.h
//  MeetingSys
//
//  Created by luoyan on 2017/5/5.
//  Copyright © 2017年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSRootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MSRootViewController *rootViewController;

- (void)authorizeOperation;

@end

