//
//  GCTicTacToe.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/21/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import "GCTicTacToe.h"

#import "GCTicTacToeView.h"

@implementation GCTicTacToe

#pragma mark -
#pragma mark Memory lifecycle

- (id) init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}


- (void) dealloc
{
    [position release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark GCGame protocol

- (UIView *) viewWithFrame: (CGRect) frame
{
    tttView = [[GCTicTacToeView alloc] initWithFrame: frame];
    tttView.delegate = self;
    return tttView;
}


- (void) startGameWithLeft: (GCPlayer *) left
                     right: (GCPlayer *) right
           andPlaySettings: (NSDictionary *) settingsDict
{
    leftPlayer = [left retain];
    rightPlayer = [right retain];
    
    if ([settingsDict objectForKey: GCGameModeKey] == GCGameModeOfflineUnsolved)
        mode = OFFLINE_UNSOLVED;
    else if ([settingsDict objectForKey: GCGameModeKey] == GCGameModeOnlineSolved)
        mode = ONLINE_SOLVED;
    
    position = [[GCTicTacToePosition alloc] initWithWidth: 3 height: 3 toWin: 3];
    position.leftTurn = YES;
}


- (GCPlayer *) leftPlayer
{
    return leftPlayer;
}


- (GCPlayer *) rightPlayer
{
    return rightPlayer;
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
            return [piece isEqual: (position.leftTurn ? @"X" : @"O")] ? GCGameValueWin : GCGameValueLose;
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


- (PlayerSide) currentPlayer
{
    if (position.leftTurn)
        return PLAYER_LEFT;
    else
        return PLAYER_RIGHT;
}


- (void) waitForHumanMoveWithCompletion: (GCMoveCompletionHandler) completionHandler
{
    Block_release(moveHandler);
    moveHandler = Block_copy(completionHandler);
    [tttView startReceivingTouches];
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
    
    [tttView setNeedsDisplay];
}


- (void) undoMove: (NSNumber *) move toPosition: (GCTicTacToePosition *) previousPosition
{
    [position.board replaceObjectAtIndex: [move unsignedIntegerValue] withObject: GCTTTBlankPiece];
    
    position.leftTurn = !position.leftTurn;
    
    [tttView setNeedsDisplay];
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

- (GCPosition *) currentPosition
{
    return position;
}


#pragma mark -
#pragma mark GCTicTacToeViewDelegate

- (GCTicTacToePosition *) position
{
    return position;
}

- (void) userChoseMove: (NSNumber *) slot
{
    [tttView stopReceivingTouches];
    moveHandler(slot);
}

@end
