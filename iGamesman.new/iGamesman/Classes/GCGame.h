//
//  GCGame.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 9/15/11.
//  Copyright 2011 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCPlayer.h"

#define GCGameModeKey @"GCGamePlayMode"
#define GCGameModeOfflineUnsolved @"OFFLINE_UNSOLVED"
#define GCGameModeOnlineSolved @"ONLINE_SOLVED"


typedef id<NSCopying> Position;
typedef id<NSCopying> Move;

typedef enum { WIN, LOSE, TIE, DRAW, NONPRIMITIVE, UNKNOWN } GameValue;
typedef enum { ONLINE_SOLVED = 0, OFFLINE_UNSOLVED } PlayMode;
typedef enum { PLAYER_LEFT, PLAYER_RIGHT } PlayerSide;


/** 
 * The protocol that all games must adhere to to cooperate with the system framework.
 */
@protocol GCGame

@optional
/**
 * Return the position that result by making the move MOVE
 *  from the current. The underlying game object
 *  needs to keep a position in its local state and modify
 *  that position for each doMove call. Note that the game may
 *  choose whatever objects it likes to represent moves and positions,
 *  but those types must conform to the NSCopying protocol.
 *
 * @param move The move to be made. Guaranteed to be a legal move.
 *
 * @return The position that results by making MOVE from the current position.
 */
- (Position) doMove: (Move) move;


/**
 * Undo the move MOVE from the current position such that the new
 *  current position is TOPOS (the position before MOVE was made).
 * 
 * @param move The move to undo. Guaranteed to be the move that led to the current position.
 * @param toPos The position that results from undoing MOVE. Guaranteed to be the position before MOVE was made.
 */
- (void) undoMove: (Move) move toPosition: (Position) toPos;


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


@required
- (void) startGameWithLeft: (GCPlayer *) leftPlayer
                     right: (GCPlayer *) rightPlayer
           andPlaySettings: (NSDictionary *) settingsDict;

@optional
/**
 * Return the left player.
 *
 * @return The game's left player.
 */
- (GCPlayer *) leftPlayer;


/**
 * Assign the left player.
 *
 * @param left The new left player.
 */
- (void) setLeftPlayer: (GCPlayer *) left;


/**
 * Return the right player.
 *
 * @return The game's right player.
 */
- (GCPlayer *) rightPlayer;


/**
 * Assign the right player.
 *
 * @param right The new right player.
 */
- (void) setRightPlayer: (GCPlayer *) right;


- (NSDictionary *) playSettings;
- (void) setPlaySettings: (NSDictionary *) settingsDict;


/**
 * Return the view that displays this game's interface.
 *
 * @return The view managed by this game that displays the game's interface.
 * @deprecated Use viewWithFrame: instead.
 */
- (UIView *) view;


@required
/**
 * Return the view (with frame rectangle FRAME) that displays this game's interface.
 *
 * @param frame The frame rectangle this game's
 *
 * @return The view managed by this game that displays the game's interface.
 */
- (UIView *) viewWithFrame: (CGRect) frame;


@optional
/**
 * Wait for the user to make a move, then return that move back through the completion handler.
 *
 * @param completionHandler The callback handler to be called with the user's move as argument.
 */
- (void) waitForHumanMoveWithCompletion: (void (^) (Move move)) completionHandler;


/**
 * Return a view for changing the game's variants (rules).
 *
 * @return The view managed by this game that displays the game's rule-changing interface.
 */
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
