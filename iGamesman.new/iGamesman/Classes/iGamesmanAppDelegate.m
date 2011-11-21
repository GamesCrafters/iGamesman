//
//  iGamesmanAppDelegate.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 9/7/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import "iGamesmanAppDelegate.h"

#import "GCCarouselViewController.h"

@implementation iGamesmanAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /* Create the background image */
    UIImageView *backgroundView;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        backgroundView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"Patchwork@2x.png"]];
        backgroundView.frame = CGRectMake(0, 0, 768, 1024);
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        backgroundView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"Patchwork.png"]];
        backgroundView.frame = CGRectMake(0, 0, 320, 480);
    }
    else
    {
        backgroundView = nil;
    }
    
    
    /* Add it to the window so it appears everywhere in the app */
    [self.window addSubview: backgroundView];
    [backgroundView release];
    
    
    /* Create the root view controller and add its view to the window */
    GCCarouselViewController *carouselViewController = [[GCCarouselViewController alloc] init];
    
    [self.window addSubview: carouselViewController.view];
    
#warning TODO: Stop leaking the view controller
        
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
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
