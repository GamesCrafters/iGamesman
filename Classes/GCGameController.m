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
@synthesize position, maxPosition;
@synthesize game;

- (id) initWithGame: (GCGame *) _game andViewController: (GCGameViewController *) viewControl {
	if (self = [super init]) {
		game = _game;
		viewController = viewControl;
		turn = NO;
		stopped = NO;
		computerMove = nil;
		
		moveStack = [[NSMutableArray alloc] init];
		undoStack = [[NSMutableArray alloc] init];
		dataHistoryStack = [[NSMutableArray alloc] init];
		dataUndoStack    = [[NSMutableArray alloc] init];
		
		DELAY = 1.0;
		
		if ([game player1Type] != HUMAN && [game player2Type] != HUMAN) {
			[viewController.playPauseButton setEnabled: YES];
			[viewController.slider setEnabled: NO];
		}
		
		srand(time(NULL));
		
		position = 0;
		maxPosition = 0;
	}
	return self;
}


- (void) undo {
	if (position > 0) {
		position -= 1;
		
		if ([game playMode] == ONLINE_SOLVED) {
			// Pop the top entry off the data history stack
			NSDictionary *entry = [[dataHistoryStack lastObject] retain];
			[dataHistoryStack removeLastObject];
			
			// Push the entry onto the data undo stack
			[dataUndoStack addObject: entry];
			[entry release];
		}
		
		// Pop the move off the move stack
		id move = [[moveStack lastObject] retain];
		[moveStack removeLastObject];
		
		// Push the move onto the undo stack
		[undoStack addObject: move];
		
		[game undoMove: move];
		[move release];
		
		[viewController.slider setValue: position];
		
		viewController.playPauseButton.enabled = YES;
		[viewController.playPauseButton setImage: [UIImage imageNamed: @"Resume.png"]];
		stopped = YES;
		
		if ([game player1Type] == HUMAN && [game player2Type] == HUMAN && stopped)
			[self restart];
	}
}

- (void) redo {
	if (position < maxPosition) {
		position += 1;
		
		if ([game playMode] == ONLINE_SOLVED) {
			// Pop the top entry off the data undo stack
			NSDictionary *entry = [[dataUndoStack lastObject] retain];
			[dataUndoStack removeLastObject];
			
			// Push the entry onto the data history stack
			[dataHistoryStack addObject: entry];
			[entry release];
		}
		
		// Pop the move off the undo stack
		id move = [[undoStack lastObject] retain];
		[undoStack removeLastObject];
		
		// Push the move onto the move stack
		[moveStack addObject: move];
		
		[game doMove: move];
		[move release];
		
		[viewController.slider setValue: position];
		
		viewController.playPauseButton.enabled = YES;
		[viewController.playPauseButton setImage: [UIImage imageNamed: @"Resume.png"]];
		stopped = YES;
	}
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
	
	if ([game playMode] == ONLINE_SOLVED) {
		NSDictionary *lastEntry = [dataHistoryStack lastObject];
		
		// Create a new entry only if it's new
		if (![[lastEntry objectForKey: @"board"] isEqual: [game getBoard]] ||
			![[lastEntry objectForKey: @"player"] isEqual: [game currentPlayer] == PLAYER1 ? @"1" : @"2"]) {
			NSArray *keys = [[NSArray alloc] initWithObjects: @"board", @"player", @"value", @"remoteness", nil];
			NSArray *values = [[NSArray alloc] initWithObjects: [[game getBoard] copy],
							   ([game currentPlayer] == PLAYER1 ? @"1" : @"2"), [game getValue], 
							   [NSNumber numberWithInteger: [game getRemoteness]], nil];
			NSDictionary *entry = [[NSDictionary alloc] initWithObjects: values forKeys: keys];
			[keys autorelease]; [values autorelease];
			
			// Push the entry onto the data history stack
			[dataHistoryStack addObject: entry];
			[entry release];
		} // else use the cached entry
	}
	
	if ([game player1Type] == HUMAN || [game player2Type] == HUMAN) {
		[viewController.slider setEnabled: YES];
		[viewController.playPauseButton setEnabled: NO];
	}
	if (![game primitive]) {
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
	[moveStack addObject: [game getHumanMove]];
	
	[undoStack release];
	undoStack = [[NSMutableArray alloc] init];
	
	[dataUndoStack release];
	dataUndoStack = [[NSMutableArray alloc] init];
	
	[game stopUserInput];
	position += 1;
	maxPosition = position;
	[viewController.slider setMaximumValue: position];
	[viewController.slider setValue: position];
	if (stopped) stopped = NO;
	[self go];
}

- (void) takeComputerTurn {	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	PlayerType p = ([game currentPlayer] == PLAYER1) ? [game player1Type] : [game player2Type];
	if ([game playMode] == OFFLINE_UNSOLVED || p == COMPUTER_RANDOM) {
		NSArray *legals = [game legalMoves];
		int choice = rand() % [legals count];
		
		[NSThread sleepForTimeInterval: DELAY];
		
		[game doMove: [legals objectAtIndex: choice]];
		[moveStack addObject: [legals objectAtIndex: choice]];
		
		[undoStack release];
		undoStack = [[NSMutableArray alloc] init];
		
		[dataUndoStack release];
		dataUndoStack = [[NSMutableArray alloc] init];
	} else {
		NSLog(@"======================================================================");
		NSArray *legals = [game legalMoves];
		NSMutableArray *vals = [[NSMutableArray alloc] init];
		NSMutableArray *remotes = [[NSMutableArray alloc] init];
		for (id move in legals) {
			[vals addObject: [[game getValueOfMove: move] uppercaseString]];
			[remotes addObject: [NSNumber numberWithInteger: [game getRemotenessOfMove: move]]];
		}
		NSLog(@"legals: %@", legals);
		NSLog(@"vals: %@", vals);
		NSLog(@"remotes: %@", remotes);
		
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
		NSLog(@"wins: %@", wins);
		NSLog(@"loses: %@", loses);
		NSLog(@"winRemotes: %@", winRemotes);
		NSLog(@"loseRemotes: %@", loseRemotes);
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
			NSLog(@"Lose case");
			int maxRemote = -1;
			for (id a_move in loses) {
				int index = [legals indexOfObject: a_move];
				maxRemote = MIN(maxRemote, [[remotes objectAtIndex: index] integerValue]);
			}
			NSLog(@"%d", maxRemote);
			NSNumber *R = [NSNumber numberWithInt: maxRemote];
			int moveIndex = [loseRemotes indexOfObject: R];
			while (moveIndex != NSNotFound) {
				[moveChoices addObject: [loses objectAtIndex: moveIndex]];
				moveIndex = [loseRemotes indexOfObject: R inRange: NSMakeRange(moveIndex + 1, [loseRemotes count] - moveIndex - 1)];
			}
		}
		
		[NSThread sleepForTimeInterval: DELAY];
		
		int choice = rand() % [moveChoices count];
		[game doMove: [moveChoices objectAtIndex: choice]];
		[moveStack addObject: [moveChoices objectAtIndex: choice]];
		
		[undoStack release];
		undoStack = [[NSMutableArray alloc] init];
		
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
	maxPosition = position;
	[viewController.slider setMaximumValue: position];
	[viewController.slider setValue: position];
	[pool drain];
	[self performSelectorOnMainThread: @selector(go) withObject: nil waitUntilDone: NO];
}

- (NSArray *) getVVHData {
	return dataHistoryStack;
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[moveStack release];
	[super dealloc];
}

@end
