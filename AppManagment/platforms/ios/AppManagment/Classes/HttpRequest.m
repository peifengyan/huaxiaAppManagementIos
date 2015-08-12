//
//  HttpRequest.m
//  AppManagment
//
//  Created by Elvis_J_Chan on 12/17/14.
//
//

#import "HttpRequest.h"
#import "DesEncryptUtil.h"
#import "AFHTTPClient.h"
#import "NSString+FormatObject.h"

@implementation HttpRequest

- (void) getWithURLString:(NSString *) url parameters:(NSDictionary *) parametersDict WithSuccess:(void (^)(id responseObject))success failure:(void (^)(id errorObject))failure {
    
    NSString *agentCode = @"";
    NSString *pwd = @"";
    
    NSMutableDictionary *parameters = [parametersDict mutableCopy];
    
    NSArray *parametersArray = [parameters allKeys];
    
    for (int i = 0; i < [parametersArray count]; i++) {
        
        NSString *parametersKey = [parametersArray objectAtIndex:i];
        NSString *newPassword = @"";
        if ([parametersKey isEqualToString:@"agentCode"]) {
            
            NSString *newCode = [DesEncryptUtil encryptUseDES:[parameters objectForKey:parametersKey]];
            newCode = [newCode stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            newCode = [newCode stringByReplacingOccurrencesOfString:@" " withString:@""];
            [parameters setObject:newCode forKey:parametersKey];
            agentCode = newCode;
            [[NSUserDefaults standardUserDefaults] setObject:agentCode forKey:@"agentCode"];
        }
        else if ([parametersKey isEqualToString:@"password"] || [parametersKey isEqualToString:@"newPwd"] || [parametersKey isEqualToString:@"oldPwd"]) {
            
            NSString *md5 = [DesEncryptUtil md5DigestString:[parameters objectForKey:parametersKey]];
            newPassword = [[DesEncryptUtil encryptUseDES:[md5 uppercaseStringWithLocale:[NSLocale currentLocale]]] mutableCopy];
            newPassword = [newPassword stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            newPassword = [newPassword stringByReplacingOccurrencesOfString:@" " withString:@""];
            [parameters setObject:newPassword forKey:parametersKey];
            if ([parametersKey isEqualToString:@"password"]) {
                
                pwd = newPassword;
                [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:@"password"];
            }
        }
        if (i == 0) {
            
            NSString *appendingString = [NSString stringWithFormat:@"?%@=%@",parametersKey,[parameters objectForKey:parametersKey]];
            url = [url stringByAppendingString:appendingString];
        }
        else {
            NSString *appendingString = [NSString stringWithFormat:@"&%@=%@",parametersKey,[parameters objectForKey:parametersKey]];
            url = [url stringByAppendingString:appendingString];
        }
        [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"agentCode"] forHTTPHeaderField:@"agentCode"];
    [request addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"] forHTTPHeaderField:@"password"];
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
        
        [request addValue:@"PAD" forHTTPHeaderField:@"clientType"];
    }
    else {
        
        [request addValue:@"PHONE" forHTTPHeaderField:@"clientType"];
    }
    [request addValue:@"IOS" forHTTPHeaderField:@"clientOs"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        id resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if (error != nil && resultDic == nil) {
            
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:enc];
            responseObject = [string dataUsingEncoding:NSUTF8StringEncoding];
        }
        if (success) {
            
            success (responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorCode = [NSString stringWithFormat:@"%d",error.code];
        NSString *errorMessage = [NSString jsonStringWithObject:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        NSDictionary *dict = @{
                               @"errorCode": errorCode,
                               @"errorMessage":errorMessage
                               };
        if (failure) {
            
            failure ( dict );
        }
    }];
    [operation start];
}
- (void) postWithURLString:(NSString *) url parameters:(NSDictionary *) parametersDict WithSuccess:(void (^)(id responseObject))success failure:(void (^)(id errorObject))failure {
    
    NSString *agentCode = @"";
    NSString *pwd = @"";
    
    NSMutableDictionary *parameters = [parametersDict mutableCopy];
    
    NSArray *parametersArray = [parameters allKeys];
    for (int i = 0; i < [parametersArray count]; i ++ ) {
        
        NSString *parametersKey = [parametersArray objectAtIndex:i];
        NSString *newPassword = @"";
        if ([parametersKey isEqualToString:@"agentCode"]) {
            
            NSString *newCode = [DesEncryptUtil encryptUseDES:[parameters objectForKey:parametersKey]];
            newCode = [newCode stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            newCode = [newCode stringByReplacingOccurrencesOfString:@" " withString:@""];
            [parameters setObject:newCode forKey:parametersKey];
            agentCode = newCode;
            [[NSUserDefaults standardUserDefaults] setObject:agentCode forKey:@"agentCode"];
        }
        else if ([parametersKey isEqualToString:@"password"] || [parametersKey isEqualToString:@"newPwd"] || [parametersKey isEqualToString:@"oldPwd"]) {
            
            NSString *md5 = [DesEncryptUtil md5DigestString:[parameters objectForKey:parametersKey]];
            newPassword = [[DesEncryptUtil encryptUseDES:[md5 uppercaseStringWithLocale:[NSLocale currentLocale]]] mutableCopy];
            newPassword = [newPassword stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            newPassword = [newPassword stringByReplacingOccurrencesOfString:@" " withString:@""];
            [parameters setObject:newPassword forKey:parametersKey];
            if ([parametersKey isEqualToString:@"password"]) {
                
                pwd = newPassword;
                [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:@"password"];
            }
        }
    }
    
    AFHTTPClient *s = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    NSMutableURLRequest *request = [s multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSArray *array = [parameters allKeys];
        for (int i = 0; i < [array count]; i ++ ) {
            
            NSString *s = [parameters objectForKey:[array objectAtIndex:i]];
            [formData appendPartWithFormData:[s dataUsingEncoding:NSUTF8StringEncoding] name:[array objectAtIndex:i]];
        }
    }];
    [request setURL:[NSURL URLWithString:url]];
    [request addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"agentCode"] forHTTPHeaderField:@"agentCode"];
    [request addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"] forHTTPHeaderField:@"password"];
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
        
        [request addValue:@"PAD" forHTTPHeaderField:@"clientType"];
    }
    else {
        
        [request addValue:@"PHONE" forHTTPHeaderField:@"clientType"];
    }
    [request addValue:@"IOS" forHTTPHeaderField:@"clientOs"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSHTTPURLResponse *response = operation.response;
        if (response.statusCode == 200) {
            NSError *error = nil;
            id resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
            if (error != nil && resultDic == nil) {
                
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                NSString *string = [[NSString alloc] initWithData:responseObject encoding:enc];
                responseObject = [string dataUsingEncoding:NSUTF8StringEncoding];
            }
            if (success) {
                
                success (responseObject);
            }
        }
        else {
            
            NSHTTPURLResponse *response = operation.response;
            NSDictionary *dict = @{
                                   @"httpStatusCode": [NSNumber numberWithInteger:response.statusCode],
                                   @"errorCode": [NSNumber numberWithInteger:response.statusCode],
                                   @"errorMessage": @"HTTP Response Status Code"
                                   };
            if (failure) {
                
                failure ( dict );
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorMessage = [NSString jsonStringWithObject:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        NSHTTPURLResponse *response = operation.response;
        
        NSDictionary *dict = @{
                               @"httpStatusCode": [NSNumber numberWithInteger:response.statusCode],
                               @"errorCode": [NSNumber numberWithInteger:error.code],
                               @"errorMessage":errorMessage
                               };
        if (failure) {
            
            failure ( dict );
        }
    }];
    [operation start];
}
@end
