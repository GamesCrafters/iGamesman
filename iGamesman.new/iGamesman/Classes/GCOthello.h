//
//  GCOthello.h
//  iGamesman
//
//  Created by Luca Weihs on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCGame.h"
#import "GCPlayer.h"
#import "GCJSONService.h"

@interface GCOthello : NSObject <GCGame> {
	PlayMode gameMode;
	int rows, cols;
	id othView;
	BOOL misere, autoPass;
	NSMutableArray *board;
	BOOL leftPlayerTurn;
	int leftPlayerPieces, rightPlayerPieces;
	NSMutableArray *myOldMoves;
    BOOL predictions, moveValues;
    GCJSONService *service;
}
@property (nonatomic, assign) GCPlayer *leftPlayer;
@property (nonatomic, assign) GCPlayer *rightPlayer;
@property (nonatomic, assign) BOOL autoPass;
@property (nonatomic, assign, getter=isMisere) BOOL misere;
@property (nonatomic, assign) int rows, cols;
@property (nonatomic, assign) BOOL leftPlayerTurn;
@property (nonatomic, retain) NSMutableArray *myOldMoves, *board;
@property (nonatomic, assign) int leftPlayerPieces, rightPlayerPieces;
@property (nonatomic, assign) BOOL predictions, moveValues;

- (void) resetBoard;
- (NSArray *) getFlips: (int) loc;
- (BOOL) isOutOfBounds: (int) loc offset: (int) offset;
- (void) postHumanMove: (NSNumber *) move;
+ (NSString *) stringForBoard: (NSArray *) _board;
- (void) postReady;
- (void) postProblem;
- (void) startGameWithLeft: (GCPlayer *) leftGCPlayer
                     right: (GCPlayer *) rightGCPlayer
           andPlaySettings: (NSDictionary *) settingsDict;

@end
