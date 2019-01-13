//
//  JPushManager.h
//  Pods
//
//  Created by dmlzj on 2019/1/12.
//

#import <Foundation/Foundation.h>
#import <JPush/JPUSHService.h>

@interface JPushManager : NSObject

+ (instancetype)shareInstance;
@property (nonatomic, assign) BOOL isLaunchedByNotification;    // 是否点击推送信息进入app
/** 配置推送服务 */
- (void)configPushService:(NSDictionary *)info;
/** 注册token */
+ (void)registerForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
/** 后台更新 */
+ (void)performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

/** ios10之前 收到push消息回调方法 */
+ (void)receiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@end
