//
//  JFDataBase.m
//  DataBaseTest
//
//  Created by Elvis_J_Chan on 14/6/6.
//  Copyright (c) 2014年 Elvis_J_Chan. All rights reserved.
//

#import "JFDataBase.h"

#import "MBProgressHUD.h"

@interface JFDataBase () <MBProgressHUDDelegate> {
    
    MBProgressHUD *HUD;
    
}
@end
//数据库名
#define DataBaseName @"MyDatabase.db"
//获取数据库路径
#define PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:DataBaseName]

JFDataBase *dataBase = nil;
@implementation JFDataBase

+ (JFDataBase *) shareDataBaseWithDBName:(NSString *)databaseName {
    
    NSString *dbPath = PATH;
    //数据库名
    if (databaseName != nil && databaseName.length != 0) {
        
        if ([databaseName hasSuffix:@".db"] || [databaseName hasSuffix:@".sqlite"]) {
            dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:databaseName];
        }
        else {
            dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",databaseName]];
        }
    }
    
    dataBase = [[JFDataBase alloc] initWithPath:dbPath];
//    MLog(@"%@",dbPath);
    BOOL res;
    res = [dataBase open];
    if (res == NO) {
        
        NSLog(@"数据库 %@ 打开失败",databaseName);
    }
    else {
        NSLog(@"数据库 %@ 打开成功",databaseName);
    }
    return dataBase;
}
- (BOOL) insertTable:(NSString *)tableName key:(NSString *)key type:(NSString *)keyType defaultValue:(NSString *)defaultValue {
    
    if (keyType.length == 0 || keyType == nil) {
        
        keyType = @"VARCHAR(100)";
    }
    if (defaultValue.length == 0 || defaultValue == nil) {
        
        defaultValue = @"\"\"";
    }
    
    NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@ DEFAULT %@",tableName,key,keyType,defaultValue];
    BOOL res;
    res = [dataBase executeUpdate:sql];
    if (res == NO) {
        
        NSLog(@"创建Sql表失败，SQL:%@",sql);
        return NO;
    }
    else {
        NSLog(@"创建 Sql:%@ 成功",sql);
    }
    return res;
}
- (BOOL) replaceTable:(NSString *)tableName newKeys:(NSString *)newKeys originalkeys:(NSString *)originalkeys {
    
    
    NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO __temp__%@",tableName,tableName];
    NSString *sql1 = [NSString stringWithFormat:@"CREATE TABLE %@ (%@);",tableName,newKeys];
    NSString *sql2 = [NSString stringWithFormat:@"INSERT INTO %@ SELECT %@ FROM __temp__%@;",tableName,originalkeys,tableName];
    NSString *sql3 = [NSString stringWithFormat:@"DROP TABLE __temp__%@;",tableName];
    
    BOOL res = [dataBase executeUpdate:sql];
    if (res) {
            
        NSLog(@"创建临时表 SQL: %@ 成功",sql);
        res = [dataBase executeUpdate:sql1];
        if (res) {
                
            NSLog(@"创建新表 SQL: %@ 成功",sql1);
            res = [dataBase executeUpdate:sql2];
            if (res) {
                    
                NSLog(@"更新新表 SQL: %@ 成功",sql2);
                res = [dataBase executeUpdate:sql3];
                if (res) {
                        
                    NSLog(@"删除临时表 SQL: %@ 成功",sql3);
                }
                else {
                        
                    NSLog(@"删除临时表 SQL: %@ 失败",sql3);
                }
            }
            else {
                    
                NSLog(@"更新新表 SQL: %@ 失败",sql2);
            }
        }
        else {
                
            NSLog(@"创建新表 SQL: %@ 失败",sql1);
        }
    }
    else {
            
        NSLog(@"创建临时表 SQL: %@ 失败",sql);
    }

    return res;

}
#pragma mark - create TableWithSql
/**
 *	@brief      根据SQL语句创建表单
 *
 *	@param      sql 创建表单sql语句
 *
 *	@return     创建结果 BOOL值 (YES:创建成功 NO:创建失败)
 */
- (BOOL) createTableWithSql:(NSString *)sql {
    
    BOOL res;
    res = [dataBase executeUpdate:sql];
    
    NSArray *a = [sql componentsSeparatedByString:@" ("];
    NSArray *new = [[a objectAtIndex:0] componentsSeparatedByString:@" "];
    
    if (res == NO) {
        
        NSLog(@"创建数据表: %@ 失败",[new lastObject]);
        return NO;
    }
    else {
        NSLog(@"创建数据表: %@ 成功",[new lastObject]);
    }
    return res;
}

