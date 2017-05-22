//
//  MSRootViewController.h
//  MeetingSys
//
//  Created by luoyan on 2017/5/5.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MSBaseViewController.h"

@interface MSRootViewController : MSBaseViewController

- (void)checkAppUpdateOnBackgroud:(BOOL)back;
- (void)handleNotification:(NSDictionary *)info isActive:(BOOL)isActive;
@end
