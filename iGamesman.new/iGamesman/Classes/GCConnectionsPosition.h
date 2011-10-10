//
//  CGConnectionsPosition.h
//  iGamesman
//
//  Created by Ian Ackerman on 10/10/11.
//  Copyright 2011 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GCConnectionsPosition : NSObject<NSCopying> {
	BOOL p1Turn;
	NSMutableArray *board;
	int size;
}

@property (nonatomic, assign) int size;
@property (nonatomic, assign) BOOL p1Turn;
@property (nonatomic, assign) NSMutableArray *board;

- (id)initWithSize:(int)sideLength;

@end
