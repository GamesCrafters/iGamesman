//
//  GCConnectFour.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 9/15/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import "GCConnectFour.h"

#define BLANK @"+"

@implementation GCConnectFour

- (id) init {
	if (self = [super init]) {
		player1Name = @"Player 1";
		player2Name = @"Player 2";
		
		player1Type = HUMAN;
		player2Type = HUMAN;
		
		width = 7;
		height = 6;
		pieces = 4;
		
        position = [[GCConnectFourPosition alloc] initWithWidth:width height:height];
		
		predictions = NO;
		moveValues = NO;
		
	}
	return self;
}

/**
 * Return the position that result by making the move MOVE
 *  from the current. The underlying game object
 *  needs to keep a position in its local state and modify
 *  that position for each doMove call. Note that the game may
 *  choose whatever objects it likes to represent moves and positions,
 *  but those types must conform to the NSCopying protocol.
 *
 * @param move NSNumber representing the move to be made. Guaranteed to be a legal move.
 *
 * @return The position that results by making MOVE from the current position.
 */
- (Position) doMove: (NSNumber *) moveObject
{
	//[c4view doMove: move];    // FIXME
    NSMutableArray *board = position.board;
    
	int slot = [moveObject intValue] - 1;
	while (slot < width * height) {
		if ([[board objectAtIndex: slot] isEqual: BLANK]) {
			[board replaceObjectAtIndex: slot withObject: (position.p1Turn ? @"X" : @"O")];
			break;
		}
		slot += width;
	}
	position.p1Turn = !position.p1Turn;
	
	if (gameMode == ONLINE_SOLVED) {
		// Peek at the top of the undo stack
		NSDictionary *undoEntry = [serverUndoStack lastObject];
		if ([[undoEntry objectForKey: @"board"] isEqual: board]) {
			// Pop it off the undo stack
			[undoEntry retain];
			[serverUndoStack removeLastObject];
			
			// Push it onto the history stack
			[serverHistoryStack addObject: undoEntry];
			[undoEntry release];
//			[c4view updateLabels];  // FIXME
//			[self postReady];   // FIXME
		} else {
			// Wipe the undo stack
			[serverUndoStack release];
			serverUndoStack = [[NSMutableArray alloc] init];
			
			// Wipe the service object
			[service release];
			service = [[GCJSONService alloc] init];
			
//			[c4view updateServerDataWithService: service];  // FIXME
		}
	}
	
	if (gameMode != ONLINE_SOLVED) {
//		[c4view updateLabels];  // FIXME
    }
    
    return position;
}


/**
 * Undo the move MOVE from the current position such that the new
 *  current position is TOPOS (the position before MOVE was made).
 * 
 * @param move The move to undo. Guaranteed to be the move that led to the current position.
 * @param toPos The position that results from undoing MOVE. Guaranteed to be the position before MOVE was made.
 */
- (void) undoMove: (Move) move toPosition: (Position) toPos
{
    
}


/**
 * Return the value of the position POS.
 *
 * @param pos The position in question.
 *
 * @return The value of the requested position (WIN, LOSE, TIE, or DRAW if primitive, NONPRIMITIVE if not)
 */
- (GameValue) primitive: (Position) pos
{
    
}


/**
 * Return the legal moves for the position POS.
 *
 * @param pos The position in question.
 *
 * @return An NSArray of Move objects, representing all of the moves that are legal from POS.
 *  If there are no legal moves, return an empty array - NOT nil.
 */
- (NSArray *) generateMoves: (Position) pos
{
    
}


- (void) startGameWithLeft: (GCPlayer *) leftPlayer
                     right: (GCPlayer *) rightPlayer
           andPlaySettings: (NSDictionary *) settingsDict
{
    
}

/**
 * Return the left player.
 *
 * @return The game's left player.
 */
- (GCPlayer *) leftPlayer
{
    
}


/**
 * Assign the left player.
 *
 * @param left The new left player.
 */
- (void) setLeftPlayer: (GCPlayer *) left
{
    
}


/**
 * Return the right player.
 *
 * @return The game's right player.
 */
- (GCPlayer *) rightPlayer
{
    
}


/**
 * Assign the right player.
 *
 * @param right The new right player.
 */
- (void) setRightPlayer: (GCPlayer *) right
{
    
}


- (NSDictionary *) playSettings
{
    
}
- (void) setPlaySettings: (NSDictionary *) settingsDict
{
    
}


/**
 * Return the view that displays this game's interface.
 *
 * @return The view managed by this game that displays the game's interface.
 */
- (UIView *) view
{
    
}


/**
 * Wait for the user to make a move, then return that move back through the completion handler.
 *
 * @param completionHandler The callback handler to be called with the user's move as argument.
 */
- (void) waitForHumanMoveWithCompletion: (void (^) (Move move)) completionHandler
{
    
}


/**
 * Return a view for changing the game's variants (rules).
 *
 * @return The view managed by this game that displays the game's rule-changing interface.
 */
- (UIView *) variantsView
{
    
}

/* Accessors for misere */
- (BOOL) isMisere
{
    
}
- (void) setMisere: (BOOL) misere
{
    
}

/* Pause any ongoing tasks (such as server requests) */
- (void) pause
{
    
}
/* Resume any tasks paused by -pause */
- (void) resume
{
    
}

/* Report the play modes supported by the game */
- (BOOL) supportsPlayMode: (PlayMode) mode
{
    
}

/* Show/hide move values and predictions */
- (void) showPredictions: (BOOL) predictions
{
    
}
- (void) showMoveValues: (BOOL) moveValues
{
    
}

/* Report whose turn it is (left or right) */
- (PlayerSide) currentPlayer
{
    
}


@end
