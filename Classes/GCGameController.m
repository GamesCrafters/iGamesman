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
	
	PlayerType p = ([game currentPlayer] == PLAYER1) ? [game player1Type] : [game player2Type];
	if ([game playMode] == OFFLINE_UNSOLVED || p == COMPUTER_RANDOM) {
		NSArray *legals = [game legalMoves];
		int choice = rand() % [legals count];
		
		[NSThread sleepForTimeInterval: 1.0];
		
		[game doMove: [legals objectAtIndex: choice]];
	} else {
		NSArray *legals = [game legalMoves];
		NSMutableArray *vals = [[NSMutableArray alloc] init];
		NSMutableArray *remotes = [[NSMutableArray alloc] init];
		for (id move in legals) {
			[vals addObject: [[game getValueOfMove: move] uppercaseString]];
			[remotes addObject: [NSNumber numberWithInteger: [game getRemotenessOfMove: move]]];
		}
		
		NSMutableArray *wins = [[NSMutableArray alloc] init];
		NSMutableArray *loses = [[NSMutableArray alloc] init];
		NSMutableArray *ties = [[NSMutableArray alloc] init];
		NSMutableArray *draws = [[NSMutableArray alloc] init];
		for (int i = 0; i < [legals count]; i += 1) {
			NSString *val = (NSString *) [vals objectAtIndex: i];
			NSNumber *num = [NSNumber numberWithInt: i];
			if ([val isEqual: @"WIN"]) [wins addObject: num];
			if ([val isEqual: @"LOSE"]) [loses addObject: num];
			if ([val isEqual: @"TIE"]) [ties addObject: num];
			if ([val isEqual: @"DRAW"]) [draws addObject: num];
		}
		NSLog(@"W: %@\nL: %@\nT: %@", wins, loses, ties);
		id move;
		if ([wins count] != 0) {
			int minRemote = 10000;
			for (NSNumber *num in wins) {
				minRemote = MIN(minRemote, [[remotes objectAtIndex: [num integerValue]] integerValue]);
			}
			move = [legals objectAtIndex: [remotes indexOfObject: [NSNumber numberWithInt: minRemote]]];
		} else if ([ties count] != 0) {
			int maxRemote = -1;
			for (NSNumber *num in ties) {
				maxRemote = MAX(maxRemote, [[remotes objectAtIndex: [num integerValue]] integerValue]);
			}
			move = [legals objectAtIndex: [remotes indexOfObject: [NSNumber numberWithInt: maxRemote]]];
		} else if ([draws count] != 0) {
			move = @"Some draw";
		} else {
			int maxRemote = -1;
			for (NSNumber *num in loses) {
				maxRemote = MAX(maxRemote, [[remotes objectAtIndex: [num integerValue]] integerValue]);
			}
			move = [legals objectAtIndex: [remotes indexOfObject: [NSNumber numberWithInt: maxRemote]]];
		}
		
		[game doMove: move];
	}
	
	[runner cancel];
	[runner release];
	runner = nil;
	
	[pool release];
	position += 1;
	[self performSelectorOnMainThread: @selector(go) withObject: nil waitUntilDone: NO];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[super dealloc];
}

@end
