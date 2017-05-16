//
//  AppDelegate.m
//  MeetingSys
//
//  Created by luoyan on 2017/5/5.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "AppDelegate.h"
#import "MSNavigationController.h"
#import "MSLoginViewController.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate ()<JPUSHRegisterDelegate>

@property (nonatomic, strong) MSLoginViewController *loginVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self registerJPush:launchOptions];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self authorizeOperation];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)authorizeOperation
{
    //加载本地用户信息
    [[MSUserInfo shareUserInfo] getUserInfoFromLocal];
    
//    [MSUserInfo shareUserInfo].token = @"aweifawenfalef";
    //不需要加载启动页则判断是否需要登录
    if (![MSUserInfo shareUserInfo].token.length) {
        self.loginVC = [[MSLoginViewController alloc] init];
        @weakify(self)
        MSNavigationController *rootNav = [[MSNavigationController alloc] initWithRootViewController:self.loginVC];
        self.loginVC.loginCompleteBlock = ^(BOOL success){
            @strongify(self)
            if (success) {
                [self enterRootView];
            }
        };
        self.window.rootViewController = rootNav;
        
    } else {
        [self enterRootView];
    }
}

- (void)enterRootView
{
    self.rootViewController = [[MSRootViewController alloc] init];
    MSNavigationController *rootNav = [[MSNavigationController alloc] initWithRootViewController:self.rootViewController];
    self.window.rootViewController = rootNav;
    
//    //如果登录页面存在，则做一个登录页面退场效果。
//    if (self.loginVC) {
//        [self.rootViewController.view addSubview:self.loginVC.view];
//        self.loginVC.view.alpha = 1;
//        self.loginVC.view.transform = CGAffineTransformMakeScale(1, 1);
//        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            self.loginVC.view.alpha = 0;
//            self.loginVC.view.transform = CGAffineTransformMakeScale(2.5, 2.5);
//        } completion:^(BOOL finished) {
//            [self.loginVC.view removeFromSuperview];
//            self.loginVC = nil;
//            NSLog(@"登录页面释放-动画结束");
//        }];
//    }
}

- (void)setupConfig {
    
    //    [[FLEXManager sharedManager] showExplorer];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager]
     setKeyboardDistanceFromTextField:IQKeyboardDistanceFromTextField];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager] setCanAdjustTextView:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark 极光推送注册
- (void)registerJPush:(NSDictionary *)launchOptions
{
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    BOOL isProduction = YES;
#ifndef __OPTIMIZE__
    isProduction = NO;
#endif
    //Required
    // init Push(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil  )
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:kJPushAPPKey
                          channel:@"APPStore"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            [registrationID writeToFile:[self getFileDocPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
            NSLog(@"registrationID获取成功：%@",registrationID);
            // 保存registrationID到钥匙串中
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"kJPushRegistrationID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}

- (NSString *)getFileDocPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager* fileMgr = [[NSFileManager alloc] init];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"registrationid.txt"];
    
    BOOL isDir = YES;
    if (![fileMgr fileExistsAtPath:filePath isDirectory:&isDir]) {
        [fileMgr createFileAtPath:filePath contents:nil attributes:nil];
    }
    return filePath;
}

//注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /// Required - 注册 DeviceToken
    if (![[MSUserInfo shareUserInfo] getDeviceToken]) {
        // 用于标示该设备唯一标识
        [[MSUserInfo shareUserInfo] saveDeviceToken:deviceToken];
    }
    // 注册时需要对应的deviceToken,不能拿保存在钥匙串中的token（app删除，重新安装，会产生新的deviceToken，钥匙串中保存的是第一次安装该app时产生的deviceToken）。
    [JPUSHService registerDeviceToken:deviceToken];
}

// 向服务器发送用户对应的设备信息
- (void)registerDeviceInfoForUser
{
    NSString *deviceTokenString = [[[[[[MSUserInfo shareUserInfo] getDeviceToken] description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                    stringByReplacingOccurrencesOfString:@">" withString:@""]
                                   stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceTokenString：%@", deviceTokenString);
    deviceTokenString = deviceTokenString.length?deviceTokenString:@"";
    NSString *jPushRegistrationID = [[NSUserDefaults standardUserDefaults] objectForKey:@"kJPushRegistrationID"];
    NSString *registerId = jPushRegistrationID.length?jPushRegistrationID:@"";
    NSString *account = [MSUserInfo shareUserInfo].userId?[MSUserInfo shareUserInfo].userId:@"";
    NSLog(@"registerAppAccountDevices:deviceToken=%@,registerId=%@,account=%@",deviceTokenString,registerId,account);
//    [HybridFrameModel registerAppAccountDevices:deviceTokenString registerId:registerId accountInfo:account success:^(StatusModel *data) {
//        if (data.code == 0) {
//            //注册成功
//            [SHMUserInfo shareUserInfo].isRegisterPushInfo = YES;
//        } else {
//            [SHMUserInfo shareUserInfo].isRegisterPushInfo = NO;
//        }
//        
//        SHMUserInfo *userInfo = [SHMUserInfo shareUserInfo];
//        [[SHMUserInfo getUsingLKDBHelper] insertToDB:userInfo callback:^(BOOL result) {
//            NSLog(@"result = %zd",result);
//        }];
//    }];
}

//实现注册APNs失败接口
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

//添加处理APNs通知回调方法
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [self handlerPushMessage:userInfo isActive:YES];
    }
    //    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [self handlerPushMessage:userInfo isActive:NO];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    
    BOOL isActive = [UIApplication sharedApplication].applicationState == UIApplicationStateActive?YES:NO;
    [self handlerPushMessage:userInfo isActive:isActive];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)handlerPushMessage:(NSDictionary*)userInfo isActive:(BOOL)isActive
{
//    if (![self isNeedLogin]) {
//        [self.tabBarVC handleNotification:userInfo isActive:isActive];
//    } else {
//        // 退出登录后，会注销推送，没登录理论上不会推送。
//    }
}
@end
