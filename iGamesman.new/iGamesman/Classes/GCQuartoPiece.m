//
//  GCQuartoPiece.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/16/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import "GCQuartoPiece.h"

@implementation GCQuartoPiece


- (id) initWithPieceNumber: (int) number
{
    self = [super init];
    
    if (self)
    {
        pieceNumber = number;
    }
    
    return self;
}


+ (id) pieceWithSquare: (BOOL) isSquare
                 solid: (BOOL) isSolid
                  tall: (BOOL) isTall
                 white: (BOOL) isWhite
{
    static NSArray *pieces = nil;
    
    int squareBit = (int) isSquare;
    int solidBit  = (int) isSolid;
    int tallBit   = (int) isTall;
    int whiteBit  = (int) isWhite;
    
    int number = squareBit + (solidBit << 1) + (tallBit << 2) + (whiteBit << 3);
    
    if (pieces)
        return [pieces objectAtIndex: number];
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity: 16];
    
    for (int i = 0; i < 16; i += 1)
    {
        GCQuartoPiece *piece = [[GCQuartoPiece alloc] initWithPieceNumber: i];
        [temp addObject: piece];
        [piece release];
    }
    
#warning Figure out why this autorelease is failing
    //pieces = [temp autorelease];
    pieces = temp;
    
    return [pieces objectAtIndex: number];
}


+ (id) blankPiece
{
    static GCQuartoPiece *blankPiece = nil;
    
    if (blankPiece)
        return blankPiece;
    
    blankPiece = [[[GCQuartoPiece alloc] initWithPieceNumber: -1] autorelease];
    
    return blankPiece;
}


- (BOOL) isBlank
{
    return (pieceNumber == -1);
}


- (BOOL) isSquare
{
    return (pieceNumber & 1);
}


- (BOOL) isSolid
{
    return ((pieceNumber >> 1) & 1);
}


- (BOOL) isTall
{
    return ((pieceNumber >> 2) & 1);
}


- (BOOL) isWhite
{
    return ((pieceNumber >> 3) & 1);
}

@end
