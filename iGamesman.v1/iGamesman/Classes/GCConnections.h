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
#import "GCConnectionsView.h"

@interface GCConnections : NSObject <GCGame, GCConnectionsViewDelegate>
{

    //NSMutableArray *pieces;
	GCPlayer *leftPlayer, *rightPlayer;
	NSDictionary *settings;
	
	GCMoveCompletionHandler moveHandler;
	
	GCConnectionsPosition *position;
	
	GCConnectionsView* view;
	
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