#pragma mark - insert Table
/**
 *	@brief  根据表单名字插入数据
 *
 *	@param  tableName 执行插入表单的表单名
 *	@param  dictionary 执行插入表单的内容，是一个NSDictionary对象（dictionary中的keys要与表单字段名保持一致）
 *
 *	@return  创建结果 BOOL值 (YES:插入成功 NO:插入失败)
 */
- (BOOL) insertTable:(NSString *)tableName withObjectDictionary:(NSDictionary *)dictionary {
    
    NSMutableDictionary *object = [dictionary mutableCopy]; //转化为可变数组
    NSString *keys = [[NSString alloc] init];
    NSString *values = [[NSString alloc] init];
    NSArray *keyArray = [object allKeys];
    
    for (int i = 0; i < [keyArray count]; i ++) {
        
        NSString *key = [NSString stringWithFormat:@"\"%@\"",[keyArray objectAtIndex:i]];
        NSString *value = [NSString stringWithFormat:@"'%@'",[object objectForKey:[keyArray objectAtIndex:i]]];
        
        if (i == 0) {
            
            keys = key;
            values = value;
        }
        else {
            
            keys = [keys stringByAppendingFormat:@", %@",key];
            values = [values stringByAppendingFormat:@", %@",value];
        }
    }
    //插入SQL语句
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@) values (%@)",tableName,keys,values];
    
    BOOL res;
    res = [dataBase executeUpdate:sql];
    if (res == NO) {
        
        NSLog(@"数据插入 %@ 失败",tableName);
        return NO;
    }
    else {
        
        NSLog(@"数据插入 %@ 成功",tableName);
    }
    return res;
}

#pragma mark - update Table
/**
 *	@brief  根据表单字段的某些字段更新数据
 *
 *	@param  tableName 执行插入表单的表单名
 *	@param  conditions 执行更新表单的条件（可为多条件，conditions中的keys要与表单字段名字相同）
 *	@param  dictionary 执行更新表单的内容，是一个NSDictionary对象（dictionary中的keys要与表单字段名保持一致）
 *
 *	@return  更新结果 BOOL值 (YES:更新成功 NO:更新失败)
 */
- (BOOL) updateTable:(NSString *)tableName updateByConditions:(NSDictionary *)conditions withObjectDictionary:(NSDictionary *)dictionary {
    
    NSLog(@"数据存在 执行修改");
    NSString *updateString = [[NSString alloc] init];
    NSArray *keyArray = [dictionary allKeys];
    //设置更新全部内容
    for (int i = 0; i < [keyArray count]; i ++) {
        NSString *key = [keyArray objectAtIndex:i];
        NSString *value = [dictionary objectForKey:key];
        
        NSString *newStr = [NSString stringWithFormat:@"\"%@\" = '%@'",key,value];
        if (i == 0) {
            
            updateString = newStr;
        }
        else {
            
            updateString = [updateString stringByAppendingFormat:@", %@",newStr];
        }
    }
    //设置更新条件
    NSString *conditionsString = [[NSString alloc] init];
    NSArray *conditionsKeyArray = [conditions allKeys];
    if (conditionsKeyArray.count != 0) {
        
        for (int i = 0; i < [conditionsKeyArray count]; i ++) {
            
            NSString *key = [conditionsKeyArray objectAtIndex:i];
            NSString *value = [conditions objectForKey:key];
            
            NSString *newStr = [NSString stringWithFormat:@"\"%@\" = '%@'",key,value];
            
            if (i == 0) {
                
                conditionsString = newStr;
            }
            else {
                
                conditionsString = [conditionsString stringByAppendingFormat:@" and %@",newStr];
            }
        }
    }
    else {
        
        conditionsString = @"'1' = '1'";
    }
    //更新语句
    NSString *sqlString = [NSString stringWithFormat:
                        @"update %@ set %@ where %@",
                        tableName,updateString,
                        conditionsString];
    BOOL res;
    res = [dataBase executeUpdate:sqlString];
    if (res == NO) {
        
        NSLog(@"%@ 数据 %@ 更新失败",tableName,conditionsString);
        return NO;
    }
    else {
        
        NSLog(@"%@ 数据 %@ 更新成功",tableName,conditionsString);
        return YES;
    }
}

