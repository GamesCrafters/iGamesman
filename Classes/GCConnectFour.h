//
//  GCConnectFour.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 1/29/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCGame.h"

@class GCConnectFourViewController;

/**
 The controlling class for Connect-4
 */
@interface GCConnectFour : GCGame {
	GCConnectFourViewController *c4view;
	NSString *player1Name, *player2Name;
	BOOL player1Human, player2Human;
	int width, height, pieces;
	BOOL p1Turn;
	NSMutableArray *board;
	NSString *humanMove;
	NSThread *waiter;
}

@property (nonatomic, retain) NSString *player1Name, *player2Name;
@property (nonatomic, assign, getter=isPlayer1Human) BOOL player1Human;
@property (nonatomic, assign, getter=isPlayer2Human) BOOL player2Human;
@property (nonatomic, assign) int width, height, pieces;
@property (nonatomic, retain) NSArray *board;
@property (nonatomic, readonly) BOOL p1Turn;

- (void) resetBoard;
- (void) postHumanMove: (NSString *) move;

@end
