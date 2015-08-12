//
//  JFDataBase.h
//  DataBaseTest
//
//  Created by Elvis_J_Chan on 14/6/6.
//  Copyright (c) 2014年 Elvis_J_Chan. All rights reserved.
//

#import "FMDatabase.h"

#define PRODUCT_TYPE_INFO       @"product_type"
#define PRODUCT_INFO            @"product_info"
#define SESSION_INFO            @"session_info"
#define CHAT_INFO                   @"chat_info"
#define MENU_INFO                   @"app_menu"

//创建一个菜单表  应用对应的菜单
#define CREATE_MENU_INFO [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (cmsmanage_id varchar(64) primary key, cmsmanage_title varchar(64), cmsmanage_managetype varchar(64), cmsmanage_node varchar(64), cmsmanage_channel_id varchar(64), cmsmanage_menulevel varchar(64), cmsmanage_value varchar(64), cmsmanage_createtime varchar(64), cmsmanage_updatetime varchar(64))",MENU_INFO]

//产品类型表
#define CREATE_PRODUCT_TYPE_INFO [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (productstype_id varchar(64) primary key, productstype_title varchar(50), productstype_content varchar(50), productstype_icon varchar(50), productstype_photo varchar(50), productstype_channel_id varchar(50), productstype_createtime varchar(50), productstype_updatetime varchar(50))",PRODUCT_TYPE_INFO]

//产品表
#define CREATE_PRODUCT_INFO [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (products_id varchar(64) primary key, products_title varchar(50), products_icon varchar(50), products_photo varchar(50), products_minpremium varchar(50), products_pluspremium varchar(50), products_insured_age varchar(50), products_policyholder_age varchar(50), products_configure_url varchar(50), products_ratedata_url varchar(50), products_introduction varchar(50), products_cases varchar(50), products_recommend varchar(50), products_productstype_id varchar(50), products_number varchar(50), products_createtime varchar(50), products_updatetime varchar(50))",PRODUCT_INFO]

//会话表
#define CREATE_SESSION_INFO [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id varchar(64) primary key, userId1 varchar(64), userId2 varchar(64), updateTime varchar(64))",SESSION_INFO]
//消息表
#define CREATE_CHAT_INFO [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id varchar(64) primary key, content varchar(512), session_id varchar(64), time varchar(64), fromUserId varchar(64), toUserId varchar(64))",CHAT_INFO]


//当前用户表

@interface JFDataBase : FMDatabase

+ (JFDataBase *) shareDataBaseWithDBName:(NSString *)databaseName;
#pragma mark - table operation
#pragma mark creat table
/**
 *	@brief      根据SQL语句创建表单
 *
 *	@param      sql 创建表单sql语句
 *
 *	@return     创建结果 BOOL值 (YES:创建成功 NO:创建失败)
 */
- (BOOL) createTableWithSql:(NSString *)sql;
#pragma mark - table data operation
#pragma mark insert
/**
 *	@brief  根据表单名字插入数据
 *
 *	@param  tableName 执行插入表单的表单名
 *	@param  dictionary 执行插入表单的内容，是一个NSDictionary对象（dictionary中的keys要与表单字段名保持一致）
 *
 *	@return  创建结果 BOOL值 (YES:插入成功 NO:插入失败)
 */
- (BOOL) insertTable:(NSString *)tableName withObjectDictionary:(NSDictionary *)dictionary;
#pragma mark update
/**
 *	@brief  根据表单字段的某些字段更新数据
 *
 *	@param  tableName 执行更新表单的表单名
 *	@param  conditions 执行更新表单的条件（可为多条件，conditions中的keys要与表单字段名字相同）
 *	@param  dictionary 执行更新表单的内容，是一个NSDictionary对象（dictionary中的keys要与表单字段名保持一致）
 *
 *	@return  更新结果 BOOL值 (YES:更新成功 NO:更新失败)
 */
- (BOOL) updateTable:(NSString *)tableName updateByConditions:(NSDictionary *)conditions withObjectDictionary:(NSDictionary *)dictionary;
#pragma mark delete
/**
 *	@brief  根据dictionary内容针对某一table进行条件删除
 *
 *	@param  tableName 执行删除表单的表单名
 *	@param  dictionary 执行删除表单的条件，是一个NSDictionary对象（可为多条件，dictionary中的keys要与表单字段名保持一致）
 *
 *	@return  删除结果 BOOL值 (YES:删除成功 NO:删除失败)
 */
- (BOOL) deleteTable:(NSString *)tableName deleteByConditions:(NSDictionary *)conditions;
#pragma mark query
/**
 *	@brief  根据sql语句查询某个表单数据
 *
 *	@param  sql 执行查询表单的sql语句
 *
 *	@return  返回内部为NSDictionary的NSArray对象
 */
- (NSArray *) queryTableWithSql:(NSString *)sql;
/**
 *	@brief  根据条件查询某个表单数据
 *
 *	@param  tableName 执行查询表单的表单名
 *	@param  conditions 执行查询表单的条件，是一个NSDictionary对象（可为多条件，dictionary中的keys要与表单字段名保持一致）
 *	@param  sortKey 根据sortKey进行排序
 *	@param  sortType 排序方法:desc/asc
 *
 *	@return  返回内部为NSDictionary的NSArray对象
 */
