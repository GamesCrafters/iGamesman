//
//  GCQuartoBoard.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/16/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import "GCQuartoBoard.h"

#import "GCQuartoPiece.h"


@interface GCQuartoBoard ()

/**
 * Set a new board
 *
 * @param aBoard The new board. The receiver retains the array.
 */
- (void) setBoard: (NSMutableArray *) aBoard;


/**
 * Set a new remaining pieces array
 *
 * @param pieces The new array of remaining pieces. The receiver retains the array.
 */
- (void) setRemainingPieces: (NSMutableArray *) pieces;

@end


@implementation GCQuartoBoard

- (id) init
{
    self = [super init];
    
    if (self)
    {
        board = [[NSMutableArray alloc] initWithCapacity: 16];
        remainingPieces = [[NSMutableArray alloc] initWithCapacity: 16];
        
        for (int i = 0; i < 16; i += 1)
        {
            GCQuartoPiece *blank = [GCQuartoPiece blankPiece];
            [board addObject: blank];
            
            BOOL square = (i >> 0) & 1;
            BOOL solid  = (i >> 1) & 1;
            BOOL tall   = (i >> 2) & 1;
            BOOL white  = (i >> 3) & 1;
            
            GCQuartoPiece *piece = [GCQuartoPiece pieceWithSquare: square
                                                            solid: solid
                                                             tall: tall
                                                            white: white];
            [remainingPieces addObject: piece];
        }
    }
    
    return self;
}


- (void) setBoard: (NSMutableArray *) aBoard
{
    /* Release the old board */
    [board release];
    
    /* Retain the passed-in board */
    board = [aBoard retain];
}


- (void) setRemainingPieces: (NSMutableArray *) pieces
{
    /* Release the old array */
    [remainingPieces release];
    
    /* Retain the passed-in array */
    remainingPieces = [pieces retain];
}


- (id) copyWithZone: (NSZone *) zone
{
    GCQuartoBoard *copy = [[GCQuartoBoard allocWithZone: zone] init];
    
    NSMutableArray *boardCopy = [board mutableCopy];
    NSMutableArray *piecesCopy = [remainingPieces mutableCopy];
    
    [copy setBoard: boardCopy];
    [copy setRemainingPieces: piecesCopy];
    
    [boardCopy release];
    [piecesCopy release];
    
    return copy;
}

@end
