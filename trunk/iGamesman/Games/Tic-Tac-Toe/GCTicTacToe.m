//
//  GCTicTacToe.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/10/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCTicTacToe.h"

#import "GCPlayer.h"
#import "GCTicTacToePosition.h"
#import "GCTicTacToeView.h"

#import "GCJSONService.h"


@implementation GCTicTacToe

#pragma mark - Memory lifecycle

- (id) init
{
    self = [super init];
    
    if (self)
    {
        _tttView = nil;
        
        _leftPlayer  = nil;
        _rightPlayer = nil;
        
        _showMoveValues = _showDeltaRemoteness = NO;
    }
    
    return self;
}


- (void) dealloc
{
    [_leftPlayer release];
    [_rightPlayer release];
    [_position release];
    [_tttView release];
    [_moveValues release];
    
    [super dealloc];
}


#pragma mark - GCGame protocol

- (NSString *) gcWebServiceName
{
    if ([_position isMisere])
        return nil;
    
    return @"ttt";
}


- (NSDictionary *) gcWebParameters
{
    if ([_position isMisere])
        return nil;
    
    NSNumber *width  = [NSNumber numberWithUnsignedInteger: _position.columns];
    NSNumber *height = [NSNumber numberWithUnsignedInteger: _position.rows];
    NSNumber *pieces = [NSNumber numberWithUnsignedInteger: _position.toWin];
    
    NSArray *objs = [NSArray arrayWithObjects: width, height, pieces, nil];
    NSArray *keys = [NSArray arrayWithObjects: @"width", @"height", @"pieces", nil];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjects: objs forKeys: keys];
    
    return params;
}


