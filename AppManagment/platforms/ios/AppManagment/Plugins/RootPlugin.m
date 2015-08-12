//
//  RootPlugin.m
//  Test
//
//  Created by andy on 13-12-9.
//
//

#import "RootPlugin.h"
#import "AppDelegate.h"
#import <Cordova/CDVViewController.h>

@implementation RootPlugin

#pragma mark - 外放接口

// 模态推送 (推入vc)
//
- (void)presentViewController:(UIViewController *)vc animated:(BOOL)isAnimation completion:(void (^)(void))completion {
    
    CDVViewController *cvc = [GlobalVariables getGlobalVariables].currentController;
    [cvc presentViewController:vc animated:isAnimation completion:completion];
}

// 返回结果, 并且返回提示字符串
//
- (void)returnOKResult:(BOOL)isOK withResultString:(NSString *)string {
    
    CDVPluginResult *result = nil;
    if (isOK) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:string];
    } else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:string];
    }
    [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
}

// 返回结果, 并且返回数组
//
- (void)returnOKResult:(BOOL)isOK withResultArray:(NSArray *)array {
    
    CDVPluginResult *result = nil;
    if (isOK) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:array];
    }else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsArray:array];
    }
    [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
}

/**
 *  返回结果, 并且返回地点
 */
- (void)returnOKResult:(BOOL)isOK withResultDictionary:(NSDictionary *)dict {
    CDVPluginResult *result = nil;
    
    if (isOK) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
    }else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
    }
    [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
}

/**
 *  测试专用
 */
- (void)showAlertViewWithMessage:(NSString *)message {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"测试" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}



@end
