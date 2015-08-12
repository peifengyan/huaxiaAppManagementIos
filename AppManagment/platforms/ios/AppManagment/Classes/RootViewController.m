//
//  RootViewController.m
//  Commcan_for_staff
//
//  Created by andy on 2/19/14.
//
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

#pragma mark - help_code

// 设置字体颜色为白色
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}


#pragma mark - 生命周期函数

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}



@end
