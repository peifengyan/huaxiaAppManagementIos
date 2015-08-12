//
//  Conversation.m
//  CordovaLibTest
//
//  Created by Guo Mingliang on 14-5-14.
//
//

#import "ConversationPlugin.h"

@implementation ConversationPlugin

- (void) queryConversationByUser:(CDVInvokedUrlCommand *)command {
    
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    NSString *databaseName = [reciveFromJS objectForKey:@"databaseName"];
    NSString *tableName = [reciveFromJS objectForKey:@"tableName"];
    NSString *userId1 = [[reciveFromJS objectForKey:@"conditions"] objectForKey:@"userId1"];
    NSString *userId2 = [[reciveFromJS objectForKey:@"conditions"] objectForKey:@"userId2"];

    NSString *sql = [NSString stringWithFormat:@"select * from %@ where (userId1 = '%@' and userId2 = '%@') or (userId1 = '%@' and userId2 = '%@')",tableName,userId1,userId2,userId2,userId1];
    FMResultSet *rs = [[JFDataBase shareDataBaseWithDBName:databaseName] executeQuery:sql];
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:0];
    
    while ([rs next]) {
        
        [result addObject:[rs resultDictionary]];
    }
    
    if ([result count] != 0) {
        
        [self.commandDelegate runInBackground:^{
            
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:[result objectAtIndex:0]] callbackId:command.callbackId];
        }];
    }
    else {
        
        [self.commandDelegate runInBackground:^{
            
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""] callbackId:command.callbackId];
        }];
    }
}
@end
