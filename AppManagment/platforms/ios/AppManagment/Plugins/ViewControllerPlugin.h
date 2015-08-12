//
//  ViewControllerPlugin.h
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/9/4.
//
//

#import <Foundation/Foundation.h>
#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVplugin.h>
#else
#import "Cordova/CDVPlugin.h"
#endif

#import "ConversationViewController.h"
#import "MainViewController.h"

@interface ViewControllerPlugin : CDVPlugin {
    
}


- (void) pushToViewController:(CDVInvokedUrlCommand *)command;

- (void) closeWebView:(CDVInvokedUrlCommand *)command;

@end


