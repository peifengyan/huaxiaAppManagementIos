//
//  Conversation.h
//  CordovaLibTest
//
//  Created by Guo Mingliang on 14-5-14.
//
//

#import <Foundation/Foundation.h>
#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVplugin.h>
#else
#import "Cordova/CDVPlugin.h"
#endif


@interface ConversationPlugin : CDVPlugin


- (void) queryConversationByUser:(CDVInvokedUrlCommand *)command;

@end
