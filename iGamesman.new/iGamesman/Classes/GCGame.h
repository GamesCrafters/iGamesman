//
//  GCGame.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 9/15/11.
//  Copyright 2011 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCPlayer.h"

typedef id Position;
typedef id Move;

typedef enum { WIN, LOSE, TIE, DRAW, NONPRIMITIVE, UNKNOWN } GameValue;
typedef enum { ONLINE_SOLVED, OFFLINE_UNSOLVED } PlayMode;
typedef enum { PLAYER_LEFT, PLAYER_RIGHT } PlayerSide;


/** This class must be treated as the ABSTRACT superclass of all games.
 *  Instantiating GCGame directly WILL NOT WORK (all method calls will
 *  raise an exception. If a subclass fails to implement a method, an 
 *  exception will be raised when that message is sent. */
@protocol GCGame 

- (Position) doMove: (Move) move fromPosition: (Position) fromPos;
- (void) undoMove: (Move) move fromPosition: (Position) fromPos toPosition: (Position) toPos;
- (GameValue) primitive: (Position) pos;
- (NSArray *) generateMoves: (Position) pos;

- (void) startGameWithLeft: (GCPlayer *) leftPlayer
                     right: (GCPlayer *) rightPlayer
           andPlaySettings: (NSDictionary *) settingsDict;

/* Accessors for the players and “meta-game” settings */
- (GCPlayer *) leftPlayer;
- (void) setLeftPlayer: (GCPlayer *) left;
- (GCPlayer *) rightPlayer;
- (void) setRightPlayer: (GCPlayer *) right;
- (NSDictionary *) playSettings;
- (void) setPlaySettings: (NSDictionary *) settingsDict;

- (UIView *) view;

- (void) waitForHumanMoveWithCompletion: (void (^) (Move move)) completionHandler;

- (UIView *) variantsView;

/* Accessors for misere */
- (BOOL) isMisere;
- (void) setMisere: (BOOL) misere;

/* Pause any ongoing tasks (such as server requests) */
- (void) pause;
/* Resume any tasks paused by -pause */
- (void) resume;

/* Report the play modes supported by the game */
- (BOOL) supportsPlayMode: (PlayMode) mode;

/* Show/hide move values and predictions */
- (void) showPredictions: (BOOL) predictions;
- (void) showMoveValues: (BOOL) moveValues;

/* Report whose turn it is (left or right) */
- (PlayerSide) currentPlayer;


@end
