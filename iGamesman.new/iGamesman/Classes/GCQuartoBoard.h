//
//  GCQuartoBoard.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/16/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GCQuartoPiece;

@interface GCQuartoBoard : NSObject <NSCopying>
{
    NSMutableArray *board;
    NSMutableArray *remainingPieces;
}


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
 * Return an array of the currently unplaced pieces.
 *
 * @return The remaining unplaced pieces
 */
- (NSArray *) availablePieces;


/**
 * Add a piece to the board in the ROWth row and COLUMNth column.
 * Removes the placed piece from the array of available pieces.
 *
 * @param piece The piece to be added to the board
 * @param row The row number in the range [0,3]
 * @param column The column number in the range [0,3]
 *
 * @return YES is placement was successful, NO if not
 */
- (BOOL) placePiece: (GCQuartoPiece *) piece atRow: (NSUInteger) row andColumn: (NSUInteger) column;


/**
 * Remove the piece in the ROWth row and COLUMNth column from the board.
 * Adds the removed piece to the array of available pieces.
 * 
 * @param row The row number in the range [0,3]
 * @param column The column number in the range [0,3]
 *
 * @return The piece that was removed, or nil if there was no piece there.
 */
- (GCQuartoPiece *) removePieceAtRow: (NSUInteger) row andColumn: (NSUInteger) column;


@end