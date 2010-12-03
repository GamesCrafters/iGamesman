//
//  GCYGame.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/5/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCGame.h"
#import "GCJSONService.h"


@class GCYGameViewController;

@interface GCYGame : GCGame {
	//UI
	GCYGameViewController		*yGameView;
	NSMutableArray				*board;
	
	//game instance variables
	int							layers;
	int							innerTriangleLength;
	BOOL						misere;
	BOOL						predictions, moveValues;
	NSString					*player1Name, *player2Name;
	PlayerType					player1Type, player2Type;
	
	//game management
	BOOL						p1Turn;
	PlayMode					gameMode;
	GCJSONService				*service;
	NSNumber					*humanMove;
	NSMutableArray				*serverHistoryStack;
	NSMutableArray				*serverUndoStack;
}


@property (nonatomic, assign) int layers;
@property (nonatomic, assign) int innerTriangleLength;

@property (nonatomic, assign) BOOL p1Turn;
@property (nonatomic, assign) BOOL misere;
@property (nonatomic, assign) BOOL predictions, moveValues;

@property (nonatomic, assign) PlayMode gameMode;
@property (nonatomic, retain) NSMutableArray *board;
@property (readonly) GCYGameViewController *yGameView;
@property (nonatomic, retain) NSMutableArray *serverHistoryStack;
@property (nonatomic, retain) NSString *player1Name, *player2Name;
@property (nonatomic, assign) PlayerType player1Type, player2Type;

- (void) resetBoard;
- (void) postHumanMove: (NSNumber *) num;
- (void) postReady;
- (void) postProblem;
- (BOOL) boardContainsPlayerPiece: (NSString *) piece forPosition: (NSNumber *) position;
+ (NSString *) stringForBoard: (NSArray *) _board;


@end
