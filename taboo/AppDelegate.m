//
//  AppDelegate.m
//  taboo
//
//  Created by Stephen Derico on 1/26/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import "AppDelegate.h"
#import "Crittercism.h"
#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
     [[LocalyticsSession sharedLocalyticsSession] startSession:@"a7df0dbe7259339d7882f6f-ca6ed5aa-4d7a-11e1-a7f3-008545fe83d2"];

    
    [Crittercism initWithAppID: @"4f2a4f51b0931507690003f3"
                        andKey:@"4f2a4f51b0931507690003f3pih3u927"
                     andSecret:@"qkkdns13unaiqihjdgj28esvbhtf9l4o"];
    
   


    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
     UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[LocalyticsSession sharedLocalyticsSession] resume];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

@end
