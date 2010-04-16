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
	BOOL p1Turn;
	GCYGameViewController *yGameView;
	PlayMode gameMode;
	NSNumber *humanMove;
	NSDictionary *positionConnections;
	NSDictionary *edgesForPosition;
	NSArray *leftEdges;
	
}

@property (nonatomic, retain) NSDictionary *edgesForPosition;
@property (nonatomic, retain) NSArray *leftEdges;
@property (nonatomic, retain) NSDictionary *positionConnections;
@property (nonatomic, retain) NSString *player1Name, *player2Name;
@property (nonatomic, assign) PlayerType player1Type, player2Type;
@property (nonatomic, assign) int layers;
@property (nonatomic, assign) BOOL p1Turn;
@property (readonly) GCYGameViewController *yGameView;

- (void) resetBoard;
- (void) postHumanMove: (NSNumber *) num;
- (BOOL) boardContainsPlayerPiece: (NSString *) piece forPosition: (NSNumber *) position;
- (void) setGrossDictionaryValues;

@end
