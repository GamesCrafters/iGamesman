//
//  GCConnectFourViewController.h
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/3/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCConnectFourService.h"


/**
 Manages the Connect-4 board view and maintains the game play.
 */
@interface GCConnectFourViewController : UIViewController {
	NSMutableArray *board;			///< Represents the current state of the Connect-4 board
	UILabel *descLabel;				///< Displays messages to the user
	NSArray *colHeads;				///< Contains the buttons along the top row of the board
	GCConnectFourService *service;  ///< Handles the server requests
	int width;						///< The number of columns
	int height;						///< The number of rows
	int pieces;						///< The number in a row needed to win
	BOOL turn;						///< Keeps track of whose turn it is
	BOOL showPredictions;			///< Keeps track of whether or not to display predictions
	BOOL showMoveValues;			///< Keeps track of whether or not to display move values
}


/// The designated initializer
- (id) initWithWidth: (NSInteger) _width height: (NSInteger) _height pieces: (NSInteger) _pieces;

/// Handles the changing of appearance options
- (void) updateDisplayOptions: (NSDictionary *) options;

/// Receives the button taps and interprets them as moves
- (void) tapped: (UIButton *) sender;

/// Update the message label and the display of move values
- (void) updateLabels;

/// Disables all of the board's buttons
- (void) disableButtons;

/// Returns a UIColor for a given game value
- (UIColor *) colorForValue: (NSString *) value;

@end
