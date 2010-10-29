//
//  GCTicTacToeViewController.h
//  GamesmanMobile
//
//  Created by Class Account on 10/8/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCTicTacToe.h"


@interface GCTicTacToeViewController : UIViewController {
	GCTicTacToe *game;
	
	BOOL touchesEnabled;
}

@property (nonatomic, assign) BOOL touchesEnabled;

- (id) initWithGame: (GCTicTacToe *) _game;
- (void) doMove: (NSNumber *) move;
- (void) undoMove: (NSNumber *) move;

@end
