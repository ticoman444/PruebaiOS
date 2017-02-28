//
//  AppDelegate.m
//  Prueba_iOS_ObjC
//
//  Created by Humberto Cetina on 2/25/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)    splitViewController:(UISplitViewController *)splitViewController
collapseSecondaryViewController:(UIViewController *)secondaryViewController
      ontoPrimaryViewController:(UIViewController *)primaryViewController{
    
    if (primaryViewController.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact)
    {
        NSLog(@"primaryViewController: compact");
    }
    
    if (primaryViewController.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular)
    {
        NSLog(@"primaryViewController: regular");
    }
    
    if (primaryViewController.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        NSLog(@"primaryViewController: iPhone");
    }
    
    if (primaryViewController.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        NSLog(@"primaryViewController: iPad");
    }
    
    NSLog(@"primaryViewController: %f", primaryViewController.traitCollection.displayScale);
    
    if (secondaryViewController.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact)
    {
        NSLog(@"secondaryViewController: compact");
    }
    
    if (secondaryViewController.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular)
    {
        NSLog(@"secondaryViewController: regular");
    }
    
    if (secondaryViewController.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        NSLog(@"secondaryViewController: iPhone");
    }
    
    if (secondaryViewController.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        NSLog(@"secondaryViewController: iPad");
    }
    
    NSLog(@"secondaryViewController: %f", secondaryViewController.traitCollection.displayScale);
    NSLog(@"-------------------------------------------------------------------------");
    
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    if (_window.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPad ||
        (_window.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPhone && _window.traitCollection.displayScale == 3.0))
    {
        return UIInterfaceOrientationMaskAll;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UISplitViewController *split = (UISplitViewController *)_window.rootViewController;
    split.preferredDisplayMode =  UISplitViewControllerDisplayModePrimaryOverlay;
    split.delegate = self;
    return YES;
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
