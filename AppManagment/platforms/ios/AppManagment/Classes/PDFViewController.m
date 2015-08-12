//
//  PDFViewController.m
//  AppManagment
//
//  Created by Elvis_J_Chan on 12/16/14.
//
//

#import "PDFViewController.h"

@interface PDFViewController () {
    
    UIButton *closeButton;
}

@end

@implementation PDFViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (UIButton*) setButtonBackgroundImage:(NSString*)imageName buttonTitle:(NSString*)title buttonFrame:(CGRect)rect selector:(SEL)selector {
    
    UIButton * buttonName = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonName setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [buttonName setTitle:title forState:UIControlStateNormal];
    buttonName.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    buttonName.frame = rect;
    [buttonName addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return buttonName;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;

    NSLog(@"加载页面: %@",self.loadWebUrl);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.loadWebUrl]]];
    // Do any additional setup after loading the view from its nib.
    
    CGRect buttonRect = CGRectMake(50, 26, 45, 30);
    closeButton = [self setButtonBackgroundImage:@"button_close" buttonTitle:@"关闭" buttonFrame:buttonRect selector:@selector(backButtonClicked:)];
    [self.view addSubview:closeButton];
}
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = NO;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self preferredStatusBarStyle];
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}
- (void) generatedPDFButtonClicked:(UIButton *) button {
    
//    createPDF = [NDHTMLtoPDF createPDFWithURL:[NSURL URLWithString:self.loadWebUrl]
//                                   pathForPDF:self.savePath
//                                     delegate:self
//                                     pageSize:kPaperSizeLetter
//                                      margins:UIEdgeInsetsMake(0, 0, 0, 0)];
}
- (void) backButtonClicked:(UIButton *)button {
    
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.3;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    
//    if ([[UIApplication sharedApplication] statusBarOrientation] == 1) {
//        
//        transition.subtype = kCATransitionFromLeft;
//    }
//    else if ([[UIApplication sharedApplication] statusBarOrientation] == 2) {
//        
//        transition.subtype = kCATransitionFromRight;
//    }
//    else if ([[UIApplication sharedApplication] statusBarOrientation] == 3) {
//        
//        transition.subtype = kCATransitionFromBottom;
//    }
//    else {
//        
//        transition.subtype = kCATransitionFromTop;
//    }
//    
//    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark NDHTMLtoPDFDelegate

//- (void)HTMLtoPDFDidSucceed:(NDHTMLtoPDF*)htmlToPDF {
//    
//    NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did succeed (%@ / %@)", htmlToPDF, htmlToPDF.PDFpath];
//    NSLog(@"%@",result);
////    [self loadPDFInPath:htmlToPDF.PDFpath];
////    [self returnOKResult:YES withResultString:htmlToPDF.PDFpath];
//}
//
//- (void)HTMLtoPDFDidFail:(NDHTMLtoPDF*)htmlToPDF {
//    
//    NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did fail (%@)", htmlToPDF];
//    NSLog(@"%@",result);
////    [self returnOKResult:NO withResultString:@"保存失败"];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
