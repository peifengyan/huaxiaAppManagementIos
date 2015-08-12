//
//  WXEntryPlugin.h
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/12/10.
//
//

#import "RootPlugin.h"

@interface WXEntryPlugin : RootPlugin

- (void) WebPageShareToWXFriend:(CDVInvokedUrlCommand *)command;

- (void) WebPageShareToWXPerson:(CDVInvokedUrlCommand *)command;
@end
