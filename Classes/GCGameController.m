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
		
		if ([game player1Type] != HUMAN && [game player2Type] != HUMAN) {
			[viewController.playPauseButton setEnabled: YES];
			[viewController.slider setEnabled: NO];
		}
		
		srand(time(NULL));
		
		position = 0;
	}
	return self;
}

- (void) go {
	[viewController.slider setMaximumValue: position];
	[viewController.slider setValue: position];
	if ([game player1Type] == HUMAN || [game player2Type] == HUMAN)
		[viewController.slider setEnabled: YES];
	if (![game isPrimitive: [game getBoard]]) {
		PlayerType p = ([game currentPlayer] == PLAYER1) ? [game player1Type] : [game player2Type];
		if (p == HUMAN)
			[self takeHumanTurn];
		else if (!stopped) {
			[viewController.slider setEnabled: NO];
			runner = [[NSThread alloc] initWithTarget: self selector: @selector(takeComputerTurn) object: nil];
			[runner start];
		}
	}
}

- (void) stop {
	stopped = YES;
	[viewController.slider setEnabled: YES];
	[[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void) restart {
	stopped = NO;
	if ([game player1Type] != HUMAN && [game player2Type] != HUMAN)
		[viewController.slider setEnabled: NO];
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
	position += 1;
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
	position += 1;
	[self performSelectorOnMainThread: @selector(go) withObject: nil waitUntilDone: NO];
}

- (void) dealloc {
	[super dealloc];
}

@end
