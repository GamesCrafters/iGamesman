//
//  GCConnectFourViewController.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/5/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCConnectFour.h"
#import "GCConnectFourService.h"


@interface GCConnectFourViewController : UIViewController {
	UIActivityIndicatorView *spinner;
	NSThread *waiter;
	NSTimer *timer;
	
	UILabel *message;
	
	GCConnectFourService *service;
	GCConnectFour *game;			///< The Connect-4 controlling object for this VC
	int width;						///< The number of columns
	int height;						///< The number of rows
	int pieces;						///< The number in a row needed to win
	BOOL buttonsEnabled;
}

@property (nonatomic, assign) BOOL buttonsEnabled;

/// The designated initializer
- (id) initWithGame: (GCConnectFour *) _game;

/// Receiver of button taps. Simply converts the button into a move and sends it to GAME
- (void) tapped: (UIButton *) sender;
- (void) updateServerDataWithService: (GCConnectFourService *) service;
- (void) fetchNewData: (BOOL) buttonsOn;
- (void) fetchFinished: (BOOL) buttonsOn;
- (void) timedOut: (NSTimer *) theTimer;
- (void) updateLabels;
- (void) doMove: (NSString *) move;
- (void) disableButtons;
- (void) enableButtons;

@end
