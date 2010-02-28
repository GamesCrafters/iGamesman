//
//  GCGame.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 1/29/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCGame.h"


@implementation GCGame

// Return the game's name
- (NSString *) gameName { return nil; }

// Getters for the player names
- (NSString *) player1Name { return nil; }
- (NSString *) player2Name { return nil; }

// Setters for the player names
- (void) setPlayer1Name: (NSString *) p1 { }
- (void) setPlayer2Name: (NSString *) p2 { }

// Getter for Player 1 Human/Computer
- (PlayerType) player1Type { return HUMAN; }
// Getter for Player 2 Human/Computer
- (PlayerType) player2Type { return HUMAN; }

// Setter for Player 1 Type
- (void) setPlayer1Type: (PlayerType) type { }
// Setter for Player 2 Type
- (void) setPlayer2Type: (PlayerType) type { }

// Return YES for supported mode(s)
- (BOOL) supportsPlayMode: (PlayMode) mode { return NO; }

// Return the option menu
- (UIViewController *) optionMenu { return nil; }

// Return the game's view controller
- (UIViewController *) gameViewController { return nil; }

// Do anything necessary to get the game started (return NO if something fails)
- (void) startGameInMode: (PlayMode) mode { }

// Return YES if ready to go, NO if not
- (BOOL) gameReady { return YES; }

// Get the current play mode
- (PlayMode) playMode { return OFFLINE_UNSOLVED; }

// Getters for Predictions and Move Values
- (BOOL) predictions { return NO; }
- (BOOL) moveValues { return NO; }

// Setters for Predictions and Move Values
// Must update the view to reflect the new settings
- (void) setPredicitons: (BOOL) pred { }
- (void) setMoveValues: (BOOL) move { }

// Return the current board
- (id) getBoard { return nil; }

// Return the name of the player whose turn it is
- (Player) getPlayer { return NONE; }

// Return the value of the current board
- (NSString *) getValue { return @"UNAVAILABLE"; }

// Return the remoteness of the current board (or -1 if not available)
- (NSInteger) getRemoteness { return -1; }

// Return the value of MOVE
- (NSString *) getValueOfMove: (id) move { return @"UNAVAILABLE"; }

// Return the remoteness of MOVE (or -1 if not available)
- (NSInteger) getRemotenessOfMove: (id) move { return -1; }

// Return an array of legal moves using the current board
- (NSArray *) legalMoves { return nil; }

// Return YES if THEBOARD is primitive, NO if not
- (BOOL) isPrimitive: (id) theBoard  { return NO; }

// Ask the user for input
- (void) askUserForInput { }

// End asking for user input
- (void) stopUserInput { }

// Get the current player
- (Player) currentPlayer { return NONE; }

// Get the move the user chose (only called after the GameController receives a notification)
- (id) getHumanMove { return nil; }

// Perform MOVE and update the view accordingly
- (void) doMove: (id) move { }

@end
