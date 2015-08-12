//
//  TableDataPlugin.m
//  CordovaLibTest
//
//  Created by Elvis_J_Chan on 14/8/19.
//
//

#import "TableDataPlugin.h"

@implementation TableDataPlugin

- (void) insertTableData:(CDVInvokedUrlCommand *)command {
    
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    
    NSString *databaseName = [reciveFromJS objectForKey:@"databaseName"];
    NSString *tableName = [reciveFromJS objectForKey:@"tableName"];
    NSArray *data = [reciveFromJS objectForKey:@"data"];
    
    MLog(@"%@",reciveFromJS);

    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int i = 0; i < [data count]; i++) {
        
        BOOL res = [[JFDataBase shareDataBaseWithDBName:databaseName] insertTable:tableName withObjectDictionary:[data objectAtIndex:i]];
        if (res) {
            
            [result addObject:@"1"];
        }
        else {
            
            [result addObject:@"0"];
        }
    }
    [self.commandDelegate runInBackground:^{

        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:result] callbackId:command.callbackId];
    }];
}
- (void) syncInsertTableData:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{
        
        NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
        NSString *databaseName = [reciveFromJS objectForKey:@"databaseName"];
        NSString *tableName = [reciveFromJS objectForKey:@"tableName"];
        NSArray *data = [reciveFromJS objectForKey:@"data"];
        
        MLog(@"%@",reciveFromJS);
        NSMutableArray *sqlArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for ( int i = 0 ; i < [data count]; i ++ ) {
            
            NSDictionary *dict = [data objectAtIndex:i];
            NSString *sqlString = [[JFDataBase shareDataBaseWithDBName:databaseName] returnSqlInsertTable:tableName withObjectDictionary:dict];
            [sqlArray addObject:sqlString];;
        }
        BOOL res = [[JFDataBase shareDataBaseWithDBName:databaseName] syncInsertData:sqlArray];

        if (res) {
            
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"] callbackId:command.callbackId];

        }
        else {
            
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"0"] callbackId:command.callbackId];

        }
    }];
}
- (void) executeUpdateSql:(CDVInvokedUrlCommand *) command {
    
    [self.commandDelegate runInBackground:^{
        
        NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
        
        NSString *databaseName = [reciveFromJS objectForKey:@"databaseName"];
        NSString *sqlString = [reciveFromJS objectForKey:@"sql"];
        
        BOOL res = [[JFDataBase shareDataBaseWithDBName:databaseName] executeUpdate:sqlString];
        if (res) {
            NSLog(@"%@ 成功",sqlString);
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"] callbackId:command.callbackId];
        }
        else {
            NSLog(@"%@ 失败",sqlString);
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"0"] callbackId:command.callbackId];
        }
    }];
}
- (void) updateTableData:(CDVInvokedUrlCommand *) command {
    
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    
    NSString *databaseName = [reciveFromJS objectForKey:@"databaseName"];
    NSString *tableName = [reciveFromJS objectForKey:@"tableName"];
    NSArray *data = [reciveFromJS objectForKey:@"data"];
    NSArray *conditions = [reciveFromJS objectForKey:@"conditions"];
    
    MLog(@"%@",reciveFromJS);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int i = 0; i < [data count]; i++) {
        
        BOOL res = [[JFDataBase shareDataBaseWithDBName:databaseName] updateTable:tableName updateByConditions:[conditions objectAtIndex:i] withObjectDictionary:[data objectAtIndex:i]];
        
        if (res) {
            
            [result addObject:@"1"];
        }
        else {
            
            [result addObject:@"0"];
        }
    }
    [self.commandDelegate runInBackground:^{

        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:result] callbackId:command.callbackId];
    }];
}

- (void) deleteTableData:(CDVInvokedUrlCommand *)command {
    
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    
    NSString *databaseName = [reciveFromJS objectForKey:@"databaseName"];
    NSString *tableName = [reciveFromJS objectForKey:@"tableName"];
    NSArray *conditions = [reciveFromJS objectForKey:@"conditions"];
    
    MLog(@"%@",reciveFromJS);

    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int i = 0; i < [conditions count]; i++) {
        
        BOOL res = [[JFDataBase shareDataBaseWithDBName:databaseName] deleteTable:tableName deleteByConditions:[conditions objectAtIndex:i]];
        
        if (res) {
            
            [result addObject:@"1"];
        }
        else {
            
            [result addObject:@"0"];
        }
    }
    [self.commandDelegate runInBackground:^{

        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:result] callbackId:command.callbackId];
    }];
}
- (void) queryAppIDByAppName:(CDVInvokedUrlCommand *)command {
    
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    NSString *appName = [reciveFromJS objectForKey:@"appName"];

    NSString *sqlString = [NSString stringWithFormat:@"select appId from %@ where name = '%@'",kAppInfoTableName,appName];
    NSArray *array = [[JFDataBase shareDataBaseWithDBName:kAppDatabaseName] queryTableWithSql:sqlString];
    NSMutableDictionary *appId = [[NSMutableDictionary alloc] initWithCapacity:0];
    if ([array count] != 0) {
        
        appId = [array objectAtIndex:0];
    }
    if ([appId count] != 0) {
        
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:appId] callbackId:command.callbackId];
    }
    else {
        
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:@{@"message":@"查询结果为空"}] callbackId:command.callbackId];
    }
}
- (void) queryAllTableData:(CDVInvokedUrlCommand *)command {
    
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    
    NSString *tableName = [reciveFromJS objectForKey:@"tableName"];
    NSString *databaseName = [reciveFromJS objectForKey:@"databaseName"];
    NSString *sqlOrderType = [reciveFromJS objectForKey:@"sqlOrderType"];
    NSString *sqlOrderColm = [reciveFromJS objectForKey:@"sqlOrderColm"];
    
    MLog(@"%@",reciveFromJS);

    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    result = [[[JFDataBase shareDataBaseWithDBName:databaseName] queryTable:tableName queryByConditions:nil sortByKey:sqlOrderColm sortType:sqlOrderType] mutableCopy];
    
    [self.commandDelegate runInBackground:^{

        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:result] callbackId:command.callbackId];
    }];
}

