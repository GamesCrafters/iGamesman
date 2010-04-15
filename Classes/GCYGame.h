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
	
	//ghettotastic until I figure out what to do. 
	NSDictionary *layer0Connections;
	NSDictionary *layer1Connections;
	NSDictionary *layer2Connections;
	
	//More ghettotastiliciousness
	NSDictionary *layer0edgesForPosition;
	NSDictionary *layer1edgesForPosition;
	NSDictionary *layer2edgesForPosition;
	
	NSArray *layer0leftEdges;
	NSArray *layer1leftEdges;
	NSArray *layer2leftEdges;
}

@property (nonatomic, retain) NSDictionary *edgesForPosition;
@property (nonatomic, retain) NSArray *leftEdges;
@property (nonatomic, retain) NSDictionary *positionConnections;
@property (nonatomic, retain) NSString *player1Name, *player2Name;
@property (nonatomic, assign) PlayerType player1Type, player2Type;
@property (nonatomic, assign) int layers;
@property (nonatomic, assign) BOOL p1Turn;

- (void) resetBoard;
- (void) postHumanMove: (NSNumber *) num;

@end
