//
//  GCGameController.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/10/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCGameController.h"


@implementation GCGameController

@synthesize stopped, DELAY;

- (id) initWithGame: (GCGame *) _game andViewController: (GCGameViewController *) viewControl {
	if (self = [super init]) {
		game = _game;
		viewController = viewControl;
		turn = NO;
		stopped = NO;
		computerMove = nil;
		
		DELAY = 1.0;
		
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
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(goGameReady)
												 name: @"GameIsReady"
											   object: game];
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(end)
												 name: @"GameEncounteredProblem"
											   object: game];
	[game notifyWhenReady];
}

- (void) goGameReady {
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	if ([game player1Type] == HUMAN || [game player2Type] == HUMAN)
		[viewController.slider setEnabled: YES];
	if (![game primitive: [game getBoard]]) {
		PlayerType p = ([game currentPlayer] == PLAYER1) ? [game player1Type] : [game player2Type];
		if (p == HUMAN)
			[self takeHumanTurn];
		else if (!stopped) {
			[viewController.slider setEnabled: NO];
			runner = [[NSThread alloc] initWithTarget: self selector: @selector(takeComputerTurn) object: nil];
			[runner start];
		}
	} else {
		[viewController.slider setEnabled: YES];
		stopped = YES;
		[viewController.playPauseButton setImage: [UIImage imageNamed: @"Resume.png"]];
	}
}

- (void) end {
	[[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void) stop {
	stopped = YES;
	if (runner)
		[runner cancel];
	[game stop];
	[viewController.slider setEnabled: YES];
}

- (void) restart {
	stopped = NO;
	[game resume];
	if ([game player1Type] != HUMAN && [game player2Type] != HUMAN)
		[viewController.slider setEnabled: NO];
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(goGameReady)
												 name: @"GameIsReady"
											   object: game];
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(end)
												 name: @"GameEncounteredProblem"
											   object: game];
	[game notifyWhenReady];
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
	[viewController.slider setMaximumValue: position];
	[viewController.slider setValue: position];
	[self go];
}

- (void) takeComputerTurn {	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	PlayerType p = ([game currentPlayer] == PLAYER1) ? [game player1Type] : [game player2Type];
	if ([game playMode] == OFFLINE_UNSOLVED || p == COMPUTER_RANDOM) {
		NSLog(@"WTF");
		NSArray *legals = [game legalMoves];
		int choice = rand() % [legals count];
		
		[NSThread sleepForTimeInterval: DELAY];
		
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
		NSMutableArray *winRemotes = [[NSMutableArray alloc] init];
		NSMutableArray *loseRemotes = [[NSMutableArray alloc] init];
		NSMutableArray *tieRemotes = [[NSMutableArray alloc] init];
		NSMutableArray *drawRemotes = [[NSMutableArray alloc] init];
		for (int i = 0; i < [legals count]; i += 1) {
			NSString *val = (NSString *) [vals objectAtIndex: i];
			id move = [legals objectAtIndex: i];
			if ([val isEqual: @"WIN"]) [wins addObject: move];
			if ([val isEqual: @"LOSE"]) [loses addObject: move];
			if ([val isEqual: @"TIE"]) [ties addObject: move];
			if ([val isEqual: @"DRAW"]) [draws addObject: move];
			
			NSNumber *R = (NSNumber *) [remotes objectAtIndex: i];
			if ([val isEqual: @"WIN"]) [winRemotes addObject: R];
			if ([val isEqual: @"LOSE"]) [loseRemotes addObject: R];
			if ([val isEqual: @"TIE"]) [tieRemotes addObject: R];
			if ([val isEqual: @"DRAW"]) [drawRemotes addObject: R];
		}
		NSMutableArray *moveChoices = [[NSMutableArray alloc] initWithCapacity: [legals count]];
		if ([wins count] != 0) {
			int minRemote = 10000;
			for (id a_move in wins) {
				int index = [legals indexOfObject: a_move];
				minRemote = MIN(minRemote, [[remotes objectAtIndex: index] integerValue]);
			}
			NSNumber *R = [NSNumber numberWithInt: minRemote];
			int moveIndex = [winRemotes indexOfObject: R];
			while (moveIndex != NSNotFound) {
				[moveChoices addObject: [wins objectAtIndex: moveIndex]];
				moveIndex = [winRemotes indexOfObject: R inRange: NSMakeRange(moveIndex + 1, [winRemotes count] - moveIndex - 1)];
			}
		} else if ([ties count] != 0) {
			int maxRemote = -1;
			for (id a_move in ties) {
				int index = [legals indexOfObject: a_move];
				maxRemote = MAX(maxRemote, [[remotes objectAtIndex: index] integerValue]);
			}
			NSNumber *R = [NSNumber numberWithInt: maxRemote];
			int moveIndex = [tieRemotes indexOfObject: R];
			while (moveIndex != NSNotFound) {
				[moveChoices addObject: [ties objectAtIndex: moveIndex]];
				moveIndex = [tieRemotes indexOfObject: R inRange: NSMakeRange(moveIndex + 1, [tieRemotes count] - moveIndex - 1)];
			}
		} else if ([draws count] != 0) {
			NSLog(@"Some draw");
		} else {
			int maxRemote = -1;
			for (id a_move in loses) {
				int index = [legals indexOfObject: a_move];
				maxRemote = MIN(maxRemote, [[remotes objectAtIndex: index] integerValue]);
			}
			NSNumber *R = [NSNumber numberWithInt: maxRemote];
			int moveIndex = [tieRemotes indexOfObject: R];
			while (moveIndex != NSNotFound) {
				[moveChoices addObject: [ties objectAtIndex: moveIndex]];
				moveIndex = [tieRemotes indexOfObject: R inRange: NSMakeRange(moveIndex + 1, [tieRemotes count] - moveIndex - 1)];
			}
		}
		
		[NSThread sleepForTimeInterval: DELAY];
		
		int choice = rand() % [moveChoices count];
		[game doMove: [moveChoices objectAtIndex: choice]];
		
		[wins release];  [winRemotes release];
		[loses release]; [loseRemotes release];
		[ties release];  [tieRemotes release];
		[draws release]; [drawRemotes release];
		
		[legals release];
		[vals release];
		[remotes release];
	}
	
	[runner cancel];
	[runner release];
	runner = nil;
	
	position += 1;
	[viewController.slider setMaximumValue: position];
	[viewController.slider setValue: position];
	[pool drain];
	[self performSelectorOnMainThread: @selector(go) withObject: nil waitUntilDone: NO];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[super dealloc];
}

@end
