//
//  DatePickerDialogPlugin.m
//  Commcan_for_staff
//
//  Created by andy on 14-5-12.
//
//

#import "DatePickerDialogPlugin.h"

#define PICKER_VIEW_HEIGHT (200)    // 时间选择器高度
#define DURATION 0.3                // 动画间隔

@implementation DatePickerDialogPlugin


/**
 *  时间选择器
 */
- (void)getDateOrTime:(CDVInvokedUrlCommand *)command {
    
    self.callbackId = command.callbackId;
//    [[UIDevice currentDevice] setValue: [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
    if (_mainView == nil) {
        // 获取代理
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        // 获取Window
        _window = delegate.window;
        
        // 创建视图
        _mainView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [_window addSubview:_mainView];
        
        // 背景色
        _mainView.backgroundColor = [UIColor blackColor];
        // 透明度
        _mainView.alpha = 0;
        
        // 添加点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popPickerView)];
        [_mainView addGestureRecognizer:tapGesture];
    }
    
    // 创建时间选择器
    if (_datePicker == nil) {
        int w = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        int h = CGRectGetHeight([[UIScreen mainScreen] bounds]);
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,
                                                                     h,
                                                                     w,
                                                                     PICKER_VIEW_HEIGHT)];
//        if (IS_IPAD) {
//
//            _datePicker.frame = CGRectMake(0,
//                                           w,
//                                           h,
//                                           PICKER_VIEW_HEIGHT);
//        }
        // 设置类型为_Year_Month_Day
        _datePicker.datePickerMode = UIDatePickerModeDate;
        // 添加视图
        [_window addSubview:_datePicker];
        
        // 背景颜色
        _datePicker.backgroundColor = [UIColor whiteColor];
        
        // 设置圆角
        _datePicker.layer.masksToBounds = YES;
        _datePicker.layer.cornerRadius = 10.0f;
        
        // 设置边框
        _datePicker.layer.borderWidth = 1.0f;
        _datePicker.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    

    // 显示背景
    _mainView.hidden = NO;

    // 动画
    [UIView animateWithDuration:DURATION animations:^{
        // 背景样式切换
        _mainView.alpha = 0.6;
        
        // 改变PickView样式
        CGRect frame = _datePicker.frame;
        frame.origin.y -= (PICKER_VIEW_HEIGHT);
        _datePicker.frame= frame;
        
    }];
}

/**
 *  推回时间选择器
 */
- (void)popPickerView {

    // 动画
    [UIView animateWithDuration:DURATION animations:^{
        // 背景样式切换
        _mainView.alpha = 0;
        
        // 改变PickView样式
        CGRect frame = _datePicker.frame;
        frame.origin.y += (PICKER_VIEW_HEIGHT);
        _datePicker.frame= frame;
    }];
    
    // 隐藏视图
    [self performSelector:@selector(mainViewHidden) withObject:nil afterDelay:0.5];
    
    // 获取时间
    NSDate *date = _datePicker.date;
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd"];

    // 获取时间字符串
    NSString *dateString = [dateformat stringFromDate:date];

    // 开始阶段
    NSArray *array = [dateString componentsSeparatedByString:@"-"];
    NSString *year = [array objectAtIndex:0];
    NSString *month = [array objectAtIndex:1];
    NSString *day = [array objectAtIndex:2];
    
    // 转换Json
    // 格式      {"month":5,"year":2014,"dayOfMonth":9}
    NSDictionary *res = [NSDictionary dictionaryWithObjectsAndKeys:
                         [self check:month],   @"month",
                         [self check:year] ,   @"year",
                         [self check:day] ,    @"dayOfMonth",nil];
    
    // 返回Json
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:res] callbackId:self.callbackId];

}

/**
 *  隐藏主视图
 */
- (void)mainViewHidden {
    _mainView.hidden = YES;
}

/**
 *  修改字符串
 */
- (NSString *)check:(NSString *)str {
    if (str.length == 1) {
        return [NSString stringWithFormat:@"0%@",str];
    }
    return str;
}

@end
