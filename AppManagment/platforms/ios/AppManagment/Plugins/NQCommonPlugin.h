//
//  NQCommonPlugin.h
//  HelloCordova
//
//  Created by andy on 8/29/14.
//
//

#import "RootPlugin.h"

@interface NQCommonPlugin : RootPlugin

/**
 *  打开App
 *
 *  @param command 参数
 */
- (void)openApp:(CDVInvokedUrlCommand *)command;

/**
 *  能否打开App
 *
 *  @param command 参数
 */
- (void)canOpenApp:(CDVInvokedUrlCommand *)command;

- (void)beginSendingMessage:(CDVInvokedUrlCommand *)command;

- (void)endSendingMessage:(CDVInvokedUrlCommand *)command;

@end
