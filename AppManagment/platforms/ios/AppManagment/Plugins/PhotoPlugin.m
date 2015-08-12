//
//  PhotoPlugin.m
//  PhotoDemo
//
//  Created by andy on 14-1-16.
//
//

#import "PhotoPlugin.h"
#import "DesEncryptUtil.h"
#import "MBProgressHUD.h"
#import "Reachable.h"

#define PHOTO_DIRECTORY_PATH @"/Library/Caches/photoLib"
// 匿名类别
@interface PhotoPlugin() <MBProgressHUDDelegate> {
    
    MBProgressHUD *HUD;
}

// 初始化文件夹路径
- (void)setFilePath;

// 创建文件夹
- (void)createFileDirectory;

// 删除文件夹
- (void)removeFileDirectory;

// 推送_相册视图控制器 (系统默认相册)
- (void)presentPhotoLibController;
    
// 推送_相册视图控制器 (多选QB)
- (void)presentPhotoQBLibController:(NSInteger)maxNumber;

// 推送_拍照视图控制器
- (void)presentPhotoCameraController;

// 保存_拍照图片到本地相册
- (void)sameImageFromCamera:(UIImage *)image;

// 保存_照片到设置路径当中
- (void)saveImage:(UIImage *)image withPath:(NSString *)path;

// 判断_当前文件夹是否存在
- (BOOL)isExecutableFileAtPath :(NSString *)path;

// 返回_缓存文件夹的大小, 单位: M
- (long long) fileSizeAtPath:(NSString*) filePath;
- (float) folderSizeAtPath:(NSString*) folderPath;

// 获取_当前时间的字符串
- (NSString *)getDateString;

// 返回_保存文件的保存路径
- (NSString *)getPathWithFilename:(NSString *)filename;
    
// 返回_本地图片URL
- (void)returnImageURL:(NSString *)url ;
    
@end

@implementation PhotoPlugin

// 压缩图像
const CGFloat imageQuality = 0.5;   // 图像质量
const NSInteger compressWidth = 1024;   // 生成相片像素宽
const NSInteger compressHeight = 768;   // 生成相片像素高

//======================== Code Start ===============================

#pragma mark - help_method
/**
 *  初始化成员变量_directoryPath;
 */
- (void)setFilePath {
    _directoryPath = [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),PHOTO_DIRECTORY_PATH];
}

/**
 *  获取_pickController. 并且创建一个存放图片相册文件夹
 */
- (void)createFileDirectory {
    // 判断是否存在 存放相片的文件夹
    [self setFilePath];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:_directoryPath]) {
        [manager createDirectoryAtPath:_directoryPath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
    }
}

/**
 *  删除文件夹
 */
- (void)removeFileDirectory {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:_directoryPath]) {
        [manager removeItemAtPath:_directoryPath error:nil];
    }
}

/**
 *  检测文件是否存在
 */
- (BOOL)isExecutableFileAtPath :(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager isExecutableFileAtPath:path]) {
        return YES;
    }
    return NO;
}

/**
 *  获取当前时间的字符串
 */
- (NSString *)getDateString {
    NSDate *date = [NSDate date];
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
    [matter setDateFormat:@"hh-MM-dd HH-mm-ss"];
    return [matter stringFromDate:date];
}

/**
 *  获取缓存大小 单位: M
 */
//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

/**
 *  设置保存路径, 并且返回该路径
 */
- (NSString *)getPathWithFilename:(NSString *)filename {
    
    NSString *md5 = [DesEncryptUtil md5DigestString:filename];
    NSString *path = [NSString stringWithFormat:@"%@/%@.png", _directoryPath, md5];
    
    return path;
}

/**
 *  返回图片路径(单选_字符串)
 */
- (void)returnImageURL:(NSString *)url {
    [self returnOKResult:YES withResultString:url];
}
/**
 *  返回图片路径(多选_数组)
 */
- (void)returnImageURLArray:(NSArray *)array {
    [self returnOKResult:YES withResultArray:array];
}

/**
 *  压缩图片
 */
