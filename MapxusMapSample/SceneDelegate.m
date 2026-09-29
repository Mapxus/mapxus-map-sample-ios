#import "SceneDelegate.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

@interface SceneDelegate ()

@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene
        willConnectToSession:(UISceneSession *)session
        options:(UISceneConnectionOptions *)connectionOptions {
    if (![scene isKindOfClass:[UIWindowScene class]]) {
        return;
    }

    [self monitorNetwork];
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:nil];
}

- (void)sceneDidBecomeActive:(UIScene *)scene {
}

- (void)sceneWillResignActive:(UIScene *)scene {
}

- (void)sceneWillEnterForeground:(UIScene *)scene {
}

- (void)sceneDidEnterBackground:(UIScene *)scene {
}

- (void)monitorNetwork {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status != AFNetworkReachabilityStatusNotReachable) {
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *viewController = self.window.rootViewController;
            if (viewController == nil) {
                return;
            }

            while (viewController.presentedViewController != nil) {
                viewController = viewController.presentedViewController;
            }

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Networking Error"
                                                                           message:@"Go to open the network."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:nil];
            [alert addAction:openAction];
            [alert addAction:cancelAction];
            [viewController presentViewController:alert animated:YES completion:nil];
        });
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

@end