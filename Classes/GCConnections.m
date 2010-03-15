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
		fringe = [[NSMutableArray alloc] init];
		
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

- (void) askUserForInput {
	[conView enableButtons];
}

- (void) stopUserInput {
	[conView disableButtons];
}

- (void) postHumanMove: (NSNumber *) num{
	humanMove = num;
	[[NSNotificationCenter defaultCenter] postNotificationName: @"HumanChoseMove" object: self];
}

- (NSNumber *) getHumanMove {
	return humanMove;
}

- (NSArray *) legalMoves {
	NSMutableArray *moves = [[NSMutableArray alloc] init];
	
	for (int j = 0; j < size; j += 1) {
		for (int i = 0; i < size; i += 1) {
			if ([[board objectAtIndex: i + j * size] isEqual: BLANK]) {
				if ( (p1Turn && i != 0 && i != size - 1) || (!p1Turn && j != 0 && j != size - 1) )
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

- (BOOL) isPrimitive: (NSArray *) theBoard  { 
	BOOL win = NO;
	
	//Check if player1 wins
	// win =		
	//fringe(check children)
	//need another function continuousPath
	
	[fringe removeAllObjects];
	if(p1Turn){
		//continuousPath going downwards
	}
	else{
		//continuousPath going across
	}
}

- (BOOL) playerHasContinuousPath{
	int position;
	int neighborPosition;
	
	// Iterate through the fringe until it is either empty or we have found a path to the end
	while ([fringe count] > 0){
		position = [[fringe objectAtIndex: 0] intValue];
		[fringe removeObjectAtIndex: 0];
		
	
		//Check whose turn it is
		//////////////////p1 turn/////////////////////////
		if (p1Turn){ 
			//Check to see if we are at the end of our path
			if (position/size == size - 2) return YES;
			
			//add neighbors to the fringe
			//////////////odd case///////////////	
			if (position % 2){						
				
				//Check to be sure neighbor is filled and isn't in the fringe already
				
				/////left neighbor- only check if we are not in the leftmost column
				if ((position % size) > 3){
					neighborPosition = position - 2;
					
					//Check if The proper piece is in the neighboring position and that the position is not already in the fringe, then add it to the fringe
					if ([[board objectAtIndex: neighborPosition] isEqual: X] && ![fringe containsObject:[NSNumber numberWithInt: neighborPosition]])
						[fringe addObject: [NSNumber numberWithInt: neighborPosition]];
					
				}
				
				
				/////bottom left neighbor
				neighborPosition = position + size - 1;
				
				//Check if The proper piece is in the neighboring position and that the position is not already in the fringe, then add it to the fringe
				if ([[board objectAtIndex: neighborPosition] isEqual: X] && ![fringe containsObject:[NSNumber numberWithInt: neighborPosition]])
					[fringe addObject: [NSNumber numberWithInt: neighborPosition]];
				
				
				/////right neighbor- only check if we are not in the rightmost column
				if ((position % size) < size - 2){
					neighborPosition = position + 2;
					
					//Check if The proper piece is in the neighboring position and that the position is not already in the fringe, then add it to the fringe
					if ([[board objectAtIndex: neighborPosition] isEqual: X] && ![fringe containsObject:[NSNumber numberWithInt: neighborPosition]])
						[fringe addObject: [NSNumber numberWithInt: neighborPosition]];				
				}
				
				/////bottom right neighbor
				neighborPosition = position + size + 1;
				
				//Check if The proper piece is in the neighboring position and that the position is not already in the fringe, then add it to the fringe
				if ([[board objectAtIndex: neighborPosition] isEqual: X] && ![fringe containsObject:[NSNumber numberWithInt: neighborPosition]])
					[fringe addObject: [NSNumber numberWithInt: neighborPosition]];
				
			}
			//////////////even case///////////////
			else{ 	
			}
		
		//////////////////p2 turn/////////////////////////
		}else { 
			//Check to see if we are at the end of our path
			if (position % size == 1) return YES;
			
			//add neighbors to the fringe
			if (position % 2){
				
			}
			else{
				
			}
		}
	}
	
	return NO;
	
}
						
						

- (void) notifyWhenReady {
	if (gameMode == OFFLINE_UNSOLVED)
		[[NSNotificationCenter defaultCenter] postNotificationName: @"GameIsReady" object: self];
}

- (void) dealloc {
	[player1Name release];
	[player2Name release];
	[board release];
	[fringe release];
	[humanMove release];
	//[service release];
	[super dealloc];
}


@end