- (UIImage *)compressImage:(UIImage *)image {
    int height = CGImageGetHeight(image.CGImage);
    int width = CGImageGetWidth(image.CGImage);
    
    if ( height > width ) {
        CGFloat scale = (CGFloat)height/640;
        
        CGSize size = CGSizeMake(width/scale, height/scale);
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, width/scale, height/scale)];
        
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }else {
        CGFloat scale = (CGFloat)width/640;
        
        CGSize size = CGSizeMake(height/scale, width/scale);
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, height/scale, width/scale)];
        
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
    
    //    CGSize size = CGSizeMake(width/scale, height/scale);
    //    UIGraphicsBeginImageContext(size);
    //    [image drawInRect:CGRectMake(0, 0, width/scale, height/scale)];
    //
    //    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //
    //
    //    return newImage;
}

/**
 *  保存相机拍摄照片到本地相册
 */
- (void)sameImageFromCamera:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, nil, nil ,nil);
}

/**
 *  保存图片
 */
- (void)saveImage:(UIImage *)image withPath:(NSString *)path {
    // 如果文件存在, 就直接返回
    if ([self isExecutableFileAtPath:path]) {
        return;
    }
    // 如果文件不存在, 就保存图片
    NSData *data = UIImageJPEGRepresentation(image, imageQuality);
    [data writeToFile:path atomically:YES];
}
/**
 *  跳转到系统默认相册界面(单选)
 */
- (void)presentPhotoLibController {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    
    [self presentViewController:imagePickerController
                       animated:YES
                     completion:NULL];
}

/**
 *  跳转到选择图像列表界面 (多选)
 */
- (void)presentPhotoQBLibController:(NSInteger)maxNumber {
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = maxNumber;
    imagePickerController.limitsMaximumNumberOfSelection = YES;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    
    [self presentViewController:navigationController
                       animated:YES
                     completion:NULL];
}

/**
 *  跳转到拍照界面
 */
- (void)presentPhotoCameraController {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    
    [self presentViewController:imagePickerController
                       animated:YES
                     completion:NULL];
}

/**
 *  异步下载图片
 */
- (void)uploadImageWithFilePath:(NSString *)filePath url:(NSString *)url {
    
    // 图片二进制数据流
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];

    NSMutableData *data = (NSMutableData *)UIImagePNGRepresentation(image);
    
    // 创建请求
    NSURL *uploadURL = [NSURL URLWithString:url];
    
    AFHTTPClient *s = [[AFHTTPClient alloc] initWithBaseURL:uploadURL];
    NSMutableURLRequest *request = [s multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        [formData appendPartWithFormData:[agentCode dataUsingEncoding:NSUTF8StringEncoding] name:@"agentCode"];
        [formData appendPartWithFormData:[pwd dataUsingEncoding:NSUTF8StringEncoding] name:@"password"];
        [formData appendPartWithFileData:data name:@"photo" fileName:@"A.png" mimeType:@"image/png"];
    }];
    [request setURL:[NSURL URLWithString:url]];
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
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        id resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        if (error != nil && resultDic == nil) {
            
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:enc];
            NSData *newData = [string dataUsingEncoding:NSUTF8StringEncoding];
            error = nil;
            resultDic = [NSJSONSerialization JSONObjectWithData:newData options:0 error:&error];
        }
        
        if ( error == nil && [[[resultDic objectForKey:@"status"] objectForKey:@"code"] integerValue] == 0 ) {
            
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            HUD.labelText = @"上传成功";
            [HUD hide:YES afterDelay:0.5f];
            NSDictionary *data = [resultDic objectForKey:@"jsonMap"];
            NSDictionary *dict = @{
                                   @"url": [data objectForKey:@"url"],
                                   @"local": filePath
                                   };
            [self returnOKResult:YES withResultDictionary:dict];
        }
        else {
            
            HUD.labelText = @"上传失败";
            [HUD hide:YES afterDelay:0.5f];
            
            if (resultDic == nil) {
                
                NSDictionary *dict = @{
                                       @"errorCode": @"-1",
                                       @"errorMessage": @"返回数据出错",
                                       @"local": filePath
                                       };
                [self returnOKResult:NO withResultDictionary:dict];
            }
            else {
                
                [HUD hide:YES afterDelay:0.5f];
                NSString *errorMessage = nil;
                if ([[resultDic objectForKey:@"errorMessage"] isKindOfClass:[NSArray class]]) {
                    
                    errorMessage = [[resultDic objectForKey:@"errorMessage"] objectAtIndex:0];
                }
                else {
                    
                    errorMessage = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
                }
                NSDictionary *dict = @{
                                       @"errorCode": [resultDic objectForKey:@"errorCode"],
                                       @"errorMessage": errorMessage,
                                       @"local": filePath
                                       };
                [self returnOKResult:NO withResultDictionary:dict];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        HUD.labelText = @"上传失败";
        [HUD hide:YES afterDelay:0.5f];
        NSDictionary *dict = @{
                               @"errorCode":[NSString stringWithFormat:@"%d", error.code],
                               @"errorMessage":[error.userInfo objectForKey:NSLocalizedDescriptionKey],
                               @"local":filePath
                               };
        [self returnOKResult:NO withResultDictionary:dict];
    }];
    [operation start];
    
}