- (NSString *) gcWebBoardString
{
    if ([_position isMisere])
        return nil;
    
    NSMutableString *boardString = [NSMutableString string];
    
    for (GCTTTPiece piece in _position.board)
    {
        if ([piece isEqualToString: GCTTTXPiece])
            [boardString appendString: @"X"];
        else if ([piece isEqualToString: GCTTTOPiece])
            [boardString appendString: @"O"];
        else if ([piece isEqualToString: GCTTTBlankPiece])
            [boardString appendString: @" "];
    }
    
    return [boardString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}


- (void) gcWebReportedPositionValue: (GCGameValue *) value remoteness: (NSInteger) remoteness
{
    
}


- (void) gcWebReportedValues: (NSArray *) values remotenesses: (NSArray *) remotenesses forMoves: (NSArray *) moves
{
    NSMutableArray *tempVals = [[NSMutableArray alloc] initWithCapacity: [[_position board] count]];
    for (NSUInteger i = 0; i < [[_position board] count]; i += 1)
        [tempVals addObject: GCGameValueUnknown];
    
    for (NSUInteger i = 0; i < [moves count]; i += 1)
    {
        NSString *moveString = [[moves objectAtIndex: i] uppercaseString];
        GCGameValue *value = [values objectAtIndex: i];
        
        char columnChar = (char) [moveString characterAtIndex: 0];
        NSUInteger column = columnChar - 'A';
        NSUInteger row    = [[moveString substringFromIndex: 1] integerValue] - 1;
        
        [tempVals replaceObjectAtIndex: column + row * _position.columns withObject: value];
    }
    
    _moveValues = tempVals;
    
    
    NSMutableArray *tempRemotes = [[NSMutableArray alloc] initWithCapacity: [[_position board] count]];
    for (NSUInteger i = 0; i < [[_position board] count]; i += 1)
        [tempRemotes addObject: [NSNumber numberWithInteger: INT_MAX]];
    
    for (NSUInteger i = 0; i < [moves count]; i += 1)
    {
        NSString *moveString = [[moves objectAtIndex: i] uppercaseString];
        NSNumber *remoteness = [remotenesses objectAtIndex: i];
        
        char columnChar = (char) [moveString characterAtIndex: 0];
        NSUInteger column = columnChar - 'A';
        NSUInteger row    = [[moveString substringFromIndex: 1] integerValue] - 1;
        
        [tempRemotes replaceObjectAtIndex: column + row * _position.columns withObject: remoteness];
    }
    
    _remotenessValues = tempRemotes;
    
    [_tttView setNeedsDisplay];
}


- (GCMove *) moveForGCWebMove: (NSString *) gcWebMove
{
    char columnChar = (char) [gcWebMove characterAtIndex: 0];
    NSUInteger column = columnChar - 'A';
    NSUInteger row    = [[gcWebMove substringFromIndex: 1] integerValue] - 1;
    
    return [NSNumber numberWithInteger: column + row * _position.columns];
}


- (NSString *) name
{
    return @"Tic-Tac-Toe";
}


- (UIView *) viewWithFrame: (CGRect) frame
{
    if (_tttView)
        [_tttView release];
    
    _tttView = [[GCTicTacToeView alloc] initWithFrame: frame];
    _tttView.delegate = self;
    return _tttView;
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
    
    [_leftPlayer setEpithet: @"X"];
    [_rightPlayer setEpithet: @"O"];
    
    if (_position)
        [_position release];
    
    _position = [[GCTicTacToePosition alloc] initWithWidth: 3 height: 3 toWin: 3];
    [_position setLeftTurn: YES];
    
    BOOL misere = [[options objectForKey: GCMisereOptionKey] boolValue];
    [_position setMisere: misere];
    
    [_tttView setNeedsDisplay];
}


- (void) waitForHumanMoveWithCompletion: (GCMoveCompletionHandler) completionHandler
{
    _moveHandler = completionHandler;
    
    [_tttView startReceivingTouches];
}


- (GCPosition *) currentPosition
{
    return _position;
}


- (GCPlayerSide) currentPlayerSide
{
    if (_position.leftTurn)
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
    
    if (_position.leftTurn)
    {
        [_position.board replaceObjectAtIndex: [move unsignedIntegerValue] withObject: GCTTTXPiece];
    }
    else
    {
        [_position.board replaceObjectAtIndex: [move unsignedIntegerValue] withObject: GCTTTOPiece];
    }
    
    _position.leftTurn = !_position.leftTurn;
    
    [_moveValues release];
    _moveValues = nil;
    
    [_tttView setNeedsDisplay];
}


- (void) undoMove: (NSNumber *) move toPosition: (GCTicTacToePosition *) previousPosition
{
    [_position.board replaceObjectAtIndex: [move unsignedIntegerValue] withObject: GCTTTBlankPiece];
    
    _position.leftTurn = !_position.leftTurn;
    
    [_moveValues release];
    _moveValues = nil;
    
    [_tttView setNeedsDisplay];
}


- (GCGameValue *) primitive
{
    NSUInteger rows = _position.rows;
    NSUInteger columns = _position.columns;
    NSUInteger toWin = _position.toWin;
    
    for (int i = 0; i < rows * columns; i += 1)
    {
        NSString *piece = [_position.board objectAtIndex: i];
        
        if ([piece isEqualToString: GCTTTBlankPiece])
            continue;
        
        /* Horizontal case */
        BOOL horizontal = YES;
        for (int j = i; j < i + toWin; j += 1)
        {
            if ((j >= columns * rows) || ((i % columns) > (j % columns)) || ![[_position.board objectAtIndex: j] isEqual: piece])
            {
                horizontal = NO;
                break;
            }
        }
        
        
        /* Vertical case */
        BOOL vertical = YES;
		for (int j = i; j < i + columns * toWin; j += columns)
        {
			if ((j >= columns * rows) || ![[_position.board objectAtIndex: j] isEqual: piece])
            {
				vertical = NO;
				break;
			}
		}
        
        
        /* Positive diagonal case */
        BOOL positiveDiagonal = YES;
		for (int j = i; j < i + toWin + columns * toWin; j += (columns + 1) )
        {
			if ((j >= columns * rows) || ((i % columns) > (j % columns)) || ![[_position.board objectAtIndex: j] isEqual: piece])
            {
				positiveDiagonal = NO;
				break;
			}
		}
        
        
        /* Negative diagonal case */
        BOOL negativeDiagonal = YES;
		for (int j = i; j < i + columns * toWin - toWin; j += (columns - 1))
        {
			if ((j >= columns * rows) || ((i % columns) < (j % columns)) || ![[_position.board objectAtIndex: j] isEqual: piece])
            {
				negativeDiagonal = NO;
				break;
			}
		}
        
        if (horizontal || vertical || positiveDiagonal || negativeDiagonal)
        {
            BOOL pieceIsCurrentPlayer = [piece isEqual: ([_position leftTurn] ? GCTTTXPiece : GCTTTOPiece)];
            if ([_position isMisere])
                return (pieceIsCurrentPlayer ? GCGameValueLose : GCGameValueWin);
            else
                return (pieceIsCurrentPlayer ? GCGameValueWin : GCGameValueLose);
        }
    }
    
    NSUInteger numBlanks = 0;
    for (int i = 0; i < [_position.board count]; i += 1)
    {
        if ([[_position.board objectAtIndex: i] isEqualToString: GCTTTBlankPiece])
            numBlanks += 1;
    }
    if (numBlanks == 0)
        return GCGameValueTie;
    
    return nil;
}


- (NSArray *) generateMoves
{
    NSMutableArray *legalMoves = [[NSMutableArray alloc] initWithCapacity: _position.rows * _position.columns];
    
    for (int i = 0; i < [_position.board count]; i += 1)
    {
        if ([[_position.board objectAtIndex: i] isEqualToString: GCTTTBlankPiece])
            [legalMoves addObject: [NSNumber numberWithInt: i]];
    }
    
    return [legalMoves autorelease];
}


- (BOOL) isMisere
{
    return [_position isMisere];
}


- (BOOL) canShowMoveValues
{
    return ![_position isMisere];
}


- (BOOL) canShowDeltaRemoteness
{
    return ![_position isMisere];
}


- (BOOL) isShowingDeltaRemoteness
{
    if ([_position isMisere])
        return NO;
    
    return _showDeltaRemoteness;
}


- (BOOL) isShowingMoveValues
{
    if ([_position isMisere])
        return NO;
    
    return _showMoveValues;
}


- (void) setShowingDeltaRemoteness: (BOOL) deltaRemoteness
{
    _showDeltaRemoteness = deltaRemoteness;
    
    [_tttView setNeedsDisplay];
}


- (void) setShowingMoveValues: (BOOL) moveVals
{
    _showMoveValues = moveVals;
    
    [_tttView setNeedsDisplay];
}


#pragma mark -
#pragma mark GCTicTacToeViewDelegate

- (GCTicTacToePosition *) position
{
    return _position;
}


- (NSArray *) moveValues
{
    return _moveValues;
}


- (NSArray *) remotenessValues
{
    return _remotenessValues;
}


- (void) userChoseMove: (NSNumber *) slot
{
    [_tttView stopReceivingTouches];
    _moveHandler(slot);
}


@end
