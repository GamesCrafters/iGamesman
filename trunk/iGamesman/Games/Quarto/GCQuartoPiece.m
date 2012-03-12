//
//  GCQuartoPiece.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/3/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCQuartoPiece.h"


@interface GCQuartoPiece ()

/* Private initializers for factory methods */
- (id) initWithTall: (BOOL) isTall square: (BOOL) isSquare hollow: (BOOL) isHollow white: (BOOL) isWhite;
- (id) initBlank;

@end



@implementation GCQuartoPiece

@synthesize tall = _tall, square = _square, hollow = _hollow, white = _white;
@synthesize blank = _blank;


+ (id) pieceWithTall: (BOOL) isTall square: (BOOL) isSquare hollow: (BOOL) isHollow white: (BOOL) isWhite
{
    static NSArray *pieces = nil;
    
    NSUInteger index = (isTall << 3) + (isSquare << 2) + (isHollow << 1) + (isWhite << 0);
    
    if (pieces)
    {
        return [pieces objectAtIndex: index];
    }
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity: 16];
    for (NSUInteger i = 0; i < 16; i += 1)
    {
        GCQuartoPiece *piece = [[GCQuartoPiece alloc] initWithTall: ((i & 8) > 0)
                                                            square: ((i & 4) > 0)
                                                            hollow: ((i & 2) > 0)
                                                             white: ((i & 1) > 0)];
        [temp addObject: piece];
        [piece release];
    }
    
    pieces = temp;
    
    return [pieces objectAtIndex: index];
}


+ (id) blankPiece
{
    static GCQuartoPiece *blank = nil;
    
    if (blank)
        return blank;
    
    blank = [[GCQuartoPiece alloc] initBlank];
    
    return blank;
}


- (id) initWithTall: (BOOL) isTall square: (BOOL) isSquare hollow: (BOOL) isHollow white: (BOOL) isWhite
{
    self = [super init];
    
    if (self)
    {
        _tall   = isTall;
        _square = isSquare;
        _hollow = isHollow;
        _white  = isWhite;
        
        _blank = NO;
    }
    
    return self;
}


- (id) initBlank
{
    self = [super init];
    
    if (self)
    {
        _blank = YES;
    }
    
    return self;
}


#pragma mark - 

- (BOOL) isEqual: (GCQuartoPiece *) object
{
    if (_blank && [object blank])
        return YES;
    else if (_blank || [object blank])
        return NO;
    
    return ((_tall == [object tall]) && (_square == [object square]) && (_hollow == [object hollow]) && (_white == [object white]));
}


#pragma mark - NSCopying

- (id) copyWithZone: (NSZone *) zone
{
    GCQuartoPiece *copy;
    
    if (_blank)
        copy = [[GCQuartoPiece allocWithZone: zone] initBlank];
    else
        copy = [[GCQuartoPiece allocWithZone: zone] initWithTall: _tall square: _square hollow: _hollow white: _white];
    
    return copy;
}

@end
