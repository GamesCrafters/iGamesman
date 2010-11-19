//
//  GCOthello.h
//  GamesmanMobile
//
//  Created by Caroline Modic and Ian Vonseggern on 9/26/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCGame.h"

@class GCOthelloViewController;


@interface GCOthello : GCGame {
	GCOthelloViewController *othView;
	NSString *player1Name, *player2Name;
	PlayMode gameMode;
	PlayerType player1Type, player2Type;
	int rows, cols;
	BOOL misere;
	NSMutableArray *board;
	BOOL p1Turn;
	int p1pieces, p2pieces;
	NSMutableArray *myOldMoves;
	NSNumber *humanMove;
}

@property(nonatomic, retain) NSString *player1Name, *player2Name;
@property(nonatomic, assign) PlayerType player1Type, player2Type;
@property (nonatomic, assign, getter=isMisere) BOOL misere;
@property (nonatomic, assign) int rows, cols;
@property (nonatomic, assign) BOOL p1Turn;
@property (nonatomic, retain) NSMutableArray *myOldMoves, *board;
@property (nonatomic, assign) int p1pieces, p2pieces;

- (void) resetBoard;
- (NSArray *) getFlips: (int) loc;
- (BOOL) isOutOfBounds: (int) loc offset: (int) offset;
- (void) postHumanMove: (NSNumber *) move;

@end
