//
//  GCConnections.h
//  iGamesman
//
//  Created by Ian Ackerman on 07/10/11.
//  Copyright 2011 Gamescrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCGame.h"
#import "GCPlayer.h"
#import "GCConnectionsPosition.h"

@interface GCConnections : NSObject <GCGame>
{
	//GCConnectionsViewController *conView;
	NSMutableArray *board;
    NSMutableArray *pieces;
	GCPlayer *player1, *player2;
	NSDictionary *settings;
	
	GCConnectionsPosition *position;
	
	//NSNumber *humanMove;
	BOOL misere;
	BOOL predictions, moveValues;
	BOOL circling;
	//GCJSONService *service;
	//NSThread *waiter;
}

@property (nonatomic, assign, getter=isMisere) BOOL misere;
@property (nonatomic, assign) BOOL predictions, moveValues;
@property (nonatomic, assign) BOOL circling;

- (void) resetBoard;
- (BOOL) encircled: (NSArray *) theBoard;
- (void) decrementVerticesIn: (NSMutableArray *) loop;
- (void) chainDecrement: (NSMutableArray *) loop
				  given: (NSMutableArray *) decrementedVerts;
//- (void) decrementVertices: (NSMutableArray *) vertices 
//				   inArray: (NSMutableArray *) loop;
- (NSString *) stringForBoard: (NSArray *) _board;

@end
