//
//  GCGameController.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/10/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCGameController.h"


@implementation GCGameController

@synthesize stopped;

- (id) initWithGame: (GCGame *) _game andViewController: (GCGameViewController *) viewControl {
	if (self = [super init]) {
		game = _game;
		viewController = viewControl;
		turn = NO;
		stopped = NO;
		computerMove = nil;
		
		if ([game player1Type] != HUMAN && [game player2Type] != HUMAN)
			[viewController.playPauseButton setEnabled: YES];
		
		srand(time(NULL));
	}
	return self;
}

- (void) go {
	// Branch whether the current player is a human or a computer
	// If going to a computer move, make sure to thread it!
	if (![game isPrimitive: [game getBoard]]) {
		PlayerType p = ([game currentPlayer] == PLAYER1) ? [game player1Type] : [game player2Type];
		if (p == HUMAN)
			[self takeHumanTurn];
		else if (!stopped) {
			runner = [[NSThread alloc] initWithTarget: self selector: @selector(takeComputerTurn) object: nil];
			[runner start];
		}
	}
}

- (void) stop {
	stopped = YES;
	[[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void) restart {
	stopped = NO;
	[self go];
}

- (void) takeHumanTurn {
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(humanChoseMove:) 
												 name: @"HumanChoseMove" 
											   object: game];
	[game askUserForInput];
}

- (void) humanChoseMove: (NSNotification *) notification {
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	
	[game doMove: [game getHumanMove]];
	
	[game stopUserInput];
	[self go];
}

- (void) takeComputerTurn {	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSArray *legals = [game legalMoves];
	int choice = rand() % [legals count];
	
	[NSThread sleepForTimeInterval: 1.0];
	
	[game doMove: [legals objectAtIndex: choice]];
	
	[runner cancel];
	[runner release];
	runner = nil;
	
	[pool release];
	[self performSelectorOnMainThread: @selector(go) withObject: nil waitUntilDone: NO];
}

- (void) dealloc {
	[super dealloc];
}

@end
