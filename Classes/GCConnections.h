//
//  GCConnections.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/12/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCGame.h"
#import "GCJSONService.h"

@class GCConnectionsViewController;


@interface GCConnections : GCGame {
	GCConnectionsViewController *conView;
	NSString *player1Name, *player2Name;
	PlayerType player1Type, player2Type;
	NSMutableArray *board;
	int size;
	BOOL p1Turn;
	NSNumber *humanMove;
	PlayMode gameMode;
	BOOL misere;
	GCJSONService *service;
	BOOL predictions, moveValues;
	
}

@property (nonatomic, retain) NSString *player1Name, *player2Name;
@property (nonatomic, assign) PlayerType player1Type, player2Type;
@property (nonatomic, assign) int size;
@property (nonatomic, assign) BOOL p1Turn;
@property (nonatomic, assign, getter=isMisere) BOOL misere;
@property (nonatomic, assign) BOOL predictions, moveValues;
@property (nonatomic, retain) GCJSONService *service;
@property (nonatomic, assign) PlayMode gameMode;

- (void) resetBoard;
- (void) postHumanMove: (NSNumber *) num;
- (BOOL) encircled: (NSArray *) theBoard;
//- (void) decrementVertices: (NSMutableArray *) vertices 
//				   inArray: (NSMutableArray *) loop;
- (NSString *) stringForBoard: (NSArray *) _board;
- (void) fetchNewData;


@end
