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

@synthesize position, gameMode;

- (id) init {
	if (self = [super init]) {
        leftPlayer = [[GCPlayer alloc] init];
        leftPlayer.name = @"Player 1";
        leftPlayer.type = HUMAN;
        
        rightPlayer = [[GCPlayer alloc] init];
        rightPlayer.name = @"Player 2";
        rightPlayer.type = HUMAN;
		
		width = 7;
		height = 6;
		pieces = 4;
		
        position = [[GCConnectFourPosition alloc] initWithWidth:width height:height pieces:pieces];
		
		predictions = NO;
		moveValues = NO;
		
	}
	return self;
}


#pragma mark Move/position methods.

/**
 * Return the value of the position POS.
 *
 * @param pos The position in question.
 *
 * @return The value of the requested position (WIN, LOSE, TIE, or DRAW if primitive, NONPRIMITIVE if not)
 */
- (GameValue) primitive: (GCConnectFourPosition *) pos
{
    NSMutableArray *board = pos.board;
    
	for (int i = 0; i < width * height; i += 1) {
		NSString *piece = [board objectAtIndex: i];
		if ([piece isEqual: BLANK])
			continue;
		
		// Check the horizontal case
		BOOL case1 = YES;
		for (int j = i; j < i + pieces; j += 1) {
			if (j >= width * height || i % width > j % width || ![[board objectAtIndex: j] isEqual: piece]) {
				case1 = NO;
				break;
			}
		}
		
		// Check the vertical case
		BOOL case2 = YES;
		for (int j = i; j < i + width * pieces; j += width) {
			if ( j >= width * height || ![[board objectAtIndex: j] isEqual: piece] ) {
				case2 = NO;
				break;
			}
		}
		
		// Check the diagonal case (positive slope)
		BOOL case3 = YES;
		for (int j = i; j < i + pieces + width * pieces; j += (width + 1) ) {
			if ( j >= width * height || (i % width > j % width) || ![[board objectAtIndex: j] isEqual: piece] ) {
				case3 = NO;
				break;
			}
		}
		
		// Check the diagonal case (negative slope)
		BOOL case4 = YES;
		for (int j = i; j < i + width * pieces - pieces; j += (width - 1) ) {
			if ( j >= width * height || (i % width < j % width) || ![[board objectAtIndex: j] isEqual: piece] ) {
				case4 = NO;
				break;
			}
		}		
		if (case1 || case2 || case3 || case4)
			return [piece isEqual: (pos.p1Turn ? @"X" : @"O")] ? (misere ? LOSE : WIN) : (misere ? WIN : LOSE);
	}
	
	// Finally, check if the board is full
	BOOL full = YES;
	for (int i = 0; i < width * height; i += 1) {
		if ([[board objectAtIndex: i] isEqual: BLANK]) {
			full = NO;
			break;
		}
	}
	if (full) return TIE;
	
	return NONPRIMITIVE;
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
	[c4view doMove: moveObject];
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
			[c4view updateLabels];
//			[self postReady];   // FIXME
		} else {
			// Wipe the undo stack
			[serverUndoStack release];
			serverUndoStack = [[NSMutableArray alloc] init];
			
			// Wipe the service object
			[service release];
			service = [[GCJSONService alloc] init];
			
			[c4view updateServerDataWithService: service];
		}
	}
	
	if (gameMode != ONLINE_SOLVED) {
		[c4view updateLabels];
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
- (void) undoMove: (NSNumber *) move toPosition: (Position) toPos
{
	[c4view undoMove: move];
    NSMutableArray *board = position.board;
	
	int slot = [move integerValue] - 1 + width * (height - 1);
	while (slot >= 0) {
		if (![[board objectAtIndex: slot] isEqualToString: BLANK]) {
			[board replaceObjectAtIndex: slot withObject: BLANK];
			break;
		}
		slot -= width;
	}
	position.p1Turn = !position.p1Turn;
	
	if (gameMode == ONLINE_SOLVED) {
		// Pop the entry off the history stack
		NSDictionary *entry = [[serverHistoryStack lastObject] retain];
		[serverHistoryStack removeLastObject];
		
		// Push the entry onto the undo stack
		[serverUndoStack addObject: entry];
		[entry release];
	}
	[c4view updateLabels];
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
	NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity: width];
	
	int col = 1;
	for (int i = width * (height - 1); i < width * height; i += 1) {
		if ([[position.board objectAtIndex: i] isEqual: BLANK])
			[moves addObject: [NSString stringWithFormat: @"%d", col]];
		col += 1;
	}
	
	return moves;
}
- (NSArray *) legalMoves
{
    return [self generateMoves:position];
}


