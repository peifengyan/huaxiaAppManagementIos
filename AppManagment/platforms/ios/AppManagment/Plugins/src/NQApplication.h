//
//  NQApplication.h
//  NQApplication
//
//  Created by andy on 9/2/14.
//  Copyright (c) 2014 JianXiang Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define OPEN_IGNORE  @"auth|hello"
//#define OPEN_CONTAIN @"auth|hello"

typedef enum NQOpenResult {
    NQOpenResult_Illegal =0, // 客户端打开失败 -- 不合法SchemesURL
    NQOpenResult_Fail,       // 客户端打开失败 -- SchemesURL无法正常打开
    NQOpenResult_Success     // 客户端打开成功
} NQOpenResult;

@interface NQApplication : NSObject

/**
 *  打开指定客户端
 *
 *  @param schemesURL 指定客户端SchemesURL
 *  @param params     用户所需要传入的参数
 *
 *  @return 返回是否可以安装
 */
+ (NQOpenResult)openApp:(NSString *)schemesURL params:(NSDictionary *)params;

/**
 *  解析处理OpenURL
 *
 *  @param openURL 客户端被打开的OpenURL
 *
 *  @return 转换后的参数
 */
+ (NSDictionary *)handleOpenURL:(NSURL *)openURL;

@end
