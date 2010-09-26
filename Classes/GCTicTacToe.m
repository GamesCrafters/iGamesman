//
//  GCTicTacToe.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 9/17/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCTicTacToe.h"
#import "GCTicTacToeOptionMenu.h"

#define BLANK @"+"
#define X @"X"
#define O @"O"


@implementation GCTicTacToe

@synthesize player1Name, player2Name;
@synthesize player1Type, player2Type;
@synthesize misere;
@synthesize rows, cols, inarow;

- (id) init {
	if (self = [super init]) {
		player1Name = @"Player 1";
		player2Name = @"Player 2";
		
		rows = 3;
		cols = 3;
		inarow = 3;
		
		misere = NO;
		
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

@end
