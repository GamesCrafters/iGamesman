//
//  ConnectionsIntegerQueue.h
//  GamesmanMobile
//
//  Created by Class Account on 3/16/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ConnectionsIntegerQueue : NSObject {

	NSMutableArray *fringe;
	NSMutableArray *blackList;
}

- (void) push: (int) position;
- (int)	pop;
- (void) reset;
- (BOOL) notEmpty;

@end
