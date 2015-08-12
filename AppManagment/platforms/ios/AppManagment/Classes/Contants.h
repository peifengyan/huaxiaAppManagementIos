//
//  Constants.h
//  候鸟
//
//  Created by Elvis_J_Chan on 14-5-18.
//  Copyright (c) 2014年 MU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contants : NSObject

//接口地址
FOUNDATION_EXPORT NSString * const kHostSite;
//XMPP地址
FOUNDATION_EXPORT NSString * const kXMPPDomain;
FOUNDATION_EXPORT NSString * const kXMPPHost;
FOUNDATION_EXPORT NSString * const kXMPPPort;
//统计主机地址
FOUNDATION_EXPORT NSString * const kStatisticsHost;
//统计SDK AppKey
FOUNDATION_EXPORT NSString * const kStatisticsAppKey;
//
FOUNDATION_EXPORT NSString * const kCheckVerson;
//本地数据库
FOUNDATION_EXPORT NSString * const kUserDatabaseName;
FOUNDATION_EXPORT NSString * const kAppDatabaseName;
FOUNDATION_EXPORT NSString * const kProductDatabaseName;
FOUNDATION_EXPORT NSString * const kChatDatabaseName;
FOUNDATION_EXPORT NSString * const kWeatherDatabaseName;
//用户表
FOUNDATION_EXPORT NSString * const kCurrentUserTableName;
FOUNDATION_EXPORT NSString * const kCurrentUserSqlString;
//消息表
FOUNDATION_EXPORT NSString * const kMessageTableName;
FOUNDATION_EXPORT NSString * const kMessageSqlString;
//天气表
FOUNDATION_EXPORT NSString * const kWeatherTableName;
FOUNDATION_EXPORT NSString * const kWeatherSqlString;
//应用表
FOUNDATION_EXPORT NSString * const kAppInfoTableName;
FOUNDATION_EXPORT NSString * const kAppInfoSqlString;
FOUNDATION_EXPORT NSString * const kConfigSqlString;

//判断设备型号
#define IS_IPHONE_3 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320, 640), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//判断设备类型
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)      ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)      ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)      ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//DeBug
#define MLog(format, ...) do {\
fprintf(stderr, "\n____________________________________________________________\n");\
fprintf(stderr, "<%s : %d> %s\n",\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__, __func__);\
(NSLog)((format), ##__VA_ARGS__);\
fprintf(stderr, "￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣\n");\
} while (0)


#define CHECK(str)     if (str.length == 0) {\
str = @"未填写";\
}
//判断字符串是否为空或者为空字符串
#define StringIsNullOrEmpty(str) (str==nil||[str isEqualToString:@""])
//判断字符串不为空并且不为空字符串
#define StringNotNullAndEmpty(str) (str!=nil && ![str isEqualToString:@""] && ![str isEqualToString:@"null"])
//快速格式化一个字符串
#define _S(str,...) [NSString stringWithFormat:str,##__VA_ARGS__]

//用户表字段
FOUNDATION_EXPORT NSString * const kPDFText;
FOUNDATION_EXPORT NSString * const kPDFTextFont;
FOUNDATION_EXPORT NSString * const kPDFTextFontName;
FOUNDATION_EXPORT NSString * const kPDFTextFontSize;
FOUNDATION_EXPORT NSString * const kPDFTextColor;
FOUNDATION_EXPORT NSString * const kPDFRect;
FOUNDATION_EXPORT NSString * const kPDFTextAlignment;
FOUNDATION_EXPORT NSString * const kPDFLineBreakMode;

//用户表字段
FOUNDATION_EXPORT NSString * const kUserID;
FOUNDATION_EXPORT NSString * const kUserAccountState;
FOUNDATION_EXPORT NSString * const kUserAgentCode;
FOUNDATION_EXPORT NSString * const kUserIcon;
FOUNDATION_EXPORT NSString * const kUserAgentName;
FOUNDATION_EXPORT NSString * const kUserBirthday;
FOUNDATION_EXPORT NSString * const kUserBranchType;
FOUNDATION_EXPORT NSString * const kUserGender;
FOUNDATION_EXPORT NSString * const kUserGroup;
FOUNDATION_EXPORT NSString * const kUserIdNo;
FOUNDATION_EXPORT NSString * const kUserIdType;
FOUNDATION_EXPORT NSString * const kUserOrganId;
FOUNDATION_EXPORT NSString * const kUserPassword;
FOUNDATION_EXPORT NSString * const kUserPermissionType;
FOUNDATION_EXPORT NSString * const kUserPhone;
FOUNDATION_EXPORT NSString * const kUserState;
FOUNDATION_EXPORT NSString * const kUserServiceLoginTime;
FOUNDATION_EXPORT NSString * const kUserLocalLoginTime;
FOUNDATION_EXPORT NSString * const kUserStatus;

@end
