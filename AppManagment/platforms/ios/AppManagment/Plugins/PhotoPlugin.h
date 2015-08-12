//
//  PhotoPlugin.h
//  PhotoDemo
//
//  Created by andy on 14-1-16.
//
//

#import "RootPlugin.h"
#import "QBImagePickerController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPClient.h"

@interface PhotoPlugin : RootPlugin <
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    QBImagePickerControllerDelegate>
{    
    NSString *_directoryPath;
    NSString *_filePath;

    // 接收参数 上传图片的时候专用
    BOOL _paramIsUpload;
    NSString *_paramDownloadURL;
    NSString *_paramFilePath;
    NSString *agentCode;
    NSString *pwd;
}

- (void)photoLib:(CDVInvokedUrlCommand *)command;
- (void)photoCamera:(CDVInvokedUrlCommand *)command;
- (void)removePhoto:(CDVInvokedUrlCommand *)command;

// 上传图片
- (void)uploadImage:(CDVInvokedUrlCommand *)command;


@end
