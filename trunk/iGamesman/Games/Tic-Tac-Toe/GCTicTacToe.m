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
        tttView = nil;
        
        leftPlayer  = nil;
        rightPlayer = nil;
        
        showMoveValues = showDeltaRemoteness = NO;
    }
    
    return self;
}


- (void) dealloc
{
    [leftPlayer release];
    [rightPlayer release];
    [position release];
    [tttView release];
    [moveValues release];
    
    [super dealloc];
}


#pragma mark - GCGame protocol

- (NSString *) gcWebServiceName
{
    return @"ttt";
}


- (NSDictionary *) gcWebParameters
{    
    NSNumber *width  = [NSNumber numberWithUnsignedInteger: position.columns];
    NSNumber *height = [NSNumber numberWithUnsignedInteger: position.rows];
    NSNumber *pieces = [NSNumber numberWithUnsignedInteger: position.toWin];
    
    NSArray *objs = [NSArray arrayWithObjects: width, height, pieces, nil];
    NSArray *keys = [NSArray arrayWithObjects: @"width", @"height", @"pieces", nil];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjects: objs forKeys: keys];
    
    return params;
}


- (NSString *) gcWebBoardString
{
    NSMutableString *boardString = [NSMutableString string];
    
    for (GCTTTPiece piece in position.board)
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
    NSMutableArray *tempVals = [[NSMutableArray alloc] initWithCapacity: [[position board] count]];
    for (NSUInteger i = 0; i < [[position board] count]; i += 1)
        [tempVals addObject: GCGameValueUnknown];
    
    for (NSUInteger i = 0; i < [moves count]; i += 1)
    {
        NSString *moveString = [[moves objectAtIndex: i] uppercaseString];
        GCGameValue *value = [values objectAtIndex: i];
        
        char columnChar = (char) [moveString characterAtIndex: 0];
        NSUInteger column = columnChar - 'A';
        NSUInteger row    = [[moveString substringFromIndex: 1] integerValue] - 1;
        
        [tempVals replaceObjectAtIndex: column + row * position.columns withObject: value];
    }
    
    moveValues = tempVals;
    
    
    NSMutableArray *tempRemotes = [[NSMutableArray alloc] initWithCapacity: [[position board] count]];
    for (NSUInteger i = 0; i < [[position board] count]; i += 1)
        [tempRemotes addObject: [NSNumber numberWithInteger: INT_MAX]];
    
    for (NSUInteger i = 0; i < [moves count]; i += 1)
    {
        NSString *moveString = [[moves objectAtIndex: i] uppercaseString];
        NSNumber *remoteness = [remotenesses objectAtIndex: i];
        
        char columnChar = (char) [moveString characterAtIndex: 0];
        NSUInteger column = columnChar - 'A';
        NSUInteger row    = [[moveString substringFromIndex: 1] integerValue] - 1;
        
        [tempRemotes replaceObjectAtIndex: column + row * position.columns withObject: remoteness];
    }
    
    remotenessValues = tempRemotes;
    
    [tttView setNeedsDisplay];
}


- (GCMove *) moveForGCWebMove: (NSString *) gcWebMove
{
    char columnChar = (char) [gcWebMove characterAtIndex: 0];
    NSUInteger column = columnChar - 'A';
    NSUInteger row    = [[gcWebMove substringFromIndex: 1] integerValue] - 1;
    
    return [NSNumber numberWithInteger: column + row * position.columns];
}


- (NSString *) name
{
    return @"Tic-Tac-Toe";
}


- (UIView *) viewWithFrame: (CGRect) frame
{
    if (tttView)
        [tttView release];
    
    tttView = [[GCTicTacToeView alloc] initWithFrame: frame];
    tttView.delegate = self;
    return tttView;
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
    
    [leftPlayer setEpithet: @"X"];
    [rightPlayer setEpithet: @"O"];
    
    if (position)
        [position release];
    
    position = [[GCTicTacToePosition alloc] initWithWidth: 3 height: 3 toWin: 3];
    position.leftTurn = YES;
}


- (void) waitForHumanMoveWithCompletion: (GCMoveCompletionHandler) completionHandler
{
    moveHandler = completionHandler;
    
    [tttView startReceivingTouches];
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
    
    if (position.leftTurn)
    {
        [position.board replaceObjectAtIndex: [move unsignedIntegerValue] withObject: GCTTTXPiece];
    }
    else
    {
        [position.board replaceObjectAtIndex: [move unsignedIntegerValue] withObject: GCTTTOPiece];
    }
    
    position.leftTurn = !position.leftTurn;
    
    [moveValues release];
    moveValues = nil;
    
    [tttView setNeedsDisplay];
}


- (void) undoMove: (NSNumber *) move toPosition: (GCTicTacToePosition *) previousPosition
{
    [position.board replaceObjectAtIndex: [move unsignedIntegerValue] withObject: GCTTTBlankPiece];
    
    position.leftTurn = !position.leftTurn;
    
    [moveValues release];
    moveValues = nil;
    
    [tttView setNeedsDisplay];
}


- (GCGameValue *) primitive
{
    NSUInteger rows = position.rows;
    NSUInteger columns = position.columns;
    NSUInteger toWin = position.toWin;
    
    for (int i = 0; i < rows * columns; i += 1)
    {
        NSString *piece = [position.board objectAtIndex: i];
        
        if ([piece isEqualToString: GCTTTBlankPiece])
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
            return [piece isEqual: (position.leftTurn ? GCTTTXPiece : GCTTTOPiece)] ? GCGameValueWin : GCGameValueLose;
    }
    
    NSUInteger numBlanks = 0;
    for (int i = 0; i < [position.board count]; i += 1)
    {
        if ([[position.board objectAtIndex: i] isEqualToString: GCTTTBlankPiece])
            numBlanks += 1;
    }
    if (numBlanks == 0)
        return GCGameValueTie;
    
    return nil;
}


- (NSArray *) generateMoves
{
    NSMutableArray *legalMoves = [[NSMutableArray alloc] initWithCapacity: position.rows * position.columns];
    
    for (int i = 0; i < [position.board count]; i += 1)
    {
        if ([[position.board objectAtIndex: i] isEqualToString: GCTTTBlankPiece])
            [legalMoves addObject: [NSNumber numberWithInt: i]];
    }
    
    return [legalMoves autorelease];
}


- (BOOL) isShowingDeltaRemoteness
{
    return showDeltaRemoteness;
}


- (BOOL) isShowingMoveValues
{
    return showMoveValues;
}


- (void) setShowingDeltaRemoteness: (BOOL) deltaRemoteness
{
    showDeltaRemoteness = deltaRemoteness;
    
    [tttView setNeedsDisplay];
}


- (void) setShowingMoveValues: (BOOL) moveVals
{
    showMoveValues = moveVals;
    
    [tttView setNeedsDisplay];
}


#pragma mark -
#pragma mark GCTicTacToeViewDelegate

- (GCTicTacToePosition *) position
{
    return position;
}


- (NSArray *) moveValues
{
    return moveValues;
}


- (NSArray *) remotenessValues
{
    return remotenessValues;
}


- (void) userChoseMove: (NSNumber *) slot
{
    [tttView stopReceivingTouches];
    moveHandler(slot);
}


@end
