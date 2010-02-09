//
//  GamesmanMobileAppDelegate.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 1/29/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GamesmanMobileAppDelegate : NSObject <UIApplicationDelegate> {
	UITabBarController *tBarControl;
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

