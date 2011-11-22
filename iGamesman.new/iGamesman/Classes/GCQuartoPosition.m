//
//  GCQuartoBoard.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/16/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import "GCQuartoPosition.h"

#import "GCQuartoPiece.h"

#define FLIP_PLAYER(p) ((p == PLAYER_LEFT) ? PLAYER_RIGHT : PLAYER_LEFT)


@interface GCQuartoPosition ()

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

@implementation GCQuartoPosition

#pragma mark -
#pragma mark Memory lifecycle

- (id) initWithStartingPlayer: (PlayerSide) playerSide
{
    self = [super init];
    
    if (self)
    {
        currentPlayer = playerSide;
        turnPhase = GC_QUARTO_CHOOSE;
        
        platformPiece = [GCQuartoPiece blankPiece];
        
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

- (GCQuartoPiece *) pieceAtRow: (NSUInteger) row andColumn: (NSUInteger) column
{
    GCQuartoPiece *piece = [board objectAtIndex: (row * 4) + column];
    return piece;
}


- (GCQuartoPiece *) pieceOnPlatform
{
    return platformPiece;
}


- (NSArray *) availablePieces
{
    return remainingPieces;
}


- (PlayerSide) currentPlayer
{
    return currentPlayer;
}


- (GCQuartoMovePhase) currentTurnPhase
{
    return turnPhase;
}


- (BOOL) movePieceToPlatform: (GCQuartoPiece *) piece
{
    if (turnPhase != GC_QUARTO_CHOOSE)
        return NO;
    
    if (![remainingPieces containsObject: piece])
        return NO;
    
    [remainingPieces removeObject: piece];
    platformPiece = piece;
    
    turnPhase = GC_QUARTO_PLACE;
    currentPlayer = FLIP_PLAYER(currentPlayer);

    return YES;
}


- (GCQuartoPiece *) removePieceFromPlatform
{
    if (turnPhase != GC_QUARTO_PLACE)
        return nil;
    
    GCQuartoPiece *piece = platformPiece;
    [remainingPieces addObject: piece];
    
    platformPiece = [GCQuartoPiece blankPiece];
    
    turnPhase = GC_QUARTO_CHOOSE;
    currentPlayer = FLIP_PLAYER(currentPlayer);
    
    return piece;
}


- (BOOL) placePlatformPieceAtRow: (NSUInteger) row andColumn: (NSUInteger) column
{
    if (turnPhase != GC_QUARTO_PLACE)
        return NO;
    
    if ([platformPiece isBlank])
        return NO;
    
    [board replaceObjectAtIndex: (row * 4) + column withObject: platformPiece];

    platformPiece = nil;
    
    turnPhase = GC_QUARTO_CHOOSE;
    
    return YES;
}


- (GCQuartoPiece *) removePieceAtRow: (NSUInteger) row andColumn: (NSUInteger) column
{
    if (turnPhase != GC_QUARTO_CHOOSE)
        return nil;
    
    GCQuartoPiece *piece = [board objectAtIndex: (row * 4) + column];
    
    if ([piece isBlank])
        return nil;
    
    [board replaceObjectAtIndex: (row * 4) + column withObject: [GCQuartoPiece blankPiece]];
    
    platformPiece = piece;
    
    turnPhase = GC_QUARTO_PLACE;
    
    return piece;
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
#warning Update Me!
    GCQuartoPosition *copy = [[GCQuartoPosition allocWithZone: zone] init];
    
    NSMutableArray *boardCopy = [board mutableCopy];
    NSMutableArray *piecesCopy = [remainingPieces mutableCopy];
    
    [copy setBoard: boardCopy];
    [copy setRemainingPieces: piecesCopy];
    
    [boardCopy release];
    [piecesCopy release];
    
    return copy;
}

@end
