//
//  YGameQueue.m
//  GamesmanMobile
//
//  Created by Class Account on 4/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YGameQueue.h"


@implementation YGameQueue

/** Returns and empty YGameQueue**/
- (id) init {
	[super init];
	fringe = [[NSMutableArray alloc] init];
	blackList = [[NSMutableArray alloc] init];
	return self;
}

- (void) dealloc {
	[fringe release];
	[blackList release];
	[super dealloc];
}


/** Push an NSNumber onto the Queue if it isn't already on the black list**/
- (void) push: (NSNumber *) position{
	if (![blackList containsObject: position]){
		[fringe addObject: position];
		[blackList addObject: position];
	}
}


/**Pop off the next element on the fringe**/
- (NSNumber *) pop{
	NSNumber * ret = [fringe objectAtIndex: 0];
	[fringe removeObjectAtIndex: 0];
	return ret;
}


/** Returns and empty YGameQueue**/
- (BOOL) notEmpty{
	return ([fringe count] > 0);
}


/** Empty the fringe but not the blackList **/
- (void) emptyFringe{
	[fringe removeAllObjects];
}


/** Empty the fringe and the blackList **/
- (void) clearAll{
	[fringe removeAllObjects];
	[blackList removeAllObjects];
}

@end
