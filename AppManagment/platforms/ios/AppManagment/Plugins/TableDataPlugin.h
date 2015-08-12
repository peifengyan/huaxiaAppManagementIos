//
//  TableDataPlugin.h
//  CordovaLibTest
//
//  Created by Elvis_J_Chan on 14/8/19.
//
//

#import "RootPlugin.h"

@interface TableDataPlugin : RootPlugin


- (void) insertTableData:(CDVInvokedUrlCommand *)command;

- (void) syncInsertTableData:(CDVInvokedUrlCommand *)command;

- (void) updateTableData:(CDVInvokedUrlCommand *)command;

- (void) deleteTableData:(CDVInvokedUrlCommand *)command;

- (void) queryAllTableData:(CDVInvokedUrlCommand *)command;

- (void) queryTableDataByConditions:(CDVInvokedUrlCommand *)command;

- (void) fuzzyQueryTableDataByConditions:(CDVInvokedUrlCommand *)command;

- (void) updateORInsertTableDataByConditions:(CDVInvokedUrlCommand *)command;

- (void) queryTableDataUseSql:(CDVInvokedUrlCommand *)command;

- (void) queryAppIDByAppName:(CDVInvokedUrlCommand *)command;

- (void) executeUpdateSql:(CDVInvokedUrlCommand *)command;
@end
