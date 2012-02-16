//
//  GCTicTacToeViewController.h
//  GamesmanMobile
//
//  Created by Class Account on 10/8/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCTicTacToe.h"
#import "GCJSONService.h"


@interface GCTicTacToeViewController : UIViewController {
	GCTicTacToe *game;
	GCJSONService *service;
	
	NSThread *waiter;
	NSTimer *timer;
	
	UILabel *messageLabel;
	UIActivityIndicatorView *spinner;
	
	BOOL touchesEnabled;
}

@property (nonatomic, assign) BOOL touchesEnabled;

- (id) initWithGame: (GCTicTacToe *) _game;
- (void) updateServerDataWithService: (GCJSONService *) _service;
- (void) updateDisplay;
- (void) doMove: (NSNumber *) move;
- (void) undoMove: (NSNumber *) move;

@end
