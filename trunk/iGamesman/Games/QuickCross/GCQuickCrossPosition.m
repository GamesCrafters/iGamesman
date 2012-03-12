//
//  GCQuickCrossPosition.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/22/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCQuickCrossPosition.h"


GCQuickCrossPiece const GCQuickCrossBlankPiece      = @"+";
GCQuickCrossPiece const GCQuickCrossHorizontalPiece = @"-";
GCQuickCrossPiece const GCQuickCrossVerticalPiece   = @"|";

GCQuickCrossMove const GCQuickCrossSpinMove            = @"GCQX_SPIN";
GCQuickCrossMove const GCQuickCrossPlaceHorizontalMove = @"GCQX_PLACE_HORIZONTAL";
GCQuickCrossMove const GCQuickCrossPlaceVerticalMove   = @"GCQX_PLACE_VERTICAL";


@implementation GCQuickCrossPosition

@synthesize rows = _rows, columns = _columns, toWin = _toWin;
@synthesize leftTurn = _leftTurn;
@synthesize board = _board;

#pragma mark - Memory lifecycle

- (id) initWithWidth: (NSUInteger) width 
              height: (NSUInteger) height 
               toWin: (NSUInteger) needed
{
    self = [super init];
    
    if (self)
    {
        _rows    = height;
        _columns = width;
        _toWin   = needed;
        
        _board = [[NSMutableArray alloc] initWithCapacity: _rows * _columns];
        for (NSUInteger i = 0; i < _rows * _columns; i += 1)
            [_board addObject: GCQuickCrossBlankPiece];
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
    GCQuickCrossPosition *copy = [[GCQuickCrossPosition allocWithZone: zone] initWithWidth: _columns height: _rows toWin: _toWin];
    
    [copy setLeftTurn: _leftTurn];
    
    NSMutableArray *boardCopy = [_board copy];
    [copy setBoard: boardCopy];
    [boardCopy release];
    
    return copy;
}

@end