#pragma mark - delete Table
/**
 *	@brief  根据dictionary内容针对某一table进行条件删除
 *
 *	@param  tableName 执行删除表单的表单名
 *	@param  dictionary 执行删除表单的条件，是一个NSDictionary对象（可为多条件，dictionary中的keys要与表单字段名保持一致）
 *
 *	@return  删除结果 BOOL值 (YES:删除成功 NO:删除失败)
 */
- (BOOL) deleteTable:(NSString *)tableName deleteByConditions:(NSDictionary *)conditions {
    
    NSString *conditionsString = [[NSString alloc] init];
    NSArray *keyArray = [conditions allKeys];
    for (int i = 0; i < [keyArray count]; i ++) {
        
        NSString *key = [keyArray objectAtIndex:i];
        NSString *value = [conditions objectForKey:key];
        
        NSString *newStr = [NSString stringWithFormat:@"\"%@\" = '%@'",key,value];
        
        if (i == 0) {
            
            conditionsString = newStr;
        }
        else {
            
            conditionsString = [conditionsString stringByAppendingFormat:@" and %@",newStr];
        }
    }
    NSString *sqlString = [NSString stringWithFormat:@"delete from %@ where %@", tableName,conditionsString];
    BOOL res;
    res = [dataBase executeUpdate:sqlString];
    if (res == NO) {
        
        NSLog(@"%@ 数据删除失败",tableName);
        return NO;
    }
    else {
        
        NSLog(@"%@ 数据删除成功",tableName);
        return YES;
    }
}

#pragma mark - query Table
/**
 *	@brief  根据sql语句查询某个表单数据
 *
 *	@param  sql 执行查询表单的sql语句
 *
 *	@return  返回内部为NSDictionary的NSArray对象
 */
- (NSArray *) queryTableWithSql:(NSString *)sql {
    
    FMResultSet *rs = [dataBase executeQuery:sql];
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        
        [array addObject:[rs resultDictionary]];
    }
    return array;
}

/**
 *	@brief  根据条件查询某个表单数据
 *
 *	@param  tableName 执行查询表单的表单名
 *	@param  conditions 执行查询表单的条件，是一个NSDictionary对象（可为多条件，dictionary中的keys要与表单字段名保持一致）
 *
 *	@return  返回内部为NSDictionary的NSArray对象
 */
- (NSArray *) queryTable:(NSString *)tableName queryByConditions:(NSDictionary *)conditions  sortByKey:(NSString *) sortKey sortType:(NSString *) sortType {
    
    NSString *conditionsString = [[NSString alloc] init];
    NSMutableArray *keyArray = [[NSMutableArray alloc] initWithCapacity:0];
    if ([conditions count] != 0) {
        //查询条件不为空
        keyArray = (NSMutableArray *)[conditions allKeys];
        for (int i = 0; i < [keyArray count]; i ++) {
            
            NSString *key = [keyArray objectAtIndex:i];
            NSString *value = [conditions objectForKey:key];
            //单一查询条件
            NSString *newStr = [NSString stringWithFormat:@"\"%@\" = '%@'",key,value];
            
            if (i == 0) {
                
                conditionsString = newStr;
            }
            else {
                
                conditionsString = [conditionsString stringByAppendingFormat:@" and %@",newStr];
            }
        }
        conditionsString = [NSString stringWithFormat:@" where %@",conditionsString];
    }
    
    if (sortKey.length != 0 && sortType.length != 0) {
        
        NSString *orderBy = [NSString stringWithFormat:@" order by \"%@\" %@",sortKey,sortType];
        conditionsString = [conditionsString stringByAppendingString:orderBy];
    }
    
    NSString *sqlString = [NSString stringWithFormat:@"select * from %@%@",tableName,conditionsString];
    FMResultSet *rs = [dataBase executeQuery:sqlString];
    NSMutableArray *returnArray = [NSMutableArray array];
    while ([rs next]) {
        
        [returnArray addObject:[rs resultDictionary]];
    }
    return returnArray;
}

/**
 *	@brief  根据条件查询模糊表单数据
 *
 *	@param  tableName 执行模糊查询表单的表单名
 *	@param  conditions 执行查询表单的条件，是一个NSDictionary对象（可为多条件，dictionary中的keys要与表单字段名保持一致）
 *	@param  conditions OR/AND
 *
 *	@return  返回内部为NSDictionary的NSArray对象
 */
