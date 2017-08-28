//
//  Header.h
//  NTGS
//
//  Created by 殷年平 on 2017/8/7.
//  Copyright © 2017年 殷年平. All rights reserved.
//

#ifndef Header_h
#define Header_h
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialUImanager.h"
#import "UMessage.h"
#import "MBProgressHUD.h"

#import "WXApi.h"
#import "WXApiObject.h"
#import <CommonCrypto/CommonCrypto.h>

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#endif /* Header_h */
