//
//  GCGame.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 9/15/11.
//  Copyright 2011 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCPlayer.h"

typedef id<NSCopying> Position;
typedef id<NSCopying> Move;

typedef enum { WIN, LOSE, TIE, DRAW, NONPRIMITIVE, UNKNOWN } GameValue;
typedef enum { ONLINE_SOLVED, OFFLINE_UNSOLVED } PlayMode;
typedef enum { PLAYER_LEFT, PLAYER_RIGHT } PlayerSide;


/** 
 * The protocol that all games must adhere to to cooperate with the system framework.
 */
@protocol GCGame 

/**
 * Return the position that result by making the move MOVE
 *  from the position FROMPOS. The underlying game object
 *  may choose to keep a position in its local state and modify
 *  that position for each doMove call. Note that the game may
 *  choose whatever objects it likes to represent moves and positions,
 *  but those types must conform to the NSCopying protocol.
 *
 * @param move The move to be made. Guaranteed to be a legal move.
 * @param fromPos The position from which to make the move. This will always be the "current" position.
 *
 * @return The position that results by making MOVE from FROMPOS.
 */
- (Position) doMove: (Move) move fromPosition: (Position) fromPos;

/**
 * Undo the move MOVE from the position FROMPOS such that the new
 *  current position is TOPOS (the position before MOVE was made).
 * 
 * @param move The move to undo. Guaranteed to be the move that led to the current position.
 * @param fromPos The position from which to undo. This will always be the "current" position.
 * @param toPos The position that results from undoing MOVE. Guaranteed to be the position before MOVE was made.
 */
- (void) undoMove: (Move) move fromPosition: (Position) fromPos toPosition: (Position) toPos;

/**
 * Return the value of the position POS.
 *
 * @param pos The position in question.
 *
 * @return The value of the requested position (WIN, LOSE, TIE, or DRAW if primitive, NONPRIMITIVE if not)
 */
- (GameValue) primitive: (Position) pos;

/**
 * Return the legal moves for the position POS.
 *
 * @param pos The position in question.
 *
 * @return An NSArray of Move objects, representing all of the moves that are legal from POS.
 *  If there are no legal moves, return an empty array - NOT nil.
 */
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
