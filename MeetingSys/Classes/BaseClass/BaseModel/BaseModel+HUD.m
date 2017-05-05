//
//  BaseModel+HUD.m
//  HuiXin
//
//  Created by 文俊 on 15/11/6.
//  Copyright © 2015年 文俊. All rights reserved.
//

#import "BaseModel+HUD.h"
#import "HUDManager.h"

@implementation BaseModel (HUD)

+ (void)startHUD:(NetworkHUD)networkHUD target:(id)target
{
    
    if (networkHUD > 2 && networkHUD < 6)
    {
        [HUDManager showHUD:MBProgressHUDModeIndeterminate hide:NO afterDelay:kHUDTime enabled:YES message:@"请稍候..."];
    } else if (networkHUD >= 6 && networkHUD <= 8) {
        if ([target isKindOfClass:[UIViewController class]]) {
            
            [HUDManager showHUDWithMessage:@"请稍候..." onTarget:((UIViewController *)target).view];
        }
    }
}

+ (void)handleResponse:(StatusModel *)statusModel networkHUD:(NetworkHUD)networkHUD
{
    NSString *message = statusModel.msg;
    NSInteger code = statusModel.code;
    
    switch (networkHUD)
    {
        case NetworkHUDBackground:
            break;
        case NetworkHUDMsg:
        {
            if (![message isKindOfClass:[NSNull class]] && [message nonNull])
            {
                [HUDManager alertWithTitle:message];
            }
        }
            break;
        case NetworkHUDError:
        {
            if (code != 0 && ![message isKindOfClass:[NSNull class]] && [message nonNull])
            {
                [HUDManager alertWithTitle:message];
            }
        }
            break;
        case NetworkHUDLockScreenButNav:
        case NetworkHUDLockScreen:
        {
            [HUDManager hiddenHUD];
        }
            break;
        case NetworkHUDLockScreenButNavWithMsg:
        case NetworkHUDLockScreenAndMsg:
        {
            if (![message isKindOfClass:[NSNull class]] && [message nonNull])
            {
                
                [HUDManager alertWithTitle:message];
            }else{
                [HUDManager hiddenHUD];
            }
        }
            break;
        case NetworkHUDLockScreenButNavWithError:
        case NetworkHUDLockScreenAndError:
        {
            if (code != 0 && ![message isKindOfClass:[NSNull class]] && [message nonNull])
            {
                [HUDManager alertWithTitle:message];
            }else{
                [HUDManager hiddenHUD];
            }
        }
            break;
        default:
            break;
    }
}

@end
