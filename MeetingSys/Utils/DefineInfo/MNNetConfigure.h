//
//  MNNetConfigure.h
//  MeNote
//
//  Created by luoyan on 2017/4/20.
//  Copyright © 2017年 roger. All rights reserved.
//

#ifndef MNNetConfigure_h
#define MNNetConfigure_h

#define isTrueEnvironment 1 //正式发布
#define isTestEnvironment 1 //测试环境


#if isTrueEnvironment
//正式环境的环境类型
#define kServerHost                 @"http://47.91.133.198:8080"
#define kServerCurrentPath          @"/agate-web/"
#define kServerPushNotificationHost @"http://47.91.133.198:8080/agate-web"
#define kJPushAPPKey                @"1f775a82abf23e099c5f658c"
#else

#if isTestEnvironment
// 测试环境
#define kServerHost                 @"http://119.23.243.229:8080"////@"http://192.168.1.110:8888" //
#define kServerCurrentPath          @"/agate-web/"
#define kServerPushNotificationHost @"http://119.23.243.229:8080/agate-web"
#define kJPushAPPKey                @"1f775a82abf23e099c5f658c"
#endif

#endif

#endif /* MNNetConfigure_h */
