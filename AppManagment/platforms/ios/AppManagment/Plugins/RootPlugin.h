//
//  RootPlugin.h
//  Test
//
//  Created by andy on 13-12-9.
//
//

#import <Cordova/CDVPlugin.h>
#import <Foundation/Foundation.h>

@interface RootPlugin : CDVPlugin

@property(nonatomic, copy) NSString *callbackId;

// 推送到视图控制器 vc
- (void)presentViewController:(UIViewController *)vc animated:(BOOL)isAnimation completion:(void (^)(void))completion;

// 返回结果___字符串
- (void)returnOKResult:(BOOL)isOK withResultString:(NSString *)string;

// 返回结果___数组
- (void)returnOKResult:(BOOL)isOK withResultArray:(NSArray *)array;

// 返回结果___字典
- (void)returnOKResult:(BOOL)isOK withResultDictionary:(NSDictionary *)dict;

- (void)showAlertViewWithMessage:(NSString *)message;

@end
