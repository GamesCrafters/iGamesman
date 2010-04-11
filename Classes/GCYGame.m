//
//  GCYGame.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/5/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCYGame.h"
#import "GCYGameViewController.h"
#import "GCYOptionMenu.h"

#define BLANK @"+"


@implementation GCYGame

@synthesize player1Name, player2Name;
@synthesize player1Type, player2Type;
@synthesize layers;
@synthesize p1Turn;
@synthesize positionConnections;

- (id) init {
	if (self = [super init]) {
		player1Name = @"Player 1";
		player2Name = @"Player 2";
		
		player1Type = HUMAN;
		player2Type = HUMAN;
		
		layers = 0;
		
		p1Turn = YES;
		
		board = [[NSMutableArray alloc] initWithCapacity: 15];
		for (int i = 0; i < [board count]; i += 1)
			[board addObject: BLANK];
		
		layer0Connections = [[NSDictionary alloc] initWithObjectsAndKeys: 
							 
							   [NSNumber numberWithInt: 1], [NSSet setWithObjects: [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 3], nil], 
		
							   [NSNumber numberWithInt: 2], [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 4], 
															 [NSNumber numberWithInt: 5], nil], 
		
							   [NSNumber numberWithInt: 3], [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 5], 
															 [NSNumber numberWithInt: 6], nil], 
		
							   [NSNumber numberWithInt: 4], [NSSet setWithObjects: [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 7], 
															 [NSNumber numberWithInt: 8], nil], 
		
							   [NSNumber numberWithInt: 5], [NSSet setWithObjects: [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 4], 
															 [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 9], nil], 
		
							   [NSNumber numberWithInt: 6], [NSSet setWithObjects: [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 9], 
															 [NSNumber numberWithInt: 10], nil], 
		
							   [NSNumber numberWithInt: 7], [NSSet setWithObjects: [NSNumber numberWithInt: 4], [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 11], 
															 [NSNumber numberWithInt: 12], nil], 
		
							   [NSNumber numberWithInt: 8], [NSSet setWithObjects: [NSNumber numberWithInt: 4], [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 7], 
															 [NSNumber numberWithInt: 9], [NSNumber numberWithInt: 12], [NSNumber numberWithInt: 13], nil], 
							   
							   [NSNumber numberWithInt: 9], [NSSet setWithObjects: [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 8], 
															  [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 13], [NSNumber numberWithInt: 14], nil],
		
							   [NSNumber numberWithInt: 10], [NSSet setWithObjects: [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 9], [NSNumber numberWithInt: 14], 
															  [NSNumber numberWithInt: 15], nil],
							   
							   [NSNumber numberWithInt: 11], [NSSet setWithObjects: [NSNumber numberWithInt: 7], [NSNumber numberWithInt: 12], nil], 
							   
							   [NSNumber numberWithInt: 12], [NSSet setWithObjects: [NSNumber numberWithInt: 7], [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 11], 
															  [NSNumber numberWithInt: 13], nil], 
		
							   [NSNumber numberWithInt: 13], [NSSet setWithObjects: [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 9], [NSNumber numberWithInt: 12], 
															  [NSNumber numberWithInt: 14], nil], 
		
							   [NSNumber numberWithInt: 14], [NSSet setWithObjects: [NSNumber numberWithInt: 9], [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 13], 
															  [NSNumber numberWithInt: 15], nil], 
		
							   [NSNumber numberWithInt: 15], [NSSet setWithObjects: [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 14], nil], nil];
		
		/***************************
		 *** Not finished at all.
		 ***************************/
		
		layer1Connections = [[NSDictionary alloc] initWithObjectsAndKeys: 
							 
							 [NSNumber numberWithInt: 1], [NSSet setWithObjects: [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 20], 
														   [NSNumber numberWithInt: 21], [NSNumber numberWithInt: 22], nil], 
							 
							 [NSNumber numberWithInt: 2], [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 4], 
														   [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 22], [NSNumber numberWithInt: 23], nil], 
							 
							 [NSNumber numberWithInt: 3], [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 5], 
														   [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 19], [NSNumber numberWithInt: 20], nil], 
							 
							 [NSNumber numberWithInt: 4], [NSSet setWithObjects: [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 7], 
														   [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 23], [NSNumber numberWithInt: 24], nil], 
							 
							 [NSNumber numberWithInt: 5], [NSSet setWithObjects: [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 4], 
														   [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 9], nil], 
							 
							 [NSNumber numberWithInt: 6], [NSSet setWithObjects: [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 9], 
														   [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 18], [NSNumber numberWithInt: 19], nil], 
							 
							 [NSNumber numberWithInt: 7], [NSSet setWithObjects: [NSNumber numberWithInt: 4], [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 11], 
														   [NSNumber numberWithInt: 12], [NSNumber numberWithInt: 24], [NSNumber numberWithInt: 25], nil], 
							 
							 [NSNumber numberWithInt: 8], [NSSet setWithObjects: [NSNumber numberWithInt: 4], [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 7], 
														   [NSNumber numberWithInt: 9], [NSNumber numberWithInt: 12], [NSNumber numberWithInt: 13], nil], 
							 
							 [NSNumber numberWithInt: 9], [NSSet setWithObjects: [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 8], 
														   [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 13], [NSNumber numberWithInt: 14], nil],
							 
							 [NSNumber numberWithInt: 10], [NSSet setWithObjects: [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 9], [NSNumber numberWithInt: 14], 
															[NSNumber numberWithInt: 15], [NSNumber numberWithInt: 17], [NSNumber numberWithInt: 18], nil],
							 
							 [NSNumber numberWithInt: 11], [NSSet setWithObjects: [NSNumber numberWithInt: 7], [NSNumber numberWithInt: 12], [NSNumber numberWithInt: 25], 
															[NSNumber numberWithInt: 26], [NSNumber numberWithInt: 27], nil], 
							 
							 [NSNumber numberWithInt: 12], [NSSet setWithObjects: [NSNumber numberWithInt: 7], [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 11], 
															[NSNumber numberWithInt: 13], [NSNumber numberWithInt: 27], [NSNumber numberWithInt: 28], nil], 
							 
							 [NSNumber numberWithInt: 13], [NSSet setWithObjects: [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 9], [NSNumber numberWithInt: 12], 
															[NSNumber numberWithInt: 14], [NSNumber numberWithInt: 28], [NSNumber numberWithInt: 29], nil], 
							 
							 [NSNumber numberWithInt: 14], [NSSet setWithObjects: [NSNumber numberWithInt: 9], [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 13], 
															[NSNumber numberWithInt: 15], [NSNumber numberWithInt: 29], [NSNumber numberWithInt: 30], nil], 
							 
							 [NSNumber numberWithInt: 15], [NSSet setWithObjects: [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 14], [NSNumber numberWithInt: 16], 
															[NSNumber numberWithInt: 17], [NSNumber numberWithInt: 30], nil], 
							 
							 [NSNumber numberWithInt: 16], [NSSet setWithObjects: [NSNumber numberWithInt: 15], [NSNumber numberWithInt: 17], [NSNumber numberWithInt: 30], nil], 
							 
							 [NSNumber numberWithInt: 17], [NSSet setWithObjects: [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 15], [NSNumber numberWithInt: 16], 
															[NSNumber numberWithInt: 18], nil], nil];
	}
	
	return self;
}

- (NSString *) gameName {
	return @"Y";
}

- (BOOL) supportsPlayMode:(PlayMode)mode {
	return mode == OFFLINE_UNSOLVED;
}

- (void) startGameInMode: (PlayMode) mode {
	if (yGameView)  
		[yGameView release];
	yGameView = [[GCYGameViewController alloc] initWithLayers:layers];
	
	gameMode = mode;
}

- (UIViewController *) optionMenu {
	return [[GCYOptionMenu alloc] initWithGame: self];
}

- (UIViewController *) gameViewController {
	return yGameView;
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

- (void) notifyWhenReady {
	if (gameMode == OFFLINE_UNSOLVED)
		[[NSNotificationCenter defaultCenter] postNotificationName: @"GameIsReady" object: self];
}

@end
