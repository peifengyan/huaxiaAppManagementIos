//
//  ShareClass.h
//
//
//  Created by Elvis_J_Chan on 13-6-25.
//  Copyright (c) 2013年 Elvis_J_Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

#define WECHAT_APP_ID @"wx266b7351865f74de"
//AppSecret="f61ceaccac8e6a599fd84eafcde43de3"
@interface ShareClass : NSObject <WXApiDelegate>

- (void) shareWeiXinWithTitle:(NSString *) title description:(NSString *) description url:(NSString *) url sence:(int) sence;

@end
