//
//  GamesmanAppDelegate.h
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/2/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The application delegate. Lays out the initial view hierarchy. 
 The applicationDidFinishLaunching method starts the app up by
 initializing each of the three main view controllers, each of
 which is placed in a navigation controller, then adding them 
 to the tab bar, then adding the tab bar to the window.
 */
@interface GamesmanAppDelegate : NSObject <UIApplicationDelegate> {
	/// Manages the three main views
	UITabBarController *tBarControl;
	/// The main window
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

