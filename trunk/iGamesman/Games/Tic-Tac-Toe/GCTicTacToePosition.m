//
//  GCTicTacToePosition.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/21/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import "GCTicTacToePosition.h"


GCTTTPiece const GCTTTBlankPiece = @"-";
GCTTTPiece const GCTTTXPiece     = @"X";
GCTTTPiece const GCTTTOPiece     = @"O";


@implementation GCTicTacToePosition

@synthesize columns = _columns, rows = _rows, toWin = _toWin;
@synthesize leftTurn = _leftTurn;
@synthesize board = _board;
@synthesize misere = _misere;


#pragma mark -
#pragma mark Memory lifecycle

- (id) initWithWidth: (NSUInteger) width
              height: (NSUInteger) height
               toWin: (NSUInteger) needed
{
    self = [super init];
    
    if (self)
    {
        _columns = width;
        _rows = height;
        _toWin = needed;
        
        _board = [[NSMutableArray alloc] initWithCapacity: _rows * _columns];
        for (int i = 0; i < _rows * _columns; i += 1)
            [_board addObject: GCTTTBlankPiece];
    }
    
    return self;
}


- (void) dealloc
{
    [_board release];
    
    [super dealloc];
}


#pragma mark - 
#pragma mark NSCopying

- (id) copyWithZone: (NSZone *) zone
{
    GCTicTacToePosition *copy = [[GCTicTacToePosition allocWithZone: zone] initWithWidth: _columns height: _rows toWin: _toWin];
    
    [copy setLeftTurn: _leftTurn];
    [copy setMisere: _misere];
    NSMutableArray *boardCopy = [_board copy];
    [copy setBoard: boardCopy];
    [boardCopy release];
    
    return copy;
}

@end
