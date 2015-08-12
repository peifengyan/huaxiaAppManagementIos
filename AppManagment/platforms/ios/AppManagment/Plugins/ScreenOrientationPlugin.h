//
//  ScreenOrientationPlugin.h
//  AppManagment
//
//  Created by Elvis_J_Chan on 1/6/15.
//
//

#import "RootPlugin.h"

@interface ScreenOrientationPlugin : RootPlugin
- (void) landscape:(CDVInvokedUrlCommand *) command;
- (void) portrait:(CDVInvokedUrlCommand *) command;
@end
