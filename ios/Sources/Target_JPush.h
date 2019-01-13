//
//  Target_JPush.h
//  Pods
//
//  Created by dmlzj on 2019/1/12.
//

@interface Target_JPush : NSObject

- (void)Action_registerForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)Action_setIsLaunchedByNotification:(NSNumber *)val;
- (void)Action_addPushNotification:(NSDictionary *)notificationPayload;
- (void)Action_receiveRemoteNotification:(NSDictionary *)info;
- (void)Action_performFetchWithCompletionHandler:(NSDictionary *)info;

@end
