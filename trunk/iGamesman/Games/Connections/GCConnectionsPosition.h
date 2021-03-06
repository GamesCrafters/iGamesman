//
//  CGConnectionsPosition.h
//  iGamesman
//
//  Created by Ian Ackerman on 10/10/11.
//  Copyright 2011 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *GCConnectionsPiece;

GCConnectionsPiece const GCConnectionsBlankPiece;
GCConnectionsPiece const GCConnectionsRedPiece;
GCConnectionsPiece const GCConnectionsBluePiece;


@interface GCConnectionsPosition : NSObject<NSCopying>
{
	BOOL _leftTurn;
	NSMutableArray *_board;
	int _size;
    
    BOOL _misere;
}

@property (nonatomic, assign) int size;
@property (nonatomic, assign) BOOL leftTurn;
@property (nonatomic, retain) NSMutableArray *board;
@property (nonatomic, assign, getter = isMisere) BOOL misere;

- (id) initWithSize: (int) sideLength;

@end
