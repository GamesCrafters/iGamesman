//
//  GCQuartoPosition.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/3/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCGame.h"


typedef enum { GCQ_LEFT_CHOOSE, GCQ_RIGHT_PLACE, GCQ_RIGHT_CHOOSE, GCQ_LEFT_PLACE } GCQuartoPhase;


@class GCQuartoPiece;

@interface GCQuartoPosition : NSObject <NSCopying>
{
    NSMutableArray *_board;
    NSMutableArray *_pieces;
    
    GCQuartoPiece *_platformPiece;
    
    GCQuartoPhase _phase;
    
    BOOL _misere;
}


@property (nonatomic, readonly) NSMutableArray *pieces;
@property (nonatomic, assign) GCQuartoPhase phase;
@property (nonatomic, assign, getter = isMisere) BOOL misere;

- (GCGameValue *) primitive;

- (void) setPlatformPiece: (GCQuartoPiece *) piece;
- (GCQuartoPiece *) platformPiece;
- (void) removePlatformPiece;

- (void) placePiece: (GCQuartoPiece *) piece atRow: (NSUInteger) row column: (NSUInteger) column;
- (GCQuartoPiece *) pieceAtRow: (NSUInteger) row column: (NSUInteger) column;
- (void) removePieceAtRow: (NSUInteger) row column: (NSUInteger) column;


@end
