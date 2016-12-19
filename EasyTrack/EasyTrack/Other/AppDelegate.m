//
//  AppDelegate.m
//  EasyTrack
//
//  Created by neo on 2016/11/14.
//  Copyright © 2016年 neo. All rights reserved.
//

#import "AppDelegate.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "QLNavigationController.h"
#import "QLHomeViewController.h"

#define AMapServiceKey @"13d69cc720c91071f56b686f4ac6fd09"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [AMapServices sharedServices].apiKey = AMapServiceKey;
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT)];
    
    QLHomeViewController *homeVC = [[QLHomeViewController alloc] init];
    QLNavigationController *navVC = [[QLNavigationController alloc] initWithRootViewController:homeVC];
    self.window.rootViewController = navVC;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
