//
//  ConnectionsIntegerQueue.m
//  GamesmanMobile
//
//  Created by Class Account on 3/16/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "ConnectionsIntegerQueue.h"


@implementation ConnectionsIntegerQueue

- (id) init {
	fringe = [[NSMutableArray alloc] init];
	blackList = [[NSMutableArray alloc] init];
	return self;
}

- (void) dealloc {
	[fringe release];
	[blackList release];
	[super dealloc];
}
	

/**  Given an interger representing a position, adds the integer as a NSNumber to the fringe
	and blackList if it is not in the blackList
**/

- (void) push: (int) position{
	NSNumber * myNum = [NSNumber numberWithInt: position];
	
	if (![blackList containsObject: myNum]){
		[fringe addObject: myNum];
		[blackList addObject: myNum];
	}
}

/**  Returns the integer at the beginning of the fringe.  Assumes that the fringe is not empty. 
**/
- (int)	pop{
	int ret = [[fringe objectAtIndex: 0] intValue];
	[fringe removeObjectAtIndex: 0];
	return ret;
}

- (void) reset{
	[fringe removeAllObjects];
	[blackList removeAllObjects];
}

- (BOOL) notEmpty{
	return ([fringe count] > 0);
}

@end
