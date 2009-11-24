//
//  GCGameMenuController.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 10/14/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCGameViewController.h"
#import "GCNameChangeController.h"
#import "GCRulesDelegate.h"

/**
 The "pre-game" menu for any game. Currently just provides a button to
 start a game of Connect-4.
 */
@interface GCGameMenuController : UITableViewController <FlipsideViewControllerDelegate, NameChangeDelegate, GCRulesDelegate> {
	NSArray  *cellLabels; ///< Contains the text of each of the cells in the table view
	NSString *p1Name;	  ///< Player 1's name
	NSString *p2Name;	  ///< Player 2's name
	id game;
}

/// The designated initializer
- (id)initWithGame: (id) _game andName: (NSString *) gameName;

@end
