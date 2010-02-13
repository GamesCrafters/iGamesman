//
//  GCConnectFour.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 1/29/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCConnectFour.h"
#import "GCConnectFourOptionMenu.h"
#import "GCConnectFourViewController.h"


#define BLANK @"+"

@implementation GCConnectFour

@synthesize player1Name, player2Name;
@synthesize player1Human, player2Human;
@synthesize width, height, pieces;
@synthesize board;
@synthesize p1Turn;

- (id) init {
	if (self = [super init]) {
		player1Name = @"Player 1";
		player2Name = @"Player 2";
		
		player1Human = YES;
		player2Human = YES;
		
		width = 6;
		height = 5;
		pieces = 4;
		
		p1Turn = YES;
		
		board = [[NSMutableArray alloc] initWithCapacity: width * height];
		for (int i = 0; i < width * height; i += 1)
			[board addObject: BLANK];
	}
	return self;
}

- (NSString *) gameName { 
	return @"Connect-4"; 
}

- (BOOL) supportsPlayMode:(PlayMode)mode {
	if (mode == ONLINESOLVED) return YES;
	if (mode == OFFLINEUNSOLVED) return NO;
	return NO;
}

- (UIViewController *) optionMenu {
	return [[GCConnectFourOptionMenu alloc] initWithGame: self];
}

- (UIViewController *) gameViewController {
	return c4view;
}

- (void) startGame {
	[self resetBoard];
	
	p1Turn = YES;
	
	if (!c4view)
		[c4view release];
	c4view = [[GCConnectFourViewController alloc] initWithGame: self];
}

- (NSArray *) getBoard {
	return board;
}

- (NSArray *) legalMoves {
	NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity: width];
	
	int col = 1;
	for (int i = width * (height - 1); i < width * height; i += 1) {
		if ([[board objectAtIndex: i] isEqual: BLANK])
			[moves addObject: [NSString stringWithFormat: @"%d", col]];
		col += 1;
	}
	
	return moves;
}

- (BOOL) isPrimitive: (NSArray *) theBoard {
	// First check if the board is full
	BOOL full = YES;
	for (int i = 0; i < width * height; i += 1) {
		if ([[theBoard objectAtIndex: i] isEqual: BLANK]) {
			full = NO;
			break;
		}
	}
	if (full) return full;
	
	for (int i = 0; i < width * height; i += 1) {
		NSString *piece = [theBoard objectAtIndex: i];
		if ([piece isEqual: BLANK])
			continue;
		
		// Check the horizontal case
		BOOL case1 = YES;
		for (int j = i; j < i + pieces; j += 1) {
			if (i % width > j % width || ![[theBoard objectAtIndex: j] isEqual: piece]) {
				case1 = NO;
				break;
			}
		}
		if (case1) return case1;
		
		// Check the vertical case
		BOOL case2 = YES;
		for (int j = i; j < i + width * pieces; j += width) {
			if ( j > width * height || ![[theBoard objectAtIndex: j] isEqual: piece] ) {
				case2 = NO;
				break;
			}
		}
		if (case2) return case2;
		
		// Check the diagonal case (positive slope)
		BOOL case3 = YES;
		for (int j = i; j < i + pieces + width * pieces; j += (width + 1) ) {
			if ( j > width * height || (i % width > j % width) || ![[theBoard objectAtIndex: j] isEqual: piece] ) {
				case3 = NO;
				break;
			}
		}
		if (case3) return case3;
		
		// Check the diagonal case (negative slope)
		BOOL case4 = YES;
		for (int j = i; j < i + width * pieces - pieces; j += (width - 1) ) {
			if ( j > width * height || (i % width < j % width) || ![[theBoard objectAtIndex: j] isEqual: piece] ) {
				case4 = NO;
				break;
			}
		}
		if (case4) return case4;
	}
	
	return NO;
}

- (void) askUserForInput {
	[c4view enableButtons];
}

- (void) stopUserInput {
	[c4view disableButtons];
}

- (void) postHumanMove: (NSString *) move {
	humanMove = move;
	[[NSNotificationCenter defaultCenter] postNotificationName: @"HumanChoseMove" object: self];
}

- (NSString *) getHumanMove {
	return humanMove;
}

- (BOOL) currentPlayerIsHuman {
	return p1Turn ? player1Human : player2Human;
}

- (void) doMove: (NSString *) move {
	[c4view doMove: move];
	
	int slot = [move integerValue] - 1;
	while (slot < width * height) {
		if ([[board objectAtIndex: slot] isEqual: BLANK]) {
			[board replaceObjectAtIndex: slot withObject: (p1Turn ? @"X" : @"O")];
			break;
		}
		slot += width;
	}
	p1Turn = !p1Turn;
}

- (void) resetBoard {
	if (board != nil) {
		[board release];
		board = nil;
	}
	
	board = [[NSMutableArray alloc] initWithCapacity: width * height];
	for (int i = 0; i < width * height; i += 1)
		[board addObject: BLANK];
}

- (void) dealloc {
	[board release];
	[super dealloc];
}

@end
