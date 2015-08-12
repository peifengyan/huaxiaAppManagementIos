//
//  DownloadPlugin.h
//  myApp
//
//  Created by Elvis_J_Chan on 14/8/28.
//
//

#import "RootPlugin.h"

@interface DownloadPlugin : RootPlugin <NSFileManagerDelegate>

- (void) downloadZip:(CDVInvokedUrlCommand *)command;

- (void) downloadNavtiveApp:(CDVInvokedUrlCommand *)command;

- (void) updateZip:(CDVInvokedUrlCommand *)command;

@end
