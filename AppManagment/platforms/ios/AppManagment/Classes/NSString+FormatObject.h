//
//  NSString+FormatObject.h
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/9/3.
//
//

#import <Foundation/Foundation.h>

@interface NSString (FormatObject)

+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;

+(NSString *) jsonStringWithArray:(NSArray *)array;

+(NSString *) jsonStringWithString:(NSString *) string;

+(NSString *) jsonStringWithObject:(id) object;

@end
