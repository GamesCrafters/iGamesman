//
//  GCQuarto.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 10/3/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import "GCQuarto.h"



@interface GCQuartoPiece : NSObject <NSCopying>
{
    BOOL _tall, _light, _square, _hollow;
}

@property (nonatomic, readonly) BOOL tall, light, square, hollow;

- (id) initWithTall: (BOOL) tall
              light: (BOOL) light
             square: (BOOL) square
             hollow: (BOOL) hollow;

@end

@implementation GCQuartoPiece

@synthesize tall = _tall, light = _light, square = _square, hollow = _hollow;

- (id) initWithTall: (BOOL) tall light: (BOOL) light square: (BOOL) square hollow: (BOOL) hollow
{
    self = [super init];
    
    if (self)
    {
        _tall = tall;
        _light = light;
        _square = square;
        _hollow = hollow;
    }
    
    return self;
}


- (id) copyWithZone:(NSZone *)zone
{
    [self retain];
    return self;
}


- (NSString *) description
{
    return [NSString stringWithFormat: @"%c%c%c%c", (_tall ? 'T' : 't'), (_light ? 'L' : 'l'), (_square ? 'S' : 's'), (_hollow ? 'H' : 'h')];
}

@end



#pragma mark -

@implementation GCQuarto

#pragma mark - GCGame protocol

- (NSArray *) doMove: (NSString *) move
{
    BOOL tall =   ([move characterAtIndex: 0] == 'T');
    BOOL light =  ([move characterAtIndex: 1] == 'L');
    BOOL square = ([move characterAtIndex: 2] == 'S');
    BOOL hollow = ([move characterAtIndex: 3] == 'H');
    
    int slot = [[move substringFromIndex: 4] intValue];
    
    GCQuartoPiece *piece;
    for (GCQuartoPiece *availablePiece in pieces)
    {
        if ((availablePiece.tall == tall) && (availablePiece.light == light) && (availablePiece.square == square) && (availablePiece.hollow == hollow))
        {
            piece = availablePiece;
            break;
        }
    }
    
    [board replaceObjectAtIndex: slot withObject: piece];
    [pieces removeObject: piece];
    
    return board;
}


- (void) undoMove: (NSString *) move toPosition: (NSArray *) toPos
{
    int slot = [[move substringFromIndex: 4] intValue];
    
    GCQuartoPiece *piece = [board objectAtIndex: slot];
    [pieces addObject: piece];
    
    [board replaceObjectAtIndex: slot withObject: @"-"];
}


- (GameValue) primitive: (NSArray *) pos
{
    /* Check the horizontal rows */
    for (int row = 0; row < 4; row += 1)
    {
        int bits = 0xF;
        for (int col = 0; col < 4; col += 1)
        {
            GCQuartoPiece *piece = [pos objectAtIndex: 4 * row + col];
            int pieceBits = (piece.tall) + (piece.light << 1) + (piece.square << 2) + (piece.hollow << 3);
            bits &= pieceBits;
        }
        
        if (bits != 0)
            return LOSE;
    }
    
    /* Check the vertical columns */
    for (int col = 0; col < 4; col += 1)
    {
        int bits = 0xF;
        for (int row = 0; row < 4; row += 1)
        {
            GCQuartoPiece *piece = [pos objectAtIndex: 4 * row + col];
            int pieceBits = (piece.tall) + (piece.light << 1) + (piece.square << 2) + (piece.hollow << 3);
            bits &= pieceBits;
        }
        if (bits != 0)
            return LOSE;
    }
    
    /* Check the main diagonal */
    int bits = 0xF;
    for (int i = 0; i < 4; i += 1)
    {
        GCQuartoPiece *piece = [pos objectAtIndex: 4 * i + i];
        int pieceBits = (piece.tall) + (piece.light << 1) + (piece.square << 2) + (piece.hollow << 3);
        bits &= pieceBits;
    }
    if (bits != 0)
        return LOSE;
    
    /* Check the other diagonal */
    bits = 0xF;
    for (int i = 0; i < 4; i += 1)
    {
        GCQuartoPiece *piece = [pos objectAtIndex: 4 * i + (4 - i)];
        int pieceBits = (piece.tall) + (piece.light << 1) + (piece.square << 2) + (piece.hollow << 3);
        bits &= pieceBits;
    }
    if (bits != 0)
        return LOSE;
    
    return NONPRIMITIVE;
}


- (NSArray *) generateMoves: (Position) pos
{
    
}


#pragma mark - Memory lifecycle

- (id) init
{
    self = [super init];
    if (self) {
        board = [[NSMutableArray alloc] initWithCapacity: 16];
        
        pieces = [[NSMutableArray alloc] initWithCapacity: 16];
        
        for (int i = 0; i < 16; i += 1)
        {
            BOOL tall   = (i & 1) != 0;
            BOOL light  = (i & 2) != 0;
            BOOL square = (i & 4) != 0;
            BOOL hollow = (i & 8) != 0;
            
            GCQuartoPiece *piece = [[GCQuartoPiece alloc] initWithTall: tall light: light square: square hollow: hollow];
            [pieces addObject: piece];
            [piece release];
            
            [board addObject: @"-"];
        }
    }
    
    return self;
}


- (void) dealloc
{
    [pieces release];
    
    [super dealloc];
}

@end
