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

@synthesize columns, rows, toWin;
@synthesize leftTurn;
@synthesize board;


#pragma mark -
#pragma mark Memory lifecycle

- (id) initWithWidth: (NSUInteger) width
              height: (NSUInteger) height
               toWin: (NSUInteger) needed
{
    self = [super init];
    
    if (self)
    {
        columns = width;
        rows = height;
        toWin = needed;
        
        board = [[NSMutableArray alloc] initWithCapacity: rows * columns];
        for (int i = 0; i < rows * columns; i += 1)
            [board addObject: GCTTTBlankPiece];
    }
    
    return self;
}


- (void) dealloc
{
    [board release];
    
    [super dealloc];
}


#pragma mark - 
#pragma mark NSCopying

- (id) copyWithZone: (NSZone *) zone
{
    GCTicTacToePosition *copy = [[GCTicTacToePosition alloc] initWithWidth: columns height: rows toWin: toWin];
    
    copy.leftTurn = leftTurn;
    copy.board = [board copy];
    
    return copy;
}

@end
