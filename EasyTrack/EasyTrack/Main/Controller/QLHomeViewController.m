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

@interface QLHomeViewController () <MAMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *mapModeBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (strong, nonatomic) MAMapView *mapview;
@end

@implementation QLHomeViewController

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
    [self.view insertSubview:self.mapview atIndex:0];
    
    //mapModeBtn
    self.mapModeBtn.layer.cornerRadius = 5;
    self.mapModeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.mapModeBtn.layer.borderWidth = 0.5;
    self.mapModeBtn.backgroundColor = [UIColor whiteColor];
    
    self.startBtn.backgroundColor = [UIColor whiteColor];
    
}

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
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.mapview setMapType:MAMapTypeBus];
    }]];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - MAMapViewDelegate
@end
