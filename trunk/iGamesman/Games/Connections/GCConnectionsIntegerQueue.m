//
//  GCConnectionsIntegerQueue.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 3/16/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCConnectionsIntegerQueue.h"


@implementation GCConnectionsIntegerQueue

#pragma mark - Memory lifecycle

- (id) init
{
    self = [super init];
    
    if (self)
    {
        _fringe = [[NSMutableArray alloc] init];
        _blackList = [[NSMutableArray alloc] init];
    }
    
	return self;
}


- (void) dealloc
{
	[_fringe release];
	[_blackList release];
    
	[super dealloc];
}


#pragma mark -

/**
 Given an interger representing a position, adds the integer as a NSNumber to the fringeand blackList if it is not in the blackList
 */

- (void) push: (int) position
{
	NSNumber * myNum = [NSNumber numberWithInt: position];
	
	if (![_blackList containsObject: myNum])
    {
		[_fringe addObject: myNum];
		[_blackList addObject: myNum];
	}
}

/**
 Returns the integer at the beginning of the fringe.  Assumes that the fringe is not empty. 
 */
- (int)	pop
{
	int ret = [[_fringe objectAtIndex: 0] intValue];
	[_fringe removeObjectAtIndex: 0];
	return ret;
}

- (void) reset
{
	[_fringe removeAllObjects];
	[_blackList removeAllObjects];
}

- (BOOL) notEmpty
{
	return ([_fringe count] > 0);
}

@end
