//
//  DeviceModelPlugin.m
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/10/10.
//
//

#import "DeviceModelPlugin.h"

@implementation DeviceModelPlugin

- (void)currentDeviceModel:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{

        if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
            
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"pad"] callbackId:command.callbackId];
        }
        else {
            
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"phone"] callbackId:command.callbackId];
        }
    }];
}


@end
