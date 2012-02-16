//
//  GCConnectFourViewController.h
//  iGamesman
//
//  Created by Jordan Salter on 26/10/2011.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCConnectFour.h"
#import "GCConnectFourPosition.h"
#import "GCPlayer.h"
#import "GCJSONService.h"

@class GCConnectFour;

@interface GCConnectFourViewController : UIViewController {
	UIActivityIndicatorView *spinner;
	NSThread *waiter;
	NSTimer *timer;
	
	UILabel *message;
	
	GCJSONService *service;
	GCConnectFour *game;			///< The Connect-4 controlling object for this VC
	int width;						///< The number of columns
	int height;						///< The number of rows
	int pieces;						///< The number in a row needed to win
	BOOL touchesEnabled;
    
    CGRect viewRect;
}

@property (nonatomic, assign) BOOL touchesEnabled;

/// The designated initializer
- (id) initWithGame: (GCConnectFour *) _game frame: (CGRect) rect;

/// Receiver of button taps. Simply converts the button into a move and sends it to GAME
- (void) tapped: (UIButton *) sender;
- (void) updateServerDataWithService: (GCJSONService *) service;
- (void) fetchNewData: (BOOL) buttonsOn;
- (void) fetchFinished: (BOOL) buttonsOn;
- (void) timedOut: (NSTimer *) theTimer;
- (void) updateLabels;
- (void) displayPrimitive;
- (void) doMove: (NSNumber *) move;
- (void) undoMove: (NSNumber *) move;
//- (void) disableButtons;
//- (void) enableButtons;
- (void) stop;

@end