- (NSArray *) fuzzyQueryTable:(NSString *)tableName queryByDataConditions:(NSDictionary *)conditions fuzzyConditions:(NSString *)fuzzyConditions sortByKey:(NSString *) sortKey sortType:(NSString *) sortType {
//    Select * from T_OCCUPATION where OCCUPATION_CODE like "%60%" or OCCUPATION_NAME like "%员%"
    NSString *conditionsString = [[NSString alloc] init];
    NSMutableArray *keyArray = [[NSMutableArray alloc] initWithCapacity:0];
    if ([conditions count] != 0) {
        keyArray = (NSMutableArray *)[conditions allKeys];
        for (int i = 0; i < [keyArray count]; i ++) {
            
            NSString *key = [keyArray objectAtIndex:i];
            NSString *value = [conditions objectForKey:key];
            NSString *percentString = @"%";
            NSString *newStr = [NSString stringWithFormat:@"\"%@\" like '%@%@%@'",key,percentString,value,percentString];
            
            if (i == 0) {
                
                conditionsString = newStr;
            }
            else {
                
                conditionsString = [conditionsString stringByAppendingFormat:@" %@ %@",fuzzyConditions,newStr];
            }
        }
        conditionsString = [NSString stringWithFormat:@" where %@",conditionsString];
    }
    if (sortKey.length != 0 && sortType.length != 0) {
        
        NSString *orderBy = [NSString stringWithFormat:@" order by \"%@\" %@",sortKey,sortType];
        conditionsString = [conditionsString stringByAppendingString:orderBy];
    }
    
    NSString *sqlString = [NSString stringWithFormat:@"select * from %@%@",tableName,conditionsString];
    FMResultSet *rs = [dataBase executeQuery:sqlString];
    NSMutableArray *returnArray = [NSMutableArray array];
    while ([rs next]) {
        
        [returnArray addObject:[rs resultDictionary]];
    }
    return returnArray;
}

/**
 *	@brief  判断某个表内是否存在某些字段，如果存在执行更新，如果不存在，执行插入
 *
 *	@param  tableName 执行更新/插入表单的表单名
 *	@param  conditions 执行更新/插入表单的查询的条件（可为多条件，dictionary中的keys要与表单字段名保持一致）
 *	@param  object 执行更新/插入表单的NSDictionary对象
 *
 *	@return 更新/插入结果 BOOL值 (YES:更新/插入成功 NO:更新/插入失败)
 */
- (BOOL) queryTable:(NSString *)tableName ifExistsWithConditions:(NSDictionary *)conditions withNewObject:(NSDictionary *)object {
    
    //设置更新条件
    NSString *conditionsString = [[NSString alloc] init];
    NSArray *conditionsKeyArray = [conditions allKeys];
    for (int i = 0; i < [conditionsKeyArray count]; i ++) {
        
        NSString *key = [conditionsKeyArray objectAtIndex:i];
        NSString *value = [conditions objectForKey:key];
        
        NSString *newStr = [NSString stringWithFormat:@"\"%@\" = '%@'",key,value];
        
        if (i == 0) {
            
            conditionsString = newStr;
        }
        else {
            
            conditionsString = [conditionsString stringByAppendingFormat:@" and %@",newStr];
        }
    }
    
    NSString *sqlString = [NSString stringWithFormat:@"select * from %@ where %@",tableName,conditionsString];
    FMResultSet *rs = [dataBase executeQuery:sqlString];
    BOOL res;
    
    if([rs next]) {
        
        res = [self updateTable:tableName updateByConditions:conditions withObjectDictionary:object];
        return res;
    }
    else {
        
        res = [self insertTable:tableName withObjectDictionary:object];
        return res;
    }
    return res;
}

/**
 *	@brief  获取某一表单最后某一条数据对应的值
 *
 *	@param  tableName 执行查询表单的名字
 *	@param  key 执行查询表单后获取某一值的字段
 *
 *	@return  返回为id的值
 */
