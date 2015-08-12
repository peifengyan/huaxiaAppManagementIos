//
//  DatePickerDialogPlugin.h
//  Commcan_for_staff
//
//  Created by andy on 14-5-12.
//
//


#import "RootPlugin.h"

@interface DatePickerDialogPlugin : RootPlugin
{
    UIDatePicker * _datePicker; // 时间选择器

    UIView *_mainView;          // 背景视图
    
    UIWindow *_window;          // 窗口
}

// 时间选择器
- (void)getDateOrTime:(CDVInvokedUrlCommand *)command;

@end
