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
#import "IntegerQueue.h"

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
//	for (int j = 0; j < size; j += 1) {
//		NSString *row = @"";
//		for (int i = 0; i < size; i += 1) {
//			row = [row stringByAppendingString: [board objectAtIndex: i + j * size]];
//		}
//		NSLog(@"%@", row);
//	}
//	NSLog(@" ");
	
	//put here??
	[conView updateLabels];
	
}

- (NSString *) primitive: (NSArray *) theBoard  { 
	IntegerQueue * queue = [[IntegerQueue alloc] init];
	int position;
	int neighborPosition;

	if ([[self legalMoves] count] == 0){
		
		//should I put this here?
		[conView displayPrimitive];
		
		return @"WIN";
	}

	//////////////////p1 turn/////////////////////////
	if (!p1Turn){ 
		
		//add in initial positions, starting with the position directly below the top left connector
		for (int i = size + 1; i < size * 2 - 1; i += 2){
			if ([[board objectAtIndex: i] isEqual: X])
				[queue push: i];
		}
		
		while ([queue notEmpty]){
			position = [queue pop];
			
			//Check to see if we are at the end of our path
			if (position/size >= size - 2){
				[queue release];
				//NSLog(@"Game Over");
				
				//should I put this here?
				[conView displayPrimitive];
				
				return YES;
			}
			
			//add neighbors to the fringe
			//////////////odd case///////////////	In terms of column number from 0-size and position in terms of array (index at 0)
			if ((position % size) % 2){						
				//////left neighbor- only check if we are not in the leftmost column
				if ((position % size) > 1){
					neighborPosition = position + size - 1;
					
					if ([[board objectAtIndex: neighborPosition] isEqual: X])
						[queue push: neighborPosition];
				}
				
				/////right neighbor- only check if we are not in the rightmost column
				if ((position % size) < size - 2){
					neighborPosition = position + size + 1;
					
					if ([[board objectAtIndex: neighborPosition] isEqual: X])
						[queue push: neighborPosition];
				}
				
				/////bottom neighbor
				neighborPosition = position + size * 2;
				if ([[board objectAtIndex: neighborPosition] isEqual: X])
					[queue push: neighborPosition];
				
			}
			//////////////even case///////////////
			else{ 	
				
				/////left neighbor- only check if we are not in the leftmost column///////
				if ((position % size) > 3){
					neighborPosition = position - 2;
					
					//Check if The proper piece is in the neighboring position and that the position is not already in the fringe, then add it to the fringe
					if ([[board objectAtIndex: neighborPosition] isEqual: X])
						[queue push: neighborPosition];
					
				}
				
				/////bottom left neighbor///////
				neighborPosition = position + size - 1;
				if ([[board objectAtIndex: neighborPosition] isEqual: X])
					[queue push: neighborPosition];
				
				/////right neighbor- only check if we are not in the rightmost column///////
				if ((position % size) < size - 2){
					neighborPosition = position + 2;
					if ([[board objectAtIndex: neighborPosition] isEqual: X])
						[queue push: neighborPosition];
				}
				
				/////bottom right neighbor///////
				neighborPosition = position + size + 1;
				if ([[board objectAtIndex: neighborPosition] isEqual: X])
					[queue push: neighborPosition];
			}
		}
		
		//////////////////p2 turn/////////////////////////
	}else { 
		//add initial positions
		for (int i = size + 1; i < size * (size - 1); i += size){
			if ([[board objectAtIndex: i] isEqual: O])
				[queue push: i];
		}
		
		//check player
		while ([queue notEmpty]){
			position = [queue pop];
		    NSLog(@"X queue not empty: %d", position);
			
			//Check to see if we are at the end of our path
			if (position % size >= size - 2){
				[queue release];
				NSLog(@"Game Over");
				
				//should I put this here?
				[conView displayPrimitive];
				
				return YES;
			}
			
			//////////////odd case///////////////
			if ((position % size) % 2){
				//up- only check if not in topmost row
				if(position > 2 * size){
					neighborPosition = position - size + 1;
					
					if([[board objectAtIndex: neighborPosition] isEqual: O])
						[queue push: neighborPosition];
				}
				
				//down- only check if not in bottommost row
				if(position < size * (size - 2)){
					neighborPosition = position + size + 1;
					
					if([[board objectAtIndex: neighborPosition] isEqual: O])
						[queue push: neighborPosition];
					
				}
				//right
				neighborPosition = position + 2;
				if ([[board objectAtIndex: neighborPosition] isEqual: O])
					[queue push: neighborPosition];
				
			}
			//////////////even case///////////////
			else{
				//up- only if not in the third row
				if (position > size * 3){
					neighborPosition = position - size * 2;
					if ([[board objectAtIndex: neighborPosition] isEqual: O])
						[queue push: neighborPosition];
				}
				
				//down- only if not in the third row from the bottom
				if (position < size * (size - 3)){
					neighborPosition = position + size * 2;
					if ([[board objectAtIndex: neighborPosition] isEqual: O])
						[queue push: neighborPosition];
				}
				//upper right
				neighborPosition = position - size + 1;
				if ([[board objectAtIndex: neighborPosition] isEqual: O])
					[queue push: neighborPosition];
				
				//lower right
				neighborPosition = position + size + 1;
				if ([[board objectAtIndex: neighborPosition] isEqual: O])
					[queue push: neighborPosition];
				
			}
		}
	}
	
	[queue release];
	return NO;
}

//- (BOOL) playerHasContinuousPath{
//
//}
//						
						

- (void) notifyWhenReady {
	if (gameMode == OFFLINE_UNSOLVED)
		[[NSNotificationCenter defaultCenter] postNotificationName: @"GameIsReady" object: self];
}

- (void) dealloc {
	[player1Name release];
	[player2Name release];
	[board release];
	[humanMove release];
	//[service release];
	[super dealloc];
}


@end
