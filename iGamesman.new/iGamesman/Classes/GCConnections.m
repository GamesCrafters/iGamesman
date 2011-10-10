//
//  GCConnections.m
//  iGamesman
//
//  Created by Ian Ackerman on 07/10/11.
//  Copyright 2011 Gamescrafters. All rights reserved.
//

#import "GCConnections.h"
#import "ConnectionsIntegerQueue.h"

#define BLANK @"+"
#define X @"X"
#define XCON @"x"
#define O @"O"
#define OCON @"o"

@implementation GCConnections

@synthesize misere;
@synthesize predictions, moveValues;
@synthesize circling;

- (id) init {
	if (self = [super init]) {
		
		position = [[GCConnectionsPosition alloc] initWithSize: 7];
		
		misere = NO;
		circling = NO;
		
		board = position.board;
		}
	
	return self;
}

- (Position) doMove: (Move) move {
	//[conView doMove: move];
	
	int slot = [move integerValue] - 1;
	[board replaceObjectAtIndex: slot withObject: (position.p1Turn ? X : O)]; //Keep board? just use position.
	position.board = board;
	return position;
}

- (void) undoMove: (Move) move toPosition: (GCConnectionsPosition *) toPos {
	//[conView undoMove: move];
	
	int slot = [move intValue] - 1;
	[board replaceObjectAtIndex: slot withObject: BLANK];
	position.p1Turn = !position.p1Turn;
	position = toPos;
	
	//[conView updateLabels];
}

