/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  AppDelegate.m
//  AppManagment
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

#import <Cordova/CDVPlugin.h>

#import "AFHTTPRequestOperation.h"
#import "Reachable.h"
#import "HttpRequest.h"


@implementation AppDelegate
@synthesize sc;
@synthesize window, viewController;

- (id)init
{
    /** If you need to do any extra app-specific initialization, you can do it here
     *  -jm
     **/
    NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

    int cacheSizeMemory = 8 * 1024 * 1024; // 8MB
    int cacheSizeDisk = 32 * 1024 * 1024; // 32MB
#if __has_feature(objc_arc)
        NSURLCache* sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
#else
        NSURLCache* sharedCache = [[[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"] autorelease];
#endif
    [NSURLCache setSharedURLCache:sharedCache];

    self = [super init];
    return self;
}

#pragma mark UIApplicationDelegate implementation

/**
 * This is main kick off after the app inits, the views and Settings are setup here. (preferred - iOS4 and up)
 */
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
#if __has_feature(objc_arc)
        self.window = [[UIWindow alloc] initWithFrame:screenBounds];
#else
        self.window = [[[UIWindow alloc] initWithFrame:screenBounds] autorelease];
#endif
    self.window.autoresizesSubviews = YES;

#if __has_feature(objc_arc)
        self.viewController = [[MainViewController alloc] init];
#else
        self.viewController = [[[MainViewController alloc] init] autorelease];
#endif
    
    // Set your app's start page by setting the <content src='foo.html' /> tag in config.xml.
    // If necessary, uncomment the line below to override it.
    // self.viewController.startPage = @"index.html";
    sc = [[ShareClass alloc] init];
    // NOTE: To customize the view's frame size (which defaults to full screen), override
    // [self.viewController viewWillAppear:] in your view controller.
    [[JFDataBase shareDataBaseWithDBName:kAppDatabaseName] createAppTable];
    [[JFDataBase shareDataBaseWithDBName:kChatDatabaseName] createChatTable];
    [[JFDataBase shareDataBaseWithDBName:kUserDatabaseName] createUserTable];
    [[JFDataBase shareDataBaseWithDBName:kWeatherDatabaseName] createWeatherTable];
    
    Reachable *internetReach = [Reachable reachableForInternetConnection];
    [internetReach startNotifier];
    [self updateInterfaceWithReachable:internetReach];

    [self setAPNS];
    
    CLLocationManager *loactionManager = [[CLLocationManager alloc] init];
    if ([loactionManager respondsToSelector:@selector(requestWhenInUseAuthorization)] && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [loactionManager requestWhenInUseAuthorization];
    }
    loactionManager.distanceFilter = 10;
    loactionManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"showCoverView"];
    
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self setBadgeNumber];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}
- (void) applicationDidEnterBackground:(UIApplication *)application {
    
    [self setBadgeNumber];
}
// repost all remote and local notification using the default NSNotificationCenter so multiple plugins may respond
- (void) application:(UIApplication*)application didReceiveLocalNotification:(UILocalNotification*)notification {
    // re-post ( broadcast )
    [[NSNotificationCenter defaultCenter] postNotificationName:CDVLocalNotification object:notification];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 处理推送消息
    NSLog(@"收到推送消息:%@",userInfo);
    NSMutableDictionary *dict = [userInfo mutableCopy];
    [dict removeObjectForKey:@"aps"];
    
    BOOL result = [[JFDataBase shareDataBaseWithDBName:kChatDatabaseName] queryTable:kMessageTableName ifExistsWithConditions:@{@"MESSAGE_ID": [userInfo objectForKey:@"MESSAGE_ID"]} withNewObject:dict];
    if (result) {
        
        [self setBadgeNumber];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reciveNotification" object:nil];
    }
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // re-post ( broadcast )
    NSString* token = [[[[deviceToken description]
                         stringByReplacingOccurrencesOfString: @"<" withString: @""]
                        stringByReplacingOccurrencesOfString: @">" withString: @""]
                       stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSString *requestURL = [NSString stringWithFormat:@"%@/app/agentClient/addDeviceToken?deviceToken=%@",kHostSite,token];
    [[HttpRequest alloc] postWithURLString:requestURL parameters:nil WithSuccess:^(id responseObject) {
        
        id result = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (result == nil) {
            
            NSLog(@"推送请求返回值出错");
            return;
        }
        if ([[[result objectForKey:@"status"] objectForKey:@"code"] integerValue] == 0) {
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"canPush"];
        }
        else {
            
            NSLog(@"请求出错 errorCode:%@,message:%@",[[result objectForKey:@"status"] objectForKey:@"code"],[[result objectForKey:@"status"] objectForKey:@"msg"]);
        }
        
    } failure:^(id errorObject) {
        
        NSLog(@"%@",errorObject);
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:CDVRemoteNotification object:token];
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // re-post ( broadcast )
    [[NSNotificationCenter defaultCenter] postNotificationName:CDVRemoteNotificationError object:error];
}

- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window {
    
    // iPhone doesn't support upside down by default, while the iPad does.  Override to allow all orientations always, and let the root view controller decide what's allowed (the supported orientations mask gets intersected).
    NSUInteger supportedInterfaceOrientations = (1 << UIInterfaceOrientationPortrait) | (1 << UIInterfaceOrientationLandscapeLeft) | (1 << UIInterfaceOrientationLandscapeRight) | (1 << UIInterfaceOrientationPortraitUpsideDown);

    return supportedInterfaceOrientations;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application {
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
- (void) applicationDidBecomeActive:(UIApplication *)application {
    
    NSString *agentCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"agentCode"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];

    if (agentCode.length != 0 && password.length != 0) {
        
        [self getNotification];
    }
}
- (void) getNotification {
    
    NSString *requestURL = [NSString stringWithFormat:@"%@/app/message/myMessage",kHostSite];
    [[HttpRequest alloc] getWithURLString:requestURL parameters:nil WithSuccess:^(id responseObject) {
        
        id result = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSDictionary *status = [result objectForKey:@"status"];
        if ([status count] == 0) {
            
            return ;
        }
        NSMutableArray *dataList = [[result objectForKey:@"dataList"] mutableCopy];
        if ([dataList count] == 0) {
            
            return;
        }
        if ([[status objectForKey:@"code"] integerValue] == 0) {
            
            for (int i = 0; i < [dataList count]; i ++ ) {
                
                NSMutableDictionary *userInfo = [[dataList objectAtIndex:i] mutableCopy];
                NSArray *a = [[JFDataBase shareDataBaseWithDBName:kChatDatabaseName] queryTable:kMessageTableName queryByConditions:@{@"MESSAGE_ID": [userInfo objectForKey:@"MESSAGE_ID"]} sortByKey:nil sortType:nil];
                if ([a count] == 0) {
                    
                    [[JFDataBase shareDataBaseWithDBName:kChatDatabaseName] insertTable:kMessageTableName withObjectDictionary:userInfo];
                }
                else {
                    
                    [[JFDataBase shareDataBaseWithDBName:kChatDatabaseName] updateTable:kMessageTableName updateByConditions:@{@"MESSAGE_ID": [userInfo objectForKey:@"MESSAGE_ID"]} withObjectDictionary:userInfo];
                }
            }
        }
        [self setBadgeNumber];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reciveNotification" object:nil];
        
    } failure:^(id errorObject) {
        
        NSLog(@"%@",errorObject);
    }];
}
- (void) setBadgeNumber {
    
    NSArray *res = [[JFDataBase shareDataBaseWithDBName:kChatDatabaseName] queryTableWithSql:@"select * from message_info where STATE == 0"];
    int badgeNumber = [res count];
    [UIApplication sharedApplication].applicationIconBadgeNumber = badgeNumber;
}
#pragma mark - connection
- (void) setAPNS {
    // 开启APNS推送
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else {
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert |
          UIRemoteNotificationTypeBadge |
          UIRemoteNotificationTypeSound)];
    }
}

