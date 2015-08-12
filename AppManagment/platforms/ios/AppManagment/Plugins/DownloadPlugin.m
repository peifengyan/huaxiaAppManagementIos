//
//  DownloadPlugin.m
//  myApp
//
//  Created by Elvis_J_Chan on 14/8/28.
//
//

#import "DownloadPlugin.h"
#import "MBProgressHUD.h"
#import "AFDownloadRequestOperation.h"
#import "ZipArchive.h"

CGFloat zipPercent = 0.95;
CGFloat unzipPercent = 0.1;

@interface DownloadPlugin () <MBProgressHUDDelegate> {
    
    MBProgressHUD *HUD;
    float dataPer;
}
@end

@implementation DownloadPlugin

- (void) updateZip:(CDVInvokedUrlCommand *)command {
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] keyWindow];
    self.callbackId = command.callbackId;
    UIWindow *viewC = (UIWindow *)delegate;
    [viewC.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    //获取下载连接
    NSString *downloadURL = [reciveFromJS objectForKey:@"url"];
    //获取下载保存路径
    NSError *fileError = nil;
    NSString *downloadFilePath = [DocumentOperation getPathWithComponent:[reciveFromJS objectForKey:@"package"] withIntermediateDirectories:YES error:&fileError];
    NSLog(@"\n%@\n%@",downloadURL,downloadFilePath);
//    {
//        package = "promodel/1004";
//        url = "http://218.247.15.102/emm_backend_static/ipa/nanshansongv2.zip";
//    }
//    /var/mobile/Containers/Data/Application/6947F398-0110-4970-BF2C-0723E90D9229/Documents/promodel/1004
    
    NSString *deletePath = [downloadFilePath stringByAppendingString:@"/www"];
    
    NSError * error = nil;
    
    BOOL delete = [[NSFileManager defaultManager] removeItemAtPath:deletePath error:&error];
    if (delete) {
        
        NSLog(@"删除文件成功");
    }
    else {
        
        NSLog(@"删除文件失败 error:%@", error);
    }
    
    if (fileError == nil && delete) {
//            /var/mobile/Containers/Data/Application/FD17D1C8-201E-431D-AD53-6F858283270B/Documents/promodel/1004
        [self downloadZipFromURL:downloadURL storePath:downloadFilePath downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            /var/mobile/Containers/Data/Application/FD17D1C8-201E-431D-AD53-6F858283270B/Documents/promodel/1004
            [self unzipFileWithPath:downloadFilePath unzipName:responseObject];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"下载出错:%@",error);
            NSDictionary *dict = @{
                                   @"errorCode":[NSString stringWithFormat:@"%d", error.code],
                                   @"errorMessage":[error.userInfo objectForKey:NSLocalizedDescriptionKey],
                                   };
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict] callbackId:command.callbackId];

        }];
    }
    else {
        
        NSLog(@"路径出错:%@",fileError);
        NSDictionary *dict = @{
                               @"errorCode":[NSString stringWithFormat:@"%d", fileError.code],
                               @"errorMessage":[fileError.userInfo objectForKey:NSLocalizedDescriptionKey],
                               };
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict] callbackId:command.callbackId];
    }
}
- (void) downloadZip:(CDVInvokedUrlCommand *)command {
    
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    self.callbackId = command.callbackId;
//    {
//        package = "promodel/1004";
//        url = "http://218.247.15.102/emm_backend_static/ipa/nanshansongv2.zip";
//    }
    NSString *downloadURL = [reciveFromJS objectForKey:@"url"];
    NSError *fileError = nil;
    NSString *downloadFilePath = [DocumentOperation getPathWithComponent:[reciveFromJS objectForKey:@"package"] withIntermediateDirectories:YES error:&fileError];
    NSLog(@"%@\n%@",downloadURL,downloadFilePath);
    
    if (fileError == nil) {
//        /var/mobile/Containers/Data/Application/5CF4A3A4-1B2A-494F-9FD9-97AD89DE3CD5/Documents/promodel/1004
        [self downloadZipFromURL:downloadURL storePath:downloadFilePath downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            /var/mobile/Containers/Data/Application/5CF4A3A4-1B2A-494F-9FD9-97AD89DE3CD5/Documents/promodel/1004/nanshansongv1.zip
            [self unzipFileWithPath:downloadFilePath unzipName:responseObject];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [HUD hide:YES afterDelay:0.3];
            NSLog(@"下载出错:%@",error.description);
            NSDictionary *dict = @{
                                   @"errorCode":[NSString stringWithFormat:@"%d", error.code],
                                   @"errorMessage":[error.userInfo objectForKey:NSLocalizedDescriptionKey],
                                   };
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict] callbackId:command.callbackId];
        }];
    }
    else {
        
        [HUD hide:YES afterDelay:0.3];
        NSLog(@"路径出错:%@",fileError.description);
        NSDictionary *dict = @{
                               @"errorCode":[NSString stringWithFormat:@"%d", fileError.code],
                               @"errorMessage":[fileError.userInfo objectForKey:NSLocalizedDescriptionKey],
                               };
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict] callbackId:command.callbackId];
    }
}

- (void)downloadZipFromURL:(NSString *)urlString storePath:(NSString *)path downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))succeed failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))faild {
    
    HUD = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.labelText = @"下载中...";
    HUD.delegate = self;
    [HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
    
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
        dataPer = percentDone * zipPercent;
        NSLog(@"------%f",percentDone);
    }];
    [operation start];
}