- (NSArray *) getAllColumnNameWithTable:(NSString *)tableName {
    
    FMResultSet *columnNamesSet = [dataBase executeQuery:[NSString stringWithFormat:@"PRAGMA table_info(%@)", tableName]];
    NSMutableArray* columnNames = [[NSMutableArray alloc] init];
    while ([columnNamesSet next]) {
        
        [columnNames addObject:[columnNamesSet resultDictionary]];
        
    }
    return columnNames;
}
- (NSString *) returnSqlInsertTable:(NSString *)tableName withObjectDictionary:(NSDictionary *)dictionary {
    
    NSMutableDictionary *object = [dictionary mutableCopy]; //转化为可变数组
    NSString *keys = [[NSString alloc] init];
    NSString *values = [[NSString alloc] init];
    NSArray *keyArray = [object allKeys];
    
    for (int i = 0; i < [keyArray count]; i ++) {
        
        NSString *key = [NSString stringWithFormat:@"\"%@\"",[keyArray objectAtIndex:i]];
        NSString *value = [NSString stringWithFormat:@"'%@'",[object objectForKey:[keyArray objectAtIndex:i]]];
        
        if (i == 0) {
            
            keys = key;
            values = value;
        }
        else {
            
            keys = [keys stringByAppendingFormat:@", %@",key];
            values = [values stringByAppendingFormat:@", %@",value];
        }
    }
    //插入SQL语句
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@) values (%@)",tableName,keys,values];
    return sql;
}
#pragma mark - create User Table
- (BOOL) createAppTable {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"APPINFOSUCCEED"]) {
        
        BOOL result = [self createTableWithSql:kAppInfoSqlString];
        if (result) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"APPINFOSUCCEED"];
        }
        return result;
    }
    return NO;
}
- (BOOL) createMenuTable {
    
    return [self createTableWithSql:CREATE_MENU_INFO];
}
- (BOOL) createProductTable {
    
    return [self createTableWithSql:CREATE_PRODUCT_INFO];
}
- (BOOL) createProductTypeTable {
    
    return [self createTableWithSql:CREATE_PRODUCT_TYPE_INFO];
}
- (BOOL) createSessionTable {
    
    return [self createTableWithSql:CREATE_SESSION_INFO];
}
- (BOOL) createChatTable {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"MESSAGESUCCEED"]) {
        
        BOOL result = [self createTableWithSql:kMessageSqlString];
        if (result) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MESSAGESUCCEED"];
        }
        return result;
    }
    return NO;
}
- (BOOL) createUserTable {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"USERSUCCEED"]) {
        
        BOOL result = [self createTableWithSql:kCurrentUserSqlString];
        if (result) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"USERSUCCEED"];
        }
        return result;
    }
    return NO;
}
- (BOOL) createWeatherTable {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"WEATHERSUCCEED"]) {
        
        BOOL result = [self createTableWithSql:kWeatherSqlString];
        if (result) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WEATHERSUCCEED"];
        }
        return result;
    }
    return NO;
}

NSUInteger indexNow;
NSUInteger indexMax;

- (BOOL) syncInsertData:(NSArray *) data {
    
    BOOL result = NO;
    [dataBase open];
    
    [dataBase beginTransaction];
    BOOL isRollBack = NO;
    indexNow = 0;
    indexMax = [data count];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        HUD = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
        [[[UIApplication sharedApplication] keyWindow] addSubview:HUD];
        HUD.mode = MBProgressHUDModeAnnularDeterminate;
        HUD.delegate = self;
        HUD.labelText = @"初始化数据";
        [HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
        
    });
    @try {
        
        indexNow = 0;
        for (int i = 0; i < [data count]; i++) {
            
            indexNow = i;
            NSString *sql = [data objectAtIndex:i];
            BOOL a = [dataBase executeUpdate:sql];
            if (!a) {
                NSLog(@"初始化数据失败");
            }
        }
    }
    @catch (NSException *exception) {
        isRollBack = YES;
        [dataBase rollback];
    }
    @finally {
        if (!isRollBack) {
            BOOL res = [dataBase commit];
            result = res;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (res) {
                    
                    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                    HUD.mode = MBProgressHUDModeCustomView;
                    HUD.labelText = @"初始化成功";
                    [HUD hide:YES];
                }
                else {
                    
                    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                    HUD.mode = MBProgressHUDModeCustomView;
                    HUD.labelText = @"初始化失败";
                    [HUD hide:YES];
                }
            });
        }
    }
    return result;
}

- (void)myProgressTask {
	// This just increases the progress indicator in a loop
	float progress = 0.0f;
	while (progress < 1.0f) {
		progress = (float)indexNow/indexMax;
		HUD.progress = progress;
		usleep(50000);
	}
}
@end
