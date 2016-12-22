//
//  QLResultViewController.m
//  EasyTrack
//
//  Created by neo on 2016/12/22.
//  Copyright © 2016年 neo. All rights reserved.
//

#import "QLResultViewController.h"

@interface QLResultViewController () <MAMapViewDelegate>

@end

@implementation QLResultViewController

#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setup];
//
//    [self drawTrack];
    
    self.mapview.frame = CGRectMake(0, 64, K_SCREEN_WIDTH, K_SCREEN_HEIGHT - 64);
    self.mapview.showsUserLocation = NO;
    [self.view insertSubview:self.mapview atIndex:0];
}

#pragma mark - method
- (void)setup {
    
    self.title = @"我的轨迹";
    
    //设置mapview
    self.mapview = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, K_SCREEN_WIDTH, K_SCREEN_HEIGHT - 64)];
    self.mapview.delegate = self;
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    self.mapview.showsUserLocation = NO;
    [self.view insertSubview:self.mapview atIndex:0];
    
}

- (void)drawTrack {
    
    //构造折线数据对象
    CLLocationCoordinate2D commonPolylineCoords[self.coordinateArray.count];
    for (int i = 0; i<self.coordinateArray.count; i++) {
        CLLocation *location = self.coordinateArray[i];
        commonPolylineCoords[i].latitude =  location.coordinate.latitude;
        commonPolylineCoords[i].longitude = location.coordinate.longitude;
    }
    
    //构造折线对象
    MAPolyline *mypolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:self.coordinateArray.count];
    
    //在地图上添加折线对象
    [self.mapview addOverlay:mypolyline];
    
}
@end
