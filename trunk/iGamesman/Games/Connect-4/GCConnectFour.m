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
        _connectFourView = nil;
        
        _position = nil;
        
        _leftPlayer  = nil;
        _rightPlayer = nil;
        
        _moveHandler = nil;
        
        _showMoveValues = _showDeltaRemoteness = NO;
        
        _moveValues = nil;
        _remotenessValues = nil;
    }
    
    return self;
}


- (void) dealloc
{
    [_connectFourView release];
    [_position release];
    [_leftPlayer release];
    [_rightPlayer release];
    [_moveValues release];
    [_remotenessValues release];
    
    [super dealloc];
}


#pragma mark - GCGame protocol

- (NSString *) gcWebServiceName
{
    return @"connect4";
}


- (NSDictionary *) gcWebParameters
{
    NSNumber *width  = [NSNumber numberWithUnsignedInteger: [_position columns]];
    NSNumber *height = [NSNumber numberWithUnsignedInteger: [_position rows]];
    NSNumber *pieces = [NSNumber numberWithUnsignedInteger: [_position toWin]];
    
    NSArray *objs = [NSArray arrayWithObjects: width, height, pieces, nil];
    NSArray *keys = [NSArray arrayWithObjects: @"width", @"height", @"pieces", nil];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjects: objs forKeys: keys];
    
    return params;
}


- (NSString *) gcWebBoardString
{
    NSMutableString *boardString = [NSMutableString string];
    
    for (GCConnectFourPiece piece in [_position board])
    {
        if ([piece isEqualToString: GCConnectFourRedPiece])
            [boardString appendString: @"X"];
        else if ([piece isEqualToString: GCConnectFourBluePiece])
            [boardString appendString: @"O"];
        else if ([piece isEqualToString: GCConnectFourBlankPiece])
            [boardString appendString: @" "];
    }
    
    return [boardString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}


- (void) gcWebReportedPositionValue: (NSString *) value remoteness: (NSInteger) remoteness
{
    
}


- (void) gcWebReportedValues: (NSArray *) values remotenesses: (NSArray *) remotenesses forMoves: (NSArray *) moves
{
    NSMutableArray *tempVals = [[NSMutableArray alloc] initWithCapacity: [_position columns]];
    for (NSUInteger i = 0; i < [_position columns]; i += 1)
        [tempVals addObject: GCGameValueUnknown];
    
    NSMutableArray *tempRemotes = [[NSMutableArray alloc] initWithCapacity: [_position columns]];
    for (NSUInteger i = 0; i < [_position columns]; i += 1)
        [tempRemotes addObject: [NSNumber numberWithInt: INT_MAX]];
    
    for (NSUInteger i = 0; i < [moves count]; i += 1)
    {
        NSString *moveString = [moves objectAtIndex: i];
        GCGameValue *value = [values objectAtIndex: i];
        NSNumber *remoteness = [remotenesses objectAtIndex: i];
        
        
        NSInteger column = [moveString integerValue];
        
        [tempVals replaceObjectAtIndex: column withObject: value];
        [tempRemotes replaceObjectAtIndex: column withObject: remoteness];
    }
    
    _moveValues = tempVals;
    _remotenessValues = tempRemotes;
    
    [_connectFourView setNeedsDisplay];
}


- (GCMove *) moveForGCWebMove: (NSString *) gcWebMove
{
    NSInteger column = [gcWebMove integerValue];
    return [NSNumber numberWithInteger: column];
}


- (NSString *) name
{
    return @"Connect 4";
}


- (UIView *) viewWithFrame: (CGRect) frame
{
    if (_connectFourView)
        [_connectFourView release];
    
    _connectFourView = [[GCConnectFourView alloc] initWithFrame: frame];
    [_connectFourView setDelegate: self];
    return _connectFourView;
}


- (void) startGameWithLeft: (GCPlayer *) left right: (GCPlayer *) right
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
    
    _position = [[GCConnectFourPosition alloc] initWithWidth: 6 height: 4 toWin: 4];
    [_position setLeftTurn: YES];
    
    [_connectFourView resetBoard];
}


- (void) waitForHumanMoveWithCompletion: (GCMoveCompletionHandler) completionHandler
{
    _moveHandler = completionHandler;
    
    [_connectFourView startReceivingTouches];
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
    NSMutableArray *board = [_position board];
    
    [_connectFourView doMove: move];
    
	NSUInteger slot = [move unsignedIntegerValue];
	while (slot < ([_position columns] * [_position rows]))
    {
		if ([[board objectAtIndex: slot] isEqual: GCConnectFourBlankPiece])
        {
			[board replaceObjectAtIndex: slot withObject: ([_position leftTurn] ? GCConnectFourRedPiece : GCConnectFourBluePiece)];
			break;
		}
		slot += [_position columns];
	}
    
    [_moveValues release];
    _moveValues = nil;
    
    [_remotenessValues release];
    _remotenessValues = nil;

    [_position setLeftTurn: ![_position leftTurn]];
}


