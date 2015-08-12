//
//  MapPlugin.m
//  MapDemo
//
//  Created by andy on 14-1-15.
//
//

#import "MapPlugin.h"

@implementation MapPlugin

#pragma mark - help__code
/**
 *  将经纬度_转化成数组 >>> 格式为 [latitude, longitude]
 */
- (NSArray *)getLocationArray:(CLLocationCoordinate2D)coordinate {
    
    return [NSArray arrayWithObjects:
            // 数组元素
            [NSNumber numberWithFloat:coordinate.latitude],
            [NSNumber numberWithFloat:coordinate.longitude],
            nil];
}
/**
 *  获取 >>> 本地经纬度
 */
- (void)getCurrentLocation:(CDVInvokedUrlCommand *)command {
    
    self.callbackId = command.callbackId;
    self.loactionManager = nil;
    self.loactionManager = [[CLLocationManager alloc] init];
    if ([self.loactionManager respondsToSelector:@selector(requestWhenInUseAuthorization)] && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [self.loactionManager requestWhenInUseAuthorization];
    }
    self.loactionManager.distanceFilter = 10;
    self.loactionManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.loactionManager.delegate = self;
    
    [self.loactionManager startUpdatingLocation];
}

#pragma mark - LocationDelegate

/**
 *  定位回调
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // 禁止定位
    [manager stopUpdatingLocation];
    
    CLLocation *location = locations.lastObject;
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSArray *locationArray = [self getLocationArray:coordinate];
    
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:locationArray] callbackId:self.callbackId];
}

/**
 *  定位失败
 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"定位失败:%@",error);
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"定位失败"] callbackId:self.callbackId];
}

@end
