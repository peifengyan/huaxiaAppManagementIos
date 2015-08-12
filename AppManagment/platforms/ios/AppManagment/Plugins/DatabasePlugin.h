//
//  DatabasePlugin.h
//  CordovaLibTest
//
//  Created by Elvis_J_Chan on 14/8/19.
//
//

#import <Foundation/Foundation.h>
#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVplugin.h>
#else
#import "Cordova/CDVPlugin.h"
#endif

@interface DatabasePlugin : CDVPlugin

- (void) createDatabase:(CDVInvokedUrlCommand *)command;

- (void) deleteDatabase:(CDVInvokedUrlCommand *)command;

@end