- (void) queryTableDataByConditions:(CDVInvokedUrlCommand *)command {
    
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    
    NSString *databaseName = [reciveFromJS objectForKey:@"databaseName"];
    NSString *tableName = [reciveFromJS objectForKey:@"tableName"];
    NSDictionary *conditions = [reciveFromJS objectForKey:@"conditions"];
    NSString *sqlOrderType = [reciveFromJS objectForKey:@"sqlOrderType"];
    NSString *sqlOrderColm = [reciveFromJS objectForKey:@"sqlOrderColm"];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    result = [[[JFDataBase shareDataBaseWithDBName:databaseName] queryTable:tableName queryByConditions:conditions sortByKey:sqlOrderColm sortType:sqlOrderType] mutableCopy];
    
    MLog(@"\nreciveFromJS: %@\n\nresult:%@",reciveFromJS,result);
    
    [self.commandDelegate runInBackground:^{
        
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:result] callbackId:command.callbackId];
    }];
}

- (void) fuzzyQueryTableDataByConditions:(CDVInvokedUrlCommand *)command {
    
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    
    NSString *databaseName = [reciveFromJS objectForKey:@"databaseName"];
    NSString *tableName = [reciveFromJS objectForKey:@"tableName"];
    NSDictionary *conditions = [reciveFromJS objectForKey:@"conditions"];
    NSString *fuzzyConditions = [reciveFromJS objectForKey:@"fuzzyConditions"];
    NSString *sqlOrderType = [reciveFromJS objectForKey:@"sqlOrderType"];
    NSString *sqlOrderColm = [reciveFromJS objectForKey:@"sqlOrderColm"];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    result = [[[JFDataBase shareDataBaseWithDBName:databaseName] fuzzyQueryTable:tableName queryByDataConditions:conditions fuzzyConditions:fuzzyConditions sortByKey:sqlOrderColm sortType:sqlOrderType] mutableCopy];
    
    MLog(@"\nreciveFromJS: %@\n\nresult:%@",reciveFromJS,result);
    
    [self.commandDelegate runInBackground:^{
        
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:result] callbackId:command.callbackId];
    }];
}

- (void) updateORInsertTableDataByConditions:(CDVInvokedUrlCommand *)command {
    
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    NSString *databaseName = [reciveFromJS objectForKey:@"databaseName"];
    NSString *tableName = [reciveFromJS objectForKey:@"tableName"];
    NSArray *data = [reciveFromJS objectForKey:@"data"];
    NSArray *conditions = [reciveFromJS objectForKey:@"conditions"];
    
    MLog(@"%@",reciveFromJS);

    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [data count]; i++) {
        
        BOOL res = [[JFDataBase shareDataBaseWithDBName:databaseName] queryTable:tableName ifExistsWithConditions:[conditions objectAtIndex:i] withNewObject:[data objectAtIndex:i]];
        
        if (res) {
            
            [result addObject:@"1"];
        }
        else {
            
            [result addObject:@"0"];
        }
    }
    
    [self.commandDelegate runInBackground:^{
        
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:result] callbackId:command.callbackId];
    }];
}
- (void) queryTableDataUseSql:(CDVInvokedUrlCommand *)command {
    
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    NSString *databaseName = [reciveFromJS objectForKey:@"databaseName"];
    NSString *sqlString = [reciveFromJS objectForKey:@"sql"];

    NSArray *result = [[JFDataBase shareDataBaseWithDBName:databaseName] queryTableWithSql:sqlString];
    
    MLog(@"\nreciveFromJS: %@\n\n result:%@",reciveFromJS,result);
    
    [self.commandDelegate runInBackground:^{
        
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:result] callbackId:command.callbackId];
    }];
}

@end
