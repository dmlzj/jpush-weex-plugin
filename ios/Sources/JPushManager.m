//
//  JPushManager.m
//  AFNetworking
//
//  Created by dmlzj on 2019/1/12.
//
#import "JPushManager.h"
#import "BMGlobalEventManager.h"
#import "BMConfigManager.h"
#import "BMMediatorManager.h"
#import <JPushWeexPluginModule.h>
// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
@interface JPushManager () <UNUserNotificationCenterDelegate>
{
    NSString *_deviceToken;
}

@end

@implementation JPushManager
+ (instancetype)shareInstance
{
    static JPushManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[JPushManager alloc] init];
    });
    
    return _instance;
}
- (instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)appDidEnterBackground
{
    self.isLaunchedByNotification = YES;
}

- (void)appDidBecomeActive
{
    self.isLaunchedByNotification = NO;
}

#pragma mark - Public Method

- (void)configPushService:(NSDictionary *)info
{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSDictionary * launchOptions = [ud objectForKey:@"launchOptions"];
    [[[JPushWeexPluginModule alloc] init] setupWithOption:launchOptions
                                                   appKey:info[@"appKey"]?:@"321605d889bf4bdc1f060728"
                                                  channel:nil
                                         apsForProduction:0];
    [self registerRemoteNotification];
}
+ (void)registerForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)registerRemoteNotification
{
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                WXLogInfo(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}
+ (void)receiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[JPushManager shareInstance] analysisRemoteNotification:userInfo];
    
    // 将收到的APNs信息传给个推统计
    [JPUSHService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
/**
 解析push消息、透传消息
 
 @param userInfo 消息体
 */
- (void)analysisRemoteNotification:(NSDictionary *)userInfo
{
    if (![BMMediatorManager shareInstance].currentWXInstance) {
//        [[self class] addPushNotification:userInfo];
        return;
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:kJPFDidReceiveRemoteNotification object:userInfo];
    [BMGlobalEventManager pushMessage:userInfo appLaunchedByNotification:self.isLaunchedByNotification];
}



@end