#pragma mark Run methods.

- (void) startGameWithLeft: (GCPlayer *) lp
                     right: (GCPlayer *) rp
           andPlaySettings: (NSDictionary *) settingsDict
{
    leftPlayer = lp;
    rightPlayer = rp;
    playSettings = settingsDict;
    
    [position resetBoard];
	
	gameMode = ONLINE_SOLVED;       // FIXME extract this from playSettings
	
	if (gameMode == OFFLINE_UNSOLVED) {
		predictions = NO;
		moveValues = NO;
	}
	
	if (!c4view)
		[c4view release];
	c4view = [[GCConnectFourViewController alloc] initWithGame: self];
	
	PlayerType current = [self currentPlayer] == PLAYER_LEFT ? [leftPlayer type] : [rightPlayer type];
	if (current == HUMAN)
		c4view.touchesEnabled = YES;		
	
	if (gameMode == ONLINE_SOLVED) {
		service = [[GCJSONService alloc] init];
		serverHistoryStack = [[NSMutableArray alloc] init];
		serverUndoStack    = [[NSMutableArray alloc] init];
		[c4view updateServerDataWithService: service];
	}
}

/**
 * Wait for the user to make a move, then return that move back through the completion handler.
 *
 * @param completionHandler The callback handler to be called with the user's move as argument.
 */
- (void) waitForHumanMoveWithCompletion: (void (^) (Move move)) completionHandler
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


#pragma mark View options.

/* Show/hide move values and predictions */
- (void) showPredictions: (BOOL) predictions
{
    
}
- (void) showMoveValues: (BOOL) moveValues
{
    
}


#pragma mark Status reporting.

/* Report whose turn it is (left or right) */
- (PlayerSide) currentPlayer
{
    // FIXME:  this is a compatibility hack for the original GCConnectFour code
    return position.p1Turn ? PLAYER_LEFT : PLAYER_RIGHT;
}

/* Report the play modes supported by the game */
- (BOOL) supportsPlayMode: (PlayMode) mode
{
    if (mode == OFFLINE_UNSOLVED || mode == ONLINE_SOLVED)
        return YES;
    return NO;
}


#pragma mark Properties.

- (NSString *) boardString
{
    NSString *boardString = @"";
    for (NSString *piece in position.board) {
        if ([piece isEqualToString:@"+"])
            piece = @" ";
        boardString = [boardString stringByAppendingString:piece];
    }
    return boardString;
}

- (GCPlayer *) leftPlayer
{
    return leftPlayer;
}
- (void) setLeftPlayer: (GCPlayer *) left
{
    leftPlayer = [left retain];
}

- (GCPlayer *) rightPlayer
{
    return rightPlayer;
}
- (void) setRightPlayer: (GCPlayer *) right
{
    rightPlayer = [right retain];
}

- (NSDictionary *) playSettings
{
    return playSettings;
}
- (void) setPlaySettings: (NSDictionary *) settingsDict
{
    playSettings = [settingsDict retain];
}

- (BOOL) isMisere
{
    return misere;
}
- (void) setMisere: (BOOL) newMisere
{
    misere = newMisere;
}

/**
 * Return the view that displays this game's interface.
 *
 * @return The view managed by this game that displays the game's interface.
 */
- (UIView *) view
{
    return [c4view view];
}

/**
 * Return a view for changing the game's variants (rules).
 *
 * @return The view managed by this game that displays the game's rule-changing interface.
 */
- (UIView *) variantsView
{
    return nil;     // FIXME
}


@end
