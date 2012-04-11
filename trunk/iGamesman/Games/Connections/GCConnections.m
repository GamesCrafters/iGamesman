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
        _position = nil;
        
        _connectionsView = nil;
        
        _leftPlayer = nil;
        _rightPlayer = nil;
    }
    
    return self;
}


#pragma mark - GCGame protocol

- (NSString *) name
{
    return @"Connections";
}


- (UIView *) viewWithFrame: (CGRect) frame
{
    if (_connectionsView)
        [_connectionsView release];
    
    _connectionsView = [[GCConnectionsView alloc] initWithFrame: frame];
    [_connectionsView setDelegate: self];
    return _connectionsView;
}


- (void) startGameWithLeft: (GCPlayer *) left right: (GCPlayer *) right options: (NSDictionary *) options
{
    [left retain];
    [right retain];
    
    if (_leftPlayer)
        [_leftPlayer release];
    if (_rightPlayer)
        [_rightPlayer release];
    
    _leftPlayer  = left;
    _rightPlayer = right;
    
    [_leftPlayer setEpithet: @"Red"];
    [_rightPlayer setEpithet: @"Blue"];
    
    if (_position)
        [_position release];
    
    _position = [[GCConnectionsPosition alloc] initWithSize: 7];
    [_position setLeftTurn: YES];
}


- (void) waitForHumanMoveWithCompletion: (GCMoveCompletionHandler) completionHandler
{
    _moveHandler = completionHandler;
    
    [_connectionsView startReceivingTouches];
}


- (GCPosition *) currentPosition
{
    return _position;
}


- (GCPlayerSide) currentPlayerSide
{
    if ([_position leftTurn])
        return GC_PLAYER_LEFT;
    else
        return GC_PLAYER_RIGHT;
}


- (GCPlayer *) leftPlayer
{
    return _leftPlayer;
}


- (GCPlayer *) rightPlayer
{
    return _rightPlayer;
}


- (void) doMove: (NSNumber *) move
{	
	int slot = [move integerValue] - 1;
    
	[[_position board] replaceObjectAtIndex: slot withObject: ([_position leftTurn] ? GCConnectionsRedPiece : GCConnectionsBluePiece)];
	[_position setLeftTurn: ![_position leftTurn]];
	
    [_connectionsView setNeedsDisplay];
}


- (void) undoMove: (NSNumber *) move toPosition: (GCConnectionsPosition *) toPos
{
	int slot = [move intValue] - 1;
    
	[[_position board] replaceObjectAtIndex: slot withObject: GCConnectionsBlankPiece];
	[_position setLeftTurn: ![_position leftTurn]];
    
    [_connectionsView setNeedsDisplay];
}


- (GCGameValue *) primitive
{
	GCConnectionsIntegerQueue * queue = [[GCConnectionsIntegerQueue alloc] init];
	int positionNum;
	int neighborPosition;
	int size = [_position size];
	
	NSMutableArray* board = [_position board];

    if ([[self generateMoves] count] == 0)
    {
		[queue release];
        return GCGameValueLose;
	}
	
	//////////////////p1 turn finished/////////////////////////
	if (![_position leftTurn])
    { 	
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
	NSMutableArray *board = [_position board];
	int size = [_position size];
	
	for (int j = 0; j < size; j += 1)
    {
		for (int i = 0; i < size; i += 1)
        {
			if ([[board objectAtIndex: i + j * size] isEqual: GCConnectionsBlankPiece])
            {
                if ( ([_position leftTurn] && (i != 0) && (i != (size - 1))) || (![_position leftTurn] && (j != 0) && (j != (size -1))) )
                    [moves addObject: [NSNumber numberWithInt: i + j * size + 1]];
			}
		}
	}
	return [moves autorelease];
}


- (BOOL) canShowMoveValues
{
    return NO;
}


- (BOOL) canShowDeltaRemoteness
{
    return NO;
}


#pragma mark - GCConnectionsViewDelegate

- (GCConnectionsPosition *) position
{
    return _position;
}


- (void) userChoseMove: (NSNumber *) slot
{
    [_connectionsView stopReceivingTouches];
    _moveHandler(slot);
}

@end
