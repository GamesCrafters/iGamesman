//
//  GCGameViewController.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 10/29/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCGameOptionsController.h"

@protocol FlipsideViewControllerDelegate;


/**
 The main game view controller. Essentially a container for the
 game's view controller. Manages the toolbar along the bottom of the screen.
 */
@interface GCGameViewController : UIViewController <OptionPanelDelegate> {
	BOOL showPredictions;		///< YES if predicitons are ON, NO if predictions are OFF
	BOOL showMoveValues;		///< YES if move values are ON, NO if move values are OFF
	UIViewController *gameView; ///< The game-specific view controller
	UIBarButtonItem *stepBack;
	UIBarButtonItem *stepForward;
	id <FlipsideViewControllerDelegate> delegate;
	id game;
}

/// This view's delegate, to have this view dismissed
@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *stepBack, *stepForward;

- (id)initWithGame: (id) _game;

/// Called when the user taps the back button in the toolbar
- (IBAction) done;

/// Called when the user taps the options button in the toolbar
- (IBAction) changeOptions;

@end


/**
 Protocol for handling the game view modally.
 */
@protocol FlipsideViewControllerDelegate

/** 
 @brief Called when the user taps the back button. Expectation
 is that this dismisses the game view.
 */
- (void) flipsideViewControllerDidFinish: (GCGameViewController *) controller;

@end

