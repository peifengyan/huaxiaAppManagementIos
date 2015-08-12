//
//  SaveImageToNativePlugin.m
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/12/15.
//
//

#import "SaveImageToNativePlugin.h"
#import "DesEncryptUtil.h"
#import "AFDownloadRequestOperation.h"

#define PHOTO_DIRECTORY_PATH @"/Caches/photoLib"

@implementation SaveImageToNativePlugin

- ( void ) downLoadImage:( CDVInvokedUrlCommand * ) command {
    
//    {data:["",""],savePath:""}
    self.callbackId = command.callbackId;
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    NSString *imageSavePath = [reciveFromJS objectForKey:@"savePath"];
    NSArray *downloadImageURLs = [reciveFromJS objectForKey:@"data"];
    
    NSError *error = nil;
    if (imageSavePath.length == 0) {
        
        NSString *subPath = PHOTO_DIRECTORY_PATH;
        imageSavePath = [DocumentOperation getLibraryPathWithComponent:subPath withIntermediateDirectories:YES error:&error];
    }
    else {
        
        imageSavePath = [DocumentOperation getPathWithComponent:imageSavePath withIntermediateDirectories:YES error:&error];
    }
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:0];

    for ( NSString * URL in downloadImageURLs) {
        
        NSURL *downloadURL = [NSURL URLWithString:URL];
        imageSavePath = [NSString stringWithFormat:@"%@/%@",imageSavePath,[downloadURL lastPathComponent]];
        [self downloadWithURL:URL storePath:imageSavePath downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
//            [returnArray addObject:responseObject];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [returnArray addObject:[downloadURL lastPathComponent]];
        }];
    }
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:returnArray] callbackId:command.callbackId];
}
- (void) saveImageToNative:(CDVInvokedUrlCommand *) command {
    
    self.callbackId = command.callbackId;
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    NSString *imageSavePath = [reciveFromJS objectForKey:@"saveImagePath"];
    NSString *downloadImageURL = [reciveFromJS objectForKey:@"downLoadPath"];
    [downloadImageURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    if (imageSavePath.length == 0) {
        
        NSString *subPath = PHOTO_DIRECTORY_PATH;
        imageSavePath = [DocumentOperation getLibraryPathWithComponent:subPath withIntermediateDirectories:YES error:&error];
    }
    else {
        
        imageSavePath = [DocumentOperation getPathWithComponent:imageSavePath withIntermediateDirectories:YES error:&error];
    }
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *imageNewName = [NSString stringWithFormat:@"download%u.jpg",(unsigned int)time];
    imageSavePath = [NSString stringWithFormat:@"%@/%@",imageSavePath,imageNewName];
    
    [self downloadWithURL:downloadImageURL storePath:imageSavePath downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:(NSString *) responseObject] callbackId:command.callbackId];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *dict = @{
                               @"errorCode": [NSString stringWithFormat:@"%d", error.code],
                               @"errorMessage": [error.userInfo objectForKey:NSLocalizedDescriptionKey],
                               };
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict] callbackId:command.callbackId];
    }];
}

- (void) downloadWithURL:(NSString *) urlString storePath:(NSString *)path downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))succeed failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))faild {
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3600];
    [[GlobalVariables getGlobalVariables] setCurrentLoginUser];
    [request addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"agentCode"] forHTTPHeaderField:@"agentCode"];
    [request addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"] forHTTPHeaderField:@"password"];
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
        
        [request addValue:@"PAD" forHTTPHeaderField:@"clientType"];
    }
    else {
        
        [request addValue:@"PHONE" forHTTPHeaderField:@"clientType"];
    }
    [request addValue:@"IOS" forHTTPHeaderField:@"clientOs"];
    AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:path shouldResume:YES];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Successfully downloaded file to %@", path);
        if (succeed) {
            
            succeed(operation, responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        if (faild) {
            
            faild(operation, error);
        }
    }];
    
    [operation setProgressiveDownloadProgressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        
        float percentDone = totalBytesReadForFile/(float)totalBytesExpectedToReadForFile;
        NSLog(@"------%f",percentDone);

    }];
    [operation start];
}

@end
