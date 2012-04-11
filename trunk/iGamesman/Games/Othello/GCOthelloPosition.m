//
//  GCOthelloPosition.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/21/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCOthelloPosition.h"

GCOthelloPiece const GCOthelloBlankPiece = @"+";
GCOthelloPiece const GCOthelloBlackPiece = @"X";
GCOthelloPiece const GCOthelloWhitePiece = @"O";

@implementation GCOthelloPosition

@synthesize rows = _rows, columns = _columns;
@synthesize leftTurn = _leftTurn;
@synthesize board = _board;
@synthesize misere = _misere;

#pragma mark - Memory lifecycle

- (id) initWithWidth: (NSUInteger) width height: (NSUInteger) height
{
    self = [super init];
    
    if (self)
    {
        _rows = height;
        _columns = width;
        
        _board = [[NSMutableArray alloc] initWithCapacity: _rows * _columns];
        for (int i = 0; i < _rows * _columns; i += 1)
            [_board addObject: GCOthelloBlankPiece];
    }
    
    return self;
}


- (void) dealloc
{
    [_board release];
    
    [super dealloc];
}


#pragma mark -

- (NSUInteger) numberOfBlackPieces
{
    NSUInteger count = 0;
    for (NSString *piece in _board)
        if ([piece isEqualToString: GCOthelloBlackPiece])
            count += 1;
    return count;
}


- (NSUInteger) numberOfWhitePieces
{
    NSUInteger count = 0;
    for (NSString *piece in _board)
        if ([piece isEqualToString: GCOthelloWhitePiece])
            count += 1;
    return count;
}


#pragma mark - NSCopying

- (id) copyWithZone: (NSZone *) zone
{
    GCOthelloPosition *copy = [[GCOthelloPosition allocWithZone: zone] initWithWidth: _columns height: _rows];
    [copy setLeftTurn: _leftTurn];
    [copy setMisere: _misere];
    
    NSMutableArray *boardCopy = [_board mutableCopy];
    [copy setBoard: boardCopy];
    [boardCopy release];
    
    return copy;
}

@end
