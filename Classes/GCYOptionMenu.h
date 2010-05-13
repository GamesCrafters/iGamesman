//
//  GCYOptionMenu.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/5/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCRulesDelegate.h"
#import "GCOptionMenu.h"
#import "GCYGame.h"

@class GCYGame;


@interface GCYOptionMenu : UITableViewController <GCOptionMenu> {
	id <GCRulesDelegate> delegate;
	GCYGame *game;
	int layers;
	int innerTriangleLength;
}

@property (nonatomic, retain) id <GCRulesDelegate> delegate;

- (id) initWithGame: (GCYGame *) _game;
- (void) cancel;
- (void) done;
- (void) updateLayers: (UISegmentedControl *) sender;
- (void) updateTriangle: (UISegmentedControl *) sender;

@end
