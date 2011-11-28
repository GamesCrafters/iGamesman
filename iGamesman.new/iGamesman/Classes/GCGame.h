//
//  GCGame.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 9/15/11.
//  Copyright 2011 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GCGameModeKey @"GCGamePlayMode"
#define GCGameModeOfflineUnsolved @"OFFLINE_UNSOLVED"
#define GCGameModeOnlineSolved @"ONLINE_SOLVED"


/* Deprecated. Use GCPosition and GCMove instead */
typedef id<NSCopying> Position;
typedef id<NSCopying> Move;

typedef NSObject<NSCopying> GCPosition;
typedef NSObject<NSCopying> GCMove;


typedef NSString GCGameValue;
#define GCGameValueWin     @"VALUE_WIN"
#define GCGameValueLose    @"VALUE_LOSE"
#define GCGameValueTie     @"VALUE_TIE"
#define GCGameValueDraw    @"VALUE_DRAW"
#define GCGameValueUnknown @"VALUE_UNKNOWN"

/* Deprecated. Use GCGameValue instead */
typedef enum { WIN, LOSE, TIE, DRAW, NONPRIMITIVE, UNKNOWN } GameValue;

typedef enum { ONLINE_SOLVED = 0, OFFLINE_UNSOLVED } PlayMode;
typedef enum { PLAYER_LEFT, PLAYER_RIGHT } PlayerSide;


@class GCPlayer;


/** 
 * The protocol that all games must adhere to to cooperate with the system framework.
 */
@protocol GCGame

/***************************************************************\
 *                           NEW API                           *
\***************************************************************/


@required
/**
 * Make the move MOVE from the current position.
 *
 * @param move The move to be made. Guaranteed to be a legal move.
 */
- (void) doMove: (GCMove *) move;


/**
 * Undo the move MOVE from the current position such that the current
 * position is changed to PREVIOUSPOSITION (the position before MOVE was made).
 *
 * @param move The move to undo. Guaranteed to be the move that led to the current position.
 * @param previousPosition The position before MOVE was made.
 */
- (void) undoMove: (GCMove *) move toPosition: (GCPosition *) previousPosition;


/**
 * Return the value of the current position.
 *
 * @return The value of the current position (WIN, LOSE, TIE, or DRAW if primitive, nil if not)
 */
- (GCGameValue *) primitive;


/**
 * Return the legal moves that can be made from the current position.
 *
 * @return An array of GCMove objects, representing all of the moves that are legal from 
 * the current position. If there are no legal moves, return an empty array - NOT nil.
 */
- (NSArray *) generateMoves;


/**
 * Return the current position.
 *
 * @return The current position
 */
- (GCPosition *) currentPosition;


/**
 * Report whose turn it is (left or right).
 * 
 * @return The side of the player whose turn it is
 */
- (PlayerSide) currentPlayer;


/**
 * Return the view (with frame rectangle FRAME) that displays this game's interface.
 *
 * @param frame The frame rectangle this game's
 *
 * @return The view managed by this game that displays the game's interface.
 */
- (UIView *) viewWithFrame: (CGRect) frame;



typedef void (^GCMoveCompletionHandler) (GCMove *move);

/**
 * Wait for the user to make a move, then return that move back through the completion handler.
 *
 * @param completionHandler The callback handler to be called with the user's move as argument.
 */
- (void) waitForHumanMoveWithCompletion: (GCMoveCompletionHandler) completionHandler;




/***************************************************************\
 *                     DEPRECATED: OLD API                     *
\***************************************************************/

@optional
//- (Position) doMove: (Move) move;


//- (void) undoMove: (Move) move toPosition: (Position) toPos;


//- (GameValue) primitive: (Position) pos;


//- (NSArray *) generateMoves: (Position) pos;


//- (Position) currentPosition;


- (void) startGameWithLeft: (GCPlayer *) leftPlayer
                     right: (GCPlayer *) rightPlayer
           andPlaySettings: (NSDictionary *) settingsDict;

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


@end
