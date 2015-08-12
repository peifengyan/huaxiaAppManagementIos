//
//  TableStructurePlugin.h
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

@interface TableStructurePlugin : CDVPlugin

- (void) insertTableStructure:(CDVInvokedUrlCommand *)command;
- (void) updateTableStructure:(CDVInvokedUrlCommand *)command;
- (void) deleteTableStructure:(CDVInvokedUrlCommand *)command;
- (void) queryTableStructure:(CDVInvokedUrlCommand *)command;
@end