- (void)myProgressTask {
    
    float progress = 0.0f;
	while (progress < 1.0f) {
        
        progress = dataPer;
        HUD.progress = progress;
		usleep(50000);
	}
}
- (void) unzipFileWithPath:(NSString *)unzipPath unzipName:(NSString *)unzipName {
    
    HUD.labelText = @"解压中...";
    dataPer = 0.965;
    ZipArchive* za = [[ZipArchive alloc] init];

    if([za UnzipOpenFile:unzipName]) {

        BOOL ret = [za UnzipFileTo:unzipPath overWrite:YES];
        NSLog(@"%@",unzipName);
        if(NO == ret) {
            
            // error handler here
            NSDictionary *dict = @{
                                   @"errorCode": @"-4",
                                   @"errorMessage": @"zip 包解压失败",
                                   };
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict] callbackId:self.callbackId];

        }
        else {
            
            NSError * error = nil;
            
            BOOL delete = [[NSFileManager defaultManager] removeItemAtPath:unzipName error:&error];
            [self copyFolderToPath:unzipPath];
            dataPer = 0.98;
            if (delete) {
                
                NSLog(@"删除文件成功");
            }
            else {
                
                NSLog(@"删除文件失败 error:%@", error);
                [HUD hide:YES afterDelay:0.3];
                NSDictionary *dict = @{
                                       @"errorCode": @"-3",
                                       @"errorMessage": @"zip 包删除失败",
                                       };
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict] callbackId:self.callbackId];
            }
        }
        [za UnzipCloseFile];
    }
    else {
        
        [HUD hide:YES afterDelay:0.3];
        NSDictionary *dict = @{
                               @"errorCode": @"-2",
                               @"errorMessage": @"zip 包无法打开",
                               };
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict] callbackId:self.callbackId];
    }
}
- (void) hudWasHidden:(MBProgressHUD *)hud {
    
    [hud removeFromSuperview];
    dataPer = 0;
    hud = nil;
}
- (void) copyFolderToPath:(NSString *)path {
    
    HUD.labelText = @"拷贝中...";
    dataPer = 0.99;
    
    NSString *folderSavePath = [NSString stringWithFormat:@"%@/www/plugins",path];
    NSString *cordovaPluginsSavePath = [NSString stringWithFormat:@"%@/www/cordova_plugins.js",path];
    NSString *cordovaSavePath = [NSString stringWithFormat:@"%@/www/cordova.js",path];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    fileManager.delegate = self;
    NSError *error1;
    
    if (![fileManager fileExistsAtPath:folderSavePath]) {
        
        NSLog(@"创建目录");
        if (![[NSFileManager defaultManager] fileExistsAtPath:folderSavePath])
            [[NSFileManager defaultManager] createDirectoryAtPath:folderSavePath withIntermediateDirectories:YES attributes:nil error:&error1];
    }
    
    NSString *folderReadPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"www/plugins"];
    NSLog(@"default path %@",folderReadPath);
    BOOL copyFolder =[fileManager copyItemAtPath:folderReadPath toPath:folderSavePath error:&error1];
    if (!copyFolder) {
        
        NSLog(@"文件夹复制失败:%@",error1);
    }
    
    NSError *fileError = nil;
    NSString *cordovaReadPath = [[NSBundle mainBundle] pathForResource:@"www/cordova" ofType:@"js"];
    NSString *cordovaPluginsReadPath = [[NSBundle mainBundle] pathForResource:@"www/cordova_plugins" ofType:@"js"];
    
    BOOL copyCordova = [[NSFileManager defaultManager] copyItemAtPath:cordovaReadPath toPath:cordovaSavePath error:&fileError];
    BOOL copyCordovaPulgin = [[NSFileManager defaultManager] copyItemAtPath:cordovaPluginsReadPath toPath:cordovaPluginsSavePath error:&fileError];
    
    if (copyFolder && copyCordova && copyCordovaPulgin) {
        
        NSLog(@"文件全部拷贝成功回调");
        dataPer = 1;
        [HUD hide:YES];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"] callbackId:self.callbackId];
    }
    else {
        
        dataPer = 1;
        [HUD hide:YES afterDelay:0.5];
        [self.commandDelegate runInBackground:^{
            
            NSLog(@"文件全部拷贝失败回调");
            NSDictionary *dict = @{
                                   @"errorCode": @"-1",
                                   @"errorMessage": @"文件全部拷贝失败回调",
                                   };
            NSError *error = nil;
            
            BOOL delete = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            if (!delete) {
                
                NSLog(@"文件夹%@删除成功",path);
            }
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict] callbackId:self.callbackId];
        }];
    }
}
- (BOOL)fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error copyingItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath{
    if ([error code] == 516) //error code for: The operation couldn’t be completed. File exists
        return YES;
    else
        return NO;
}

- (void) downloadNavtiveApp:(CDVInvokedUrlCommand *)command {
    
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    self.callbackId = command.callbackId;
    NSString *downloadURLString = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",[reciveFromJS objectForKey:@"appList"]];
    
    NSURL *downloadURL = [NSURL URLWithString:downloadURLString];
    
    BOOL download = [[UIApplication sharedApplication] openURL:downloadURL];
    
    [self.commandDelegate runInBackground:^{
        
        if (download) {
            NSLog(@"成功打开连接");
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"1"] callbackId:self.callbackId];

        }
        else {
            NSLog(@"无法打开链接");
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"0"] callbackId:self.callbackId];
        }
    }];
}


@end
