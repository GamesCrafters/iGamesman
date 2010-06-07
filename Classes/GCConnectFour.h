//
//  GCConnectFour.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 1/29/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCGame.h"
#import "GCJSONService.h"

@class GCConnectFourViewController;

/**
 The controlling class for Connect-4
 */
@interface GCConnectFour : GCGame {
	GCConnectFourViewController *c4view;
	GCJSONService				*service;
	NSString					*player1Name, *player2Name;
	PlayerType					player1Type, player2Type;
	int							width, height, pieces;
	BOOL						p1Turn;
	BOOL						predictions, moveValues;
	BOOL						misere;
	PlayMode					gameMode;
	NSMutableArray				*board;
	NSString					*humanMove;
	NSMutableArray				*serverHistoryStack;
	NSMutableArray				*serverUndoStack;
}

@property (nonatomic, retain) NSString *player1Name, *player2Name;
@property (nonatomic, assign) PlayerType player1Type, player2Type;
@property (nonatomic, assign) int width, height, pieces;
@property (nonatomic, retain) NSMutableArray *board;
@property (nonatomic, readonly) BOOL p1Turn;
@property (nonatomic, assign) BOOL predictions, moveValues;
@property (nonatomic, assign, getter=isMisere) BOOL misere;
@property (nonatomic, assign) PlayMode gameMode;
@property (nonatomic, retain) NSMutableArray *serverHistoryStack;

+ (NSString *) stringForBoard: (NSArray *) _board;
- (void) resetBoard;
- (void) postHumanMove: (NSString *) move;
- (void) postReady;
- (void) postProblem;

@end
