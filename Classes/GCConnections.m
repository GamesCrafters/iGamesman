//
//  GCConnections.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/12/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCConnections.h"
#import "GCConnectionsOptionMenu.h"

#define BLANK @"+"


@implementation GCConnections

@synthesize player1Name, player2Name;
@synthesize player1Type, player2Type;

- (id) init {
	if (self = [super init]) {
		player1Name = @"Player 1";
		player2Name = @"Player 2";
		
		p1Turn = YES;
		
		size = 4;
		
		board = [[NSMutableArray alloc] initWithCapacity: size * size];
		for (int i = 0; i < [board count]; i += 1)
			[board addObject: BLANK];
	}
	
	return self;
}

- (NSString *) gameName {
	return @"Connections";
}

- (BOOL) supportsPlayMode:(PlayMode)mode {
	return mode == OFFLINE_UNSOLVED;
}

- (UIViewController *) optionMenu {
	return [[GCConnectionsOptionMenu alloc] initWithGame: self];
}

- (UIViewController *) gameViewController {
	return conView;
}

- (void) startGame {
	if (!conView)
		[conView release];
	conView = [[GCConnectionsViewController alloc] initWithSize: size];
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
