#import "NQApplication.h"
#import "GTMBase64.h"
typedef enum NQFILTER_TYPE{

    NQFILTER_NONE = 0,      // 允许打开任何内容
    NQFILTER_IGNORE,        // 不允许打开 OPEN_IGNORE  中的内容
    NQFILTER_CONTAIN        // 只允许打开 OPEN_CONTAIN 中的内容
    
} NQFILTER_TYPE;

@implementation NQApplication

/**
 *  打开指定客户端
 */
+ (NQOpenResult)openApp:(NSString *)schemesURL params:(NSDictionary *)params
{
    // 数据数组
    NSArray *arr = nil;
    // 过滤类型
    NQFILTER_TYPE type = NQFILTER_NONE;
    
    // 根据宏定义来设置信息内容
#ifdef OPEN_IGNORE
    arr = [OPEN_IGNORE componentsSeparatedByString:@"|"];
    type = NQFILTER_IGNORE;
#endif
#ifdef OPEN_CONTAIN
    arr = [OPEN_CONTAIN componentsSeparatedByString:@"|"];
    type = NQFILTER_CONTAIN;
#endif
    
    if ( (![arr containsObject:schemesURL] && type==NQFILTER_CONTAIN)  ||
         ( [arr containsObject:schemesURL] && type==NQFILTER_IGNORE) ) {
        
        // 如果尝试打开的不合法的schemesURL, 回调客户端
        NSLog(@"尝试打开为允许的客户端");
        return NQOpenResult_Illegal;
    }
    
    // 添加前缀
    schemesURL = [NSString stringWithFormat:@"%@://", schemesURL];
    
    // 是否可以打开
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:schemesURL]];
    
    // 如果不可以打开, 返回NO
    if (!canOpen) {
        return NQOpenResult_Fail;
    }
    
    // 如果可以打开, 拼接参数字符串后缀
    schemesURL = [NSString stringWithFormat:@"%@%@", schemesURL, parseParams(params)];
   
    // 开启指向客户端
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:schemesURL]];
    
    return NQOpenResult_Success;
}

/**
 *  解析处理OpenURL
 */
+ (NSDictionary *)handleOpenURL:(NSURL *)openURL
{
    // 获取schemesURL
    NSString *schemesURL = openURL.absoluteString;
    
    // 分割获取参数
    NSString *paramsStr = [schemesURL componentsSeparatedByString:@"://"][1];
    
    return parseOpenURL(paramsStr);
}

#pragma mark -
#pragma mark Private Methods

/**
 *  解析传入参数,转化字符串
 *
 *  @param params 需要传递的参数
 *
 *  @return 转化后的参数字符串
 */
NSString* parseParams(NSDictionary *params)
{
    if (!params) {
        return @"";
    }
    
    if ([NSJSONSerialization isValidJSONObject:params]) {
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:params
                                                       options:kNilOptions
                                                         error:&error];
        // base64加密
        return [GTMBase64 stringByEncodingData:data];
    }
    
    return @"params_is_wrong.";
}

/**
 *  解析传入参数,还原为字典参数
 *
 *  @param params 需要解析的参数字符串
 *
 *  @return 转化后的参数字典
 */
NSDictionary* parseOpenURL(NSString *paramStr)
{
    // base64解密
    NSData *data = [GTMBase64 decodeData:[paramStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 返回参数字典
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

@end

