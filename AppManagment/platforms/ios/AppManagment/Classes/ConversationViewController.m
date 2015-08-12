//
//  ConversationViewController.m
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/9/4.
//
//

#import "ConversationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+FormatObject.h"

@interface ConversationViewController () <ConversationViewControllerDelegate> {
    
    UIButton *closeButton;
}

@end

@implementation ConversationViewController
@synthesize loadWebUrl,passData,showCloseButton;
@synthesize delegate;

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
- (void) viewDidDisappear:(BOOL)animated {
    
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
    NSLog(@"加载页面: %@",self.loadWebUrl);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.loadWebUrl]]];
    
    if (self.showCloseButton) {
        
        CGRect buttonRect = [self getButtonRect];
        if (IS_IPAD && ([[UIApplication sharedApplication] statusBarOrientation] == 3 || [[UIApplication sharedApplication] statusBarOrientation] == 4)) {
            buttonRect = CGRectMake(self.view.frame.size.height-50, 26, 45, 30);
        }
        closeButton = [self setButtonBackgroundImage:@"button_close" buttonTitle:@"关闭" buttonFrame:buttonRect selector:@selector(backButtonClicked:)];
        [self.view addSubview:closeButton];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backData:) name:@"backValue" object:nil];

}
- (CGRect) getButtonRect {
    
    CGRect buttonRect = CGRectMake(self.view.frame.size.width-50, 26, 45, 30);
    return buttonRect;
}
- (void)backButtonClicked:(UIButton *)button {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) viewDidAppear:(BOOL)animated {
    
    [GlobalVariables getGlobalVariables].currentController = self;
//    [self performSelector:@selector(al) withObject:nil afterDelay:5];
//    [self performSelector:@selector(al1) withObject:nil afterDelay:8];

}
//- (void) al {
//    
//    CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
//    UIViewController *vc = [GlobalVariables getGlobalVariables].currentController;
//    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:duration];
//    //在这里设置view.transform需要匹配的旋转角度的大小就可以了。
//    vc.view.bounds = CGRectMake(0, 0, vc.view.frame.size.height, vc.view.frame.size.width);
//    vc.view.transform = rotation;
//    [UIView commitAnimations];
//}
//- (void) al1 {
//    
//    CGAffineTransform rotation = CGAffineTransformMakeRotation(0);
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
//    UIViewController *vc = [GlobalVariables getGlobalVariables].currentController;
//    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:duration];
//    //在这里设置view.transform需要匹配的旋转角度的大小就可以了。
//    vc.view.bounds = CGRectMake(0, 0, vc.view.frame.size.width, vc.view.frame.size.height);
//    vc.view.transform = rotation;
//    [UIView commitAnimations];
//}
- (void) viewWillDisappear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = NO;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self preferredStatusBarStyle];
    }
    if (self.passData != nil) {
        
        NSString *string = [NSString jsonStringWithObject:self.passData];
        NSString* jsString = [NSString stringWithFormat:@"loadAnotherJs('%@');", string];
        [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsString waitUntilDone:NO];
    }
    if ([[GlobalVariables getGlobalVariables] checkLogOut] != 0) {
        [self dismissViewControllerAnimated:NO completion:nil];
    };
}
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    
//    NSURL *requestURL = [request URL];
//    if (([[requestURL scheme] isEqualToString:@"http"] || [[requestURL scheme] isEqualToString:@"https"] || [[requestURL scheme] isEqualToString:@"mailto"])
//        && (navigationType == UIWebViewNavigationTypeLinkClicked)) {
//        
//        return ![[UIApplication sharedApplication] openURL:requestURL];
//    }
//    return YES;
//}
- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void) backData:(NSNotification *)notification {
    
    id result = [notification object];
    NSString *string = [NSString jsonStringWithObject:result];
    
    NSString* jsString = [NSString stringWithFormat:@"loadAnotherJs('%@');", string];
    [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsString waitUntilDone:NO];

}
-(BOOL) shouldAutorotate {
    
    if (IS_IPAD) {
        return YES;
    }
    else {
        
        return NO;
    }
}
- (NSUInteger)supportedInterfaceOrientations {
    
    if (IS_IPAD) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    else {
        
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    // Return YES for supported orientations
    return [self shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
@implementation ConversationViewDelegate

/* To override the methods, uncomment the line in the init function(s)
 in MainViewController.m
 */

#pragma mark CDVCommandDelegate implementation

- (id)getCommandInstance:(NSString*)className
{
    return [super getCommandInstance:className];
}

- (NSString*)pathForResource:(NSString*)resourcepath
{
    return [super pathForResource:resourcepath];
}

@end

@implementation ConversationViewQueue

/* To override, uncomment the line in the init function(s)
 in MainViewController.m
 */
- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}

@end