//
//  GCVVHViewController.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 6/26/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCGame.h"
#import "GCVVHView.h"


@interface GCVVHViewController : UIViewController <UIScrollViewDelegate> {
	UIInterfaceOrientation orientation;
	NSArray *data;
	GCGame *game;
	
	GCVVHView *vvhView;
}

@property (nonatomic, retain) GCGame *game;

- (id) initWithVVHData: (NSArray *) _data andOrientation: (UIInterfaceOrientation) orient;

@end
