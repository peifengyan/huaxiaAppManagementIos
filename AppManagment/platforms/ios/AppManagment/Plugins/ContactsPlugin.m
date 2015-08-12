//
//  ContactsPlugin.m
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/9/10.
//
//

#import "ContactsPlugin.h"

@implementation ContactsPlugin

- (void)sendMessage:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{

        self.callbackId = command.callbackId;
        
        NSString *reciveFormJS = [command.arguments objectAtIndex:0];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] keyWindow];
        UIWindow *viewC = (UIWindow *)delegate;
        
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText]) {
            
//            controller.body = @"Hello from Mugunth";
            controller.recipients = [NSArray arrayWithObjects:reciveFormJS, nil];
            controller.messageComposeDelegate = self;
            [viewC.rootViewController presentViewController:controller animated:YES completion:^{
                
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            }];
        }
    }];
}
- (void)callNumber:(CDVInvokedUrlCommand *)command {
    
    [self.commandDelegate runInBackground:^{
        
        self.callbackId = command.callbackId;

        NSString *reciveFromJS = [command.arguments objectAtIndex:0];
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] keyWindow];
        UIWindow *viewC = (UIWindow *)delegate;
        UIWebView*callWebview =[[UIWebView alloc] init];
        NSString *tel = [NSString stringWithFormat:@"tel:%@",reciveFromJS];
        NSURL *telURL =[NSURL URLWithString:tel];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [viewC.rootViewController.view addSubview:callWebview];
    }];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:

            break;
        case MessageComposeResultSent:
            
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
