//
//  GCAppDelegate.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 12/29/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>


@class GCCarouselViewController;


@interface GCAppDelegate : UIResponder <UIApplicationDelegate>
{
    GCCarouselViewController *rootViewController;
}

@property (strong, nonatomic) UIWindow *window;

@end
