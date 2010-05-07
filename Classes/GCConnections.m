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
@synthesize misere;

- (id) init {
	if (self = [super init]) {
		player1Name = @"Player 1";
		player2Name = @"Player 2";
		
		size = 7;
		misere = NO;
		
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

	if([self encircled: theBoard]){
		return misere ? @"WIN" : @"LOSE";
	}
	
	if ([[self legalMoves] count] == 0){
		//return misere ? @"LOSE" : @"WIN";
		return misere ? @"WIN" : @"LOSE";
	}

	//////////////////p1 turn finished/////////////////////////
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
				//return misere ? @"LOSE" : @"WIN";
				return misere ? @"WIN" : @"LOSE";
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
		    //NSLog(@"X queue not empty: %d", position);
			
			//Check to see if we are at the end of our path
			if (position % size >= size - 2){
				[queue release];
				//NSLog(@"Game Over");
				//return misere ? @"LOSE" : @"WIN";
				return misere ? @"WIN" : @"LOSE";
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
	return nil;
}

- (BOOL) encircled: (NSArray *) theBoard{
	//this will hold the degrees of the vertices
	//indexing is congruent to theBoard
	NSMutableArray * loop = [[NSMutableArray alloc] initWithCapacity: size*size];
	
	//player 2's turn
	if(!p1Turn){
		for(int row = 0; row <= size - 1; row += 2){
			for(int col = 1; col <= size - 2; col += 2){
				int connectorPos = row*size + col;
				
				//stop checking once we hit the bottom rightmost connector
				if(row == size - 1 && col == size - 2){
					break;
				}
					
				//only check right if in last row for player 1, increase degree of connectorPos 
				//and the corresponding connector to the right
				if(row == size - 1){
					
					if([[theBoard objectAtIndex: connectorPos + 1] isEqual: X]){
						int val = 0;
						//first connector
						if([loop objectAtIndex: connectorPos] != nil){
							val = [[loop objectAtIndex: connectorPos] intValue];
						}
						val += 1;
						NSNumber * newDegree = [NSNumber numberWithInt: val];
						[loop replaceObjectAtIndex: (NSUInteger) connectorPos withObject: newDegree];
						
						val = 0;
						//second connector
						if([loop objectAtIndex: connectorPos + 2] != nil){
							val = [[loop objectAtIndex: connectorPos + 2] intValue];
						}
						val += 1;
						NSNumber * newDegree2 = [NSNumber numberWithInt: val];
						[loop replaceObjectAtIndex: (NSUInteger) connectorPos withObject: newDegree2];
					}
					
				}
				
				//only check down if in last column for player 1
				else if(col == size - 2){
					if([[theBoard objectAtIndex: connectorPos + size] isEqual: X]){
						//update degrees of connectors
						int val = 0;
						//first connector
						if([loop objectAtIndex: connectorPos] != nil){
							val = [[loop objectAtIndex: connectorPos] intValue];
						}
						val += 1;
						NSNumber * newDegree = [NSNumber numberWithInt: val];
						[loop replaceObjectAtIndex: (NSUInteger) connectorPos withObject: newDegree];
						
						val = 0;
						//second connector
						if([loop objectAtIndex: connectorPos + 2*size] != nil){
							val = [[loop objectAtIndex: connectorPos + 2*size] intValue];
						}
						val += 1;
						NSNumber * newDegree2 = [NSNumber numberWithInt: val];
						[loop replaceObjectAtIndex: (NSUInteger) connectorPos + 2*size withObject: newDegree2];
					}
				}
				
				//check down and right to look for a connection
				else{
					if([[theBoard objectAtIndex: connectorPos + 1] isEqual: X]){
						//update degrees of connectors
						int val = 0;
						//first connector
						if([loop objectAtIndex: connectorPos] != nil){
							val = [[loop objectAtIndex: connectorPos] intValue];
						}
						val += 1;
						NSNumber * newDegree = [NSNumber numberWithInt: val];
						[loop replaceObjectAtIndex: (NSUInteger) connectorPos withObject: newDegree];
						
						//second connector to the right
						val = 0;
						if([loop objectAtIndex:	(NSUInteger connectorPos + 2)] != nil){
							val = [[loop objectAtIndex: connectorPos + 2] intValue];
						}
						val += 1;
						NSNumber * newDegree2 = [NSNumber numberWithInt: val];
						[loop replaceObjectAtIndex: (NSUInteger) val + 2 withObject: newDegree2];
					}
					// down part
					if([[theBoard objectAtIndex: connectorPos + size] isEqual: X]){
						//update degrees of connectors
						int val = 0;
						//first connector
						if([loop objectAtIndex: connectorPos] != nil){
							val = [[loop objectAtIndex: connectorPos] intValue];
						}
						val += 1;
						NSNumber * newDegree1 = [NSNumber numberWithInt: val];
						
						[loop replaceObjectAtIndex: connectorPos withObject: newDegree1];
						
						//second connector to the right
						val = 0;
						if([loop objectAtIndex: connectorPos + 2*size] != nil){
							val = [[loop objectAtIndex: connectorPos + 2*size] intValue];
						}
						val += 1; 
						NSNumber * newDegree2 = [NSNumber numberWithInt: val];
						
						[loop replaceObjectAtIndex: connectorPos withObject: newDegree2];
					}
					
				}
			}
		}
		
		
		//get rid of all connectors with one degree in loop array
		for(int row = 0; row <= size - 1; row += 2){
			for(int col = 1; col <= size - 2; col += 2){
				int connectorPos = row*size + col;
				//find all connectors with degree one and get rid of it and 
				//decrement degree of connecting connector
				if([loop objectAtIndex: connectorPos] != nil && [[loop objectAtIndex: connectorPos] intValue] == 1){
					[loop replaceObjectAtIndex: connectorPos withObject: nil];
					int val = 0;
					
					//if connecting connector is to the left
					if(col != 1 && [loop objectAtIndex: connectorPos - 2] != nil){
						val = [[loop objectAtIndex: connectorPos - 2] intValue] - 1;
						[loop replaceObjectAtIndex: connectorPos - 2 withObject: [NSNumber numberWithInt: val]];
					}
					
					//if connecting connector is to the right
					if(col != size - 2 && [loop objectAtIndex: connectorPos + 2] != nil){
						val = [[loop objectAtIndex: connectorPos + 2] intValue] - 1;
						[loop replaceObjectAtIndex: connectorPos + 2 withObject: [NSNumber numberWithInt: val]];
					}
					
					//if connecting connector is above
					if(row != 0 && [loop objectAtIndex: connectorPos - 2*size] != nil){
						val = [[loop objectAtIndex: connectorPos - 2*size] intValue] - 1;
						[loop replaceObjectAtIndex: connectorPos - 2*size withObject: [NSNumber numberWithInt: val]];
					}
					
					//if connecting connector is below
					if(row != size - 1 && [loop objectAtIndex: connectorPos + 2*size] != nil){
						val = [[loop objectAtIndex: connectorPos + 2*size] intValue] -1;
						[loop replaceObjectAtIndex: connectorPos + 2*size withObject: [NSNumber numberWithInt: val]];
					}
					
				}
			}
		}
		
		
	}
	
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
