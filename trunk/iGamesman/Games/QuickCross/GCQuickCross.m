//
//  GCQuickCross.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/22/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCQuickCross.h"

#import "GCPlayer.h"
#import "GCQuickCrossPosition.h"


@implementation GCQuickCross

#pragma mark - Memory lifecycle

- (id) init
{
    self = [super init];
    
    if (self)
    {
        position = nil;
        
        leftPlayer = nil;
        rightPlayer = nil;
        
        quickCrossView = nil;
    }
    
    return self;
}


- (void) dealloc
{
    [position release];
    
    [leftPlayer release];
    [rightPlayer release];
    
    [quickCrossView release];
    
    [super dealloc];
}


#pragma mark - GCGame protocol

- (NSString *) name
{
    return @"Quick Cross";
}


- (UIView *) viewWithFrame: (CGRect) frame center: (CGPoint) center
{
    if (quickCrossView)
        [quickCrossView release];
    
    quickCrossView = [[GCQuickCrossView alloc] initWithFrame: frame];
    [quickCrossView setDelegate: self];
    [quickCrossView setBackgroundCenter: center];
    return quickCrossView;
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
    
    [leftPlayer setEpithet: nil];
    [rightPlayer setEpithet: nil];
    
    
    if (position)
        [position release];
    
    position = [[GCQuickCrossPosition alloc] initWithWidth: 4 height: 4 toWin: 4];
    position.leftTurn = YES;
}


- (void) waitForHumanMoveWithCompletion: (GCMoveCompletionHandler) completionHandler
{
    moveHandler = completionHandler;
    
    [quickCrossView startReceivingTouches];
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


- (void) doMove: (NSArray *) move
{
    NSNumber *slot = [move objectAtIndex: 0];
    NSString *moveType = [move lastObject];
    NSUInteger index = [slot unsignedIntegerValue];
    
    if ([moveType isEqual: GCQuickCrossSpinMove])
    {
        if ([[position.board objectAtIndex: index] isEqual: GCQuickCrossVerticalPiece])
            [position.board replaceObjectAtIndex: index withObject: GCQuickCrossHorizontalPiece];
        else if ([[position.board objectAtIndex: index] isEqual: GCQuickCrossHorizontalPiece])
            [position.board replaceObjectAtIndex: index withObject: GCQuickCrossVerticalPiece];
    }
    else if ([moveType isEqual: GCQuickCrossPlaceHorizontalMove])
    {
        [position.board replaceObjectAtIndex: index withObject: GCQuickCrossHorizontalPiece];
    }
    else if ([moveType isEqual: GCQuickCrossPlaceVerticalMove])
    {
        [position.board replaceObjectAtIndex: index withObject: GCQuickCrossVerticalPiece];
    }
    
    position.leftTurn = !position.leftTurn;
    
    [quickCrossView setNeedsDisplay];
}


- (void) undoMove: (NSArray *) move toPosition: (GCQuickCrossPosition *) previousPosition
{
    NSNumber *slot = [move objectAtIndex: 0];
    NSString *moveType = [move lastObject];
    NSUInteger index = [slot unsignedIntegerValue];
    
    if ([moveType isEqual: GCQuickCrossSpinMove])
    {
        if ([[position.board objectAtIndex: index] isEqual: GCQuickCrossVerticalPiece])
            [position.board replaceObjectAtIndex: index withObject: GCQuickCrossHorizontalPiece];
        else if ([[position.board objectAtIndex: index] isEqual: GCQuickCrossHorizontalPiece])
            [position.board replaceObjectAtIndex: index withObject: GCQuickCrossVerticalPiece];
    }
    else
    {
        [position.board replaceObjectAtIndex: index withObject: GCQuickCrossBlankPiece];
    }
    
    position.leftTurn = !position.leftTurn;
    
    [quickCrossView setNeedsDisplay];
}


- (GCGameValue *) primitive
{
    NSUInteger rows = [position rows];
    NSUInteger columns = [position columns];
    NSUInteger toWin = [position toWin];
    NSMutableArray *board = [position board];
    
	for (NSUInteger i = 0; i < rows * columns; i += 1)
    {
		NSString *piece = [board objectAtIndex: i];
		if ([piece isEqual: GCQuickCrossBlankPiece])
			continue;
        
        /* Horizontal case */
        BOOL horizontal = YES;
        for (NSUInteger j = i; j < i + toWin; j += 1)
        {
            if ((j >= columns * rows) || ((i % columns) > (j % columns)) || ![[board objectAtIndex: j] isEqual: piece])
            {
                horizontal = NO;
                break;
            }
        }
        
        
        /* Vertical case */
        BOOL vertical = YES;
		for (int j = i; j < i + columns * toWin; j += columns)
        {
			if ((j >= columns * rows) || ![[board objectAtIndex: j] isEqual: piece])
            {
				vertical = NO;
				break;
			}
		}
        
        
        /* Positive diagonal case */
        BOOL positiveDiagonal = YES;
		for (int j = i; j < i + toWin + columns * toWin; j += (columns + 1) )
        {
			if ((j >= columns * rows) || ((i % columns) > (j % columns)) || ![[board objectAtIndex: j] isEqual: piece])
            {
				positiveDiagonal = NO;
				break;
			}
		}
        
        
        /* Negative diagonal case */
        BOOL negativeDiagonal = YES;
		for (int j = i; j < i + columns * toWin - toWin; j += (columns - 1))
        {
			if ((j >= columns * rows) || ((i % columns) < (j % columns)) || ![[board objectAtIndex: j] isEqual: piece])
            {
				negativeDiagonal = NO;
				break;
			}
		}
        
        
        if (horizontal || vertical || positiveDiagonal || negativeDiagonal)
            return GCGameValueLose;		
	}
	return nil;
}


- (NSArray *) generateMoves
{
    NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity: 2 * position.rows * position.columns];
    for (NSUInteger i = 0; i < position.rows + position.columns; i += 1)
    {
        NSNumber *slot = [NSNumber numberWithUnsignedInt: i];
        if ([position.board isEqual: GCQuickCrossBlankPiece])
        {
            [moves addObject: [NSArray arrayWithObjects: slot, GCQuickCrossPlaceHorizontalMove, nil]];
            [moves addObject: [NSArray arrayWithObjects: slot, GCQuickCrossPlaceVerticalMove, nil]];
        }
        else if ([position.board isEqual: GCQuickCrossHorizontalPiece] || [position.board isEqual: GCQuickCrossVerticalPiece])
        {
            [moves addObject: [NSArray arrayWithObjects: slot, GCQuickCrossSpinMove, nil]];
        }
    }
    
    return [moves autorelease];
}


#pragma mark - GCQuickCrossViewDelegate

- (GCQuickCrossPosition *) position
{
    return position;
}


- (void) userChoseMove: (NSArray *) move
{
    [quickCrossView stopReceivingTouches];
    
    moveHandler(move);
}

@end
