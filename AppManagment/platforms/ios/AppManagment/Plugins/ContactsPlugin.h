//
//  ContactsPlugin.h
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/9/10.
//
//

#import "RootPlugin.h"
#import <MessageUI/MessageUI.h>

@interface ContactsPlugin : RootPlugin <MFMessageComposeViewControllerDelegate>

- (void)sendMessage:(CDVInvokedUrlCommand *)command;

- (void)callNumber:(CDVInvokedUrlCommand *)command;

@end
