//
//  GCQuartoBoard.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/16/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCGame.h"


typedef enum { GC_QUARTO_CHOOSE, GC_QUARTO_PLACE } GCQuartoMovePhase;


@class GCQuartoPiece;

@interface GCQuartoPosition : NSObject <NSCopying>
{
    NSMutableArray *board;
    NSMutableArray *remainingPieces;
    GCQuartoPiece *platformPiece;
    PlayerSide currentPlayer;
    GCQuartoMovePhase turnPhase;
}


- (id) initWithStartingPlayer: (PlayerSide) playerSide;


/**
 * Get the piece at a particular location on the board.
 * 
 * @param row The row number in the range [0,3]
 * @param column The column number in the range [0,3]
 *
 * @return The piece in the ROWth row and COLUMNth column
 */
- (GCQuartoPiece *) pieceAtRow: (NSUInteger) row andColumn: (NSUInteger) column;


/**
 * Get the piece currently on the platform, waiting to be placed.
 *
 * @return The piece on the platform
 */
- (GCQuartoPiece *) pieceOnPlatform;


/**
 * Return an array of the currently unplaced pieces.
 *
 * @return The remaining unplaced pieces
 */
- (NSArray *) availablePieces;


/**
 * Return the player whose turn it is.
 *
 * @return The player to make the next move
 */
- (PlayerSide) currentPlayer;


/**
 * Return the phase of the current player's turn (placing or choosing).
 *
 * @return The phase of the current turn
 */
- (GCQuartoMovePhase) currentTurnPhase;


/**
 * Place one of the available pieces on the platform.
 * Removes the piece from the available pieces.
 *
 * @param piece The piece to move to the platform
 *
 * @return YES is successful, NO if not
 */
- (BOOL) movePieceToPlatform: (GCQuartoPiece *) piece;


/**
 * Put the piece on the platform back in the bag of available pieces.
 * Replaces the piece among the available pieces.
 * 
 * @return The piece that was removed from the platform, or nil if there was no piece there
 */
- (GCQuartoPiece *) removePieceFromPlatform;


/**
 * Place the piece on the platform on the board.
 *
 * @param row The row number in the range [0,3]
 * @param column The column number in the range [0,3]
 *
 * @return YES if successful, NO if not
 */
- (BOOL) placePlatformPieceAtRow: (NSUInteger) row andColumn: (NSUInteger) column;


/**
 * Remove a piece from the board and put it back on the platform.
 *
 * @param row The row number in the range [0,3]
 * @param column The column number in the range [0,3]
 *
 * @return The piece that was removed from the platform, or nil if there was no piece there
 */
- (GCQuartoPiece *) removePieceAtRow: (NSUInteger) row andColumn: (NSUInteger) column;


@end