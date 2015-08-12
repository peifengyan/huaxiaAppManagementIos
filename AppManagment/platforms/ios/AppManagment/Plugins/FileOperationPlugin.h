//
//  FileOperationPlugin.h
//  AppManagment
//
//  Created by Elvis_J_Chan on 12/16/14.
//
//

#import "RootPlugin.h"

@interface FileOperationPlugin : RootPlugin

- (void) fileExistsAtPath:(CDVInvokedUrlCommand *) command;

- (void) changePassword:(CDVInvokedUrlCommand *) command;
@end
