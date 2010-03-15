//
//  GCConnections.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/12/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCGame.h"

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
	NSMutableArray *fringe;
}

@property (nonatomic, retain) NSString *player1Name, *player2Name;
@property (nonatomic, assign) PlayerType player1Type, player2Type;
@property (nonatomic, assign) int size;
@property (nonatomic, assign) BOOL p1Turn;

- (void) resetBoard;
- (void) postHumanMove: (NSNumber *) num;

@end