- (GameValue) primitive: (GCConnectionsPosition *) pos {
	ConnectionsIntegerQueue * queue = [[ConnectionsIntegerQueue alloc] init];
	int positionNum;
	int neighborPosition;
	int size = pos.size;
	
	board = pos.board;
	
	if(circling){
		if([self encircled: board]){
			board = position.board;
			return misere ? WIN : LOSE;
		}
	}
	if ([[self generateMoves: pos] count] == 0){
		board = position.board;
		return misere ? WIN : LOSE;
	}
	
	//////////////////p1 turn finished/////////////////////////
	if (!pos.p1Turn){ 
		
		//add in initial positions, starting with the position directly below the top left connector
		for (int i = size + 1; i < size * 2 - 1; i += 2){
			if ([[board objectAtIndex: i] isEqual: X])
				[queue push: i];
		}
		
		while ([queue notEmpty]){
			positionNum = [queue pop];
			
			//Check to see if we are at the end of our path
			if (positionNum/size >= size - 2){
				[queue release];
				board = position.board;
				return misere ? WIN : LOSE;
			}
			
			//add neighbors to the fringe
			//////////////odd case///////////////	In terms of column number from 0-size and position in terms of array (index at 0)
			if ((positionNum % size) % 2){						
				//////left neighbor- only check if we are not in the leftmost column
				if ((positionNum % size) > 1){
					neighborPosition = positionNum + size - 1;
					
					if ([[board objectAtIndex: neighborPosition] isEqual: X])
						[queue push: neighborPosition];
				}
				
				/////right neighbor- only check if we are not in the rightmost column
				if ((positionNum % size) < size - 2){
					neighborPosition = positionNum + size + 1;
					
					if ([[board objectAtIndex: neighborPosition] isEqual: X])
						[queue push: neighborPosition];
				}
				
				/////bottom neighbor
				neighborPosition = positionNum + size * 2;
				if ([[board objectAtIndex: neighborPosition] isEqual: X])
					[queue push: neighborPosition];
				
			}
			//////////////even case///////////////
			else{ 	
				
				/////left neighbor- only check if we are not in the leftmost column///////
				if ((positionNum % size) > 3){
					neighborPosition = positionNum - 2;
					
					//Check if The proper piece is in the neighboring position and that the position is not already in the fringe, then add it to the fringe
					if ([[board objectAtIndex: neighborPosition] isEqual: X])
						[queue push: neighborPosition];
					
				}
				
				/////bottom left neighbor///////
				neighborPosition = positionNum + size - 1;
				if ([[board objectAtIndex: neighborPosition] isEqual: X])
					[queue push: neighborPosition];
				
				/////right neighbor- only check if we are not in the rightmost column///////
				if ((positionNum % size) < size - 2){
					neighborPosition = positionNum + 2;
					if ([[board objectAtIndex: neighborPosition] isEqual: X])
						[queue push: neighborPosition];
				}
				
				/////bottom right neighbor///////
				neighborPosition = positionNum + size + 1;
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
			positionNum = [queue pop];
		    //NSLog(@"X queue not empty: %d", positionNum);
			
			//Check to see if we are at the end of our path
			if (positionNum % size >= size - 2){
				[queue release];
				board = position.board;
				return misere ? WIN : LOSE;
			}
			
			//////////////odd case///////////////
			if ((positionNum % size) % 2){
				//up- only check if not in topmost row
				if(positionNum > 2 * size){
					neighborPosition = positionNum - size + 1;
					
					if([[board objectAtIndex: neighborPosition] isEqual: O])
						[queue push: neighborPosition];
				}
				
				//down- only check if not in bottommost row
				if(positionNum < size * (size - 2)){
					neighborPosition = positionNum + size + 1;
					
					if([[board objectAtIndex: neighborPosition] isEqual: O])
						[queue push: neighborPosition];
					
				}
				//right
				neighborPosition = positionNum + 2;
				if ([[board objectAtIndex: neighborPosition] isEqual: O])
					[queue push: neighborPosition];
				
			}
			//////////////even case///////////////
			else{
				//up- only if not in the third row
				if (positionNum > size * 3){
					neighborPosition = positionNum - size * 2;
					if ([[board objectAtIndex: neighborPosition] isEqual: O])
						[queue push: neighborPosition];
				}
				
				//down- only if not in the third row from the bottom
				if (positionNum < size * (size - 3)){
					neighborPosition = positionNum + size * 2;
					if ([[board objectAtIndex: neighborPosition] isEqual: O])
						[queue push: neighborPosition];
				}
				//upper right
				neighborPosition = positionNum - size + 1;
				if ([[board objectAtIndex: neighborPosition] isEqual: O])
					[queue push: neighborPosition];
				
				//lower right
				neighborPosition = positionNum + size + 1;
				if ([[board objectAtIndex: neighborPosition] isEqual: O])
					[queue push: neighborPosition];
				
			}
		}
	}
	
	[queue release];
	board = position.board;
	return NONPRIMITIVE;
}

- (NSArray *) generateMoves: (GCConnectionsPosition *) pos {
	NSMutableArray *moves = [[NSMutableArray alloc] init];
	board = pos.board;
	int size = pos.size;
	
	for (int j = 0; j < size; j += 1) {
		for (int i = 0; i < size; i += 1) {
			if ([[board objectAtIndex: i + j * size] isEqual: BLANK]) {
				if (i != 0 && i != size - 1 && j != 0 && j != size - 1)
					[moves addObject: [NSNumber numberWithInt: i + j * pos.size + 1]];
			}
		}
	}
	board = position.board; //Need board?
	return moves;
}


- (void) startGameWithLeft: (GCPlayer *) leftPlayer
                     right: (GCPlayer *) rightPlayer
           andPlaySettings: (NSDictionary *) settingsDict {
	player1 = leftPlayer;
	player2 = rightPlayer;
	settings = settingsDict;
}

- (GCPlayer *) leftPlayer {
	return player1;
}


- (void) setLeftPlayer: (GCPlayer *) left {
	player1 = left;
}


- (GCPlayer *) rightPlayer {
	return player2;
}


- (void) setRightPlayer: (GCPlayer *) right {
	player2 = right;
}

- (NSDictionary *) playSettings {
	return settings;
}

- (void) setPlaySettings: (NSDictionary *) settingsDict {
	settings = settingsDict;
}

- (UIView *) view {
	//UI elements not yet defined
}

- (void) waitForHumanMoveWithCompletion: (void (^) (Move move)) completionHandler {
	//Need clarification
}


- (UIView *) variantsView {
	//UI elements not yet defined
}

- (BOOL) isMisere {
	return misere;
}

- (void) setMisere: (BOOL) mis{
	misere = mis;
}

- (void) pause {
	//Server function not currently implemented
}

- (void) resume {
	//Server function not currently implemented
}


- (BOOL) supportsPlayMode: (PlayMode) mode{
	if (mode == ONLINE_SOLVED)
		return FALSE;
	if (mode == OFFLINE_UNSOLVED)
		return TRUE;
	else {
		return FALSE;
	}
}


- (void) showPredictions: (BOOL) predictions{
	//Server function not currently implemented
}

- (void) showMoveValues: (BOOL) moveValues {
	//Server function not currently implemented
}


- (PlayerSide) currentPlayer{
	return position.p1Turn ? PLAYER_LEFT : PLAYER_RIGHT;
}


@end