- (void) reachableChanged: (NSNotification* )note {
    
    Reachable* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachable class]]);
    [self updateInterfaceWithReachable: curReach];
}
- (void) updateInterfaceWithReachable: (Reachable*) curReach {
    
    NetworkStatus status = [curReach currentReachableStatus];
    if (status == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接错误" message:@"当前没有网络,请检查网络设置!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        
        [self startCheckVersion];
    }
}
- (void)startCheckVersion {
    
    NSString *str = [NSString stringWithFormat:@"%@%@",kHostSite,kCheckVerson];
    
    [[HttpRequest alloc] getWithURLString:[NSString stringWithFormat:@"%@%@",kHostSite,kCheckVerson] parameters:nil WithSuccess:^(id responseObject) {
        
        id result = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (result != nil) {
            
            NSString *status = [[result objectForKey:@"status"] objectForKey:@"code"];
            if ([status integerValue] == 0) {
                
                NSArray *dataList = [result objectForKey:@"dataList"];
                if (![dataList isKindOfClass:[NSArray class]] || dataList.count == 0) {
                    return ;
                }
                NSDictionary *resultDictionarray = dataList.lastObject;
                
                if ([resultDictionarray isKindOfClass:[NSDictionary class]] && resultDictionarray != nil) {
                    
                    NSString *url = [resultDictionarray objectForKey:@"url"];
                    _downloadURL = [[NSMutableString alloc] initWithString:@"itms-services://?action=download-manifest&url="];
                    [_downloadURL appendString:url];
                    
                    NSString *versionId = [resultDictionarray objectForKey:@"version"];
                    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                    
                    NSArray *versionArray = [versionId componentsSeparatedByString:@"."];
                    NSArray *appArray = [appVersion componentsSeparatedByString:@"."];
                    NSString *versionString = [NSString stringWithFormat:@"%@.",[versionArray objectAtIndex:0]];
                    NSString *appString = [NSString stringWithFormat:@"%@.",[appArray objectAtIndex:0]];
                    
                    for (int i = 1; i < versionArray.count; i++) {
                        versionString = [NSString stringWithFormat:@"%@%@",versionString,[versionArray objectAtIndex:i]];
                    }
                    for (int i = 1; i < appArray.count; i++) {
                        appString = [NSString stringWithFormat:@"%@%@",appString,[appArray objectAtIndex:i]];
                    }
                    if ([appString floatValue] < [versionString floatValue]) {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新提示" message:@"有新版本更新内容." delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];
                        [alert show];
                    }
                }
            }
            else {
                
                NSLog(@"获取数据出错: %@,%@",status,[[responseObject objectForKey:@"status"] objectForKey:@"msg"]);
            }
        }
    } failure:^(id errorObject) {
        
        NSLog(@"请求出错");
    }];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_downloadURL]];
    }
}
#pragma mark - 
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    NSString *str = [NSString stringWithFormat:@"%@",url];
    if ([str hasPrefix:WECHAT_APP_ID]) {
        return  [WXApi handleOpenURL:url delegate:self.sc];
    }
    else {
        
        return YES;
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSString *str = [NSString stringWithFormat:@"%@",url];
    if ([str hasPrefix:WECHAT_APP_ID]) {
        
        return  [WXApi handleOpenURL:url delegate:self.sc];
    }
    else {
        
        if (!url) {
            
            return NO;
        }
        NSString* jsString = [NSString stringWithFormat:@"handleOpenURL(\"%@\");", url];
        [self.viewController.webView stringByEvaluatingJavaScriptFromString:jsString];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPluginHandleOpenURLNotification object:url]];
        return YES;
    }
}
@end
