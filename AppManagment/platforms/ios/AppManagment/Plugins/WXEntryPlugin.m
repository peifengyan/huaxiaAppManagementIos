//
//  WXEntryPlugin.m
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/12/10.
//
//

#import "WXEntryPlugin.h"
#import "AppDelegate.h"
#import "ScreenOrientationPlugin.h"

@implementation WXEntryPlugin

- (void) WebPageShareToWXFriend:(CDVInvokedUrlCommand *)command {
    
    self.callbackId = command.callbackId;
    
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    NSString *title = [reciveFromJS objectForKey:@"title"];
    NSString *describe = [reciveFromJS objectForKey:@"describe"];
    NSString *url = [reciveFromJS objectForKey:@"url"];

    [self performSelector:@selector(backScreens) withObject:nil afterDelay:0.5];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveWechatResult:) name:@"wechatShareResult" object:nil];

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.sc shareWeiXinWithTitle:title description:describe url:url sence:1];
}
- (void) WebPageShareToWXPerson:(CDVInvokedUrlCommand *)command {
    
    self.callbackId = command.callbackId;
    
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    NSString *title = [reciveFromJS objectForKey:@"title"];
    NSString *describe = [reciveFromJS objectForKey:@"describe"];
    NSString *url = [reciveFromJS objectForKey:@"url"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveWechatResult:) name:@"wechatShareResult" object:nil];
    
    [self performSelector:@selector(backScreens) withObject:nil afterDelay:0.5];

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.sc shareWeiXinWithTitle:title description:describe url:url sence:0];
}
- (void) backScreens {
    
    ScreenOrientationPlugin *sop = [[ScreenOrientationPlugin alloc] init];
    [sop portrait:nil];
}
- (void) setScreens {
    
    ScreenOrientationPlugin *sop = [[ScreenOrientationPlugin alloc] init];
    [sop landscape:nil];
}
- (void) reciveWechatResult:(NSNotification *) notification {
    
    BaseResp *resp = [notification object];
    [self performSelector:@selector(setScreens) withObject:nil afterDelay:0];
    
    if([resp isKindOfClass:[SendMessageToWXResp class]]) {
        
        if (resp.errCode == 0) {
            
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"分享成功"] callbackId:self.callbackId];
        }
        else if (resp.errCode == -2) {
            
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"分享已取消"] callbackId:self.callbackId];
        }
        else {
            
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"分享失败"] callbackId:self.callbackId];
        }
    }
    else {
        
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"目前您的微信版本过低或未安装微信，需要安装微信才能使用"] callbackId:self.callbackId];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
