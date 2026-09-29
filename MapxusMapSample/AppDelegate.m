//
//  AppDelegate.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/7/18.
//  Copyright © 2018 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "AppDelegate.h"
#import <MapxusBaseSDK/MapxusBaseSDK.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "MapxusMapSample-Swift.h"

@interface AppDelegate () <MXMServiceDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [MapViewNetworkProtocolConfigurator configureIfNeeded];
    [IQKeyboardManager sharedManager].enable = YES;
    // Creating a Mapxus Core Service shared instance
    MXMMapServices *services = [MXMMapServices sharedServices];
    // Setting up Mapxus Core Service delegate
    services.delegate = self;
    // Sign up for Mapxus mapping service
    [services registerWithApiKey:MAPXUS_KEY secret:MAPXUS_SECRET];
    
    return YES;
}

- (UISceneConfiguration *)application:(UIApplication *)application
        configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession
        options:(UISceneConnectionOptions *)options {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration"
                                          sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
}


/// Mapxus Map Service authentication results successful callback
- (void)registerMXMServiceSuccess {
    NSLog(@"Authorization Success");
}

/// Mapxus Map Service authentication results failure callback
- (void)registerMXMServiceFailWithError:(NSError *)error {
    NSLog(@"Authorization failure：%@", error);
}

@end
