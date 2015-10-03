//
//  AppDelegate.m
//  PhoneDoodle
//
//  Created by Dawson Walker on 2015-08-02.
//  Copyright (c) 2015 Rise Digital. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "DCIntrospect-ARC/DCIntrospect.h"
#import "LogInViewController.h"
#import "MainMenuViewController.h"
#import <Parse/Parse.h>
#import <VungleSDK/VungleSDK.h>
#import <StartApp/StartApp.h>
#import <AFNetworking/AFNetworking.h>




#define ROOTVIEW [[[UIApplication sharedApplication] keyWindow] rootViewController]
@interface AppDelegate ()

@end

@implementation AppDelegate

-(BOOL) isInternetReachable
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:2];
    // Override point for customization after application launch.
    //ViewController *viewController = [ViewController new];
    STAStartAppSDK* sdk = [STAStartAppSDK sharedInstance];
    sdk.devID = @"107449490";
    sdk.appID = @"207921218";
    
    NSString* appID = @"com.RiseDigital.PhoneDoodle";
    VungleSDK* sdk2 = [VungleSDK sharedSDK];
    // start vungle publisher library
    [sdk2 startWithAppId:appID];
    [[VungleSDK sharedSDK] setDelegate:nil];
    // Initialize Parse.
    [Parse setApplicationId:@"kbBkwkM3GCxCZrHxiFg4gikIiHG6hO04fVN30tRw"
                  clientKey:@"kgk8vBjiex1oJ0LV7vRlkJbChoS6htBgFJTlxUAI"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        NSLog(@"Reachability changed: %@", AFStringFromNetworkReachabilityStatus(status));
        
        
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                // -- Reachable -- //
                NSLog(@"Reachable");
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                // -- Not reachable -- //
                
                NSLog(@"Not Reachable");
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Sorry!" message:@"Please make sure you are connected to the internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                [alertView show];
                break;
        }
        
    }];
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];

    //UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    MainMenuViewController *viewController = [MainMenuViewController new];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    [self setupDevelopmentEnvironment];
    //if User
    if(![PFUser currentUser]){
        LogInViewController *loginViewController = [LogInViewController new];
        [self.window.rootViewController presentViewController:loginViewController animated:YES completion:nil];
    }
    else{
       // NewChainViewController * newChainController = [NewChainViewController new];
        //[self.window.rootViewController presentViewController:newChainController animated:YES completion:nil];
    }
    //[vc presentViewController:viewController animated:YES completion:nil];
    //[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:viewController animated:YES completion:^{}];
    return YES;
}
- (void)setupDevelopmentEnvironment {
#if TARGET_IPHONE_SIMULATOR
    [[DCIntrospect sharedIntrospector] start];
#endif
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [PFQuery clearAllCachedResults];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
