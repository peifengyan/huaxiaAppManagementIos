//
//  DatabasePlugin.m
//  CordovaLibTest
//
//  Created by Elvis_J_Chan on 14/8/19.
//
//

#import "DatabasePlugin.h"

@implementation DatabasePlugin

- (void) createDatabase:(CDVInvokedUrlCommand *)command {
    
    NSDictionary *dbDictionary = [command.arguments objectAtIndex:0];
    NSString *dbName = @"MyDatabase.db";
    if (dbDictionary != nil && dbDictionary.count != 0) {
        
        dbName = [NSString stringWithFormat:@"%@.db",[dbDictionary objectForKey:@"databaseName"]];

    }
//    databaseName = dbName;
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:dbName];
    FMDatabase *db = [[FMDatabase alloc] initWithPath:path];
    BOOL res;
    res = [db open];
    
    CDVPluginResult* pluginResult = nil;
    if (res == YES) {
        
        NSLog(@"数据库打开成功");
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"]; //成功回调
    }
    else {
        
        NSLog(@"数据库打开失败");
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"0"]; //失败回调
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) deleteDatabase:(CDVInvokedUrlCommand *)command {
    
    NSDictionary *dbDictionary = [command.arguments objectAtIndex:0];
    
    NSString *dbName = @"MyDatabase.db";
    if (dbDictionary != nil && dbDictionary.count != 0) {
        
        dbName = [NSString stringWithFormat:@"%@.db",[dbDictionary objectForKey:@"databaseName"]];
        
    }
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:dbName];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];

    if ([fileMgr fileExistsAtPath:path]) {
        //
        NSError *err;
        BOOL res = [fileMgr removeItemAtPath:path error:&err];
        
        CDVPluginResult* pluginResult = nil;
        if (res == YES) {
            
            NSLog(@"数据库删除成功");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"]; //成功回调
        }
        else {
            
            NSLog(@"数据库删除失败");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"0"]; //失败回调
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}
@end
