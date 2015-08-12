//
//  ScreenOrientationPlugin.m
//  AppManagment
//
//  Created by Elvis_J_Chan on 1/6/15.
//
//

#import "ScreenOrientationPlugin.h"

@implementation ScreenOrientationPlugin

- (void) landscape:(CDVInvokedUrlCommand *) command {
    
//    if (SYSTEM_VERSION_LESS_THAN(@"8.0") || 1) {
//    
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
        
        CDVViewController *vc = [GlobalVariables getGlobalVariables].currentController;
        
        CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
        
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        //在这里设置view.transform需要匹配的旋转角度的大小就可以了。
        //设置导航栏旋转
        vc.navigationController.navigationBar.frame = CGRectMake(0, 0, vc.view.frame.size.height, 0);
        vc.navigationController.navigationBar.transform = rotation;
        //设置视图旋转
        vc.view.bounds = CGRectMake(0, 0, vc.view.frame.size.height, vc.view.frame.size.width);
        vc.view.transform = rotation;
        
        [UIView commitAnimations];
//    }
//    else {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                           withObject:(id)UIInterfaceOrientationLandscapeRight];
        }
//    }


}
- (void) portrait:(CDVInvokedUrlCommand *) command {
    
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
//                                       withObject:(id)UIInterfaceOrientationMaskPortrait];
//    }
//    if (SYSTEM_VERSION_LESS_THAN(@"8.0") || 1) {
//        
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
        CDVViewController *vc = [GlobalVariables getGlobalVariables].currentController;
        
        CGAffineTransform rotation = CGAffineTransformMakeRotation(0);
        
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        //在这里设置view.transform需要匹配的旋转角度的大小就可以了。
        //设置导航栏旋转
        vc.navigationController.navigationBar.frame = CGRectMake(0, 0, vc.view.frame.size.height, 0);
        vc.navigationController.navigationBar.transform = rotation;
        //设置视图旋转
        vc.view.bounds = CGRectMake(0, 0, vc.view.frame.size.width, vc.view.frame.size.height);
        vc.view.transform = rotation;
        
        [UIView commitAnimations];
//    }
//    else {
//        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//            
//            NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
//            [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
//        }
//    }
}


@end
