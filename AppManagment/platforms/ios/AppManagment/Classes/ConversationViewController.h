//
//  ConversationViewController.h
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/9/4.
//
//

#import <Cordova/CDVViewController.h>
#import <Cordova/CDVCommandDelegateImpl.h>
#import <Cordova/CDVCommandQueue.h>

@protocol ConversationViewControllerDelegate;

@interface ConversationViewController : CDVViewController <UIWebViewDelegate> {
    
    __weak id <ConversationViewControllerDelegate> delegate;

}

@property (nonatomic, weak) id <ConversationViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString *loadWebUrl;

@property (nonatomic, strong) id passData;

@property (nonatomic) BOOL showCloseButton;

@end

@interface ConversationViewDelegate : CDVCommandDelegateImpl
@end

@interface ConversationViewQueue : CDVCommandQueue
@end

@protocol ConversationViewControllerDelegate <NSObject>

- (void) backData:(NSDictionary *)dictionary;

@end