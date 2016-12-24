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
#import "WXApi.h"

#define AMapServiceKey @"13d69cc720c91071f56b686f4ac6fd09"
#define WechatID @"wx93019c4014e0c0aa"
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //配置使用HTTPS
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    
    //配置apikey
    [AMapServices sharedServices].apiKey = AMapServiceKey;
    
    //向微信注册
    [WXApi registerApp:WechatID];
    
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT)];
    
    QLHomeViewController *homeVC = [[QLHomeViewController alloc] init];
    QLNavigationController *navVC = [[QLNavigationController alloc] initWithRootViewController:homeVC];
    self.window.rootViewController = navVC;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - WXApiDelegate
- (void)onReq:(BaseReq *)req {
    QLLog(@"%s", __func__);
}

- (void)onResp:(BaseResp *)resp {
    QLLog(@"%s", __func__);
}

@end
