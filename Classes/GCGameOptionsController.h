//
//  GCGameOptionsController.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 10/30/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionPanelDelegate;


@interface GCGameOptionsController : UITableViewController {
	id <OptionPanelDelegate> delegate;
}

@property (nonatomic, assign) id <OptionPanelDelegate> delegate;

@end


@protocol OptionPanelDelegate

- (void) optionPanelDidFinish: (GCGameOptionsController *) controller 
				  predictions: (BOOL) predictions 
				   moveValues: (BOOL) moveValues;
- (void) optionPanelDidCancel: (GCGameOptionsController *) controller;
- (BOOL) showingPredictions;
- (BOOL) showingMoveValues;

@end

