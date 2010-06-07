//
//  GCConnectFour.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 1/29/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCConnectFour.h"
#import "GCConnectFourOptionMenu.h"
#import "GCConnectFourViewController.h"


#define BLANK @"+"

@implementation GCConnectFour

@synthesize player1Name, player2Name;
@synthesize player1Type, player2Type;
@synthesize width, height, pieces;
@synthesize board;
@synthesize p1Turn;
@synthesize predictions, moveValues;
@synthesize misere;
@synthesize gameMode;
@synthesize serverHistoryStack;

- (id) init {
	if (self = [super init]) {
		player1Name = @"Player 1";
		player2Name = @"Player 2";
		
		player1Type = HUMAN;
		player2Type = HUMAN;
		
		width = 6;
		height = 5;
		pieces = 4;
		
		p1Turn = YES;
		
		predictions = NO;
		moveValues = NO;
		
		board = [[NSMutableArray alloc] initWithCapacity: width * height];
		for (int i = 0; i < width * height; i += 1)
			[board addObject: BLANK];
	}
	return self;
}

/** 
 Convert the NSArray representation of a board to an NSString.
 A convenience method for making server requests.
 
 @param board a Connect-4 board, represented as an NSArray
 @return the same board, represented as an NSString
 */
+ (NSString *) stringForBoard: (NSArray *) _board {
	NSString *boardString = @"";
	for (NSString *piece in _board) {
		if ([piece isEqualToString: @"+"])
			piece = @" ";
		boardString = [NSString stringWithFormat: @"%@%@", boardString, piece];
	}
	return boardString;
}

- (NSString *) gameName { 
	return @"Connect-4"; 
}

- (BOOL) supportsPlayMode:(PlayMode)mode {
	if (mode == ONLINE_SOLVED) return YES;
	if (mode == OFFLINE_UNSOLVED) return YES;
	return NO;
}

- (UIViewController *) optionMenu {
	return [[GCConnectFourOptionMenu alloc] initWithGame: self];
}

- (UIViewController *) gameViewController {
	return c4view;
}

- (void) startGameInMode: (PlayMode) mode {
	[self resetBoard];
	
	gameMode = mode;
	
	p1Turn = YES;
	
	//predictions = NO;
	//moveValues = NO;
	
	if (!c4view)
		[c4view release];
	c4view = [[GCConnectFourViewController alloc] initWithGame: self];
	
	PlayerType current = [self currentPlayer] == PLAYER1 ? player1Type : player2Type;
	if (current == HUMAN)
		c4view.touchesEnabled = YES;		
	
	if (mode == ONLINE_SOLVED) {
		service = [[GCJSONService alloc] init];
		serverHistoryStack = [[NSMutableArray alloc] init];
		serverUndoStack    = [[NSMutableArray alloc] init];
		[c4view updateServerDataWithService: service];
	}
}

- (PlayMode) playMode {
	return gameMode;
}

- (void) updateDisplay {
	[c4view updateLabels];
}

- (void) notifyWhenReady {
	if (gameMode == OFFLINE_UNSOLVED)
		[[NSNotificationCenter defaultCenter] postNotificationName: @"GameIsReady" object: self];
}

- (void) postReady {
	[[NSNotificationCenter defaultCenter] postNotificationName: @"GameIsReady" object: self];
}

- (void) postProblem {
	[[NSNotificationCenter defaultCenter] postNotificationName: @"GameEncounteredProblem" object: self];
}

- (NSArray *) getBoard {
	return board;
}

- (NSString *) getValue {
	NSDictionary *entry = (NSDictionary *) [serverHistoryStack lastObject];
	return [[entry objectForKey: @"value"] uppercaseString];
}

- (NSInteger) getRemoteness {
	NSDictionary *entry = (NSDictionary *) [serverHistoryStack lastObject];
	return [[entry objectForKey: @"remoteness"] integerValue];
}

- (NSString *) getValueOfMove: (NSString *) move {
	NSString *s = [[NSString alloc] initWithFormat: @"%d", [move intValue] - 1];
	NSDictionary *entry = (NSDictionary *) [serverHistoryStack lastObject];
	NSDictionary *children = (NSDictionary *) [entry objectForKey: @"children"];
	NSDictionary *moveEntry = (NSDictionary *) [children objectForKey: s];
	return [[moveEntry objectForKey: @"value"] uppercaseString];
}

- (NSInteger) getRemotenessOfMove: (NSString *) move {
	NSString *s = [[NSString alloc] initWithFormat: @"%d", [move intValue] - 1];
	NSDictionary *entry = (NSDictionary *) [serverHistoryStack lastObject];
	NSDictionary *children = (NSDictionary *) [entry objectForKey: @"children"];
	NSDictionary *moveEntry = (NSDictionary *) [children objectForKey: s];
	return [[moveEntry objectForKey: @"remoteness"] integerValue];
}

