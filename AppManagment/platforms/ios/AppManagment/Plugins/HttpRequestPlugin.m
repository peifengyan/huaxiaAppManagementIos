//
//  HttpRequestPlugin.m
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/11/5.
//
//

#import "HttpRequestPlugin.h"
#import "AFHTTPClient.h"
#import "DesEncryptUtil.h"
#import "AFHTTPRequestOperation.h"
#import "NSString+FormatObject.h"

@implementation HttpRequestPlugin

- (void)get:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{
        
        self.callbackId = command.callbackId;
        NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
        NSString *url = [reciveFromJS objectForKey:@"url"];
        NSMutableDictionary *parameters = [[reciveFromJS objectForKey:@"parameters"] mutableCopy];
        
        [[HttpRequest alloc] getWithURLString:url parameters:parameters WithSuccess:^(id responseObject) {
            
            NSString *returnJson = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            id result = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            if ([[parameters objectForKey:@"newPwd"] length] != 0 && [[parameters objectForKey:@"oldPwd"] length] != 0) {
                //修改密码
                [self confirmChangePasswordJson:result];
            }
            if ([[parameters objectForKey:@"password"] length] != 0 && [[parameters objectForKey:@"agentCode"] length] != 0) {
                //修改密码
                [self getNotification:result];
            }
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:returnJson] callbackId:command.callbackId];

        } failure:^(id errorObject) {
            
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorObject] callbackId:command.callbackId];
        }];
    }];
}

- (void)post:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{
        
        NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
        NSString *url = [reciveFromJS objectForKey:@"url"];
        NSMutableDictionary *parameters = [[reciveFromJS objectForKey:@"parameters"] mutableCopy];
        
        [[HttpRequest alloc] postWithURLString:url parameters:parameters WithSuccess:^(id responseObject) {
            
            NSString *returnJson = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            id result = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            if ([[parameters objectForKey:@"newPwd"] length] != 0 && [[parameters objectForKey:@"oldPwd"] length] != 0) {
                //修改密码
                [self confirmChangePasswordJson:result];
            }
            if ([[parameters objectForKey:@"password"] length] != 0 && [[parameters objectForKey:@"agentCode"] length] != 0) {
                //修改密码
                [self getNotification:result];
            }
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:returnJson] callbackId:command.callbackId];

        } failure:^(id errorObject) {
            
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorObject] callbackId:command.callbackId];
        }];
    }];
}

- (void) confirmChangePasswordJson:( id ) data {
    
    NSDictionary *status = [data objectForKey:@"status"];
    NSString *code = [status objectForKey:@"code"];
    NSDictionary *jsonMap = [data objectForKey:@"jsonMap"];
    if ([code integerValue] == 0) {

        NSString *password = [jsonMap objectForKey:@"passwd"];
        if ([password length] != 0) {

            password = [[DesEncryptUtil encryptUseDES:[password uppercaseStringWithLocale:[NSLocale currentLocale]]] mutableCopy];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
        }
    }
}

- (void) getNotification:( id ) data {
    
    NSDictionary *status = [data objectForKey:@"status"];
    NSString *code = [status objectForKey:@"code"];
    NSDictionary *jsonMap = [data objectForKey:@"jsonMap"];

    if ([code integerValue] == 0) {
        
        NSString *password = [jsonMap objectForKey:@"PASSWORD"];
        if ([password length] != 0) {
            
            password = [[DesEncryptUtil encryptUseDES:[password uppercaseStringWithLocale:[NSLocale currentLocale]]] mutableCopy];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
        }
        NSString *agentCode = [jsonMap objectForKey:@"AGENT_CODE"];
        if ([agentCode length] != 0) {
            
            agentCode = [[DesEncryptUtil encryptUseDES:[agentCode uppercaseStringWithLocale:[NSLocale currentLocale]]] mutableCopy];
            [[NSUserDefaults standardUserDefaults] setObject:agentCode forKey:@"agentCode"];
        }
        AppDelegate *delegate = ( AppDelegate * ) [[UIApplication sharedApplication] delegate];
        [delegate setAPNS];
        [delegate getNotification];
    }
}
@end