//
//  TablePlugin.h
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

@interface TablePlugin : CDVPlugin

- (void) createTable:(CDVInvokedUrlCommand *)command;
- (void) deleteTable:(CDVInvokedUrlCommand *)command;
@end
