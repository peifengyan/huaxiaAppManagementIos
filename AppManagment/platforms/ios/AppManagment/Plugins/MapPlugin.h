//
//  MapPlugin.h
//  MapDemo
//
//  Created by andy on 14-1-15.
//
//

#import "RootPlugin.h"
#import <CoreLocation/CoreLocation.h>

@interface MapPlugin : RootPlugin <CLLocationManagerDelegate> {
    
    CLLocationCoordinate2D  _coordinate;
}

@property (nonatomic, strong) CLLocationManager *loactionManager;

// 获取本地定位经纬度
- (void)getCurrentLocation:(CDVInvokedUrlCommand *)command;

@end