#pragma mark - plugins_main_method

/**
 *  相册列表返回url
 */
- (void)photoLib:(CDVInvokedUrlCommand *)command {
    
    self.callbackId = command.callbackId;
    // 最大图片张数
    NSInteger maxNumber = [[command.arguments objectAtIndex:0] integerValue];
    
    [self createFileDirectory];
    
     //   如果多选张数为 1 >> 跳转单选系统默认相册
     //   如果多选张数大于 1 >> 跳转多选QB相册
    if (maxNumber == 1) {
        [self presentPhotoLibController];
    } else if(maxNumber > 1) {
        [self presentPhotoQBLibController:maxNumber];
    }
}
/**
 *  拍照获取返回url
 */
- (void)photoCamera:(CDVInvokedUrlCommand *)command {
    self.callbackId = command.callbackId;
    
    [self createFileDirectory];
    /*
        判断相机是否可用 
        (可用_调用相机)
        (不可用_调取相册)
     */
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self presentPhotoCameraController];
    }else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您的设备没有拍照功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

/**
 *  清除相片缓存
 */
- (void)removePhoto:(CDVInvokedUrlCommand *)command {
    self.callbackId = command.callbackId;
    
    [self setFilePath];
    [self removeFileDirectory];
}


/**
 *  上传图片
 */
- (void)uploadImage:(CDVInvokedUrlCommand *)command {
    
    HUD = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"上传中...";
    
    self.callbackId = command.callbackId;
    //设置参数
    _paramDownloadURL = [command.arguments objectAtIndex:0];
    _paramFilePath = [command.arguments objectAtIndex:1];
    
    agentCode = [DesEncryptUtil encryptUseDES:[command.arguments objectAtIndex:2]];
    
    pwd = [DesEncryptUtil encryptUseDES:[command.arguments objectAtIndex:3]];
}
// ==================== end Main_Plugin_method ======================
#pragma mark - Protocol

// 拍照的时候调用该函数, 获取图片 >> 保存图片 >> 传出url
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        NSString *currentTime = [self getDateString];
        NSString *path = [self getPathWithFilename:currentTime];
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        [self sameImageFromCamera:image];
        [self saveImage:[self compressImage:image] withPath:path];
        
        [self returnImageURL:path];
        
    } else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        NSString *filename = [[info objectForKey:@"UIImagePickerControllerReferenceURL"] absoluteString];
        NSString *path = [self getPathWithFilename:filename];
        
        [self saveImage:[self compressImage:image] withPath:path];
        [self returnImageURL:path];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 相册进行多选照片, 保存图片, 并且path存入数组中
- (void)QBImagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info {
    NSArray *mediaInfoArray = (NSArray *)info;
    
    NSMutableArray *pathArray = [NSMutableArray array];
    for (NSDictionary *dict in mediaInfoArray) {
        UIImage *image = [dict objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSString *filename = [[dict objectForKey:@"UIImagePickerControllerReferenceURL"] absoluteString];
        NSString *path = [self getPathWithFilename:filename];
        
        [self saveImage:[self compressImage:image] withPath:path];
        [pathArray addObject:path];
    }
    
    [self returnImageURLArray:pathArray];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

// 点击取消的按钮的时候, 推出相册视图
- (void)QBImagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    [imagePickerController dismissViewControllerAnimated:YES completion:^{}];
}

- (void) hudWasHidden:(MBProgressHUD *)hud {
    
    [hud removeFromSuperview];
    hud = nil;
}
@end
