//
//  CGConnectionsPosition.m
//  iGamesman
//
//  Created by Ian Ackerman on 10/10/11.
//  Copyright 2011 GamesCrafters. All rights reserved.
//

#import "GCConnectionsPosition.h"

#define BLANK @"+"
#define XCON @"x"
#define OCON @"o"

@implementation GCConnectionsPosition

@synthesize p1Turn;
@synthesize board;
@synthesize size;

- (id)initWithSize:(int)sideLength
{
    self = [super init];
    if (self) {
		size = sideLength;
        p1Turn = YES;
		board = [[NSMutableArray alloc] initWithCapacity: size * size];
		for (int j = 0; j < size; j += 1) {
			for (int i = 0; i < size; i += 1) {
				if(i % 2 == j % 2){
					[board addObject:BLANK];
				}
				else if(i % 2 == 0){
					[board addObject: OCON];
				}
				else {
					[board addObject: XCON];
				}
			}
		}
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    GCConnectionsPosition *copy = [[GCConnectionsPosition allocWithZone:zone] init];
    copy.p1Turn = p1Turn;
    copy.board = [board copy];
	copy.size = size;
    return copy;
}


@end

