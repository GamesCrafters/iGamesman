//
//  GCYGame.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/5/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCGame.h"


@class GCYGameViewController;

@interface GCYGame : GCGame {
	NSString *player1Name, *player2Name;
	PlayerType player1Type, player2Type;
	NSMutableArray *board;
	int layers;
	int innerTriangleLength;
	BOOL p1Turn;
	GCYGameViewController *yGameView;
	PlayMode gameMode;
	NSNumber *humanMove;
}

@property (nonatomic assign) int innerTriangleLength;
@property (nonatomic, retain) NSString *player1Name, *player2Name;
@property (nonatomic, assign) PlayerType player1Type, player2Type;
@property (nonatomic, assign) int layers;
@property (nonatomic, assign) BOOL p1Turn;
@property (readonly) GCYGameViewController *yGameView;

- (void) resetBoard;
- (void) postHumanMove: (NSNumber *) num;
- (BOOL) boardContainsPlayerPiece: (NSString *) piece forPosition: (NSNumber *) position;

@end
