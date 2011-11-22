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

- (Position) doMove: (NSNumber *) move {
	//[conView doMove: move];
	
	int slot = [move integerValue] - 1;
	[board replaceObjectAtIndex: slot withObject: (position.p1Turn ? X : O)]; //Keep board? just use position.
	position.board = board;
	return position;
}

- (void) undoMove: (NSNumber *) move toPosition: (GCConnectionsPosition *) toPos {
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
	//allocate view
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
	//Assumes frame of standard size,
	//Use vewWithFrame to have adjustable size
	return [[[GCConnectionsView alloc] initWithFrame: CGRectMake(0, 0, 320, 480)] autorelease];
}

- (UIView *) viewWithFrame: (CGRect) frame
{
	return [[[GCConnectionsView alloc] initWithFrame: frame] autorelease];
}

- (void) waitForHumanMoveWithCompletion: (void (^) (Move move)) completionHandler {
	//Run loop
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

- (NSString *) stringForBoard: (NSArray *) _board{
	NSString * result = @"";
	NSInteger size = position.size;
	for(int row = size - 2; row > 0; row -= 2){
		for(int col = 1; col < size - 1; col += 2){
			NSString * piece = (NSString *) [_board objectAtIndex: row*size + col];
			if([piece isEqual: BLANK]){
				result = [result stringByAppendingString: @" "];
			}
			else
				result = [result stringByAppendingString: piece];
		}
	}
	
	for(int row = size - 3; row > 0; row -= 2){
		for(int col = 2; col < size - 1; col += 2){
			NSString * piece = (NSString *) [_board objectAtIndex: row*size + col];
			if([piece isEqual: BLANK]){
				result = [result stringByAppendingString: @" "];
			}
			else
				result = [result stringByAppendingString: piece];
		}
	}
	return result;
}

- (void) chainDecrement: (NSMutableArray*) loop
				  given: (NSMutableArray *) decrementedVerts{
	int num = 0;
	NSInteger size = position.size;
	while (num < [decrementedVerts count]) {
		int connectorPos = [[decrementedVerts objectAtIndex: num] intValue];
		num += 1;
		if([[loop objectAtIndex: connectorPos] intValue] == 1){
			[loop replaceObjectAtIndex: connectorPos withObject: [NSNumber numberWithInt: -1]];
			int val = 0;
			int secondConnectorPos = 0;
			int left = connectorPos - 2;
			int right = connectorPos + 2;
			int above = connectorPos - 2*size;
			int below = connectorPos + 2*size;
			
			//decrement the connecting connector
			BOOL checkL = NO, checkR = NO, checkU = NO, checkD = NO;
			//if we are at the left most column for red or for blue, don't check left
			if(connectorPos % size > 1){
				checkL = YES;
			}
			//if we are at the right most column for red or for blue, don't check right
			if(connectorPos % size <= size - 3){
				checkR = YES;
			}
			//if we are at the top most row for red or for blue, don't check up
			if(connectorPos / size >= 2){
				checkU = YES;
			}
			//if we are at the bottom most row for red or for blue, don't check down
			if(connectorPos / size <= size - 3){
				checkD = YES;
			}
			
			if(checkL){
				if([[loop objectAtIndex: left] intValue] > 0){
					val = [[loop objectAtIndex: left] intValue] - 1;
					[loop replaceObjectAtIndex: left withObject: [NSNumber numberWithInt: val]];
					secondConnectorPos = left;
				}
			}
			if(checkR){
				if([[loop objectAtIndex: right] intValue] > 0){
					val = [[loop objectAtIndex: right] intValue] - 1;
					[loop replaceObjectAtIndex: right withObject: [NSNumber numberWithInt: val]];
					secondConnectorPos = right;
				}
			}
			if(checkU){
				if([[loop objectAtIndex: above] intValue] > 0){
					val = [[loop objectAtIndex: above] intValue] - 1;
					[loop replaceObjectAtIndex: above withObject: [NSNumber numberWithInt: val]];
					secondConnectorPos = above;
				}
			}
			if(checkD){
				if([[loop objectAtIndex: below] intValue] > 0){
					val = [[loop objectAtIndex: below] intValue] - 1;
					[loop replaceObjectAtIndex: below withObject: [NSNumber numberWithInt: val]];
					secondConnectorPos = below;
				}
			}
			
			[decrementedVerts addObject: [NSNumber numberWithInt: secondConnectorPos]];
		}
	}
	
}


- (void) decrementVerticesIn: (NSMutableArray *) loop{
	NSMutableArray * decrementedVerts = [[NSMutableArray alloc] init];
	int secondConnectorPos = 0;
	int row = 0, rowLimit = 0, col = 0, colLimit = 0;
	NSInteger size = position.size;
	if(!position.p1Turn){
		row = 0;
		rowLimit = size - 1; 
		col = 1; 
		colLimit = size - 2;
	}
	else{
		row = 1;
		rowLimit = size - 2;
		col = 0;
		colLimit = size - 1;
	}
	for(; row <= rowLimit; row+=2 ){
		for(;col <= colLimit; col +=2 ){
			int connectorPos = row*size + col;
			//find vertex with degree one and decrement it and its connecting vertex
			if([[loop objectAtIndex: connectorPos] intValue] == 1){
				[loop replaceObjectAtIndex: connectorPos withObject: [NSNumber numberWithInt: -1]];
				
				int val = 0;
				
				int left = connectorPos - 2;
				int right = connectorPos + 2;
				int above = connectorPos - 2*size;
				int below = connectorPos + 2*size;
				BOOL checkL = NO, checkR = NO, checkU = NO, checkD = NO;
				//if we are at the left most column for red or for blue, don't check left
				if(col > 1){
					checkL = YES;
				}
				//if we are at the right most column for red or for blue, don't check right
				if(col <= size - 3){
					checkR = YES;
				}
				//if we are at the top most row for red or for blue, don't check up
				if(row >= 2){
					checkU = YES;
				}
				//if we are at the bottom most row for red or for blue, don't check down
				if(row <= size - 3){
					checkD = YES;
				}
				
				if(checkL){
					if([[loop objectAtIndex: left] intValue] > 0){
						val = [[loop objectAtIndex: left] intValue] - 1;
						[loop replaceObjectAtIndex: left withObject: [NSNumber numberWithInt: val]];
						secondConnectorPos = left;
					}
				}
				if(checkR){
					if([[loop objectAtIndex: right] intValue] > 0){
						val = [[loop objectAtIndex: right] intValue] - 1;
						[loop replaceObjectAtIndex: right withObject: [NSNumber numberWithInt: val]];
						secondConnectorPos = right;
					}
				}
				if(checkU){
					if([[loop objectAtIndex: above] intValue] > 0){
						val = [[loop objectAtIndex: above] intValue] - 1;
						[loop replaceObjectAtIndex: above withObject: [NSNumber numberWithInt: val]];
						secondConnectorPos = above;
					}
				}
				if(checkD){
					if([[loop objectAtIndex: below] intValue] > 0){
						val = [[loop objectAtIndex: below] intValue] - 1;
						[loop replaceObjectAtIndex: below withObject: [NSNumber numberWithInt: val]];
						secondConnectorPos = below;
					}
				}
				
				[decrementedVerts addObject: [NSNumber numberWithInt: secondConnectorPos]];
			}
		}
	}
	[self chainDecrement: loop given: decrementedVerts];
	[decrementedVerts release];
}


- (BOOL) encircled: (NSArray *) theBoard {
	NSInteger size = position.size;
	NSMutableArray * loop = [[NSMutableArray alloc] initWithCapacity: size*size];
	
	for(int i = 0; i < size*size; i += 1){
		[loop addObject: [NSNumber numberWithInt: -1]];
	}
	
	int row = 0, rowLimit = 0, col = 0, colLimit = 0;
	
	if(!position.p1Turn){
		row = 0;
		rowLimit = size - 1; 
		col = 1; 
		colLimit = size - 2;
	}
	else{
		row = 1;
		rowLimit = size - 2;
		col = 0;
		colLimit = size - 1;
	}
	for(; row <= rowLimit; row+=2 ){
		for(;col <= colLimit; col +=2 ){
			int connectorPos = row*size + col;
			int edge = 0;
			BOOL checkRight = NO;
			BOOL checkDown = NO;
			//don't do any checking;
			if(row = rowLimit && col == colLimit){}
			
			//in last row, only look right
			else if(row == rowLimit){
				checkRight = YES;
			}
			
			//in last col, only look down
			else if(col == colLimit){
				checkDown = YES;
			}
			
			//can look right and down
			else{
				checkRight = YES;
				checkDown = YES;
			}
			
			if(checkRight){
				edge = connectorPos + 1;
				if([[theBoard objectAtIndex: edge] isEqual: BLANK]){}
				else{
					int val = 0;
					int deg = [[loop objectAtIndex: connectorPos] intValue];
					//first connector
					if(deg > 0){
						val = deg;
					}
					val += 1;
					NSNumber * newDegree = [NSNumber numberWithInt: val];
					[loop replaceObjectAtIndex: connectorPos withObject: newDegree];
					
					//second connector
					val = 0;
					deg = [[loop objectAtIndex: connectorPos + 2] intValue];
					if(deg > 0){
						val = deg;
					}
					val += 1;
					NSNumber * newDegree2 = [NSNumber numberWithInt: val];
					[loop replaceObjectAtIndex: connectorPos + 2 withObject: newDegree2];
				}
			}
			
			if(checkDown){
				edge = connectorPos + size;
				if([[theBoard objectAtIndex: edge] isEqual: BLANK]){}
				else{
					//first connector
					int val = 0;
					int deg = [[loop objectAtIndex: connectorPos] intValue];
					if(deg > 0){
						val = deg;
					}
					val += 1;
					NSNumber * newDegree = [NSNumber numberWithInt: val];
					[loop replaceObjectAtIndex: connectorPos withObject: newDegree];
					
					//second connector
					val = 0;
					deg = [[loop objectAtIndex: connectorPos + 2*size] intValue];
					if(deg > 0){
						val = deg;
					}
					val += 1;
					NSNumber * newDegree2 = [NSNumber numberWithInt: val];
					[loop replaceObjectAtIndex: connectorPos + 2*size withObject: newDegree2];
				}
			}
			
		}
	}
	[self decrementVerticesIn: (NSMutableArray *) loop];
	
	int total = 0;
	for(int i = 1; i < size*size; i += 2){
		if([[loop objectAtIndex: i] intValue] > 0)
			total += 1;
		//NSLog(@"degrees of vertexes: %d", [[loop objectAtIndex: i] intValue]);
	}
	//NSLog(@"number of connections: %d", total);
	[loop release];
	if(total >= 4){
		//[loop dealloc];
		//[vertices dealloc];
		return YES;
	}
	else{
		//[loop dealloc];
		//[vertices dealloc];
		return NO;
	}
}

- (void) resetBoard {
	if(position.board){
		[position.board release];
	}
	NSInteger size = position.size;
	position.board = [[NSMutableArray alloc] initWithCapacity: size * size];
	for (int j = 0; j < size; j += 1) {
		for (int i = 0; i < size; i += 1) {
			if(i % 2 == j % 2){
				[position.board addObject:BLANK];
			}
			else if(i % 2 == 0){
				[position.board addObject: OCON];
			}
			else {
				[position.board addObject: XCON];
			}
		}
	}
}



@end
