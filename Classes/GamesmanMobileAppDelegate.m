//
//  GamesmanMobileAppDelegate.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 1/29/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GamesmanMobileAppDelegate.h"
#import "GCGameListController.h"
#import "GCAboutController.h"

@implementation GamesmanMobileAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	tBarControl = [[UITabBarController alloc] init];
	
	// View Controller #1 : List of games
	GCGameListController *listController = [[GCGameListController alloc] initWithStyle: UITableViewStylePlain];
	UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController: listController];
	nav1.tabBarItem.image = [UIImage imageNamed: @"Play.png"];
	nav1.navigationBar.tintColor = [UIColor colorWithRed: 0 green: 0 blue: 139.0/256.0 alpha: 1];
	[listController release];
	
	// View Controller #2 : List of puzzles
	// COMING SOON
	
	// View Controller #3 : About Gamesman
	GCAboutController *aboutControl = [[GCAboutController alloc] initWithNibName: @"About" bundle: nil];
	UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController: aboutControl];
	[aboutControl release];
	nav3.tabBarItem.image = [UIImage imageNamed: @"About.png"];
	nav3.navigationBar.tintColor = [UIColor colorWithRed: 0 green: 0 blue: 139.0/256.0 alpha: 1];
	
	// Give the Tab Bar the three view controllers
	NSArray *viewControllers = [[NSArray alloc] initWithObjects: nav1, nav3, nil];
	[nav1 release];
	[nav3 release];
	tBarControl.viewControllers = viewControllers;
	[viewControllers release];
	
	// Add the Tab Bar to the window
	[window addSubview: tBarControl.view];
	
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
	[tBarControl release];
    [window release];
    [super dealloc];
}


@end
