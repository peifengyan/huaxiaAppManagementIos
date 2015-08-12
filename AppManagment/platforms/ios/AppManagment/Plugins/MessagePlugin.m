//
//  Message.m
//  CordovaLibTest
//
//  Created by Guo Mingliang on 14-5-14.
//
//

#import "MessagePlugin.h"

@implementation MessagePlugin {
    
    UIWebView *theWebView;
}
#pragma mark - UUID
NSString * message_uuid() {
    
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    NSString *uuidWithoutDash = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    CFRelease(uuid_string_ref);
    
    return uuidWithoutDash;
}
#pragma mark - 发送消息
/**
 *	@brief	添加
 *
 *	@param 	key 	字段 json字符串，要添加的数据
 *
 *	@return 成功返回 插入成功  失败返回 插入失败
 */
- (void)addMessage:(CDVInvokedUrlCommand *)command {
    
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    
    NSMutableDictionary *saveDictionary = [reciveFromJS mutableCopy];
    
    if ([[JFDataBase shareDataBaseWithDBName:@"ChatDatabase.db"] createChatTable]) {
        
        NSString *messageUUID = message_uuid();
        [saveDictionary setObject:messageUUID forKey:@"id"];
        BOOL res = [[JFDataBase shareDataBaseWithDBName:@"ChatDatabase.db"] insertTable:@"Chat_info" withObjectDictionary:saveDictionary];
        if (res) {
            
            NSLog(@"插入成功");
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:saveDictionary]; //成功回调
            [self.commandDelegate runInBackground:^{
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }];
        }
    }
}

@end
