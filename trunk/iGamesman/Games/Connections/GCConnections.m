//
//  GCConnections.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/20/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCConnections.h"

#import "GCConnectionsIntegerQueue.h"
#import "GCConnectionsPosition.h"
#import "GCPlayer.h"

@implementation GCConnections

- (id) init
{
    self = [super init];
    
    if (self)
    {
        position = nil;
        
        connectionsView = nil;
        
        leftPlayer = nil;
        rightPlayer = nil;
    }
    
    return self;
}


#pragma mark - GCGame protocol

- (NSString *) name
{
    return @"Connections";
}


- (UIView *) viewWithFrame: (CGRect) frame center: (CGPoint) center
{
    if (connectionsView)
        [connectionsView release];
    
    connectionsView = [[GCConnectionsView alloc] initWithFrame: frame];
    [connectionsView setDelegate: self];
    [connectionsView setBackgroundCenter: center];
    return connectionsView;
}


- (void) startGameWithLeft: (GCPlayer *) left right: (GCPlayer *) right
{
    [left retain];
    [right retain];
    
    if (leftPlayer)
        [leftPlayer release];
    if (rightPlayer)
        [rightPlayer release];
    
    leftPlayer  = left;
    rightPlayer = right;
    
    [leftPlayer setEpithet: @"Red"];
    [rightPlayer setEpithet: @"Blue"];
    
    if (position)
        [position release];
    
    position = [[GCConnectionsPosition alloc] initWithSize: 7];
    position.leftTurn = YES;
}


- (void) waitForHumanMoveWithCompletion: (GCMoveCompletionHandler) completionHandler
{
    moveHandler = completionHandler;
    
    [connectionsView startReceivingTouches];
}


- (GCPosition *) currentPosition
{
    return position;
}


- (GCPlayerSide) currentPlayerSide
{
    if (position.leftTurn)
        return GC_PLAYER_LEFT;
    else
        return GC_PLAYER_RIGHT;
}


- (GCPlayer *) leftPlayer
{
    return leftPlayer;
}


- (GCPlayer *) rightPlayer
{
    return rightPlayer;
}


- (void) doMove: (NSNumber *) move
{	
	int slot = [move integerValue] - 1;
    
	[position.board replaceObjectAtIndex: slot withObject: (position.leftTurn ? GCConnectionsRedPiece : GCConnectionsBluePiece)];
	position.leftTurn = !position.leftTurn;
	
    [connectionsView setNeedsDisplay];
}


- (void) undoMove: (NSNumber *) move toPosition: (GCConnectionsPosition *) toPos
{
	int slot = [move intValue] - 1;
    
	[position.board replaceObjectAtIndex: slot withObject: GCConnectionsBlankPiece];
	position.leftTurn = !position.leftTurn;
    
    [connectionsView setNeedsDisplay];
}


