//
//  GCGame.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 1/29/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCOptionMenu.h"

typedef enum { ONLINESOLVED, OFFLINEUNSOLVED } PlayMode;
typedef enum { WIN, LOSE, TIE, DRAW, UNAVAILABLE } GameValue;

/**
 Superclass of all game objects
 Do not use! This is a superclass only!
 Treat this like an abstract class!
 
 Subclasses should have the current board in their local state
 and update it at appropriate times.
 */
@interface GCGame : NSObject {

}

/// Return the game's name
- (NSString *) gameName;

/// Getter for Player 1's name
- (NSString *) player1Name;
/// Getter for Player 1's name
- (NSString *) player2Name;

/// Setter for the Player 1's name
- (void) setPlayer1Name: (NSString *) p1;
/// Setter for the Player 2's name
- (void) setPlayer2Name: (NSString *) p2;

/// Return YES for supported mode(s)
- (BOOL) supportsPlayMode: (PlayMode) mode;

/// Return the option menu
- (UIViewController<GCOptionMenu> *) optionMenu;

/// Return the game's view controller
- (UIViewController *) gameViewController;

/// Do anything necessary to get the game started (return NO if something fails)
- (BOOL) startGame;

/// Getter for Predictions
- (BOOL) predictions;
/// Getter for Move Values
- (BOOL) moveValues;

/// Setter for Predictions
/// Must update the view to reflect the new settings
- (void) setPredicitons: (BOOL) pred;
/// Setter for Move Values
/// Must update the view to reflect the new settings
- (void) setMoveValues: (BOOL) move;

/// Return YES if Forward buttons should be enabled
- (BOOL) forwardPossible;
/// Return YES if Backward buttons should be enabled
- (BOOL) backwardPossible;

/// Handle one position forward
- (void) stepForward;
/// Handle one position backward
- (void) stepBackward;

/// Handle jump forward to "end"
- (void) jumpForward;
/// Handle jump backward to beginning
- (void) jumpBackward;

/// Return the string representation of the current board
- (NSString *) getBoard;

/// Return the name of the player whose turn it is
- (NSString *) getPlayer;

/// Return the value of the current board
- (GameValue) getValue;

/// Return the remoteness of the current board (or -1 if not available)
- (NSInteger) getRemoteness;

/// Return the value of MOVE
- (GameValue) getValueOfMove: (id) move;

/// Return the remoteness of MOVE (or -1 if not available)
- (NSInteger) getRemotenessOfMove: (id) move;

/// Return an array of legal moves using the current board
- (NSArray *) legalMoves;

/// Return YES if the current board is primitive, NO if not
- (BOOL) isPrimitive;

/// Perform MOVE and update the view accordingly
- (void) doMove: (id) move;

@end
