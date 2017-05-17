//
//  SHMUserInfo.m
//  SellHouseManager
//
//  Created by luoyan on 16/5/24.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import "MSUserInfo.h"
#import "HttpClient.h"
#import "SSKeychain.h"
#import "NSDictionary+BaseModel.h"

@implementation MSUserInfo

+ (LKDBHelper *)getUsingLKDBHelper {
    return [super getDefaultLKDBHelper];
}

+ (NSString*)getTableName
{
    return @"MNUserInfoV1";
}

+ (NSString*)getPrimaryKey
{
    return @"userId";
}

+ (instancetype)shareUserInfo
{
    static MSUserInfo *userInfo = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        userInfo = [[MSUserInfo alloc] init];
    });
    return userInfo;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"headerImg" : @[@"avater"],
             @"userId":@[@"id"]
             };
}

- (void)setUserInfo:(MSUserInfo*)userInfo
{
    _userId = userInfo.userId;
    _username = userInfo.username;
    _token = userInfo.token;
    _mobile = userInfo.mobile;
    _dpName = userInfo.dpName;
    _cpName = userInfo.cpName;
    _headerImg = userInfo.headerImg;
    
    _isRememberPwd = userInfo.isRememberPwd;
    _userAcount = userInfo.userAcount;
    _isRegisterPushInfo = userInfo.isRegisterPushInfo;
}

- (void)getUserInfoFromLocal
{
    NSString *userAcount = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUserAcount];
    if (userAcount.length) {
        MSUserInfo *userInfo = [MSUserInfo searchSingleWithWhere:[NSString stringWithFormat:@"userAcount='%@'",userAcount] orderBy:nil];
        [self setUserInfo:userInfo];
    }
}

- (BOOL)savePassword:(NSString*)password
{
    return [SSKeychain setPassword:password forService:@"com.exmind.sellhousemanager" account:self.userAcount];
}

- (BOOL)deletePassword
{
    return [SSKeychain deletePasswordForService:@"com.exmind.sellhousemanager" account:self.userAcount];
}

- (NSString*)getPassword
{
    return [SSKeychain passwordForService:@"com.exmind.sellhousemanager" account:self.userAcount];
}
#pragma mark DeviceToken
// 保存设备token；
- (BOOL)saveDeviceToken:(NSData*)deviceToken
{
    BOOL removed = [SSKeychain deletePasswordForService:[self getDeviceTokenService] account:@"sellhousemanagerDeviceToken"];
    NSLog(@"removeDeviceToken = %d",removed);
    BOOL worked = [SSKeychain setPasswordData:deviceToken forService:[self getDeviceTokenService] account:@"sellhousemanagerDeviceToken"];
    NSLog(@"addDeviceToken = %d",worked);
    return worked;
}
// 获取设备token；
- (NSData*)getDeviceToken
{
    return [SSKeychain passwordDataForService:[self getDeviceTokenService] account:@"sellhousemanagerDeviceToken"];
}

- (NSString*)getDeviceTokenService
{
    return [NSString stringWithFormat:@"com.exmind.sellhousemanager_Token%d",isTrueEnvironment];
}

+ (NSURLSessionDataTask *)loginWithLoginId:(NSString *)loginId
                                  password:(NSString *)password
                                networkHUD:(NetworkHUD)hud
                                    target:(id)target
                                   success:(NetResponseBlock)success {
    CreateParamsDic;
    DicObjectSet(loginId, @"username");
    DicObjectSet(password, @"password");
    return [self dataTaskMethod:HTTPMethodPOST path:@"api/user/login" params:ParamsDic networkHUD:hud target:target success:success];
}

+ (NSURLSessionDataTask *)loginOutNetworkHUD:(NetworkHUD)hud
                                      target:(id)target
                                     success:(NetResponseBlock)success
{
    return [self dataTaskMethod:HTTPMethodPOST path:@"api/user/logout" params:nil networkHUD:hud target:target success:success];
}


+ (NSURLSessionDataTask *)uploadHeadPhoto:(UIImage *)headPhoto
                                      hud:(NetworkHUD)hud
                                   target:(id)target
                                  success:(NetResponseBlock)success
{
    CreateParamsDic;
    NSMutableArray *array = [NSMutableArray array];
    UIImage *image = headPhoto;
    NSData *data = UIImageJPEGRepresentation(image,0.5);
    NSDictionary *fileDic = [NSDictionary bm_dictionaryWithData:data
                                                       name:@"imageFiles"
                                                   fileName:[NSString stringWithFormat:@"file0.jpg"]
                                                   mimeType:@"image/jpg"];
    [array addObject:fileDic];
    
    return [self updataFile:@"api/user/changeavater" files:array params:ParamsDic networkHUD:hud target:target success:success];
}

+ (NSURLSessionDataTask *)updatePwd:(NSString *)newPwd
                             oldPwd:(NSString *)oldPwd
                                hud:(NetworkHUD)hud
                             target:(id)target
                            success:(NetResponseBlock)success
{
    CreateParamsDic;
    DicObjectSet(oldPwd, @"oldPassword");
    DicObjectSet(newPwd, @"newPassword");
    return [self dataTaskMethod:HTTPMethodPOST path:@"api/user/changepwd" params:ParamsDic networkHUD:hud target:target success:success];
}

@end
