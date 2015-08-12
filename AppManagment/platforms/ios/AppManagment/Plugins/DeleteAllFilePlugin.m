//
//  DeleteAllFilePlugin.m
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/10/13.
//
//

#import "DeleteAllFilePlugin.h"

@implementation DeleteAllFilePlugin

- (void)deleteFilePath:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{
        
        NSString *reciveFromJS = [command.arguments objectAtIndex:0];
        NSError *fileError = nil;
        NSString *deletePath = [DocumentOperation getPathWithComponent:reciveFromJS withIntermediateDirectories:YES error:&fileError];
        
        NSError *error = nil;
        
        BOOL delete = [[NSFileManager defaultManager] removeItemAtPath:deletePath error:&error];
        if (delete) {
            
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"] callbackId:command.callbackId];
        }
        else {
            
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"0"] callbackId:command.callbackId];
        }
    }];
}

@end
