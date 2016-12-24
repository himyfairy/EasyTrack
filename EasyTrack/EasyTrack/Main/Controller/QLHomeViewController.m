//
//  QLHomeViewController.m
//  EasyTrack
//
//  Created by 戚璐 on 2016/12/19.
//  Copyright © 2016年 neo. All rights reserved.
//

#import "QLHomeViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "QLResultViewController.h"

@interface QLHomeViewController () <MAMapViewDelegate, AMapLocationManagerDelegate>

/**
 IBOutlet
 */
@property (weak, nonatomic) IBOutlet UIButton *mapModeBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startBtnBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pauseBtnCenterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stopBtnCenterConstraint;

@property (strong, nonatomic) MAMapView *mapview;
@property (nonatomic, strong) MAPolyline *mypolyline;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray<CLLocation *> *coordinateArray;
@property (nonatomic, strong) NSMutableArray<MAPolyline *> *overlayArray;
@end

@implementation QLHomeViewController
#pragma mark - lazy
- (NSMutableArray<CLLocation *> *)coordinateArray {
    if (!_coordinateArray) {
        _coordinateArray = [NSMutableArray array];
    }
    return _coordinateArray;
}

- (NSMutableArray<MAPolyline *> *)overlayArray {
    if (!_overlayArray) {
        _overlayArray = [NSMutableArray array];
    }
    return _overlayArray;
}

#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
}

#pragma mark - method
- (void)setup {
    
    self.title = @"EasyTrack";
    
    //设置mapview
    self.mapview = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, K_SCREEN_WIDTH, K_SCREEN_HEIGHT - 64)];
    self.mapview.delegate = self;
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    self.mapview.showsUserLocation = YES;
    self.mapview.userTrackingMode = MAUserTrackingModeFollow;
    self.mapview.pausesLocationUpdatesAutomatically = NO;
    self.mapview.allowsBackgroundLocationUpdates = YES;
    [self.view insertSubview:self.mapview atIndex:0];
    
    //设置mapModeBtn
    self.mapModeBtn.layer.cornerRadius = 5;
    self.mapModeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.mapModeBtn.layer.borderWidth = 0.5;
    self.mapModeBtn.backgroundColor = [UIColor whiteColor];
    
    //设置startBtn、pauseBtn、stopBtn
    self.startBtn.backgroundColor = [UIColor whiteColor];
    self.startBtn.layer.cornerRadius = self.startBtn.width * 0.5;
    self.pauseBtn.backgroundColor = [UIColor colorWithRed:40/255.0 green:43/255.0 blue:53/255.0 alpha:1.0];
    self.pauseBtn.layer.cornerRadius = self.pauseBtn.width * 0.5;
    self.stopBtn.backgroundColor = [UIColor colorWithRed:40/255.0 green:43/255.0 blue:53/255.0 alpha:1.0];
    self.stopBtn.layer.cornerRadius = self.stopBtn.width * 0.5;
    
}

//切换地图模式
- (IBAction)changeMapMode:(UIButton *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择地图类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"标准地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.mapview setMapType:MAMapTypeStandard];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"卫星地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.mapview setMapType:MAMapTypeSatellite];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"夜景模式地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.mapview setMapType:MAMapTypeStandardNight];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"导航模式地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.mapview setMapType:MAMapTypeNavi];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"公交地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.mapview setMapType:MAMapTypeBus];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

//开始按钮点击
- (IBAction)startBtnClick:(UIButton *)sender {
    
    //startBtn往下动画
    self.startBtnBottomConstraint.constant = self.startBtn.height;
    
    //pauseBtn往左动画
    self.pauseBtnCenterConstraint.constant = -self.pauseBtn.width;
    
    //stopBtn往右动画
    self.stopBtnCenterConstraint.constant = self.stopBtn.width;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            //开始记录轨迹
            [self recordTrack];
        }
    }];
}

//暂停按钮点击
- (IBAction)pauseBtnClick:(UIButton *)sender {
    
    //startBtn往上动画
    self.startBtnBottomConstraint.constant = -30;
    
    //pauseBtn往右动画
    self.pauseBtnCenterConstraint.constant = 0;
    
    //stopBtn往左动画
    self.stopBtnCenterConstraint.constant = 0;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.locationManager stopUpdatingLocation];
        }
    }];
}

//停止按钮点击
- (IBAction)stopBtnClick:(UIButton *)sender {
    
    //startBtn往上动画
    self.startBtnBottomConstraint.constant = -30;
    
    //pauseBtn往右动画
    self.pauseBtnCenterConstraint.constant = 0;
    
    //stopBtn往左动画
    self.stopBtnCenterConstraint.constant = 0;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            
            //停止记录轨迹
            [self.locationManager stopUpdatingLocation];
            
            QLLog(@"%f, %f", self.mapview.centerCoordinate.latitude, self.mapview.centerCoordinate.longitude);
            
            //push结果
            QLResultViewController *resultVC = [[QLResultViewController alloc] init];
            resultVC.centerCoordinate = self.mapview.centerCoordinate;
            [resultVC.coordinateArray addObjectsFromArray:self.coordinateArray];
            [self.navigationController pushViewController:resultVC animated:YES];
            
            //清空当前控制器的坐标数组
            [self.mapview removeOverlays:self.overlayArray];
            [self.coordinateArray removeAllObjects];
            [self.overlayArray removeAllObjects];
            [self.mapview reloadMap];
            
        }
    }];
}

//记录轨迹
- (void)recordTrack {
    
    //实例化
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    //设置定位最小更新距离,单位:米
    self.locationManager.distanceFilter = 0.5;
    //开启定位
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
    
}

#pragma mark - MAMapViewDelegate
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 4.0f;
        polylineRenderer.strokeColor  = [UIColor colorWithRed:63/255.0 green:140/255.0 blue:251/255.0 alpha:1.0];
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        return polylineRenderer;
    }
    return nil;
}

#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    QLLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    [self.coordinateArray addObject:location];
    
    //构造折线数据对象
    CLLocationCoordinate2D commonPolylineCoords[self.coordinateArray.count];
    for (int i = 0; i<self.coordinateArray.count; i++) {
        CLLocation *location = self.coordinateArray[i];
        commonPolylineCoords[i].latitude =  location.coordinate.latitude;
        commonPolylineCoords[i].longitude = location.coordinate.longitude;
    }
    
    //构造折线对象
    self.mypolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:self.coordinateArray.count];
    [self.overlayArray addObject:self.mypolyline];
    
    //在地图上添加折线对象
    [self.mapview addOverlay:self.mypolyline];
    
}
@end
