//
//  Target_JPush.m
//  AFNetworking
//
//  Created by dmlzj on 2019/1/12.
//

#import "Target_JPush.h"
#import "JPushManager.h"

@implementation Target_JPush

- (void)Action_registerForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPushManager registerForRemoteNotificationsWithDeviceToken:deviceToken];
}
//- (void)Action_setIsLaunchedByNotification:(NSNumber *)val
//{
//    [[JPushManager shareInstance] setIsLaunchedByNotification:[val boolValue]];
//}
//
//- (void)Action_addPushNotification:(NSDictionary *)notificationPayload
//{
//    [JPushManager addPushNotification:notificationPayload];
//}
//
- (void)Action_receiveRemoteNotification:(NSDictionary *)info
{
    [JPushManager receiveRemoteNotification:info[@"userInfo"] fetchCompletionHandler:info[@"block"]];
}
//
//- (void)Action_performFetchWithCompletionHandler:(NSDictionary *)info
//{
//    [JPushManager performFetchWithCompletionHandler:info[@"block"]];
//}

@end
