//
//  GlobalVariables.m
//  候鸟
//
//  Created by Elvis_J_Chan on 14-5-18.
//  Copyright (c) 2014年 MU. All rights reserved.
//

#import "GlobalVariables.h"
#import "DesEncryptUtil.h"

static GlobalVariables *gv = nil;

@implementation GlobalVariables
@synthesize currentUser,currentController;

+ (GlobalVariables *) getGlobalVariables {
    
    static dispatch_once_t t;
    dispatch_once(&t, ^{
        
        gv = [[GlobalVariables alloc] init];
        
    });
    return gv;
}

- (NSString *) getStringFormTableForKey:(NSString *)key {
    
//    NSLog(@"%@--%@",key,NSLocalizedStringFromTable(key, @"InfoPlist", nil));
    return NSLocalizedStringFromTable(key, @"InfoPlist", nil);
}

- (NSUInteger) checkLogOut {
    
    NSDate *date = [NSDate date];
    long long unsigned int timeIntervalNow = [date timeIntervalSince1970];
    
    NSArray *userArray = [[JFDataBase shareDataBaseWithDBName:kUserDatabaseName] queryTable:kCurrentUserTableName queryByConditions:nil sortByKey:nil sortType:nil];
    
    long long unsigned int serviceLoginTime = 0;
    long long unsigned int localLoginTime = 0;
    NSUInteger status = 0;
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    NSInteger returnInt = 0;

    if ([userArray count] != 0) {
        
        userInfo = [[userArray objectAtIndex:0] mutableCopy];
        serviceLoginTime = [[userInfo objectForKey:@"serviceLoginTime"] longLongValue] / 1000;
        localLoginTime = [[userInfo objectForKey:@"localLoginTime"] longLongValue] / 1000;
        status = [[userInfo objectForKey:@"status"] integerValue];
        
        //12小时未登录 验证(服务器/本地)登陆 时间间隔
        NSTimeInterval intervalTimerToLogin = 60 * 60 * 12;
        //30天使用离线登录 修改数据库,验证服务器登陆 时间间隔
        NSTimeInterval intervalTimerChangeDatabase = 60 * 60 * 24 * 30;
        
        long long unsigned int biggerLoginTime = (serviceLoginTime > localLoginTime ? serviceLoginTime : localLoginTime);
        
        if (timeIntervalNow > serviceLoginTime + intervalTimerChangeDatabase) {
            
            NSLog(@"30天过期");
            status = 1;
            [userInfo setObject:[NSString stringWithFormat:@"%d",status] forKey:@"status"];
            [[JFDataBase shareDataBaseWithDBName:kUserDatabaseName] queryTable:kCurrentUserTableName ifExistsWithConditions:@{@"id": [userInfo objectForKey:@"id"]} withNewObject:userInfo];
            returnInt = 2;
        }
        if (timeIntervalNow > biggerLoginTime + intervalTimerToLogin) {
            
            NSLog(@"服务器时间12小时过期");
            returnInt = 1;            
        }
    }
    else {
        
        NSLog(@"第一次登陆/数据库无查询数据");
        returnInt = 0;
    }
    MLog(@"%d",returnInt);
    return returnInt;
}

- (NSTimeInterval) setLoginTime {
    
    NSDate *date = [NSDate date];
    NSTimeInterval timeIntervalNow = [date timeIntervalSince1970];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:timeIntervalNow] forKey:@"loginTimeInterval"];
    return timeIntervalNow;
}

- (void) setCurrentLoginUser {
    
    NSString *maxServiceSql = [NSString stringWithFormat:@"select max(%@) from %@",kUserServiceLoginTime,kCurrentUserTableName];
    NSString *maxLocalSql = [NSString stringWithFormat:@"select max(%@) from %@",kUserLocalLoginTime,kCurrentUserTableName];

    NSArray *maxServiceArray = [[JFDataBase shareDataBaseWithDBName:kUserDatabaseName] queryTableWithSql:maxServiceSql];
    NSArray *maxLocalArray = [[JFDataBase shareDataBaseWithDBName:kUserDatabaseName] queryTableWithSql:maxLocalSql];

    if (![[[maxServiceArray objectAtIndex:0] objectForKey:@"max(serviceLoginTime)"] isKindOfClass:[NSNull class]] || ![[[maxLocalArray objectAtIndex:0] objectForKey:@"max(localLoginTime)"] isKindOfClass:[NSNull class]]) {
        
        NSString *querySql = [NSString stringWithFormat:@"select * from %@ where %@ = %@",kCurrentUserTableName,kUserServiceLoginTime,[[maxServiceArray objectAtIndex:0] objectForKey:@"max(serviceLoginTime)"]];
        
        if ([[[maxServiceArray objectAtIndex:0] objectForKey:kUserServiceLoginTime] longLongValue] < [[[maxLocalArray objectAtIndex:0] objectForKey:kUserLocalLoginTime] longLongValue]) {
            
            querySql = [NSString stringWithFormat:@"select * from %@ where %@ = %@",kCurrentUserTableName,kUserLocalLoginTime,[[maxServiceArray objectAtIndex:0] objectForKey:@"max(localLoginTime)"]];
        }
        NSArray *resultArray = [[JFDataBase shareDataBaseWithDBName:kUserDatabaseName] queryTableWithSql:querySql];
        NSMutableDictionary *user = [[NSMutableDictionary alloc] initWithCapacity:0];
        if ([resultArray count] != 0) {
            
            user = [resultArray objectAtIndex:0];
            NSString *agentCode = [user objectForKey:kUserAgentCode];
            NSString *pwd = [user objectForKey:kUserPassword];
            
            if (agentCode.length != 0) {
                
                agentCode = [DesEncryptUtil encryptUseDES:agentCode];
                agentCode = [agentCode stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                agentCode = [agentCode stringByReplacingOccurrencesOfString:@" " withString:@""];
            }
            if (pwd.length != 0) {
                
                NSString *md5 = [DesEncryptUtil md5DigestString:pwd];
                pwd = [[DesEncryptUtil encryptUseDES:[md5 uppercaseStringWithLocale:[NSLocale currentLocale]]] mutableCopy];
                pwd = [pwd stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                pwd = [pwd stringByReplacingOccurrencesOfString:@" " withString:@""];
            }
            [[NSUserDefaults standardUserDefaults] setObject:agentCode forKey:@"agentCode"];
            [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:@"password"];
        }
    }
}
@end
