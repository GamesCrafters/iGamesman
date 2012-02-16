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

@synthesize rows, columns, toWin;
@synthesize leftTurn;
@synthesize board;

#pragma mark - Memory lifecycle

- (id) initWithWidth: (NSUInteger) width 
              height: (NSUInteger) height 
               toWin: (NSUInteger) needed
{
    self = [super init];
    
    if (self)
    {
        rows    = height;
        columns = width;
        toWin   = needed;
        
        board = [[NSMutableArray alloc] initWithCapacity: rows * columns];
        for (NSUInteger i = 0; i < rows * columns; i += 1)
            [board addObject: GCQuickCrossBlankPiece];
    }
    
    return self;
}


- (void) dealloc
{
    [board release];
    
    [super dealloc];
}


#pragma mark - NSCopying

- (id) copyWithZone: (NSZone *) zone
{
    GCQuickCrossPosition *copy = [[GCQuickCrossPosition allocWithZone: zone] initWithWidth: columns height: rows toWin: toWin];
    
    copy.leftTurn = leftTurn;
    
    NSMutableArray *boardCopy = [board copy];
    copy.board = boardCopy;
    [boardCopy release];
    
    return copy;
}

@end
