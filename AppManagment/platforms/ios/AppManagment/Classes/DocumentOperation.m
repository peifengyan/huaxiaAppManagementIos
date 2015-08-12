//
//  DocumentOperation.m
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/9/20.
//
//

#import "DocumentOperation.h"

@implementation DocumentOperation

+ (NSString *) getPathWithComponent:(NSString *)component withIntermediateDirectories:(BOOL)createIntermediates error:(NSError **) error {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:component];
    
    if (createIntermediates) {
        NSError *error = nil;
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:createIntermediates attributes:nil error:&error];
        }
    }
    return path;
}

+ (NSString *) getLibraryPathWithComponent:(NSString *)component withIntermediateDirectories:(BOOL)createIntermediates error:(NSError **) error {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:component];
    
    if (createIntermediates) {
        NSError *error = nil;
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:createIntermediates attributes:nil error:&error];
        }
    }
    return path;
}

- (void) removeItemInPath:(NSString *)path completion:(void(^)(BOOL deleteResult)) completion {
    
    dispatch_queue_t q = dispatch_get_main_queue();
    dispatch_async(q, ^{
        
        NSError * error = nil;
        
        BOOL deletePath = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (deletePath) {
            
            NSLog(@"删除文件成功");
        }
        else {
            
            NSLog(@"删除文件失败 error:%@", error);
        }
        completion (deletePath);
    });
}

+ (void) saveProfileImageNamed:(NSString *)imageName andImage:(UIImage *)image {
    
    NSString *pngFilePath = [DocumentOperation getPathWithComponent:imageName withIntermediateDirectories:NO error:nil];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:pngFilePath]) {
        
        pngFilePath = [DocumentOperation getPathWithComponent:imageName withIntermediateDirectories:NO error:nil];
    }
    
    NSData *imageData;
    
    imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    
    [imageData writeToFile:pngFilePath atomically:YES];
}

- (BOOL) copyFolderFromPath:(NSString *) fromPath ToPath:(NSString *) toPath {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    fileManager.delegate = self;
    NSError *createPathError = nil;
    if (![fileManager fileExistsAtPath:toPath]) {
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:toPath])
            [[NSFileManager defaultManager] createDirectoryAtPath:toPath withIntermediateDirectories:YES attributes:nil error:&createPathError];
        if (createPathError != nil) {
            
            NSLog(@"创建目录失败: %@", createPathError);
        }
    }
    NSError *copyError = nil;
    NSLog(@"default path %@",fromPath);
    BOOL copyFolder =[fileManager copyItemAtPath:fromPath toPath:toPath error:&copyError];
    if (!copyFolder) {
        
        NSLog(@"文件夹复制失败:%@",copyError);
    }
    return copyFolder;
}
- (BOOL) copyFileFromPath:(NSString *) fromPath ToPath:(NSString *) toPath {
    
    NSError *fileError = nil;
    
    BOOL copyResult = [[NSFileManager defaultManager] copyItemAtPath:fromPath toPath:toPath error:&fileError];
    if (!copyResult) {
        
        NSLog(@"拷贝失败: %@",fileError);
    }
    return copyResult;
}
- (BOOL)fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error copyingItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath{
    if ([error code] == 516) //error code for: The operation couldn’t be completed. File exists
        return YES;
    else
        return NO;
}
@end
