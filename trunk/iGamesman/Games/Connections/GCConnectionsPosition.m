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

@synthesize leftTurn;
@synthesize board;
@synthesize size;

#pragma mark - Memory lifecycle

- (id) initWithSize: (int) sideLength
{
    self = [super init];
    
    if (self)
    {
		size = sideLength;
        leftTurn = YES;
		board = [[NSMutableArray alloc] initWithCapacity: size * size];
		for (int j = 0; j < size; j += 1)
        {
			for (int i = 0; i < size; i += 1)
            {
				if (i % 2 == j % 2)
                {
					[board addObject: GCConnectionsBlankPiece];
				}
				else if (i % 2 == 0)
                {
					[board addObject: GCConnectionsBluePiece];
				}
				else
                {
					[board addObject: GCConnectionsRedPiece];
				}
			}
		}
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
    GCConnectionsPosition *copy = [[GCConnectionsPosition allocWithZone: zone] init];
    copy.leftTurn = leftTurn;
    copy.size = size;
    
    NSMutableArray *boardCopy = [board copy];
    copy.board = boardCopy;
    [boardCopy release];
	
    return copy;
}


@end

