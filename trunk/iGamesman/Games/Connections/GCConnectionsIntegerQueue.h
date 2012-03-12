//
//  GCConnectionsIntegerQueue.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 3/16/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GCConnectionsIntegerQueue : NSObject
{
	NSMutableArray *_fringe;
	NSMutableArray *_blackList;
}

- (void) push: (int) position;
- (int)	pop;
- (void) reset;
- (BOOL) notEmpty;

@end
