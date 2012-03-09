//
//  GCConnectFourPosition.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/13/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCConnectFourPosition.h"

GCConnectFourPiece const GCConnectFourBlankPiece = @"+";
GCConnectFourPiece const GCConnectFourRedPiece   = @"X";
GCConnectFourPiece const GCConnectFourBluePiece  = @"O";

@implementation GCConnectFourPosition

@synthesize columns = _columns, rows = _rows, toWin = _toWin;
@synthesize leftTurn = _leftTurn;
@synthesize board = _board;

#pragma mark - Memory lifecycle

- (id) initWithWidth: (NSUInteger) width height: (NSUInteger) height toWin: (NSUInteger) needed
{
    self = [super init];
    
    if (self)
    {
        _columns = width;
        _rows = height;
        _toWin = needed;
        
        _board = [[NSMutableArray alloc] initWithCapacity: _columns * _rows];
        for (int i = 0; i < (_rows * _columns); i += 1)
            [_board addObject: GCConnectFourBlankPiece];
    }
    
    return self;
}


- (void) dealloc
{
    [_board release];
    
    [super dealloc];
}


#pragma mark - NSCopying

- (id) copyWithZone: (NSZone *) zone
{
    GCConnectFourPosition *copy = [[GCConnectFourPosition allocWithZone: zone] initWithWidth: _columns height: _rows toWin: _toWin];
    
    [copy setLeftTurn: _leftTurn];
    NSMutableArray *boardCopy = [_board copy];
    [copy setBoard: boardCopy];
    [boardCopy release];
    
    return copy;
}

@end
