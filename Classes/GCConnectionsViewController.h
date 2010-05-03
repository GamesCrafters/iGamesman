//
//  GCConnectionsViewController.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/21/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCConnections.h"


@interface GCConnectionsViewController : UIViewController {
	UILabel *message;
	
	GCConnections *game;
	int size;
}

- (id) initWithGame: (GCConnections *) _game;
- (void) updateLabels;
- (void) displayPrimitive;
- (void) doMove: (NSNumber *) move;

/// Convenience method for disabling all of the board's buttons.
- (void) disableButtons;
/// Convenience method for enabling all of the board's buttons.
- (void) enableButtons;

@end
