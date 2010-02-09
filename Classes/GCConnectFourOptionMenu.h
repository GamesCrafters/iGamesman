//
//  GCConnectFourOptionMenu.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 1/31/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCRulesDelegate.h"
#import "GCOptionMenu.h"
#import "GCConnectFour.h"

@class GCConnectFour;


@interface GCConnectFourOptionMenu : UITableViewController <GCOptionMenu> {
	GCConnectFour *game;
	int width, height, pieces;
	NSArray *headings;
	id <GCRulesDelegate> delegate;
}

@property (retain) id <GCRulesDelegate> delegate;

- (id) initWithGame: (GCConnectFour *) _game;
- (void) cancel;
- (void) done;
- (void) update: (UISegmentedControl *) sender;

@end
