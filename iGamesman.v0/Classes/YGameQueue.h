//
//  YGameQueue.h
//  GamesmanMobile
//
//  Created by Class Account on 4/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YGameQueue : NSObject {
	NSMutableArray *fringe;
	NSMutableArray *blackList;
	NSMutableDictionary *parents;
	NSNumber *lastParent;
}

- (void) push: (NSNumber *) position;
- (NSNumber *) pop;
- (BOOL) notEmpty;
- (void) emptyFringe;
- (void) clearAll;
- (NSMutableArray *) getPath: (NSNumber *) starter;


@end



