//
//  GCQuartoPosition.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/3/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCQuartoPosition.h"

#import "GCGame.h"

#import "GCQuartoPiece.h"


BOOL match(NSUInteger a, NSUInteger b, NSUInteger c, NSUInteger d);


@implementation GCQuartoPosition

@synthesize pieces;
@synthesize phase;

#pragma mark - Memory lifecycle

- (id) init
{
    self = [super init];
    
    if (self)
    {
        board  = [[NSMutableArray alloc] initWithCapacity: 16];
        pieces = [[NSMutableArray alloc] initWithCapacity: 16];
        
        for (NSUInteger i = 0; i < 16; i += 1)
        {
            GCQuartoPiece *blank = [GCQuartoPiece blankPiece];
            [board addObject: blank];
            
            BOOL tall   = ((i & 1) > 0);
            BOOL square = ((i & 2) > 0);
            BOOL hollow = ((i & 4) > 0);
            BOOL white  = ((i & 8) > 0);
            
            GCQuartoPiece *piece = [GCQuartoPiece pieceWithTall: tall square: square hollow: hollow white: white];
            [pieces addObject: piece];
        }
        
        platformPiece = nil;
        
        phase = GCQ_LEFT_CHOOSE;
    }
    
    return self;
}


- (void) dealloc
{
    [board release];
    [pieces release];
    
    [super dealloc];
}


#pragma mark - NSCopying

- (void) setBoard: (NSMutableArray *) newBoard
{
    [newBoard retain];
    
    [board release];
    
    board = newBoard;
}


- (void) setPieces: (NSMutableArray *) newPieces
{
    [newPieces retain];
    
    [pieces release];
    
    pieces = newPieces;
}


- (id) copyWithZone: (NSZone *) zone
{
    GCQuartoPosition *copy = [[GCQuartoPosition allocWithZone: zone] init];
    copy.phase = phase;

    NSMutableArray *boardCopy = [board copy];
    [copy setBoard: boardCopy];
    [boardCopy release];
    
    NSMutableArray *piecesCopy = [pieces copy];
    [copy setPieces: piecesCopy];
    [piecesCopy release];
    
    [copy setPlatformPiece: platformPiece];
    
    return copy;
}


#pragma mark - 

- (NSInteger) valueOfPiece: (GCQuartoPiece *) piece
{
    if (piece.blank)
        return -1;
    
    return (piece.tall << 3) + (piece.square << 2) + (piece.hollow << 1) + (piece.white << 0);
}


/**
 Return YES if any bit position in a, b, c, and d is the same.
 a, b, c, and d are integers in the range [0, 15]
 */
BOOL match(NSUInteger a, NSUInteger b, NSUInteger c, NSUInteger d)
{
    if (a & b & c & d)
        return YES;
    
    if ((~a & ~b & ~c & ~d) & 0xF)
        return YES;
    
    return NO;
}


- (GCGameValue *) primitive
{
    /* Check each column */
    for (NSUInteger column = 0; column < 4; column += 1)
    {
        NSInteger piece0 = [self valueOfPiece: [board objectAtIndex: column + 0]];
        NSInteger piece1 = [self valueOfPiece: [board objectAtIndex: column + 4]];
        NSInteger piece2 = [self valueOfPiece: [board objectAtIndex: column + 8]];
        NSInteger piece3 = [self valueOfPiece: [board objectAtIndex: column + 12]];
        
        if ((piece0 == -1) || (piece1 == -1) || (piece2 == -1) || (piece3 == -1))
            continue;
        
        if (match(piece0, piece1, piece2, piece3))
            return GCGameValueWin;
    }
    
    /* Check each row */
    for (NSUInteger row = 0; row < 4; row += 1)
    {
        NSInteger piece0 = [self valueOfPiece: [board objectAtIndex: 0 + 4 * row]];
        NSInteger piece1 = [self valueOfPiece: [board objectAtIndex: 1 + 4 * row]];
        NSInteger piece2 = [self valueOfPiece: [board objectAtIndex: 2 + 4 * row]];
        NSInteger piece3 = [self valueOfPiece: [board objectAtIndex: 3 + 4 * row]];
        
        if ((piece0 == -1) || (piece1 == -1) || (piece2 == -1) || (piece3 == -1))
            continue;
        
        if (match(piece0, piece1, piece2, piece3))
            return GCGameValueWin;
    }
    
    /* Check the main diagonal */
    NSInteger piece0 = [self valueOfPiece: [board objectAtIndex: 0]];
    NSInteger piece1 = [self valueOfPiece: [board objectAtIndex: 5]];
    NSInteger piece2 = [self valueOfPiece: [board objectAtIndex: 10]];
    NSInteger piece3 = [self valueOfPiece: [board objectAtIndex: 15]];
    
    BOOL hasBlank = ((piece0 == -1) || (piece1 == -1) || (piece2 == -1) || (piece3 == -1));
    if (!hasBlank && match(piece0, piece1, piece2, piece3))
        return GCGameValueWin;
    
    /* Check the secondary diagonal */
    piece0 = [self valueOfPiece: [board objectAtIndex: 3]];
    piece1 = [self valueOfPiece: [board objectAtIndex: 6]];
    piece2 = [self valueOfPiece: [board objectAtIndex: 9]];
    piece3 = [self valueOfPiece: [board objectAtIndex: 12]];
    
    hasBlank = ((piece0 == -1) || (piece1 == -1) || (piece2 == -1) || (piece3 == -1));
    if (!hasBlank && match(piece0, piece1, piece2, piece3))
        return GCGameValueWin;
    
    return nil;
}


- (void) setPlatformPiece: (GCQuartoPiece *) piece
{
    platformPiece = [piece retain];
}


- (GCQuartoPiece *) platformPiece
{
    return platformPiece;
}


- (void) removePlatformPiece
{
    if (platformPiece)
        [platformPiece release];
    
    platformPiece = nil;
}


- (void) placePiece: (GCQuartoPiece *) piece atRow: (NSUInteger) row column: (NSUInteger) column
{
    [board replaceObjectAtIndex: column + 4 * row withObject: piece];
}


- (GCQuartoPiece *) pieceAtRow: (NSUInteger) row column: (NSUInteger) column
{
    return [board objectAtIndex: column + 4 * row];
}


- (void) removePieceAtRow:(NSUInteger)row column:(NSUInteger)column
{
    GCQuartoPiece *blank = [GCQuartoPiece blankPiece];
    [board replaceObjectAtIndex: column + 4 * row withObject: blank];
}

@end
