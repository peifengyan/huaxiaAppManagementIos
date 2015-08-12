//
//  PDFViewController.h
//  AppManagment
//
//  Created by Elvis_J_Chan on 12/16/14.
//
//

#import <UIKit/UIKit.h>

@interface PDFViewController : UIViewController

@property (nonatomic, strong) NSString *loadWebUrl;

@property (nonatomic, strong) NSString *savePath;

@property (nonatomic) BOOL showPDFButton;

@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end
