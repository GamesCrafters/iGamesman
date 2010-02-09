//
//  GCGameViewController.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 10/29/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCGame.h"
#import "GCGameOptionsController.h"

@protocol FlipsideViewControllerDelegate;


/**
 The main game view controller. Essentially a container for the
 game's view controller. Manages the toolbar along the bottom of the screen.
 */
@interface GCGameViewController : UIViewController <OptionPanelDelegate> {
	id <FlipsideViewControllerDelegate> delegate;
	UIViewController *gameView;
	GCGame *game;
}

/// This view's delegate, to have this view dismissed
@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;

- (id)initWithGame: (GCGame *) _game andPlayMode: (PlayMode) mode;

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

