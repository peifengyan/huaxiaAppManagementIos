//
//  NQCommonPlugin.m
//  HelloCordova
//
//  Created by andy on 8/29/14.
//
//

#import "NQCommonPlugin.h"
#import "NQApplication.h"

@implementation NQCommonPlugin

NSString* NSStringFromDictionary(NSDictionary *params)
{
    if (!params) {
        return @"";
    }
    
    // 解析字典, 根据所需要的数据接口拼接字符串
    NSString *rtnStr = @"";
    
    return rtnStr;
}

/**
 *  打开App
 */
- (void)openApp:(CDVInvokedUrlCommand *)command {
    
    // 回调Id
    self.callbackId = command.callbackId;
    // 获取参数
    NSArray *arr = command.arguments;
    
    // 跳转Url
    NSString *schemeUrl  = arr[0];
    // 通讯参数
    NSDictionary *params = arr[1];

    NQOpenResult result = [NQApplication openApp:schemeUrl params:params];
    
    
    [self.commandDelegate runInBackground:^{
        
        CDVPluginResult* pluginResult = nil;
        if (result == NQOpenResult_Success) {
            
            NSLog(@"打开成功");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"];
        }
        else {
            
            NSLog(@"打开失败");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"0"]; //失败回调
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];
//    // 参数转化字符串
//    NSString *paramStr = NSStringFromDictionary(params);
//    // 拼接schemeUrl
//    schemeUrl = [NSString stringWithFormat:@"%@://%@", schemeUrl, paramStr];
//
//    
//    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:schemeUrl]])
//        NSLog(@"打开失败, 如果需要可以回调前端");
//    else
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:schemeUrl]];
}
- (void) canOpenApp:(CDVInvokedUrlCommand *)command {
    
    NSString *reciveFromJS = [command.arguments objectAtIndex:0];
    NSString *canOpenString = [NSString stringWithFormat:@"%@://",reciveFromJS];
    
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:canOpenString]];
    
    [self.commandDelegate runInBackground:^{
        
        CDVPluginResult* pluginResult = nil;
        if (canOpen) {
            
            NSLog(@"应用存在");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"]; //成功回调
        }
        else {
            
            NSLog(@"应用不存在");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"0"]; //失败回调
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)beginSendingMessage:(CDVInvokedUrlCommand *)command {
    
    UIWebView *theWebView;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] keyWindow];
    UIWindow *viewC = (UIWindow *)delegate;
    for (UIView *view in viewC.rootViewController.view.subviews) {
        
        if ([view isKindOfClass:[UIWebView class]]) {
            
            theWebView = (UIWebView *)view;
        }
    }
    theWebView.frame = CGRectMake(0, 0, viewC.rootViewController.view.frame.size.width, viewC.rootViewController.view.frame.size.height-216-40-40);

}

- (void)endSendingMessage:(CDVInvokedUrlCommand *)command {
    
    UIWebView *theWebView;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] keyWindow];
    UIWindow *viewC = (UIWindow *)delegate;
    for (UIView *view in viewC.rootViewController.view.subviews) {
        
        if ([view isKindOfClass:[UIWebView class]]) {
            
            theWebView = (UIWebView *)view;
        }
    }
    theWebView.frame = CGRectMake(0, 0, viewC.rootViewController.view.frame.size.width, viewC.rootViewController.view.frame.size.height);

}
@end
