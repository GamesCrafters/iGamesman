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

#ifndef GCGameController
#import "GCGameController.h"
#endif

@protocol FlipsideViewControllerDelegate;

@class GCGameController;

/**
 The main game view controller. Essentially a container for the
 game's view controller. Manages the toolbar along the bottom of the screen.
 */
@interface GCGameViewController : UIViewController <OptionPanelDelegate> {
	id <FlipsideViewControllerDelegate> delegate;
	UIViewController *gameView;
	GCGameController *gameControl;
	GCGame *game;
	PlayMode gameMode;
	
	UIBarButtonItem *playPauseButton;
	UISlider *slider;
	
	BOOL wasPaused;
}

/// This view's delegate, to have this view dismissed
@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *playPauseButton;
@property (nonatomic, retain) IBOutlet UISlider *slider;

- (id)initWithGame: (GCGame *) _game andPlayMode: (PlayMode) mode;

- (IBAction) undoRedoSliderChanged: (UISlider *) sender;

/// Called when the user taps the back button in the toolbar
- (IBAction) done;

/// Called when the user taps the play/pause button in the toolbar
- (IBAction) playPause;

- (IBAction) stepForward;
- (IBAction) stepBackward;

/// Called when the user taps the options button in the toolbar
- (IBAction) changeOptions;

- (GCGameController *) gameController;

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

