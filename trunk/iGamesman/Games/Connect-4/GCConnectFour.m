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
        
        showMoveValues = showDeltaRemoteness = NO;
        
        moveValues = nil;
        remotenessValues = nil;
    }
    
    return self;
}


- (void) dealloc
{
    [connectFourView release];
    [position release];
    [leftPlayer release];
    [rightPlayer release];
    [moveValues release];
    [remotenessValues release];
    
    [super dealloc];
}


#pragma mark - GCGame protocol

- (NSString *) gcWebServiceName
{
    return @"connect4";
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
    
    for (GCConnectFourPiece piece in position.board)
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
    NSMutableArray *tempVals = [[NSMutableArray alloc] initWithCapacity: [position columns]];
    for (NSUInteger i = 0; i < [position columns]; i += 1)
        [tempVals addObject: GCGameValueUnknown];
    
    NSMutableArray *tempRemotes = [[NSMutableArray alloc] initWithCapacity: [position columns]];
    for (NSUInteger i = 0; i < [position columns]; i += 1)
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
    
    moveValues = tempVals;
    remotenessValues = tempRemotes;
    
    [connectFourView setNeedsDisplay];
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
    if (connectFourView)
        [connectFourView release];
    
    connectFourView = [[GCConnectFourView alloc] initWithFrame: frame];
    [connectFourView setDelegate: self];
    return connectFourView;
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
    
    position = [[GCConnectFourPosition alloc] initWithWidth: 6 height: 4 toWin: 4];
    position.leftTurn = YES;
    
    [connectFourView resetBoard];
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
    
    [moveValues release];
    moveValues = nil;
    
    [remotenessValues release];
    remotenessValues = nil;

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


- (BOOL) isShowingMoveValues
{
    return showMoveValues;
}


- (void) setShowingMoveValues: (BOOL) _moveValues
{
    showMoveValues = _moveValues;
    
    [connectFourView setNeedsDisplay];
}


- (BOOL) isShowingDeltaRemoteness
{
    return showDeltaRemoteness;
}


- (void) setShowingDeltaRemoteness: (BOOL) deltaRemoteness
{
    showDeltaRemoteness = deltaRemoteness;
    
    [connectFourView setNeedsDisplay];
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


- (NSArray *) moveValues
{
    return moveValues;
}


- (NSArray *) remotenessValues
{
    return remotenessValues;
}

@end
