//
//  QLResultViewController.m
//  EasyTrack
//
//  Created by neo on 2016/12/22.
//  Copyright © 2016年 neo. All rights reserved.
//

#import "QLResultViewController.h"
#import "QLShareView.h"
#import "WXApi.h"
@interface QLResultViewController () <MAMapViewDelegate, QLShareViewDelegate>

@end

@implementation QLResultViewController
#pragma mark - lazy
- (NSMutableArray<CLLocation *> *)coordinateArray {
    if (!_coordinateArray) {
        _coordinateArray = [NSMutableArray array];
    }
    return _coordinateArray;
}

#pragma mark - lifeCircle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setup];

    [self drawTrack];
    
    QLLog(@"viewDidLoad---");
}

#pragma mark - method
- (void)setup {
    
    self.title = @"我的轨迹";
    
    //设置mapview
    self.mapview = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, K_SCREEN_WIDTH, K_SCREEN_HEIGHT - 64)];
    self.mapview.delegate = self;
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    [self.mapview setCenterCoordinate:self.centerCoordinate];
    [self.view insertSubview:self.mapview atIndex:0];
    
    //rightBarButtonItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareItemClick)];
    
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

- (void)shareItemClick {
    [QLShareView showWithDelegate:self];
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

#pragma mark - QLShareViewDelegate
//存相册
- (void)shareViewDidClickSaveToAlbumButton:(QLShareView *)shareView {
    CGRect rect = CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT);
    __block UIImage *screenShot = nil;
    [self.mapview takeSnapshotInRect:rect withCompletionBlock:^(UIImage *resultImage, NSInteger state) {
        screenShot = resultImage;
    }];
    
    UIImageWriteToSavedPhotosAlbum(screenShot, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

//分享给微信好友
- (void)shareViewDidClickShareToWechatFriendButton:(QLShareView *)shareView {
    [self shareToWechatWithScene:WXSceneSession];
}

//分享到微信朋友圈
- (void)shareViewDidClickShareToWechatTiemlineButton:(QLShareView *)shareView {
    [self shareToWechatWithScene:WXSceneTimeline];
}

- (void)shareToWechatWithScene:(int)scene {
    
    CGRect rect = CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT);
    __block UIImage *screenShot = nil;
    [self.mapview takeSnapshotInRect:rect withCompletionBlock:^(UIImage *resultImage, NSInteger state) {
        screenShot = resultImage;
    }];
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    //缩略图
    [message setThumbImage:[UIImage imageNamed:@"thumbImage"]];
    
    WXImageObject *imageObj = [WXImageObject object];
    imageObj.imageData = UIImagePNGRepresentation(screenShot);
    message.mediaObject = imageObj;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    BOOL flag = [WXApi sendReq:req];
    if (!flag) {
        QLLog(@"error");
    }
}
@end
