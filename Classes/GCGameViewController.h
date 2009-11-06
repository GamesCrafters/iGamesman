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


@interface GCGameViewController : UIViewController <OptionPanelDelegate> {
	BOOL showPredictions;
	BOOL showMoveValues;
	UIViewController *gameView;
	id <FlipsideViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;

- (IBAction) done;
- (IBAction) changeOptions;

@end

@protocol FlipsideViewControllerDelegate

- (void) flipsideViewControllerDidFinish: (GCGameViewController *) controller;

@end

