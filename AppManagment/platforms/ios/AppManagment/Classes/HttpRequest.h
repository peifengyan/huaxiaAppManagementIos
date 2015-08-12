//
//  HttpRequest.h
//  AppManagment
//
//  Created by Elvis_J_Chan on 12/17/14.
//
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

@interface HttpRequest : NSObject

- (void) getWithURLString:(NSString *) url parameters:(NSDictionary *) parametersDict WithSuccess:(void (^)(id responseObject))success failure:(void (^)(id errorObject))failure;

- (void) postWithURLString:(NSString *) url parameters:(NSDictionary *) parametersDict WithSuccess:(void (^)(id responseObject))success failure:(void (^)(id errorObject))failure;
@end
