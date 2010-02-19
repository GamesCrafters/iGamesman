//
//  GCGameOptionsController.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 10/30/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCGame.h"

@protocol OptionPanelDelegate;

/**
 The in-game option panel for adjusting gameplay settings,
 such as displaying move values and predictions. Currently
 contains a toggle for move values and a toggle for predictions.
 */
@interface GCGameOptionsController : UITableViewController {
	UIInterfaceOrientation orientation;
	id <OptionPanelDelegate> delegate;
	PlayMode mode;
}

/// This view's delegate, to have this view dismissed.
@property (nonatomic, assign) id <OptionPanelDelegate> delegate;
@property (nonatomic, assign) PlayMode mode;

- (id) initWithOrientation: (UIInterfaceOrientation) _orientation;

/// Report to delegate that the user tapped DONE
- (void) done;

/// Report to delegate that the user tapped CANCEL
- (void) cancel;

@end


/**
 Protocol for handling option panel actions and retrieving
 the current choices of predictions ON/OFF and move values ON/OFF.
 */
@protocol OptionPanelDelegate

/** 
 @brief Called when the option panel is finished and the user tapped
 the DONE button, passing on the new option choices.
 */
- (void) optionPanelDidFinish: (GCGameOptionsController *) controller 
				  predictions: (BOOL) predictions 
				   moveValues: (BOOL) moveValues;

/**
 @brief Called when the option panel is finished and the user
 tapped the CANCEL button
 */
- (void) optionPanelDidCancel: (GCGameOptionsController *) controller;

/// Return the current "predictions" setting
- (BOOL) showingPredictions;

/// Return the current "move values" setting
- (BOOL) showingMoveValues;

@end