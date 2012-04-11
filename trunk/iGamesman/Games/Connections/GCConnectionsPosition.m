//
//  CGConnectionsPosition.m
//  iGamesman
//
//  Created by Ian Ackerman on 10/10/11.
//  Copyright 2011 GamesCrafters. All rights reserved.
//

#import "GCConnectionsPosition.h"

GCConnectionsPiece const GCConnectionsBlankPiece = @"+";
GCConnectionsPiece const GCConnectionsRedPiece   = @"X";
GCConnectionsPiece const GCConnectionsBluePiece  = @"O";


@implementation GCConnectionsPosition

@synthesize leftTurn = _leftTurn;
@synthesize board = _board;
@synthesize size = _size;
@synthesize misere = _misere;

#pragma mark - Memory lifecycle

- (id) initWithSize: (int) sideLength
{
    self = [super init];
    
    if (self)
    {
		_size = sideLength;
        _leftTurn = YES;
		_board = [[NSMutableArray alloc] initWithCapacity: _size * _size];
		for (int j = 0; j < _size; j += 1)
        {
			for (int i = 0; i < _size; i += 1)
            {
				if (i % 2 == j % 2)
                {
					[_board addObject: GCConnectionsBlankPiece];
				}
				else if (i % 2 == 0)
                {
					[_board addObject: GCConnectionsBluePiece];
				}
				else
                {
					[_board addObject: GCConnectionsRedPiece];
				}
			}
		}
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
    GCConnectionsPosition *copy = [[GCConnectionsPosition allocWithZone: zone] initWithSize: _size];
    [copy setLeftTurn: _leftTurn];
    [copy setMisere: _misere];
    
    NSMutableArray *boardCopy = [_board copy];
    [copy setBoard: boardCopy];
    [boardCopy release];
	
    return copy;
}


@end

