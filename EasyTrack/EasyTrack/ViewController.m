//
//  ViewController.m
//  EasyTrack
//
//  Created by neo on 2016/11/14.
//  Copyright © 2016年 neo. All rights reserved.
//

#import "ViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
@interface ViewController () <AMapLocationManagerDelegate>
@property (nonatomic, strong) AMapLocationManager *locationManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self.locationManager startUpdatingLocation];
    
}

#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    NSLog(@"维度：%f 经度：%f 精确度：%f", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}

//- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
//    NSLog(@"维度：%f 经度：%f 精确度：%f", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
//}
@end
