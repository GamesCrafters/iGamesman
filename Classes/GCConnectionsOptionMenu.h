//
//  GCConnectionsOptionMenu.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/12/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCRulesDelegate.h"
#import "GCOptionMenu.h"
#import "GCConnections.h"

@class GCConnections;


@interface GCConnectionsOptionMenu : UITableViewController <GCOptionMenu> {
	GCConnections *game;
	int size;
	id <GCRulesDelegate> delegate;
	BOOL misere;
}

@property (nonatomic, retain) id <GCRulesDelegate> delegate;

- (id) initWithGame: (GCConnections *) _game;
- (void) cancel;
- (void) done;

@end
