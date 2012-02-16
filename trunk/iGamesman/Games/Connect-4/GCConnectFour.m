//
//  GCConnectFour.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/13/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCConnectFour.h"

#import "GCConnectFourView.h"
#import "GCConnectFourPosition.h"
#import "GCPlayer.h"

@implementation GCConnectFour

#pragma mark - Memory lifecycle

- (id) init
{
    self = [super init];
    
    if (self)
    {
        connectFourView = nil;
        
        position = nil;
        
        leftPlayer  = nil;
        rightPlayer = nil;
        
        moveHandler = nil;
    }
    
    return self;
}


- (void) dealloc
{
    [connectFourView release];
    [position release];
    [leftPlayer release];
    [rightPlayer release];
    
    [super dealloc];
}


#pragma mark - GCGame protocol

- (UIView *) viewWithFrame: (CGRect) frame center: (CGPoint) center
{
    if (connectFourView)
        [connectFourView release];
    
    connectFourView = [[GCConnectFourView alloc] initWithFrame: frame];
    [connectFourView setDelegate: self];
    [connectFourView setBackgroundCenter: center];
    return connectFourView;
}


- (void) setViewFrame: (CGRect) frame center: (CGPoint) center
{
    [connectFourView setFrame: frame];
    [connectFourView setBackgroundCenter: center];
    [connectFourView setNeedsDisplay];
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
    
    position = [[GCConnectFourPosition alloc] initWithWidth: 7 height: 6 toWin: 4];
    position.leftTurn = YES;
}


- (void) waitForHumanMoveWithCompletion: (GCMoveCompletionHandler) completionHandler
{
    moveHandler = completionHandler;
    
    [connectFourView startReceivingTouches];
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
    NSMutableArray *board = position.board;
    
    [connectFourView doMove: move];
    
	NSUInteger slot = [move unsignedIntegerValue];
	while (slot < position.columns * position.rows)
    {
		if ([[board objectAtIndex: slot] isEqual: GCConnectFourBlankPiece])
        {
			[board replaceObjectAtIndex: slot withObject: (position.leftTurn ? GCConnectFourRedPiece : GCConnectFourBluePiece)];
			break;
		}
		slot += position.columns;
	}

    position.leftTurn = !position.leftTurn;
}


- (void) undoMove: (NSNumber *) move toPosition: (GCConnectFourPosition *) previousPosition
{
    NSMutableArray *board = position.board;
    
    [connectFourView undoMove: move];
	
	NSInteger slot = [move integerValue] + position.columns * (position.rows - 1);
	while (slot >= 0)
    {
		if (![[board objectAtIndex: slot] isEqualToString: GCConnectFourBlankPiece])
        {
			[board replaceObjectAtIndex: slot withObject: GCConnectFourBlankPiece];
			break;
		}
		slot -= position.columns;
	}
    
    position.leftTurn = !position.leftTurn;
}


- (GCGameValue *) primitive
{
    NSUInteger rows = position.rows;
    NSUInteger columns = position.columns;
    NSUInteger toWin = position.toWin;
    
    for (int i = 0; i < rows * columns; i += 1)
    {
        NSString *piece = [position.board objectAtIndex: i];
        
        if ([piece isEqualToString: GCConnectFourBlankPiece])
            continue;
        
        /* Horizontal case */
        BOOL horizontal = YES;
        for (int j = i; j < i + toWin; j += 1)
        {
            if ((j >= columns * rows) || ((i % columns) > (j % columns)) || ![[position.board objectAtIndex: j] isEqual: piece])
            {
                horizontal = NO;
                break;
            }
        }
        
        
        /* Vertical case */
        BOOL vertical = YES;
		for (int j = i; j < i + columns * toWin; j += columns)
        {
			if ((j >= columns * rows) || ![[position.board objectAtIndex: j] isEqual: piece])
            {
				vertical = NO;
				break;
			}
		}
        
        
        /* Positive diagonal case */
        BOOL positiveDiagonal = YES;
		for (int j = i; j < i + toWin + columns * toWin; j += (columns + 1) )
        {
			if ((j >= columns * rows) || ((i % columns) > (j % columns)) || ![[position.board objectAtIndex: j] isEqual: piece])
            {
				positiveDiagonal = NO;
				break;
			}
		}
        
        
        /* Negative diagonal case */
        BOOL negativeDiagonal = YES;
		for (int j = i; j < i + columns * toWin - toWin; j += (columns - 1))
        {
			if ((j >= columns * rows) || ((i % columns) < (j % columns)) || ![[position.board objectAtIndex: j] isEqual: piece])
            {
				negativeDiagonal = NO;
				break;
			}
		}
        
        if (horizontal || vertical || positiveDiagonal || negativeDiagonal)
            return [piece isEqual: (position.leftTurn ? GCConnectFourRedPiece : GCConnectFourBluePiece)] ? GCGameValueWin : GCGameValueLose;
    }
    
    NSUInteger numBlanks = 0;
    for (int i = 0; i < [position.board count]; i += 1)
    {
        if ([[position.board objectAtIndex: i] isEqualToString: GCConnectFourBlankPiece])
            numBlanks += 1;
    }
    if (numBlanks == 0)
        return GCGameValueTie;
    
    return nil;
}


- (NSArray *) generateMoves
{
    NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity: position.columns];
	
    NSUInteger width = position.columns;
    NSUInteger height = position.rows;
    
	NSUInteger column = 0;
	for (int i = width * (height - 1); i < width * height; i += 1) {
		if ([[position.board objectAtIndex: i] isEqual: GCConnectFourBlankPiece])
			[moves addObject: [NSNumber numberWithInteger: column]];
		column += 1;
	}
	
	return [moves autorelease];
}


#pragma mark - GCConnectFourViewDelegate

- (GCConnectFourPosition *) position
{
    return position;
}


- (void) userChoseMove: (NSNumber *) column
{
    [connectFourView stopReceivingTouches];
    moveHandler(column);
}

@end
