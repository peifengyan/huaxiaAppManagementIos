//
//  TableStructurePlugin.m
//  CordovaLibTest
//
//  Created by Elvis_J_Chan on 14/8/19.
//
//

#import "TableStructurePlugin.h"

@implementation TableStructurePlugin
/*SQLite数据库的基本数据类型：
 
 整数数据类型：
 
 （1）integer  ：整形数据，大小为4个字节
 
 （2）bigint     : 整形数据，大小为8个字节
 
 （3）smallint：整形数据，大小为2个字节
 
 （4）tinyint ：从0到255的整形数据，存储大小为1字节
 
 浮点数数据类型：
 
 （1）float：4字节浮点数
 
 （2）double： 8字节浮点数
 
 （3）real： 8字节浮点数
 
 字符型数据类型：
 
 （1）char(n)n长度的字串，n不能超过254
 
 （2）varchar(n)长度不固定且其长度为n的字串，n不能超过4000
 
 （3）text text存储可变长度的非unicode数据，存放比varchar更大的字符串
 
 注意事项：
 
 （1） 尽量用varchar
 
 （1） 超过255字节的只能用varchar或text
 
 （1） 能用varchar的地方不用text
 
 sqlite字符串区别：
 
 1.char存储定长数据很方便，char字段上的索引效率极高，比如定义char(10),那么不论你存储的数据是否达到了10个字节，都要占去10个字节的空间，不足的自动用空格填充。2.varchar存储变长数据，但存储效率没有char高，如果一个字段可能的值是不固定长度的，我们只知道它不可能超过10个 >字符，把它定义为varchar（10）是最合算的，varchar类型的实际长度是它的值的实际长度+1.为什么+1呢？这个字节用于保存实际使用了多大的长度。因此，从空间上考虑，用varchar合适，从效率上考虑，用char合适，关键是根据情况找到权衡点
 
 3.TEXT存储可变长度的非Unicode数据，最大长度为2^31-1（2147483647）个字符。
 
 
 日期类型：
 
 date:包含了 年份，月份，日期
 
 time：包含了小时，分钟，秒
 
 datetime：包含了年，月，日，时，分，秒
 
 timestamp：包含了年，月，日，时，分，秒，千分之一秒
 
 注意：datetime 包含日期时间格式，必须写成‘2010-08-05’不能写为‘2010-8-5’，否则在读取时会产生错误。
 
 其他类型：
 
 null：空值。
 
 blob ：二进制对象，主要用来存放图片和声音文件等
 
 default：缺省值
 
 primary key：主键值
 
 autoincrement：主键自动增长
 
 
 什么是主键
 
 （1）primary key， 主键就是一个表中，有一个字段，里面的内容不可以重复
 
 （2）一般一个表都需要设置一个主键
 
 （3）autoincrement这样让主键自动增长
 
 注意事项：
 
 所有字符串必须要加‘ ’单引号
 
 整数和浮点数不用加‘ ’
 
 日期需要加单引号‘ ’
 
 字段顺序没有关系，关键是key与value要对应
 
 对于自动增长的主键不需要插入字段*/