- (void) undoMove: (NSNumber *) move toPosition: (GCConnectFourPosition *) previousPosition
{
    NSMutableArray *board = [_position board];
    
    [_connectFourView undoMove: move];
	
	NSInteger slot = [move integerValue] + [_position columns] * ([_position rows] - 1);
	while (slot >= 0)
    {
		if (![[board objectAtIndex: slot] isEqualToString: GCConnectFourBlankPiece])
        {
			[board replaceObjectAtIndex: slot withObject: GCConnectFourBlankPiece];
			break;
		}
		slot -= [_position columns];
	}
    
    [_position setLeftTurn: ![_position leftTurn]];
}


- (GCGameValue *) primitive
{
    NSUInteger rows = [_position rows];
    NSUInteger columns = [_position columns];
    NSUInteger toWin = [_position toWin];
    
    for (int i = 0; i < rows * columns; i += 1)
    {
        NSString *piece = [[_position board] objectAtIndex: i];
        
        if ([piece isEqualToString: GCConnectFourBlankPiece])
            continue;
        
        /* Horizontal case */
        BOOL horizontal = YES;
        for (int j = i; j < i + toWin; j += 1)
        {
            if ((j >= columns * rows) || ((i % columns) > (j % columns)) || ![[[_position board] objectAtIndex: j] isEqual: piece])
            {
                horizontal = NO;
                break;
            }
        }
        
        
        /* Vertical case */
        BOOL vertical = YES;
		for (int j = i; j < i + columns * toWin; j += columns)
        {
			if ((j >= columns * rows) || ![[[_position board] objectAtIndex: j] isEqual: piece])
            {
				vertical = NO;
				break;
			}
		}
        
        
        /* Positive diagonal case */
        BOOL positiveDiagonal = YES;
		for (int j = i; j < i + toWin + columns * toWin; j += (columns + 1) )
        {
			if ((j >= columns * rows) || ((i % columns) > (j % columns)) || ![[[_position board] objectAtIndex: j] isEqual: piece])
            {
				positiveDiagonal = NO;
				break;
			}
		}
        
        
        /* Negative diagonal case */
        BOOL negativeDiagonal = YES;
		for (int j = i; j < i + columns * toWin - toWin; j += (columns - 1))
        {
			if ((j >= columns * rows) || ((i % columns) < (j % columns)) || ![[[_position board] objectAtIndex: j] isEqual: piece])
            {
				negativeDiagonal = NO;
				break;
			}
		}
        
        if (horizontal || vertical || positiveDiagonal || negativeDiagonal)
        {
            BOOL pieceIsCurrentPlayer = [piece isEqual: ([_position leftTurn] ? GCConnectFourRedPiece : GCConnectFourBluePiece)];
            return (pieceIsCurrentPlayer ? GCGameValueWin : GCGameValueLose);
        }
    }
    
    NSUInteger numBlanks = 0;
    for (int i = 0; i < [[_position board] count]; i += 1)
    {
        if ([[[_position board] objectAtIndex: i] isEqualToString: GCConnectFourBlankPiece])
            numBlanks += 1;
    }
    if (numBlanks == 0)
        return GCGameValueTie;
    
    return nil;
}


- (NSArray *) generateMoves
{
    NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity: [_position columns]];
	
    NSUInteger width = [_position columns];
    NSUInteger height = [_position rows];
    
	NSUInteger column = 0;
	for (int i = width * (height - 1); i < width * height; i += 1) {
		if ([[[_position board] objectAtIndex: i] isEqual: GCConnectFourBlankPiece])
			[moves addObject: [NSNumber numberWithInteger: column]];
		column += 1;
	}
	
	return [moves autorelease];
}


- (BOOL) isShowingMoveValues
{
    return _showMoveValues;
}


- (void) setShowingMoveValues: (BOOL) moveValues
{
    _showMoveValues = moveValues;
    
    [_connectFourView setNeedsDisplay];
}


- (BOOL) isShowingDeltaRemoteness
{
    return _showDeltaRemoteness;
}


- (void) setShowingDeltaRemoteness: (BOOL) deltaRemoteness
{
    _showDeltaRemoteness = deltaRemoteness;
    
    [_connectFourView setNeedsDisplay];
}


#pragma mark - GCConnectFourViewDelegate

- (GCConnectFourPosition *) position
{
    return _position;
}


- (void) userChoseMove: (NSNumber *) column
{
    [_connectFourView stopReceivingTouches];
    _moveHandler(column);
}


- (NSArray *) moveValues
{
    return _moveValues;
}


- (NSArray *) remotenessValues
{
    return _remotenessValues;
}

@end