- (NSArray *) legalMoves {
	NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity: width];
	
	int col = 1;
	for (int i = width * (height - 1); i < width * height; i += 1) {
		if ([[board objectAtIndex: i] isEqual: BLANK])
			[moves addObject: [NSString stringWithFormat: @"%d", col]];
		col += 1;
	}
	
	return moves;
}

- (NSString *) primitive: (NSArray *) theBoard {	
	for (int i = 0; i < width * height; i += 1) {
		NSString *piece = [theBoard objectAtIndex: i];
		if ([piece isEqual: BLANK])
			continue;
		
		// Check the horizontal case
		BOOL case1 = YES;
		for (int j = i; j < i + pieces; j += 1) {
			if (j >= width * height || i % width > j % width || ![[theBoard objectAtIndex: j] isEqual: piece]) {
				case1 = NO;
				break;
			}
		}
		
		// Check the vertical case
		BOOL case2 = YES;
		for (int j = i; j < i + width * pieces; j += width) {
			if ( j >= width * height || ![[theBoard objectAtIndex: j] isEqual: piece] ) {
				case2 = NO;
				break;
			}
		}
		
		// Check the diagonal case (positive slope)
		BOOL case3 = YES;
		for (int j = i; j < i + pieces + width * pieces; j += (width + 1) ) {
			if ( j >= width * height || (i % width > j % width) || ![[theBoard objectAtIndex: j] isEqual: piece] ) {
				case3 = NO;
				break;
			}
		}
		
		// Check the diagonal case (negative slope)
		BOOL case4 = YES;
		for (int j = i; j < i + width * pieces - pieces; j += (width - 1) ) {
			if ( j >= width * height || (i % width < j % width) || ![[theBoard objectAtIndex: j] isEqual: piece] ) {
				case4 = NO;
				break;
			}
		}		
		if (case1 || case2 || case3 || case4)
			return [piece isEqual: (p1Turn ? @"X" : @"O")] ? (misere ? @"LOSE" : @"WIN") : (misere ? @"WIN" : @"LOSE");
	}
	
	// Finally, check if the board is full
	BOOL full = YES;
	for (int i = 0; i < width * height; i += 1) {
		if ([[theBoard objectAtIndex: i] isEqual: BLANK]) {
			full = NO;
			break;
		}
	}
	if (full) return @"TIE";
	
	return nil;
}

- (void) askUserForInput {
	//[c4view enableButtons];
	c4view.touchesEnabled = YES;
}

- (void) stopUserInput {
	//[c4view disableButtons];
	c4view.touchesEnabled = NO;
}

- (void) stop {
	[c4view stop];
}

- (void) resume {
	if (gameMode == ONLINE_SOLVED) {
		[c4view updateServerDataWithService: service];
	}
}

- (void) postHumanMove: (NSString *) move {
	humanMove = move;
	[[NSNotificationCenter defaultCenter] postNotificationName: @"HumanChoseMove" object: self];
}

- (NSString *) getHumanMove {
	return humanMove;
}

- (Player) currentPlayer {
	return p1Turn ? PLAYER1 : PLAYER2;
}

- (void) doMove: (NSString *) move {
	[c4view doMove: move];
	
	int slot = [move integerValue] - 1;
	while (slot < width * height) {
		if ([[board objectAtIndex: slot] isEqual: BLANK]) {
			[board replaceObjectAtIndex: slot withObject: (p1Turn ? @"X" : @"O")];
			break;
		}
		slot += width;
	}
	p1Turn = !p1Turn;
	
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
			[self postReady];
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
	
	if (gameMode != ONLINE_SOLVED)
		[c4view updateLabels];
}

- (void) undoMove: (NSString *) move {
	[c4view undoMove: move];
	
	int slot = [move integerValue] - 1 + width * (height - 1);
	while (slot > 0) {
		if (![[board objectAtIndex: slot] isEqual: BLANK]) {
			[board replaceObjectAtIndex: slot withObject: BLANK];
			break;
		}
		slot -= width;
	}
	p1Turn = !p1Turn;
	
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

- (void) resetBoard {
	if (board != nil) {
		[board release];
		board = nil;
	}
	
	board = [[NSMutableArray alloc] initWithCapacity: width * height];
	for (int i = 0; i < width * height; i += 1)
		[board addObject: BLANK];
}

- (void) dealloc {
	[board release];
	[service release];
	[super dealloc];
}

@end
