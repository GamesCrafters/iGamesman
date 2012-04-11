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
        _position = nil;
        
        _leftPlayer = nil;
        _rightPlayer = nil;
        
        _quickCrossView = nil;
    }
    
    return self;
}


- (void) dealloc
{
    [_position release];
    
    [_leftPlayer release];
    [_rightPlayer release];
    
    [_quickCrossView release];
    
    [super dealloc];
}


#pragma mark - GCGame protocol

- (NSString *) name
{
    return @"Quick Cross";
}


- (UIView *) viewWithFrame: (CGRect) frame
{
    if (_quickCrossView)
        [_quickCrossView release];
    
    _quickCrossView = [[GCQuickCrossView alloc] initWithFrame: frame];
    [_quickCrossView setDelegate: self];
    return _quickCrossView;
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
    
    [_leftPlayer setEpithet: nil];
    [_rightPlayer setEpithet: nil];
    
    
    if (_position)
        [_position release];
    
    _position = [[GCQuickCrossPosition alloc] initWithWidth: 4 height: 4 toWin: 4];
    [_position setLeftTurn: YES];
    
    BOOL misere = [[options objectForKey: GCMisereOptionKey] boolValue];
    [_position setMisere: misere];
    
    [_quickCrossView setNeedsDisplay];
}


- (void) waitForHumanMoveWithCompletion: (GCMoveCompletionHandler) completionHandler
{
    _moveHandler = completionHandler;
    
    [_quickCrossView startReceivingTouches];
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


- (void) doMove: (NSArray *) move
{
    NSNumber *slot = [move objectAtIndex: 0];
    NSString *moveType = [move lastObject];
    NSUInteger index = [slot unsignedIntegerValue];
    
    if ([moveType isEqual: GCQuickCrossSpinMove])
    {
        if ([[[_position board] objectAtIndex: index] isEqual: GCQuickCrossVerticalPiece])
            [[_position board] replaceObjectAtIndex: index withObject: GCQuickCrossHorizontalPiece];
        else if ([[[_position board] objectAtIndex: index] isEqual: GCQuickCrossHorizontalPiece])
            [[_position board] replaceObjectAtIndex: index withObject: GCQuickCrossVerticalPiece];
    }
    else if ([moveType isEqual: GCQuickCrossPlaceHorizontalMove])
    {
        [[_position board] replaceObjectAtIndex: index withObject: GCQuickCrossHorizontalPiece];
    }
    else if ([moveType isEqual: GCQuickCrossPlaceVerticalMove])
    {
        [[_position board] replaceObjectAtIndex: index withObject: GCQuickCrossVerticalPiece];
    }
    
    [_position setLeftTurn: ![_position leftTurn]];
    
    [_quickCrossView setNeedsDisplay];
}


- (void) undoMove: (NSArray *) move toPosition: (GCQuickCrossPosition *) previousPosition
{
    NSNumber *slot = [move objectAtIndex: 0];
    NSString *moveType = [move lastObject];
    NSUInteger index = [slot unsignedIntegerValue];
    
    if ([moveType isEqual: GCQuickCrossSpinMove])
    {
        if ([[[_position board] objectAtIndex: index] isEqual: GCQuickCrossVerticalPiece])
            [[_position board] replaceObjectAtIndex: index withObject: GCQuickCrossHorizontalPiece];
        else if ([[[_position board] objectAtIndex: index] isEqual: GCQuickCrossHorizontalPiece])
            [[_position board] replaceObjectAtIndex: index withObject: GCQuickCrossVerticalPiece];
    }
    else
    {
        [[_position board] replaceObjectAtIndex: index withObject: GCQuickCrossBlankPiece];
    }
    
    [_position setLeftTurn: ![_position leftTurn]];
    
    [_quickCrossView setNeedsDisplay];
}


- (GCGameValue *) primitive
{
    NSUInteger rows = [_position rows];
    NSUInteger columns = [_position columns];
    NSUInteger toWin = [_position toWin];
    NSMutableArray *board = [_position board];
    
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
            return [_position isMisere] ? GCGameValueWin : GCGameValueLose;
	}
	return nil;
}


- (NSArray *) generateMoves
{
    NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity: 2 * [_position rows] * [_position columns]];
    for (NSUInteger i = 0; i < [_position rows] + [_position columns]; i += 1)
    {
        NSNumber *slot = [NSNumber numberWithUnsignedInt: i];
        if ([[_position board] isEqual: GCQuickCrossBlankPiece])
        {
            [moves addObject: [NSArray arrayWithObjects: slot, GCQuickCrossPlaceHorizontalMove, nil]];
            [moves addObject: [NSArray arrayWithObjects: slot, GCQuickCrossPlaceVerticalMove, nil]];
        }
        else if ([[_position board] isEqual: GCQuickCrossHorizontalPiece] || [[_position board] isEqual: GCQuickCrossVerticalPiece])
        {
            [moves addObject: [NSArray arrayWithObjects: slot, GCQuickCrossSpinMove, nil]];
        }
    }
    
    return [moves autorelease];
}


- (BOOL) isMisere
{
    return [_position isMisere];
}


- (BOOL) canShowMoveValues
{
    return NO;
}


- (BOOL) canShowDeltaRemoteness
{
    return NO;
}


#pragma mark - GCQuickCrossViewDelegate

- (GCQuickCrossPosition *) position
{
    return _position;
}


- (void) userChoseMove: (NSArray *) move
{
    [_quickCrossView stopReceivingTouches];
    
    _moveHandler(move);
}

@end
