//
//  SaveImageToNativePlugin.h
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/12/15.
//
//

#import "RootPlugin.h"

@interface SaveImageToNativePlugin : RootPlugin

- (void) saveImageToNative:(CDVInvokedUrlCommand *) command ;

- ( void ) downLoadImage:( CDVInvokedUrlCommand * ) command ;

@end
