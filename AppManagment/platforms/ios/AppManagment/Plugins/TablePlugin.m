//
//  TablePlugin.m
//  CordovaLibTest
//
//  Created by Elvis_J_Chan on 14/8/19.
//
//

#import "TablePlugin.h"

@implementation TablePlugin

- (void) createTable:(CDVInvokedUrlCommand *)command {
    
    NSString *sqlString = [[command.arguments objectAtIndex:0] objectForKey:@"createSQL"];
    BOOL res = [[JFDataBase shareDataBaseWithDBName:@""] createTableWithSql:sqlString];
    CDVPluginResult* pluginResult = nil;
    if (res == YES) {
        
        NSLog(@"创建表 SQL: %@ 成功",sqlString);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"]; //成功回调
    }
    else {
        
        NSLog(@"创建表 SQL: %@ 失败",sqlString);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"0"]; //失败回调
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}
- (void) deleteTable:(CDVInvokedUrlCommand *)command {
    
    NSString *tableName = [[command.arguments objectAtIndex:0] objectForKey:@"deleteTableName"];
    NSString *sqlString = [NSString stringWithFormat:@"DROP TABLE %@;",tableName];
    
    BOOL res = [[JFDataBase shareDataBaseWithDBName:@""] executeUpdate:sqlString];
    
    CDVPluginResult* pluginResult = nil;
    if (res) {
            
        NSLog(@"删除表 SQL: %@ 成功",sqlString);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"]; //成功回调

    }
    else {
            
        NSLog(@"删除表 SQL: %@ 失败",sqlString);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"0"]; //失败回调

    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
@end