- (NSArray *) queryTable:(NSString *) tableName queryByConditions:(NSDictionary *) conditions sortByKey:(NSString *) sortKey sortType:(NSString *) sortType;

/**
 *	@brief  判断某个表内是否存在某些字段，如果存在执行更新，如果不存在，执行插入
 *
 *	@param  tableName 执行更新/插入表单的表单名
 *	@param  conditions 执行更新/插入表单的查询的条件（可为多条件，dictionary中的keys要与表单字段名保持一致）
 *	@param  object 执行更新/插入表单的NSDictionary对象
 *
 *	@return 更新/插入结果 BOOL值 (YES:更新/插入成功 NO:更新/插入失败)
 */
- (BOOL) queryTable:(NSString *)tableName ifExistsWithConditions:(NSDictionary *)conditions withNewObject:(NSDictionary *)object;

/**
 *	@brief  根据条件查询模糊表单数据
 *
 *	@param  tableName 执行模糊查询表单的表单名
 *	@param  conditions 执行查询表单的条件，是一个NSDictionary对象（可为多条件，dictionary中的keys要与表单字段名保持一致）
 *	@param  conditions OR/AND
 *	@param  sortKey 根据sortKey进行排序
 *	@param  sortType 排序方法:desc/asc
 *
 *	@return  返回内部为NSDictionary的NSArray对象
 */
- (NSArray *) fuzzyQueryTable:(NSString *)tableName queryByDataConditions:(NSDictionary *)conditions fuzzyConditions:(NSString *)fuzzyConditions sortByKey:(NSString *) sortKey sortType:(NSString *) sortType;
#pragma mark - table structure operation
#pragma mark query
/**
 *	@brief  查询某一个表单全部字段
 *
 *	@param  tableName 执行查询表单的表单名
 *
 *	@return 查询结果为一个数组
 */
- (NSArray *) getAllColumnNameWithTable:(NSString *)tableName;
#pragma mark insert
/**
 *	@brief  插入表单字段
 *
 *	@param  tableName 执行插入表单的字段名
 *	@param  key 插入表单的字段名
 *	@param  keyType 插入表单字段的类型
 *	@param  defaultValue 插入表单字段的默认值
 *
 *	@return 插入结果 BOOL值 (YES:插入成功 NO:插入失败)
 */
- (BOOL) insertTable:(NSString *)tableName key:(NSString *)key type:(NSString *)keyType defaultValue:(NSString *)defaultValue;
/**
 *	@brief  批量插入数据
 *
 *	@param  data 插入表单数据SQL语句
 *
 *	@return 插入结果 BOOL值 (YES:插入成功 NO:插入失败)
 */
- (BOOL) syncInsertData:(NSArray *) data ;

#pragma mark update/delete
/**
 *	@brief  修改表单字段
 *
 *	@param  tableName 修改表单的字段名
 *	@param  newKeys 插入表单字段的新字段名
 *	@param  originalkeys 插入表单字段的原字段名
 *
 *	@return 修改结果 BOOL值 (YES:修改成功 NO:修改失败)
 */
- (BOOL) replaceTable:(NSString *)tableName newKeys:(NSString *)newKeys originalkeys:(NSString *)originalkeys;


- (NSString *) returnSqlInsertTable:(NSString *)tableName withObjectDictionary:(NSDictionary *)dictionary;
#pragma mark - current app table
/**
 *	@brief      创建APP_INFO表单
 *
 *	@return     创建结果 BOOL值 (YES:创建成功 NO:创建失败)
 */
- (BOOL) createAppTable;
/**
 *	@brief      创建APP_MENU表单
 *
 *	@return     创建结果 BOOL值 (YES:创建成功 NO:创建失败)
 */
- (BOOL) createMenuTable;
/**
 *	@brief      创建PRODUCT_INFO表单
 *
 *	@return     创建结果 BOOL值 (YES:创建成功 NO:创建失败)
 */
- (BOOL) createProductTable;
/**
 *	@brief      创建PRODUCT_TYPE表单
 *
 *	@return     创建结果 BOOL值 (YES:创建成功 NO:创建失败)
 */
- (BOOL) createProductTypeTable;
/**
 *	@brief      创建SESSION_INFO表单
 *
 *	@return     创建结果 BOOL值 (YES:创建成功 NO:创建失败)
 */
- (BOOL) createSessionTable;
/**
 *	@brief      创建CHAT_INFO表单
 *
 *	@return     创建结果 BOOL值 (YES:创建成功 NO:创建失败)
 */
- (BOOL) createChatTable;
/**
 *	@brief      创建CURRENT_USER_MENU表单
 *
 *	@return     创建结果 BOOL值 (YES:创建成功 NO:创建失败)
 */
- (BOOL) createUserTable;
/**
 *	@brief      创建weather_info表单
 *
 *	@return     创建结果 BOOL值 (YES:创建成功 NO:创建失败)
 */
- (BOOL) createWeatherTable;
@end