- (void) insertTableStructure:(CDVInvokedUrlCommand *)command {
    
    NSDictionary *dict = [command.arguments objectAtIndex:0];
    NSString *tableName = [dict objectForKey:@"tableName"];
    NSArray *keys = [dict objectForKey:@"keys"];
    
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < [keys count]; i++) {
        
        BOOL res = [[JFDataBase shareDataBaseWithDBName:@""] insertTable:tableName key:[[keys objectAtIndex:i] objectForKey:@"key"] type:[[keys objectAtIndex:i] objectForKey:@"type"] defaultValue:[[keys objectAtIndex:i] objectForKey:@"defaultValue"]];

        if (res) {
            
            NSLog(@"添加表字段: %@ 成功",tableName);
            [result addObject:@"1"];
        }
        else {
            
            NSLog(@"添加表字段:  %@ 失败",tableName);
            [result addObject:@"0"];
        }
    }
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:result] callbackId:command.callbackId];
}
- (void) updateTableStructure:(CDVInvokedUrlCommand *)command {
    
//    var json = {"tableName": "conversation_info",
//        "replacekeys": [{"original": "icic","new":"ic"},{"original": "b","new":"b1"},{"original": "c","new":"c1"}],
//    };
    
    NSString *tableName = [[command.arguments objectAtIndex:0] objectForKey:@"tableName"];
    NSArray *replacekeys = [[command.arguments objectAtIndex:0] objectForKey:@"replacekeys"];
    
    NSArray *tableAllKeys = [[JFDataBase shareDataBaseWithDBName:@""] getAllColumnNameWithTable:tableName];
    
    NSMutableArray *tableNewAllKeys = [[NSMutableArray alloc] initWithCapacity:0];
    tableNewAllKeys = [tableAllKeys mutableCopy];
    
    for (int i = 0; i < [replacekeys count]; i++) {
        
        NSString *replaceKey = [[replacekeys objectAtIndex:i] objectForKey:@"original"];
        NSString *replaceNewKey = [[replacekeys objectAtIndex:i] objectForKey:@"new"];

        for (int j = 0; j < [tableAllKeys count]; j++) {
            
            NSString *tableKey = [[tableAllKeys objectAtIndex:j] objectForKey:@"name"];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[tableNewAllKeys objectAtIndex:j]];
            
            if ([replaceKey isEqualToString:tableKey]) {
                
                [dict setObject:replaceNewKey forKey:@"name"];
                [tableNewAllKeys replaceObjectAtIndex:j withObject:dict];
            }
        }
    }
    
    NSString *newKeys = [[NSString alloc] init];
    NSString *originalKeys = [[NSString alloc] init];
    
    for (int i = 0; i < [tableAllKeys count]; i++) {
        
        NSString *name = [[tableNewAllKeys objectAtIndex:i] objectForKey:@"name"];
        NSString *type = [[tableNewAllKeys objectAtIndex:i] objectForKey:@"type"];
        NSString *pk = [[tableNewAllKeys objectAtIndex:i] objectForKey:@"pk"];
        
        NSString *originalName = [[tableAllKeys objectAtIndex:i] objectForKey:@"name"];
        
        if ([pk intValue] != 0) {
            
            newKeys = [newKeys stringByAppendingFormat:@", %@ %@ primary key",name,type];
        }
        else {
            
            newKeys = [newKeys stringByAppendingFormat:@", %@ %@",name,type];
        }
        
        originalKeys = [originalKeys stringByAppendingFormat:@", %@",originalName];
    }
    newKeys = [newKeys substringFromIndex:1];
    originalKeys = [originalKeys substringFromIndex:1];
    
    BOOL res = [[JFDataBase shareDataBaseWithDBName:@""] replaceTable:tableName newKeys:newKeys originalkeys:originalKeys];
    
    CDVPluginResult* pluginResult = nil;
    if (res) {
        
        NSLog(@"更新表字段: %@ 成功",tableName);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"]; //成功回调
        
    }
    else {
        
        NSLog(@"更新表字段: %@ 失败",tableName);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"0"]; //失败回调
        
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) deleteTableStructure:(CDVInvokedUrlCommand *)command {
    
    NSMutableArray *deleteKeys = [[command.arguments objectAtIndex:0] objectForKey:@"keys"];
    
    NSString *tableName = [[command.arguments objectAtIndex:0] objectForKey:@"tableName"];
    NSMutableArray *tableAllKeys = [[[JFDataBase shareDataBaseWithDBName:@""] getAllColumnNameWithTable:tableName] mutableCopy];
    
    for (int i = 0; i < [deleteKeys count]; i++) {
        
        NSString *deleteKey = [deleteKeys objectAtIndex:i];
        for (int j = 0; j < [tableAllKeys count]; j++) {
            
            NSString *tableKey = [[tableAllKeys objectAtIndex:j] objectForKey:@"name"];
            if ([deleteKey isEqualToString:tableKey]) {
                
                [tableAllKeys removeObject:[tableAllKeys objectAtIndex:j]];
            }
        }
    }
    
    NSString *newKeys = [[NSString alloc] init];
    NSString *originalKeys = [[NSString alloc] init];

    for (int i = 0; i < [tableAllKeys count]; i++) {
        
        NSString *name = [[tableAllKeys objectAtIndex:i] objectForKey:@"name"];
        NSString *type = [[tableAllKeys objectAtIndex:i] objectForKey:@"type"];
        NSString *pk = [[tableAllKeys objectAtIndex:i] objectForKey:@"pk"];
        
        if ([pk intValue] != 0) {
            
            newKeys = [newKeys stringByAppendingFormat:@", %@ %@ primary key",name,type];
        }
        else {
            
            newKeys = [newKeys stringByAppendingFormat:@", %@ %@",name,type];
        }
        
        originalKeys = [originalKeys stringByAppendingFormat:@", %@",name];
    }
    newKeys = [newKeys substringFromIndex:1];
    originalKeys = [originalKeys substringFromIndex:1];
    
    BOOL res = [[JFDataBase shareDataBaseWithDBName:@""] replaceTable:tableName newKeys:newKeys originalkeys:originalKeys];
    
    CDVPluginResult* pluginResult = nil;
    if (res) {
        
        NSLog(@"删除表字段: %@ 成功",deleteKeys);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"]; //成功回调
        
    }
    else {
        
        NSLog(@"删除表: %@ 失败",deleteKeys);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"0"]; //失败回调
        
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}
- (void) queryTableStructure:(CDVInvokedUrlCommand *)command {
    
    NSString *tableName = [[command.arguments objectAtIndex:0] objectForKey:@"tableName"];
    NSArray *array = [[JFDataBase shareDataBaseWithDBName:@""] getAllColumnNameWithTable:tableName];
    
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < [array count]; i ++) {
        
        [newArray addObject:[[array objectAtIndex:i] objectForKey:@"name"]];
    }
    
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:newArray] callbackId:command.callbackId];
}
@end
