//
//  GCTicTacToe.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 9/17/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCTicTacToe.h"
#import "GCTicTacToeOptionMenu.h"
#import "GCTicTacToeViewController.h"

#define BLANK @"+"
#define X @"X"
#define O @"O"


@implementation GCTicTacToe

@synthesize player1Name, player2Name;
@synthesize player1Type, player2Type;
@synthesize misere;
@synthesize rows, cols, inarow;
@synthesize p1Turn;
@synthesize predictions, moveValues;

+ (NSString *) stringForBoard: (NSArray *) _board {
	NSString *boardString = @"";
	for (NSString *piece in _board) {
		if ([piece isEqualToString: @"+"])
			piece = @" ";
		boardString = [NSString stringWithFormat: @"%@%@", boardString, piece];
	}
	return boardString;
}

- (id) init {
	if (self = [super init]) {
		player1Name = @"Player 1";
		player2Name = @"Player 2";
		
		rows = 3;
		cols = 3;
		inarow = 3;
		
		misere = NO;
		
		p1Turn = YES;
		
		board = [[NSMutableArray alloc] initWithCapacity: rows * cols];
		for (int i = 0; i < rows * cols; i += 1)
			[board addObject: BLANK];
		
		srand(time(NULL));
	}
	return self;
}

- (NSString *) gameName {
	return @"Tic-Tac-Toe";
}

- (BOOL) supportsPlayMode: (PlayMode) mode {
	return mode == OFFLINE_UNSOLVED || mode == ONLINE_SOLVED;
}

- (UIViewController *) optionMenu {
	return [[GCTicTacToeOptionMenu alloc] initWithGame: self];
}

- (UIViewController *) gameViewController {
	return tttView;
}

- (void) startGameInMode:(PlayMode)mode {
	[self resetBoard];
	
	gameMode = mode;
	
	p1Turn = YES;
	
	if (!tttView)
		[tttView release];
	tttView = [[GCTicTacToeViewController alloc] initWithGame: self];
	
	if (gameMode == ONLINE_SOLVED) {
		service = [[GCJSONService alloc] init];
		[tttView updateServerDataWithService: service];
	}
}

- (PlayMode) playMode {
	return gameMode;
}

- (void) resetBoard {
	if (board != nil) {
		[board release];
		board = nil;
	}
	
	board = [[NSMutableArray alloc] initWithCapacity: rows * cols];
	for (int i = 0; i < rows * cols; i += 1)
		[board addObject: BLANK];
}

- (NSArray *) getBoard {
	return board;
}

- (Player) currentPlayer {
	return p1Turn ? PLAYER1 : PLAYER2;
}

- (NSArray *) legalMoves {
	NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity: rows * cols];
	for (int i = 0; i < [board count]; i += 1) {
		if ([[board objectAtIndex: i] isEqual: BLANK])
			[result addObject: [NSNumber numberWithInt: i]];
	}
	return [result autorelease];
}

- (void) doMove: (NSNumber *) move {
	[tttView doMove: move];
	
	NSString *piece = p1Turn ? X : O;
	[board replaceObjectAtIndex: [move intValue] withObject: piece];
	p1Turn = !p1Turn;
	
	if (gameMode == OFFLINE_UNSOLVED)
		[tttView updateDisplay];
	else
		[tttView updateServerDataWithService: service];
}

- (void) undoMove: (NSNumber *) move {
	[tttView undoMove: move];
	
	[board replaceObjectAtIndex: [move intValue] withObject: BLANK];
	p1Turn = !p1Turn;
	
	if (gameMode == OFFLINE_UNSOLVED)
		[tttView updateDisplay];
	else
		[tttView updateServerDataWithService: service];
}

- (void) notifyWhenReady {
	if (gameMode == OFFLINE_UNSOLVED)
		[[NSNotificationCenter defaultCenter] postNotificationName: @"GameIsReady" object: self];
}

- (void) postReady {
	[[NSNotificationCenter defaultCenter] postNotificationName: @"GameIsReady" object: self];
}

- (void) postProblem {
	[[NSNotificationCenter defaultCenter] postNotificationName: @"GameEncounteredProblem" object: self];
}

- (void) askUserForInput {
	tttView.touchesEnabled = YES;
}

- (void) stopUserInput {
	tttView.touchesEnabled = NO;
}

- (NSNumber *) getHumanMove {
	return humanMove;
}

- (void) postHumanMove: (NSNumber *) move {
	humanMove = move;
	[[NSNotificationCenter defaultCenter] postNotificationName: @"HumanChoseMove" object: self];
}


