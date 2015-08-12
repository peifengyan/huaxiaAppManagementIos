//
//  ViewControllerPlugin.m
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/9/4.
//
//

#import "ViewControllerPlugin.h"

typedef enum {
    
    URLTypeNativeApp = 0,
    URLTypeOnlineWeb = 1
    
} URLType;

@implementation ViewControllerPlugin

- (void) pushToViewController:(CDVInvokedUrlCommand *)command {
    
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    
    NSString *loadURLString = @"http://www.baiu.com";
    
    if ([[reciveFromJS objectForKey:@"serviceType"] isEqualToString:@"REMOTE"]) {
        
        loadURLString = [reciveFromJS objectForKey:@"URL"];
    }
    else if ([[reciveFromJS objectForKey:@"serviceType"] isEqualToString:@"LOCAL"]) {
        
        loadURLString = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[reciveFromJS objectForKey:@"URL"]];
//            loadURLString = [[NSBundle mainBundle] pathForResource:[reciveFromJS objectForKey:@"URL"] ofType:nil];
    }
    
    NSRange range = [loadURLString rangeOfString:@"index.html"];
    NSRange newRange = NSMakeRange(0, range.length + range.location);
    NSString *url = [loadURLString substringWithRange:newRange];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:url]) {
        
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"文件不存在"] callbackId:command.callbackId];
    }
    else {
        
        ConversationViewController *cvc;
        
        if ([[UIScreen mainScreen] bounds].size.height <= 568) {
            
            cvc = [[ConversationViewController alloc] initWithNibName:@"ConversationViewController" bundle:nil];
            
        } else {
            
            cvc = [[ConversationViewController alloc] initWithNibName:@"ConversationViewController~iPad" bundle:nil];
        }
        cvc.loadWebUrl = loadURLString;
        cvc.showCloseButton = NO;
        id keyString = [reciveFromJS objectForKey:@"key"];
        if (keyString != nil) {
            
            cvc.passData = keyString;
        }
        UIViewController *controller = [GlobalVariables getGlobalVariables].currentController;
        [controller presentViewController:cvc animated:YES completion:nil];
    }
}

- (void) closeWebView:(CDVInvokedUrlCommand *)command {
    
    ConversationViewController *controller = (ConversationViewController *)[GlobalVariables getGlobalVariables].currentController;
    id reciveFromJS = [command.arguments objectAtIndex:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backValue" object:reciveFromJS];
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
