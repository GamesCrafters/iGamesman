//
//  GCTicTacToe.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 9/17/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCGame.h"
#import "GCJSONService.h"

@class GCTicTacToeViewController;

@interface GCTicTacToe : GCGame {
	GCTicTacToeViewController *tttView;
	
	GCJSONService *service;
	
	NSString *player1Name, *player2Name;
	PlayerType player1Type, player2Type;
	
	BOOL p1Turn;
	
	PlayMode gameMode;
	
	int rows, cols, inarow;
	BOOL misere;
	NSMutableArray *board;
	
	NSNumber *humanMove;
	
	BOOL predictions, moveValues;
}

@property (nonatomic, retain) NSString *player1Name, *player2Name;
@property (nonatomic, assign) PlayerType player1Type, player2Type;
@property (nonatomic, assign, getter=isMisere) BOOL misere;
@property (nonatomic, assign) int rows, cols, inarow;
@property (nonatomic, assign) BOOL p1Turn;
@property (nonatomic, assign) BOOL predictions, moveValues;

+ (NSString *) stringForBoard: (NSArray *) _board;
- (void) resetBoard;
- (void) postHumanMove: (NSNumber *) move;
- (void) postReady;
- (void) postProblem;

@end
