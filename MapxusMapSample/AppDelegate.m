//
//  AppDelegate.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/7/18.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "AppDelegate.h"
#import <MapxusBaseSDK/MapxusBaseSDK.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

@interface AppDelegate () <MXMServiceDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [IQKeyboardManager sharedManager].enable = YES;
    // Creating a Mapxus Core Service shared instance
    MXMMapServices *services = [MXMMapServices sharedServices];
    // Setting up Mapxus Core Service delegate
    services.delegate = self;
    // Sign up for Mapxus mapping service
    [services registerWithApiKey:@"your apiKey" secret:@"your secret"];

    [self monitorNetwork];
    
    return YES;
}


/// Mapxus Map Service authentication results successful callback
- (void)registerMXMServiceSuccess {
    NSLog(@"Authorization Success");
}

/// Mapxus Map Service authentication results failure callback
- (void)registerMXMServiceFailWithError:(NSError *)error {
    NSLog(@"Authorization failure：%@", error);
}

- (void)monitorNetwork {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Networking Error" message:@"Go to open the network." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:openAction];
            [alert addAction:cancelAction];
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
