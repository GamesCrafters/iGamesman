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
	}
	return self;
}

- (NSString *) gameName {
	return @"Tic-Tac-Toe";
}

- (BOOL) supportsPlayMode: (PlayMode) mode {
	return mode == OFFLINE_UNSOLVED;
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
}

- (void) undoMove: (NSNumber *) move {
	[board replaceObjectAtIndex: [move intValue] withObject: BLANK];
	p1Turn = !p1Turn;
}

- (void) notifyWhenReady {
	if (gameMode == OFFLINE_UNSOLVED)
		[[NSNotificationCenter defaultCenter] postNotificationName: @"GameIsReady" object: self];
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
		//file://localhost/home/cc/cs198/fa10/class/cs198-hx/iGamesman2/Classes/GCTicTacToeView.m
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

@end
