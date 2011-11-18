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


#pragma mark -

@implementation GCQuartoBoard

#pragma mark -

- (GCQuartoPiece *) pieceAtRow: (NSUInteger) row andColumn: (NSUInteger) column
{
    GCQuartoPiece *piece = [board objectAtIndex: (row * 4) + column];
    return piece;
}


- (NSArray *) availablePieces
{
    return remainingPieces;
}


- (BOOL) placePiece: (GCQuartoPiece *) piece atRow: (NSUInteger) row andColumn: (NSUInteger) column
{
    if (![remainingPieces containsObject: piece])
        return NO;
    
    [board replaceObjectAtIndex: (row * 4) + column withObject: piece];
    [remainingPieces removeObject: piece];
    
    return YES;
}


- (GCQuartoPiece *) removePieceAtRow: (NSUInteger) row andColumn: (NSUInteger) column
{
    GCQuartoPiece *piece = [board objectAtIndex: (row * 4) + column];
    if ([piece isBlank])
        return nil;
    
    [board replaceObjectAtIndex: (row * 4) + column withObject: [GCQuartoPiece blankPiece]];
    [remainingPieces addObject: piece];
    
    return piece;
}


#pragma mark -
#pragma mark Memory lifecycle

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


- (void) dealloc
{
    [board release];
    [remainingPieces release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Private accessors for copy purposes

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


#pragma mark -
#pragma mark NSCopying

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
