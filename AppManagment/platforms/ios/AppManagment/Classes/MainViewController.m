/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  MainViewController.h
//  AppManagment
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "MainViewController.h"
#import "ConversationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
#import "DocumentOperation.h"
#import "PDFRenderer.h"
#import "GeneralPDF.h"
#import "Reachable.h"

@implementation MainViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark View lifecycle
- (void) viewDidAppear:(BOOL)animated {
    
    [GlobalVariables getGlobalVariables].currentController = self;

}
- (void)viewWillAppear:(BOOL)animated {
    
    // View defaults to full size.  If you want to customize the view's size, or its subviews (e.g. webView),
    // you can do so here.
    [super viewWillAppear:animated];
    [self preferredStatusBarStyle];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    CGRect rect = [self getRectFrame];
    lanuchView = [[UIImageView alloc] initWithFrame:rect];
    lanuchView.image = [self setLanuchView];
    [self.view addSubview:lanuchView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachableChanged:) name:kReachableChangedNotification object:nil];
    
//    [self registerForKeyboardNotifications];
}
- (void) reachableChanged: (NSNotification* )note {

    NSString* jsString = [NSString stringWithFormat:@"onDeviceReady();"];
    [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsString waitUntilDone:NO];
}

- (UIImage *) setLanuchView {
    
    UIImage *returnImage;
    NSString *returnString = @"Default~iphone.png";
    if (IS_IPHONE) {
        if (IS_IPHONE_5) {
            returnString = @"Default-568h@2x~iphone.png";
        }
        else {
            returnString = @"Default~iphone.png";
        }
    }
    if (IS_IPAD) {
        
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
            returnString = @"Default-Portrait~ipad.png";
        }
        else if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortraitUpsideDown) {
            returnString = @"Default-Portrait~ipad.png";
        }
        else if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeLeft) {
            returnString = @"Default-Landscape~ipad.png";
        }
        else if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeRight) {
            returnString = @"Default-Landscape~ipad.png";
        }
    }
//    NSLog(@"%@",returnString);
    returnImage = [UIImage imageNamed:returnString];
    return returnImage;
}
- (CGRect) getRectFrame {
    
    CGRect returnRect;
    if (IS_IPHONE) {
        
        returnRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        if (IS_IPHONE_5) {
            returnRect = CGRectMake(0, 0, 320, 568);
        }
        else if (IS_IPHONE_4 || IS_IPHONE_3) {
            
            returnRect = CGRectMake(0, 0, 320, 480);
        }
    }
    if (IS_IPAD) {
        
        returnRect = CGRectMake(0, 0, 1024, 768);
//        if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
//            returnRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//        }
//        else if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortraitUpsideDown) {
//            returnRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//        }
//        else if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeLeft) {
//            if (self.view.frame.size.height < self.view.frame.size.width) {
//                
//                returnRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//            }
//            else {
//                
//                returnRect = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
//            }
//        }
//        else if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeRight) {
//            
//            if (self.view.frame.size.height < self.view.frame.size.width) {
//                
//                returnRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//            }
//            else {
//                
//                returnRect = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
//            }
//        }
    }
    return returnRect;
}
- (CGFloat) getKeyboardHeightWithRect:(CGRect)rect {
    
    CGFloat returnFloat;
    if (IS_IPHONE) {
        
        returnFloat = rect.size.height;
    }
    if (IS_IPAD) {
        
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
            returnFloat = rect.size.height;
        }
        else if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortraitUpsideDown) {
            returnFloat = rect.size.height;
        }
        else if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeLeft) {
            returnFloat = rect.size.width;
        }
        else if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeRight) {
            returnFloat = rect.size.width;
        }
    }
    return returnFloat;
}
- (void)screenChanged:(NSNotification *)noti {
    
    CGRect rect = [self getRectFrame];
    lanuchView.frame = rect;
    lanuchView.image = [self setLanuchView];
}

- (void) registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWasShown:(NSNotification *) notif {
    
    NSDictionary *info = [notif userInfo];
   
    CGRect keyboardFrame = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrame = [self.view convertRect:keyboardFrame fromView:nil];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"showCoverView"] intValue] == 0) {
        
        CGRect newFrame = self.view.bounds;
        newFrame.size.height -= keyboardFrame.size.height;
        
        NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect rect = [self getRectFrame];
        
        [UIView animateWithDuration:[notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] animations:^{
            
//            self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, -keyboardFrame.size.height, 0);
            self.webView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height-[self getKeyboardHeightWithRect:[value CGRectValue]]);
            [self.webView.scrollView setContentOffset:CGPointZero animated:NO];
            
        } completion:^(BOOL finished) {
            
            if (finished) {
                
                self.webView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height-[self getKeyboardHeightWithRect:[value CGRectValue]]);
                [self.webView.scrollView setContentOffset:CGPointZero animated:NO];
            }
        }];
    }
}

- (void) keyboardWasHidden:(NSNotification *) notif {
    
    CGRect keyboardFrame = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrame = [self.view convertRect:keyboardFrame fromView:nil];
    
    CGRect newFrame = self.view.bounds;
//    newFrame.size.height += keyboardFrame.size.height;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"showCoverView"] intValue] == 0) {
        
        [UIView animateWithDuration:[notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] animations:^{
            
            self.webView.frame = newFrame;
            
        } completion:^(BOOL finished) {
            
            if (finished) {
                
                self.webView.frame = newFrame;
            }
        }];
    }
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}


/* Comment out the block below to over-ride */

/*
- (UIWebView*) newCordovaViewWithFrame:(CGRect)bounds
{
    return[super newCordovaViewWithFrame:bounds];
}
*/

#pragma mark UIWebDelegate implementation
- (void)webViewDidStartLoad:(UIWebView*)theWebView {
    
    // Black base color for background matches the native apps
    theWebView.backgroundColor = [UIColor clearColor];
    
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = NO;
    
    [self performSelector:@selector(removeLanuchView) withObject:nil afterDelay:0.8f];
    
    NSString *os = (IS_IPAD == YES) ? @"pad":@"phone";
    NSString *js = [NSString stringWithFormat:@"window.platform='%@'",os];
    [theWebView stringByEvaluatingJavaScriptFromString:js];
    
    return [super webViewDidStartLoad:theWebView];
}
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotification) name:@"reciveNotification" object:nil];
    if ([[GlobalVariables getGlobalVariables] checkLogOut] != 0) {
        
        NSString* jsString = [NSString stringWithFormat:@"goLogin();"];
        [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsString waitUntilDone:NO];
    }
}
- (void) reciveNotification {
    
    NSString* jsString = [NSString stringWithFormat:@"reciveNotification();"];
    [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsString waitUntilDone:NO];
}

- (void) removeLanuchView {
    
    [lanuchView removeFromSuperview];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

/* Comment out the block below to over-ride */

/*

- (void) webViewDidStartLoad:(UIWebView*)theWebView
{
    return [super webViewDidStartLoad:theWebView];
}

- (void) webView:(UIWebView*)theWebView didFailLoadWithError:(NSError*)error
{
    return [super webView:theWebView didFailLoadWithError:error];
}

- (BOOL) webView:(UIWebView*)theWebView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    return [super webView:theWebView shouldStartLoadWithRequest:request navigationType:navigationType];
}
*/

@end

@implementation MainCommandDelegate

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

@implementation MainCommandQueue

/* To override, uncomment the line in the init function(s)
 in MainViewController.m
 */
- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}

@end