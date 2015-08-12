//
//  Constants.m
//  候鸟
//
//  Created by Elvis_J_Chan on 14-5-18.
//  Copyright (c) 2014年 MU. All rights reserved.
//

#import "Contants.h"

@implementation Contants

//接口地址
//NSString *const kHostSite = @"http://192.168.1.138:8080/emm_backend/api/v1/";
NSString *const kHostSite = @"http://123.57.41.120:8082";
//NSString *const kHostSite = @"http://10.0.17.111:8080";

//XMPP地址
NSString * const kXMPPHost = @"10.0.17.111";
NSString * const kXMPPPort = @"9089";
NSString * const kXMPPDomain = @"http://10.0.17.111:8080";
//统计主机地址
NSString * const kStatisticsHost = @"http://192.168.1.197/index.php?";
//统计SDK AppKey
NSString * const kStatisticsAppKey = @"05c1e8b93e8b0d0af7a17136d2d20233";

//检测版本
NSString * const kCheckVerson = @"/emm_backend/app/v1/appStore/version.json?osId=1";
//本地数据库
NSString * const kUserDatabaseName = @"UserDatabase.db";
NSString * const kAppDatabaseName = @"AppDatabase.db";
NSString * const kProductDatabaseName = @"ProductDatabase.db";
NSString * const kChatDatabaseName = @"ChatDatabase.db";
NSString * const kWeatherDatabaseName = @"WeatherDatabase.db";
//用户表
NSString * const kCurrentUserTableName = @"current_user_info";
NSString * const kCurrentUserSqlString = @"CREATE TABLE IF NOT EXISTS current_user_info (id INTEGER PRIMARY KEY AUTOINCREMENT, AVATAR varchar(64), BRANCH_TYPE_TEXT varchar(64), CREATE_TIME varchar(64), AGENT_STATE varchar(64), OPERATOR varchar(64), PHONE varchar(64), ICON varchar(512), IDTYPE_TEXT varchar(64), PERMISSION_TYPE_TEXT varchar(64), VALID_LOGIN_TIME varchar(64), EMAIL varchar(64), PWD_CHANGE_TIME varchar(64), GENDER_TEXT varchar(64), ORGAN_ID_TEXT varchar(64), PASSWORD varchar(64), ORGAN_ID varchar(64), BIRTHDAY varchar(64), ACCOUNT_STATE varchar(64), LAST_LOGIN_TIME varchar(64), AGENT_STATE_TEXT varchar(64), AGENT_NAME varchar(64), LAST_LOGOUT_TIME varchar(64), IDNO varchar(64), UPDATE_TIME varchar(64), MODIFY_OPERATOR varchar(64), BRANCH_TYPE varchar(64), GENDER varchar(64), INVALID_LOGIN varchar(64), IDTYPE varchar(64), AGENT_GROUP_TEXT varchar(64), PERMISSION_TYPE varchar(64), AGENT_CODE varchar(64), AGENT_GROUP varchar(64), localIcon varchar(64), serviceLoginTime Long DEFAULT 0 NOT NULL, localLoginTime Long DEFAULT 0 NOT NULL, status varchar(64) DEFAULT '0' NOT NULL, AUTO_DOWN Long DEFAULT 0)";
//消息表  未读为0 / 已读为1
NSString * const kMessageTableName = @"message_info";
NSString * const kMessageSqlString = @"CREATE TABLE IF NOT EXISTS message_info (MESSAGE_ID varchar(64) primary key, TITLE varchar(512), CONTENT varchar(512), TYPE varchar(64), APPID varchar(64), AGENT_CODE varchar(64), CREATE_TIME varchar(64), STATE varchar(64) DEFAULT 0 NOT NULL)";
//天气表
NSString * const kWeatherTableName = @"weather_info";
NSString * const kWeatherSqlString = @"CREATE TABLE IF NOT EXISTS weather_info (id INTEGER PRIMARY KEY AUTOINCREMENT, city varchar(64), highest_temperature varchar(64), lowest_temperature varchar(64), weather varchar(64), img varchar(512), img_small varchar(512), air_pollution_index varchar(64), pollution_index_description varchar(64), current_temperature varchar(64), wind_direction varchar(64), relative_humidity varchar(64), wind_power varchar(64), date_in_words varchar(64), date varchar(64), wind varchar(64))";
//应用表
NSString * const kAppInfoTableName = @"app_info";
NSString * const kAppInfoSqlString = @"CREATE TABLE IF NOT EXISTS app_info (appId varchar(64) primary key, appsourceid varchar(128), appstoreid varchar(128), company varchar(128), description varchar(512), icon varchar(512), iconInfo varchar(512), versionDescription varchar(512), name varchar(256), pkgname varchar(256), fullTrialText varchar(256), version varchar(64), versionId varchar(64), ipaUrl varchar(256), full_trial_id varchar(64), version_type varchar(64), schemesUrl varchar(256), service_type varchar(64), createTime varchar(64), appSize varchar(64), plistUrl varchar(256))";

NSString * const kConfigSqlString = @"CREATE TABLE IF NOT EXISTS mconfig (roomdesc varchar(128),rname varchar(128),rid INTEGER,id varchar(32) primary key)";


NSString * const kPDFText = @"kPDFText";
NSString * const kPDFTextFont = @"kPDFTextFont";
NSString * const kPDFTextFontName = @"kPDFTextFontName";
NSString * const kPDFTextFontSize = @"kPDFTextFontSize";
NSString * const kPDFTextColor = @"kPDFTextColor";
NSString * const kPDFRect = @"kPDFRect";
NSString * const kPDFTextAlignment = @"kPDFTextAlignment";
NSString * const kPDFLineBreakMode = @"kPDFLineBreakMode";
//用户表字段
NSString * const kUserID = @"id";
NSString * const kUserAccountState = @"ACCOUNT_STATE";
NSString * const kUserAgentCode = @"AGENT_CODE";
NSString * const kUserIcon = @"ICON";
NSString * const kUserAgentName = @"AGENT_NAME";
NSString * const kUserBirthday = @"BIRTHDAY";
NSString * const kUserBranchType = @"BRANCH_TYPE";
NSString * const kUserGender = @"GENDER";
NSString * const kUserGroup = @"AGENT_GROUP";
NSString * const kUserIdNo = @"IDNO";
NSString * const kUserIdType = @"IDTYPE";
NSString * const kUserOrganId = @"ORGAN_ID";
NSString * const kUserPassword = @"PASSWORD";
NSString * const kUserPermissionType = @"PERMISSION_TYPE";
NSString * const kUserPhone = @"PHONE";
NSString * const kUserState = @"AGENT_STATE";
NSString * const kUserServiceLoginTime = @"serviceLoginTime";
NSString * const kUserLocalLoginTime = @"localLoginTime";
NSString * const kUserStatus = @"status";

@end