- (GCGameValue *) primitive
{
	GCConnectionsIntegerQueue * queue = [[GCConnectionsIntegerQueue alloc] init];
	int positionNum;
	int neighborPosition;
	int size = position.size;
	
	NSMutableArray* board = position.board;

    if ([[self generateMoves] count] == 0)
    {
		[queue release];
        return GCGameValueLose;
	}
	
	//////////////////p1 turn finished/////////////////////////
	if (!position.leftTurn){ 
		
		//add in initial positions, starting with the position directly below the top left connector
		for (int i = size + 1; i < size * 2 - 1; i += 2)
        {
			if ([[board objectAtIndex: i] isEqual: GCConnectionsRedPiece])
				[queue push: i];
		}
		
		while ([queue notEmpty])
        {
			positionNum = [queue pop];
			
			//Check to see if we are at the end of our path
			if (positionNum/size >= size - 2)
            {
				[queue release];
				return GCGameValueLose;
			}
			
			//add neighbors to the fringe
			//////////////odd case///////////////	In terms of column number from 0-size and position in terms of array (index at 0)
			if ((positionNum % size) % 2)
            {						
				//////left neighbor- only check if we are not in the leftmost column
				if ((positionNum % size) > 1)
                {
					neighborPosition = positionNum + size - 1;
					
					if ([[board objectAtIndex: neighborPosition] isEqual: GCConnectionsRedPiece])
						[queue push: neighborPosition];
				}
				
				/////right neighbor- only check if we are not in the rightmost column
				if ((positionNum % size) < size - 2)
                {
					neighborPosition = positionNum + size + 1;
					
					if ([[board objectAtIndex: neighborPosition] isEqual: GCConnectionsRedPiece])
						[queue push: neighborPosition];
				}
				
				/////bottom neighbor
				neighborPosition = positionNum + size * 2;
				if ([[board objectAtIndex: neighborPosition] isEqual: GCConnectionsRedPiece])
					[queue push: neighborPosition];
				
			}
			//////////////even case///////////////
			else
            { 	
				
				/////left neighbor- only check if we are not in the leftmost column///////
				if ((positionNum % size) > 3)
                {
					neighborPosition = positionNum - 2;
					
					//Check if The proper piece is in the neighboring position and that the position is not already in the fringe, then add it to the fringe
					if ([[board objectAtIndex: neighborPosition] isEqual: GCConnectionsRedPiece])
						[queue push: neighborPosition];
					
				}
				
				/////bottom left neighbor///////
				neighborPosition = positionNum + size - 1;
				if ([[board objectAtIndex: neighborPosition] isEqual: GCConnectionsRedPiece])
					[queue push: neighborPosition];
				
				/////right neighbor- only check if we are not in the rightmost column///////
				if ((positionNum % size) < size - 2)
                {
					neighborPosition = positionNum + 2;
					if ([[board objectAtIndex: neighborPosition] isEqual: GCConnectionsRedPiece])
						[queue push: neighborPosition];
				}
				
				/////bottom right neighbor///////
				neighborPosition = positionNum + size + 1;
				if ([[board objectAtIndex: neighborPosition] isEqual: GCConnectionsRedPiece])
					[queue push: neighborPosition];
			}
		}
		
		//////////////////p2 turn/////////////////////////
	}
    else
    { 
		//add initial positions
		for (int i = size + 1; i < size * (size - 1); i += size)
        {
			if ([[board objectAtIndex: i] isEqual: GCConnectionsBluePiece])
				[queue push: i];
		}
		
		//check player
		while ([queue notEmpty])
        {
			positionNum = [queue pop];
			
			//Check to see if we are at the end of our path
			if (positionNum % size >= size - 2)
            {
				[queue release];
				return GCGameValueLose;
			}
			
			//////////////odd case///////////////
			if ((positionNum % size) % 2)
            {
				//up- only check if not in topmost row
				if (positionNum > 2 * size)
                {
					neighborPosition = positionNum - size + 1;
					
					if([[board objectAtIndex: neighborPosition] isEqual: GCConnectionsBluePiece])
						[queue push: neighborPosition];
				}
				
				//down- only check if not in bottommost row
				if(positionNum < size * (size - 2))
                {
					neighborPosition = positionNum + size + 1;
					
					if([[board objectAtIndex: neighborPosition] isEqual: GCConnectionsBluePiece])
						[queue push: neighborPosition];
					
				}
				//right
				neighborPosition = positionNum + 2;
				if ([[board objectAtIndex: neighborPosition] isEqual: GCConnectionsBluePiece])
					[queue push: neighborPosition];
				
			}
			//////////////even case///////////////
			else
            {
				//up- only if not in the third row
				if (positionNum > size * 3)
                {
					neighborPosition = positionNum - size * 2;
					if ([[board objectAtIndex: neighborPosition] isEqual: GCConnectionsBluePiece])
						[queue push: neighborPosition];
				}
				
				//down- only if not in the third row from the bottom
				if (positionNum < size * (size - 3))
                {
					neighborPosition = positionNum + size * 2;
					if ([[board objectAtIndex: neighborPosition] isEqual: GCConnectionsBluePiece])
						[queue push: neighborPosition];
				}
				//upper right
				neighborPosition = positionNum - size + 1;
				if ([[board objectAtIndex: neighborPosition] isEqual: GCConnectionsBluePiece])
					[queue push: neighborPosition];
				
				//lower right
				neighborPosition = positionNum + size + 1;
				if ([[board objectAtIndex: neighborPosition] isEqual: GCConnectionsBluePiece])
					[queue push: neighborPosition];
				
			}
		}
	}
	
	[queue release];
	return nil;
}


- (NSArray *) generateMoves
{
	NSMutableArray *moves = [[NSMutableArray alloc] init];
	NSMutableArray *board = position.board;
	int size = position.size;
	
	for (int j = 0; j < size; j += 1)
    {
		for (int i = 0; i < size; i += 1)
        {
			if ([[board objectAtIndex: i + j * size] isEqual: GCConnectionsBlankPiece])
            {
                if ( (position.leftTurn && (i != 0) && (i != (size - 1))) || (!position.leftTurn && (j != 0) && (j != (size -1))) )
                    [moves addObject: [NSNumber numberWithInt: i + j * size + 1]];
                
//				if (i != 0 && i != size - 1 && j != 0 && j != size - 1)
//					[moves addObject: [NSNumber numberWithInt: i + j * size + 1]];
			}
		}
	}
	return [moves autorelease];
}


#pragma mark - GCConnectionsViewDelegate

- (GCConnectionsPosition *) position
{
    return position;
}


- (void) userChoseMove: (NSNumber *) slot
{
    [connectionsView stopReceivingTouches];
    moveHandler(slot);
}

@end
