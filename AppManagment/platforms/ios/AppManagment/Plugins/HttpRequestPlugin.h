//
//  HttpRequestPlugin.h
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/11/5.
//
//

#import "RootPlugin.h"
#import "HttpRequest.h"

@interface HttpRequestPlugin : RootPlugin

- (void)get:(CDVInvokedUrlCommand *)command;

- (void)post:(CDVInvokedUrlCommand *)command;

@end
