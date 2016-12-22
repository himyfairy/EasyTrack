//
//  QLResultViewController.h
//  EasyTrack
//
//  Created by neo on 2016/12/22.
//  Copyright © 2016年 neo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface QLResultViewController : UIViewController
@property (strong, nonatomic) MAMapView *mapview;
@property (nonatomic, strong) NSMutableArray<CLLocation *> *coordinateArray;
@end
