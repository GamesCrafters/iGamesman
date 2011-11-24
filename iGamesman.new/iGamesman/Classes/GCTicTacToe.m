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


- (GameValue) primitive: (Position) pos
{
    GCTicTacToePosition *thePosition = (GCTicTacToePosition *) pos;
    
    NSUInteger rows = thePosition.rows;
    NSUInteger columns = thePosition.columns;
    NSUInteger toWin = thePosition.toWin;
    
    for (int i = 0; i < rows * columns; i += 1)
    {
        NSString *piece = [thePosition.board objectAtIndex: i];
        
        if ([piece isEqualToString: GCTTTBlankPiece])
            continue;
        
        /* Horizontal case */
        BOOL horizontal = YES;
        for (int j = i; j < i + toWin; j += 1)
        {
            if ((j >= columns * rows) || ((i % columns) > (j % columns)) || ![[thePosition.board objectAtIndex: j] isEqual: piece])
            {
                horizontal = NO;
                break;
            }
        }
        
        
        /* Vertical case */
        BOOL vertical = YES;
		for (int j = i; j < i + columns * toWin; j += columns)
        {
			if ((j >= columns * rows) || ![[thePosition.board objectAtIndex: j] isEqual: piece])
            {
				vertical = NO;
				break;
			}
		}

        
        /* Positive diagonal case */
        BOOL positiveDiagonal = YES;
		for (int j = i; j < i + toWin + columns * toWin; j += (columns + 1) )
        {
			if ((j >= columns * rows) || ((i % columns) > (j % columns)) || ![[thePosition.board objectAtIndex: j] isEqual: piece])
            {
				positiveDiagonal = NO;
				break;
			}
		}

        
        /* Negative diagonal case */
        BOOL negativeDiagonal = YES;
		for (int j = i; j < i + columns * toWin - toWin; j += (columns - 1))
        {
			if ((j >= columns * rows) || ((i % columns) < (j % columns)) || ![[thePosition.board objectAtIndex: j] isEqual: piece])
            {
				negativeDiagonal = NO;
				break;
			}
		}
        
        if (horizontal || vertical || positiveDiagonal || negativeDiagonal)
            return [piece isEqual: (thePosition.leftTurn ? @"X" : @"O")] ? WIN : LOSE;
    }
    
    NSUInteger numBlanks = 0;
    for (int i = 0; i < [thePosition.board count]; i += 1)
    {
        if ([[thePosition.board objectAtIndex: i] isEqualToString: GCTTTBlankPiece])
            numBlanks += 1;
    }
    if (numBlanks == 0)
        return TIE;
    
    return NONPRIMITIVE;
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
    moveHandler = Block_copy(completionHandler);
    [tttView startReceivingTouches];
}


- (Position) doMove: (NSNumber *) move
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
    
    return position;
}


- (void) undoMove: (NSNumber *) move toPosition: (Position) toPos
{
    [position.board replaceObjectAtIndex: [move unsignedIntegerValue] withObject: GCTTTBlankPiece];
    
    position.leftTurn = !position.leftTurn;
    
    [tttView setNeedsDisplay];
}


- (NSArray *) generateMoves: (Position) pos
{
    GCTicTacToePosition *thePosition = (GCTicTacToePosition *) pos;
    
    NSMutableArray *legalMoves = [[NSMutableArray alloc] initWithCapacity: thePosition.rows * thePosition.columns];
    
    for (int i = 0; i < [thePosition.board count]; i += 1)
    {
        if ([[thePosition.board objectAtIndex: i] isEqualToString: GCTTTBlankPiece])
            [legalMoves addObject: [NSNumber numberWithInt: i]];
    }
    
    return [legalMoves autorelease];
}


#pragma mark -
#pragma mark GCTicTacToeViewDelegate

- (GCTicTacToePosition *) currentPosition
{
    return position;
}

- (void) userChoseMove: (NSNumber *) slot
{
    [tttView stopReceivingTouches];
    moveHandler(slot);
}

@end
