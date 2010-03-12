//
//  GCConnections.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/12/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCConnections.h"
#import "GCConnectionsViewController.h"
#import "GCConnectionsOptionMenu.h"

#define BLANK @"+"
#define X @"X"
#define XCON @"x"
#define O @"O"
#define OCON @"o"

@implementation GCConnections

@synthesize player1Name, player2Name;
@synthesize player1Type, player2Type;
@synthesize size;
@synthesize p1Turn;

- (id) init {
	if (self = [super init]) {
		player1Name = @"Player 1";
		player2Name = @"Player 2";
		
		size = 7;
		
		board = [[NSMutableArray alloc] initWithCapacity: size * size];
		for (int j = 0; j < size; j += 1) {
			for (int i = 0; i < size; i += 1) {
				if(i % 2 == j % 2){
					[board addObject:BLANK];
				}
				else if(i % 2 == 0){
					[board addObject: OCON];
				}
				else {
					[board addObject: XCON];
				}
			}
		}
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

- (void) startGameInMode: (PlayMode) mode {
	if (!conView)
		[conView release];
	conView = [[GCConnectionsViewController alloc] initWithGame: self];
	
	p1Turn = YES;
	
	[self resetBoard];
	
	gameMode = mode;
}

- (NSArray *) getBoard {
	return board;
}

- (void) resetBoard {
	if(board){
		[board release];
	}
	
	board = [[NSMutableArray alloc] initWithCapacity: size * size];
	for (int j = 0; j < size; j += 1) {
		for (int i = 0; i < size; i += 1) {
			if(i % 2 == j % 2){
				[board addObject:BLANK];
			}
			else if(i % 2 == 0){
				[board addObject: OCON];
			}
			else {
				[board addObject: XCON];
			}
		}
	}
	
}

- (Player) currentPlayer {
	return p1Turn ? PLAYER1 : PLAYER2;
}

- (NSArray *) legalMoves {
	NSMutableArray *moves = [[NSMutableArray alloc] init];
	
	for (int j = 0; j < size; j += 1) {
		for (int i = 0; i < size; i += 1) {
			if ([[board objectAtIndex: i + j * size] isEqual: BLANK]) {
				if (! ((i == 0 || i == size - 1) && (j == 0 || j == size - 1)))
					[moves addObject: [NSNumber numberWithInt: i + j * size + 1]];
			}
		}
	}
	
	return moves;
}

- (void) doMove: (NSNumber *) move {
	[conView doMove: move];
	
	int slot = [move integerValue] - 1;
	[board replaceObjectAtIndex: slot withObject: (p1Turn ? X : O)];
	p1Turn = !p1Turn;
	for (int j = 0; j < size; j += 1) {
		NSString *row = @"";
		for (int i = 0; i < size; i += 1) {
			row = [row stringByAppendingString: [board objectAtIndex: i + j * size]];
		}
		NSLog(@"%@", row);
	}
	NSLog(@" ");
	
}

- (void) notifyWhenReady {
	if (gameMode == OFFLINE_UNSOLVED)
		[[NSNotificationCenter defaultCenter] postNotificationName: @"GameIsReady" object: self];
}

@end
