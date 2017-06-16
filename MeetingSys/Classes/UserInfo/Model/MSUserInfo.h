//
//  SHMUserInfo.h
//  SellHouseManager
//
//  Created by luoyan on 16/5/24.
//  Copyright © 2016年 JiCe. All rights reserved.
//

#import "BaseModel.h"

@interface MSUserInfo : BaseModel

@property (nonatomic, copy) NSString *userId;           //用户ID
@property (nonatomic, copy) NSString *username;         //用户姓名
@property (nonatomic, copy) NSString *nickName;         //昵称
@property (nonatomic, copy) NSString *mobile;            //手机号码
@property (nonatomic, copy) NSString *token;            //用户token
@property (nonatomic, copy) NSString *headerImg;           //用户头像
@property (nonatomic, copy) NSString *title;            //职称
@property (nonatomic, copy) NSString *dpName;           //部门名称
@property (nonatomic, copy) NSString *cpName;           //公司名称

//附加功能属性
@property (nonatomic, copy) NSString *userAcount;   //账号
@property (nonatomic, assign) BOOL isRememberPwd;
@property (nonatomic, assign) BOOL isRegisterPushInfo; //该用户是否注册推送通知信息成功
@property (nonatomic, assign) NSInteger badge;  //消息显示个数

+ (instancetype)shareUserInfo;

- (void)setUserInfo:(MSUserInfo*)userInfo;
//启动app时，从本地数据库加载数据到单例中
- (void)getUserInfoFromLocal;
//保存密码
- (BOOL)savePassword:(NSString*)password;
//删除密码
- (BOOL)deletePassword;
//获取当前账号密码
- (NSString*)getPassword;
// 保存设备token；
- (BOOL)saveDeviceToken:(NSData*)deviceToken;
// 获取设备token；
- (NSData*)getDeviceToken;

+ (NSURLSessionDataTask *)loginWithLoginId:(NSString *)loginId
                                  password:(NSString *)password
                                networkHUD:(NetworkHUD)hud
                                    target:(id)target
                                   success:(NetResponseBlock)success;

+ (NSURLSessionDataTask *)loginOutNetworkHUD:(NetworkHUD)hud
                                      target:(id)target
                                     success:(NetResponseBlock)success;

+ (NSURLSessionDataTask *)uploadHeadPhoto:(UIImage *)headPhoto
                                      hud:(NetworkHUD)hud
                                   target:(id)target
                                  success:(NetResponseBlock)success;

+ (NSURLSessionDataTask *)updatePwd:(NSString *)newPwd
                             oldPwd:(NSString *)oldPwd
                                hud:(NetworkHUD)hud
                             target:(id)target
                            success:(NetResponseBlock)success;

+ (NSURLSessionDataTask *)checkVersionNetworkHUD:(NetworkHUD)hud
                                          target:(id)target
                                         success:(NetResponseBlock)success;

+ (NSURLSessionDataTask *)registerPush:(NSString *)registerID
                           deviceToken:(NSString *)deviceToken
                                target:(id)target
                               success:(NetResponseBlock)success;

+ (NSURLSessionDataTask *)unRegisterPush:(NSString *)registerID
                             deviceToken:(NSString *)deviceToken
                                  target:(id)target
                                 success:(NetResponseBlock)success;

+ (NSURLSessionDataTask *)checkUserIsRMUpNetworkHUD:(NetworkHUD)hud
                                             target:(id)target
                                            success:(NetResponseBlock)success;
@end
