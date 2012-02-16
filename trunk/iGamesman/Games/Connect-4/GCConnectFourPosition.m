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

@synthesize columns, rows, toWin;
@synthesize leftTurn;
@synthesize board;

#pragma mark - Memory lifecycle

- (id) initWithWidth: (NSUInteger) width height: (NSUInteger) height toWin: (NSUInteger) needed
{
    self = [super init];
    
    if (self)
    {
        columns = width;
        rows = height;
        toWin = needed;
        
        board = [[NSMutableArray alloc] initWithCapacity: columns * rows];
        for (int i = 0; i < (rows * columns); i += 1)
            [board addObject: GCConnectFourBlankPiece];
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
    GCConnectFourPosition *copy = [[GCConnectFourPosition allocWithZone: zone] initWithWidth: columns height: rows toWin: toWin];
    
    copy.leftTurn = leftTurn;
    NSMutableArray *boardCopy = [board copy];
    copy.board = boardCopy;
    [boardCopy release];
    
    return copy;
}

@end