- (NSString *) getValue {
	/*NSDictionary *entry = (NSDictionary *) [serverHistoryStack lastObject];
	 NSString *value = [[entry objectForKey: @"value"] uppercaseString];
	 if ([value isEqual: @"UNAVAILABLE"]) value = nil;
	 return value;*/
	
	return [service getValue];
}

- (NSInteger) getRemoteness {
	/*NSDictionary *entry = (NSDictionary *) [serverHistoryStack lastObject];
	return [[entry objectForKey: @"remoteness"] integerValue];*/
	
	return [service getRemoteness];
}

- (NSString *) getValueOfMove: (NSNumber *) move {
	/*NSString *s = [[NSString alloc] initWithFormat: @"%d", [move intValue] - 1];
	NSDictionary *entry = (NSDictionary *) [serverHistoryStack lastObject];
	NSDictionary *children = (NSDictionary *) [entry objectForKey: @"children"];
	NSDictionary *moveEntry = (NSDictionary *) [children objectForKey: s];
	NSString *value = [[moveEntry objectForKey: @"value"] uppercaseString];
	if ([value isEqual: @"UNAVAILABLE"]) value = nil;
	return value;*/
	
	NSString *serverMove = [NSString stringWithFormat: @"%c%d", 'A' + [move intValue] % cols, 1 + [move intValue] / cols];
	NSLog([service getValueAfterMove: serverMove]);
	return [service getValueAfterMove: serverMove];
}

- (NSInteger) getRemotenessOfMove: (NSNumber *) move {
	/*NSString *s = [[NSString alloc] initWithFormat: @"%d", [move intValue] - 1];
	NSDictionary *entry = (NSDictionary *) [serverHistoryStack lastObject];
	NSDictionary *children = (NSDictionary *) [entry objectForKey: @"children"];
	NSDictionary *moveEntry = (NSDictionary *) [children objectForKey: s];
	return [[moveEntry objectForKey: @"remoteness"] integerValue];*/
	
	NSString *serverMove = [NSString stringWithFormat: @"%c%d", 'A' + [move intValue] % cols, 1 + [move intValue] / cols];
	
	return [service getRemotenessAfterMove: serverMove];
}


// Setter for Predictions
// Must update the view to reflect the new settings
- (void) setPredictions: (BOOL) pred {
	predictions = pred;
	[tttView updateDisplay];
}


// Setter for Move Values
// Must update the view to reflect the new settings
- (void) setMoveValues: (BOOL) move {
	moveValues = move;
	[tttView updateDisplay];
}
	

- (NSString *) primitive {
	for (int i = 0; i < rows * cols; i += 1) {
		NSString *piece = [board objectAtIndex: i];
		if ([piece isEqual: BLANK])
			continue;
		
		// Check the horizontal case
		BOOL case1 = YES;
		for (int j = i; j < i + inarow; j += 1) {
			if (j >= cols * rows || i % cols > j % cols || ![[board objectAtIndex: j] isEqual: piece]) {
				case1 = NO;
				break;
			}
		}
		
		// Check the vertical case
		BOOL case2 = YES;
		for (int j = i; j < i + cols * inarow; j += cols) {
			if ( j >= cols * rows || ![[board objectAtIndex: j] isEqual: piece] ) {
				case2 = NO;
				break;
			}
		}
		
		// Check the diagonal case (positive slope)
		BOOL case3 = YES;
		for (int j = i; j < i + inarow + cols * inarow; j += (cols + 1) ) {
			if ( j >= cols * rows || (i % cols > j % cols) || ![[board objectAtIndex: j] isEqual: piece] ) {
				case3 = NO;
				break;
			}
		}
		
		// Check the diagonal case (negative slope)
		BOOL case4 = YES;
		for (int j = i; j < i + cols * inarow - inarow; j += (cols - 1) ) {
			if ( j >= cols * rows || (i % cols < j % cols) || ![[board objectAtIndex: j] isEqual: piece] ) {
				case4 = NO;
				break;
			}
		}		
		if (case1 || case2 || case3 || case4)
			return [piece isEqual: (p1Turn ? @"X" : @"O")] ? (misere ? @"LOSE" : @"WIN") : (misere ? @"WIN" : @"LOSE");
	}
	
	// Finally, check if the board is full
	BOOL full = YES;
	for (int i = 0; i < cols * rows; i += 1) {
		if ([[board objectAtIndex: i] isEqual: BLANK]) {
			full = NO;
			break;
		}
	}
	if (full) return @"TIE";
	
	return nil;
	
}


- (void) dealloc {
	[service release];
	[super dealloc];
}

@end
