//
//  DocumentOperation.h
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/9/20.
//
//

#import <Foundation/Foundation.h>

@class NSFileManager;

@interface DocumentOperation : NSObject <NSFileManagerDelegate>

+ (NSString *) getPathWithComponent:(NSString *)component withIntermediateDirectories:(BOOL)createIntermediates error:(NSError **) error ;
+ (NSString *) getLibraryPathWithComponent:(NSString *)component withIntermediateDirectories:(BOOL)createIntermediates error:(NSError **) error ;

+ (void) saveProfileImageNamed:(NSString *)imageName andImage:(UIImage *)image ;

@end
