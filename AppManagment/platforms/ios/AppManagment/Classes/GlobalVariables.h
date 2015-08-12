//
//  GlobalVariables.h
//  候鸟
//
//  Created by Elvis_J_Chan on 14-5-18.
//  Copyright (c) 2014年 MU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentUser.h"

@interface GlobalVariables : NSObject

@property (nonatomic, strong) CurrentUser *currentUser;

@property (nonatomic, strong) id currentController;

+ (GlobalVariables *) getGlobalVariables;

- (NSString *) getStringFormTableForKey:(NSString *)key;

- (NSUInteger) checkLogOut;

- (void) setCurrentLoginUser ;

@end
