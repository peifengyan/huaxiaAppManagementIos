//
//  TransformPDFPlugin.h
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/11/10.
//
//

#import "RootPlugin.h"

@interface TransformPDFPlugin : RootPlugin <MBProgressHUDDelegate> {
            
    NSString *fileSavePath;
    MBProgressHUD *HUD;
}

- (void) transformPDF:(CDVInvokedUrlCommand *)command;

- (void) openPDF:(CDVInvokedUrlCommand *)command;

- (void) jsonToPDF:(CDVInvokedUrlCommand *)command;
@end
