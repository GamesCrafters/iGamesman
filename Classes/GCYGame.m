//
//  GCYGame.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/5/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCYGame.h"
#import "GCYOptionMenu.h"

#define BLANK @"+"


@implementation GCYGame

@synthesize player1Name, player2Name;
@synthesize player1Type, player2Type;

- (id) init {
	if (self = [super init]) {
		player1Name = @"Player 1";
		player2Name = @"Player 2";
		
		player1Type = HUMAN;
		player2Type = HUMAN;
		
		layers = 1;
		
		p1Turn = YES;
		
		board = [[NSMutableArray alloc] initWithCapacity: 15];
		for (int i = 0; i < [board count]; i += 1)
			[board addObject: BLANK];
	}
	
	return self;
}

- (NSString *) gameName {
	return @"Y";
}

- (BOOL) supportsPlayMode:(PlayMode)mode {
	return mode == OFFLINE_UNSOLVED;
}

- (UIViewController *) optionMenu {
	return [[GCYOptionMenu alloc] initWithGame: self];
}

- (NSArray *) getBoard {
	return board;
}

- (Player) currentPlayer {
	return p1Turn ? PLAYER1 : PLAYER2;
}

- (NSArray *) legalMoves {
	NSMutableArray *moves = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < [board count]; i += 1) {
		if ([[board objectAtIndex: i] isEqual: BLANK])
			[moves addObject: [board objectAtIndex: i]];
	}
	
	return moves;
}

@end
