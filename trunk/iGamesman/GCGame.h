//
//  GCGame.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/10/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef GCGAME_H
#define GCGAME_H


/* Left and right player indicators */
typedef enum { GC_PLAYER_LEFT, GC_PLAYER_RIGHT } GCPlayerSide;


/* Position and Move typedefs */
typedef NSObject<NSCopying> GCPosition;
typedef NSObject<NSCopying> GCMove;


/** Game values */
typedef NSString GCGameValue;
#define GCGameValueWin     @"GC_VALUE_WIN"
#define GCGameValueLose    @"GC_VALUE_LOSE"
#define GCGameValueTie     @"GC_VALUE_TIE"
#define GCGameValueDraw    @"GC_VALUE_DRAW"
#define GCGameValueUnknown @"GC_VALUE_UNKNOWN"



/**
 * The corresponding value is an NSNumber wrapping a boolean value that indicates whether misere play is on or off.
 * A value of YES means misere is enabled; a value of NO means misere is disabled.
 */
#define GCMisereOptionKey @"GC_MISERE_OPTION"


@class GCPlayer;

@protocol GCGame <NSObject>

@optional
/**
 * Return the name of the GCWeb service for this game.
 *   Example: for Tic-Tac-Toe, which has the URL:
 *     http://nyc.cs.berkeley.edu:8080/gcweb/service/gamesman/puzzles/ttt/getMoveValue;width=3;height=3;pieces=3;board=...
 *   this method should return @"ttt".
 * A game that implements this method must also implement the other -gcWeb... methods.
 *
 * @return The name of the service, or nil if the current configuration is unsupported by GCWeb
 */
- (NSString *) gcWebServiceName;


/**
 * Return a dictionary of the game-specific parameters to GCWeb for this game.
 *   Example: for 3x3 Tic-Tac-Toe, which has the URL:
 *     http://nyc.cs.berkeley.edu:8080/gcweb/service/gamesman/puzzles/ttt/getMoveValue;width=3;height=3;pieces=3;board=...
 *   this method should return {@"width" : 3, @"height" : 3, @"pieces" : 3}
 * A game that implements this method must also implement the other -gcWeb... methods.
 * This method will only be called on a game that has already been started.
 *
 * @return A dictionary of parameter names mapping to values, or nil if the current configuration is unsupported by GCWeb
 */
- (NSDictionary *) gcWebParameters;


/**
 * Return the GCWeb-acceptable string representation of the current position.
 * Must be properly URL escaped.
 * A game that implements this method must also implement the other -gcWeb... methods.
 *
 * @return The string representation of the current position, to be passed to the GCWeb request, or nil if the current configuration is unsupported by GCWeb
 */
- (NSString *) gcWebBoardString;


/**
 * Called after the server comes back with a value and remoteness for the current position.
 * The game should update its UI as needed.
 * A game that implements this method must also implement the other -gcWeb... methods.
 *
 * @param value The value of the position, or GCGameValueUnknown if unavailable.
 * @param remoteness The remoteness value of the position, or -1 if unavailable.
 */
- (void) gcWebReportedPositionValue: (GCGameValue *) value remoteness: (NSInteger) remoteness;


/**
 * Called after the server comes back with the values and remoteness values for the legal moves from the current position.
 * The game should update its UI as needed.
 * A game that implements this method must also implement the other -gcWeb... methods.
 *
 * @param values An array of GCGameValues, corresponding to the array MOVES
 * @param remotenesses An array of NSNumbers, each a wrapper for an NSInteger, corresponding to the array MOVES
 * @param moves An array of moves, as returned by GCWeb
 *
 * All three arrays are guaranteed to have the same length, and the Nth elements of VALUES and REMOTENESSES
 *     correspond to the Nth element of MOVES.
 */
- (void) gcWebReportedValues: (NSArray *) values remotenesses: (NSArray *) remotenesses forMoves: (NSArray *) moves;


/**
 * Convert a GCWeb-compatible move representation to the game object's representation.
 *
 * @param gcWebMove A move, as returned by GCWeb (usually an NSString, but possibly an NSNumber)
 *
 * @return The equivalent move, using the game object's representation.
 */
- (GCMove *) moveForGCWebMove: (NSString *) gcWebMove;


@required

/**
 * Return the game's name
 * 
 * @return The name of the game
 */
- (NSString *) name;


/**
 * Return the view (with frame rectangle FRAME) that displays this game's interface.
 *
 * @param frame The frame rectangle this game's view needs to be
 *
 * @return The view managed by this game that displays the game's interface.
 */
- (UIView *) viewWithFrame: (CGRect) frame;


/**
 * Start a new game. Games should use this method to set the initial position and to set the epithets of the two players.
 *
 * @param leftPlayer The left player
 * @param rightPlayer The right player
 * @param options The options dictionary. The keys for this dictionary are documented at the top of GCGame.h
 */
- (void) startGameWithLeft: (GCPlayer *) leftPlayer
                     right: (GCPlayer *) rightPlayer
                   options: (NSDictionary *) options;


typedef void (^GCMoveCompletionHandler) (GCMove *move);

/**
 * Wait for the user to make a move, then return that move back through the completion handler.
 * The move passed to the completion handler must be a legal move.
 *
 * @param completionHandler The callback handler to be called with the user's move as argument. The receiver is not responsible for memory-managing the block.
 */
- (void) waitForHumanMoveWithCompletion: (GCMoveCompletionHandler) completionHandler;


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
- (GCPlayerSide) currentPlayerSide;


/**
 * Return the left player.
 *
 * @return The game's left player.
 */
- (GCPlayer *) leftPlayer;


/**
 * Return the right player.
 *
 * @return The game's right player.
 */
- (GCPlayer *) rightPlayer;


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


@optional
- (BOOL) isMisere;


@required
- (BOOL) canShowMoveValues;
- (BOOL) canShowDeltaRemoteness;


@optional
- (BOOL) isShowingMoveValues;
- (BOOL) isShowingDeltaRemoteness;
- (void) setShowingMoveValues: (BOOL) moveValues;
- (void) setShowingDeltaRemoteness: (BOOL) deltaRemoteness;

@end


#endif

