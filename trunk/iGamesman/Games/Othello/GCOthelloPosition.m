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

@synthesize rows, columns;
@synthesize leftTurn;
@synthesize board;

#pragma mark - Memory lifecycle

- (id) initWithWidth: (NSUInteger) width height: (NSUInteger) height
{
    self = [super init];
    
    if (self)
    {
        rows = height;
        columns = width;
        
        board = [[NSMutableArray alloc] initWithCapacity: rows * columns];
        for (int i = 0; i < rows * columns; i += 1)
            [board addObject: GCOthelloBlankPiece];
    }
    
    return self;
}


- (void) dealloc
{
    [board release];
    
    [super dealloc];
}


#pragma mark -

- (NSUInteger) numberOfBlackPieces
{
    NSUInteger count = 0;
    for (NSString *piece in board)
        if ([piece isEqualToString: GCOthelloBlackPiece])
            count += 1;
    return count;
}


- (NSUInteger) numberOfWhitePieces
{
    NSUInteger count = 0;
    for (NSString *piece in board)
        if ([piece isEqualToString: GCOthelloWhitePiece])
            count += 1;
    return count;
}


#pragma mark - NSCopying

- (id) copyWithZone: (NSZone *) zone
{
    GCOthelloPosition *copy = [[GCOthelloPosition allocWithZone: zone] initWithWidth: columns height: rows];
    copy.leftTurn = leftTurn;
    
    NSMutableArray *boardCopy = [board copy];
    copy.board = boardCopy;
    [boardCopy release];
    
    return copy;
}

@end
