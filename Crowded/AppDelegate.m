//
//  AppDelegate.m
//  Crowded
//
//  Created by Matt Bridges on 6/7/14.
//  Copyright (c) 2014 Intrepid. All rights reserved.
//

#import "AppDelegate.h"
#import "Common.h"
#import "CDBeaconManager.h"

@interface AppDelegate ()
            
@property (nonatomic) CDBeaconManager *beaconManager;
@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setupAppearance];
    self.beaconManager = [[CDBeaconManager alloc] init];
    
    
    
    return YES;
}

- (void)setupAppearance {
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xDC6341)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName: [UIFont fontWithName:@"Archer-Bold" size:18.0],
                                                           NSForegroundColorAttributeName: UIColorFromRGB(0x232323)
                                                           }];
    
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Edmondsans-Medium" size:11.0]
                                                       
                                                         } forState:UIControlStateNormal];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"selected_tab.png"]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
