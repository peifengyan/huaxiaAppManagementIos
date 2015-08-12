//
//  DeleteAllFilePlugin.h
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/10/13.
//
//

#import "RootPlugin.h"

@interface DeleteAllFilePlugin : RootPlugin

- (void)deleteFilePath:(CDVInvokedUrlCommand *) command;

@end
