//
//  GamesmanAppDelegate.m
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/2/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import "GamesmanAppDelegate.h"
#import "GCAboutController.h"
#import "GCDiscoverListController.h"
#import "GCGameListController.h"

@implementation GamesmanAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	tBarControl = [[UITabBarController alloc] init];
	
	// View Controller #1 : List of games
	GCGameListController *listController = [[GCGameListController alloc] initWithStyle: UITableViewStylePlain];
	UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController: listController];
	nav1.tabBarItem.image = [UIImage imageNamed: @"Play.png"];
	nav1.navigationBar.tintColor = [UIColor colorWithRed: 0 green: 0 blue: 139.0/256.0 alpha: 1];
	[listController release];
	
	// View Controller #2 : List of other games
	GCDiscoverListController *discoverControl = [[GCDiscoverListController alloc] initWithStyle: UITableViewStylePlain];
	UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController: discoverControl];
	nav2.tabBarItem.image = [UIImage imageNamed: @"Discover.png"];
	nav2.navigationBar.tintColor = [UIColor colorWithRed: 0 green: 0 blue: 139.0/256.0 alpha: 1];
	[discoverControl release];
	
	// View Controller #3 : About Gamesman
	GCAboutController *aboutControl = [[GCAboutController alloc] initWithNibName: @"About" bundle: nil];
	UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController: aboutControl];
	[aboutControl release];
	nav3.tabBarItem.image = [UIImage imageNamed: @"About.png"];
	nav3.navigationBar.tintColor = [UIColor colorWithRed: 0 green: 0 blue: 139.0/256.0 alpha: 1];
	
	// Give the Tab Bar the three view controllers
	NSArray *viewControllers = [[NSArray alloc] initWithObjects: nav1, nav2, nav3, nil];
	[nav1 release];
	[nav2 release];
	[nav3 release];
	tBarControl.viewControllers = viewControllers;
	[viewControllers release];
	
	// Add the Tab Bar to the window
	[window addSubview: tBarControl.view];	
	
    [window makeKeyAndVisible];
}


- (void)dealloc {
	[tBarControl release];
    [window release];
    [super dealloc];
}


@end
