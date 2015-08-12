//
//  FileOperationPlugin.m
//  AppManagment
//
//  Created by Elvis_J_Chan on 12/16/14.
//
//

#import "FileOperationPlugin.h"

@implementation FileOperationPlugin

- (void) fileExistsAtPath:(CDVInvokedUrlCommand *) command {
    
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    NSString *filePath = [reciveFromJS objectForKey:@"filePath"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"] callbackId:command.callbackId];

    }
    else {
        
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"0"] callbackId:command.callbackId];
    }
}

- (void) changePassword:(CDVInvokedUrlCommand *) command {
    
    [[GlobalVariables getGlobalVariables] setCurrentLoginUser];
}

//NSString *config = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"config" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
//NSData *configData = [config dataUsingEncoding:NSUTF8StringEncoding];
//id configResult = [NSJSONSerialization JSONObjectWithData:configData options:0 error:nil];
//
//NSString *file = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"filedata" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
//NSData *fileData = [file dataUsingEncoding:NSUTF8StringEncoding];
//id fileResult = [NSJSONSerialization JSONObjectWithData:fileData options:0 error:nil];
////服务器返回JSON数据
//NSDictionary *jsonMap = [fileResult objectForKey:@"jsonMap"];
////
//NSArray *configDataInfo = [configResult objectForKey:@"dataInfo"];
//NSString *localDatabaseName = [[NSString alloc] init];
//
//NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
//for ( int i = 0 ; i < [configDataInfo count] ; i ++ ) {
//    //本地配置数据库名称
//    localDatabaseName = [[configDataInfo objectAtIndex:i] objectForKey:@"localDatabaseName"];
//    //本地配置表名称
//    NSString *localTableName = [[configDataInfo objectAtIndex:i] objectForKey:@"localTableName"];
//    //本地配置接口返回表字段
//    NSString *serviceTableName = [[configDataInfo objectAtIndex:i] objectForKey:@"serviceTableName"];
//    //本地配置详细数据列表
//    NSArray *tableInfo = [[configDataInfo objectAtIndex:i] objectForKey:@"tableInfo"];
//    //服务器返回具体插入某个表单数据数据
//    NSArray *insertTableData = [jsonMap objectForKey:serviceTableName];
//    
//    
//    NSMutableArray *sqlArray = [[NSMutableArray alloc] initWithCapacity:0];
//    for ( int j = 0 ; j < [insertTableData count] ; j ++ ) {
//        //获取插入单一数据
//        NSDictionary *insertOneData = [insertTableData objectAtIndex:j];
//        //替换字段
//        NSMutableDictionary *tmpDict = [insertOneData mutableCopy];
//        
//        NSMutableDictionary *conditionsDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
//        for ( int k = 0 ; k < [tableInfo count] ; k ++ ) {
//            
//            NSString *localTableKey = [[tableInfo objectAtIndex:k] objectForKey:@"localTableKey"];
//            NSString *serviceTableKey = [[tableInfo objectAtIndex:k] objectForKey:@"serviceTableKey"];
//            BOOL primaryKey = [[[tableInfo objectAtIndex:k] objectForKey:@"primaryKey"] boolValue];
//            if (primaryKey) {
//                
//                [conditionsDictionary setObject:[insertOneData objectForKey:serviceTableKey] forKey:localTableKey];
//            }
//            
//            [tmpDict setObject:[insertOneData objectForKey:serviceTableKey] forKey:localTableKey];
//            [tmpDict removeObjectForKey:serviceTableKey];
//        }
//        
//        NSString *sql = [[JFDataBase shareDataBaseWithDBName:localDatabaseName] returnSqlInsertTable:localTableName withObjectDictionary:tmpDict];
//        [sqlArray addObject:sql];
//    }
//    [arr addObjectsFromArray:sqlArray];
//}
//[[JFDataBase shareDataBaseWithDBName:localDatabaseName] syncInsertData:arr];

@end
