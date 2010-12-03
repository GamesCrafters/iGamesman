//
//  GCYGame.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 2/5/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCYGame.h"
#import "GCYGameViewController.h"
#import "GCYOptionMenu.h"
#import "YGameQueue.h"

#define BLANK @"+"
#define X @"X"
#define O @"O"


@implementation GCYGame

@synthesize player1Name, player2Name;
@synthesize player1Type, player2Type;
@synthesize layers;
@synthesize p1Turn;
@synthesize board;
@synthesize yGameView;
@synthesize misere;
@synthesize innerTriangleLength;
@synthesize gameMode;
@synthesize serverHistoryStack;
@synthesize predictions, moveValues;


- (id) init {
	if (self = [super init]) {
		player1Name = @"Player 1";
		player2Name = @"Player 2";
		
		player1Type = HUMAN;
		player2Type = HUMAN;
		
		layers = 1;
		innerTriangleLength = 2;
		
		p1Turn = YES;
		misere = NO;
		
		predictions = NO;
		moveValues = NO;
		
		board = [[NSMutableArray alloc] initWithCapacity: 15];
		for (int i = 0; i < 15; i += 1)
			[board addObject: BLANK];		
	}
	
	return self;
}

- (NSString *) gameName {
	return @"Y";
}


//##############################################
- (BOOL) supportsPlayMode:(PlayMode)mode {
	return mode == OFFLINE_UNSOLVED || mode == ONLINE_SOLVED;
}

- (PlayMode) playMode { 
	return gameMode; 
}

- (UIViewController *) optionMenu {
	return [[GCYOptionMenu alloc] initWithGame: self];
}

- (UIViewController *) gameViewController {
	return yGameView;
}

- (void) startGameInMode: (PlayMode) mode {
	if (!yGameView)  
		[yGameView release];
	
	yGameView = [[GCYGameViewController alloc] initWithGame: self];
	p1Turn = YES;
	gameMode = mode;
	
	[self resetBoard];
	
	
	if (mode == ONLINE_SOLVED) {
		service = [[GCJSONService alloc] init];
		serverHistoryStack = [[NSMutableArray alloc] init];
		serverUndoStack    = [[NSMutableArray alloc] init];
		[yGameView updateServerDataWithService: service];
	}
}


- (NSArray *) getBoard {
	return board;
}


- (void) resetBoard {
	int boardSize;
	
	if (board != nil) {
		[board release];
		board = nil;
	}
	
	boardSize = ((innerTriangleLength + 1) * (innerTriangleLength + 2)) / 2;	

	//calculate the sizes of each layer
	for (int i = 1; i <= layers; i++){
		boardSize += (innerTriangleLength + i) * 3;
	}

	board = [[NSMutableArray alloc] initWithCapacity: boardSize];
	for (int i = 0; i < boardSize; i++)
		[board addObject: BLANK];

}
	
/** A modified setter for Predictions
 ** Must update the view to reflect the new settings **/
- (void) setPredictions: (BOOL) pred {
	predictions = pred;
	[yGameView updateDisplay];
}


/** A modified setter for Move Values
 ** Must update the view to reflect the new settings **/
- (void) setMoveValues: (BOOL) move {
	moveValues = move;
	[yGameView updateDisplay];
}


- (Player) currentPlayer {
	return p1Turn ? PLAYER1 : PLAYER2;
}


- (void) askUserForInput {
	//[yGameView enableButtons];
	yGameView.touchesEnabled = YES;
}

- (void) stopUserInput {
	//[yGameView disableButtons];
	yGameView.touchesEnabled = NO;
}

- (void) postHumanMove: (NSNumber *) num {
	humanMove = num;
	[[NSNotificationCenter defaultCenter] postNotificationName: @"HumanChoseMove" object: self];
}

- (NSNumber *) getHumanMove {
	return humanMove;
}


- (NSArray *) legalMoves {
	NSMutableArray *moves = [[NSMutableArray alloc] init];
	for (int i = 0; i < [board count]; i += 1) {
		if ([[board objectAtIndex: i] isEqual: BLANK])
			[moves addObject: [NSNumber numberWithInt: i + 1]];
	}

	return [moves autorelease];
}


// Return the value of the current board
- (NSString *) getValue { 
	return [service getValue]; 
}

// Return the remoteness of the current board (or -1 if not available)
- (NSInteger) getRemoteness { 
	return [service getRemoteness]; 
}

// Return the value of MOVE
- (NSString *) getValueOfMove: (NSNumber *) move {
	NSString *moveString = [NSString stringWithFormat: @"%d", [[[yGameView translateToServer: [NSArray arrayWithObject: move]] objectAtIndex: 0] intValue]];
	return [[service getValueAfterMove: moveString] uppercaseString];
}

// Return the remoteness of MOVE (or -1 if not available)
- (NSInteger) getRemotenessOfMove: (NSNumber *) move {
	NSString *moveString = [NSString stringWithFormat: @"%d", [[[yGameView translateToServer: [NSArray arrayWithObject: move]] objectAtIndex: 0] intValue]];
	return [service getRemotenessAfterMove: moveString];
}

- (void) doMove: (NSNumber *) move {
	
	[yGameView doMove: move];
	
	int slot = [move integerValue] - 1;
	[board replaceObjectAtIndex: slot withObject: (p1Turn ? X : O)];
	p1Turn = !p1Turn;
	
	if(gameMode == ONLINE_SOLVED){
		[yGameView updateServerDataWithService: service];
//		// Peek at the top of the undo stack
//		NSDictionary *undoEntry = [serverUndoStack lastObject];
//		if ([[undoEntry objectForKey: @"board"] isEqual: board]) {
//			// Pop it off the undo stack
//			[undoEntry retain];
//			[serverUndoStack removeLastObject];
//			
//			// Push it onto the history stack
//			[serverHistoryStack addObject: undoEntry];
//			[undoEntry release];
//			[yGameView updateLabels];
//			[self postReady];
//		} else {
//			// Wipe the undo stack
//			[serverUndoStack release];
//			serverUndoStack = [[NSMutableArray alloc] init];
//			
//			// Wipe the service object
//			[service release];
//			service = [[GCJSONService alloc] init];
//			
//			[yGameView updateServerDataWithService: service];
//		}
	} else {
		[yGameView updateDisplay];
	}
}

- (void) undoMove: (NSNumber *) move {
	[yGameView undoMove: move];
	
	[board replaceObjectAtIndex: ([move integerValue] - 1) withObject: BLANK];
	p1Turn = !p1Turn;
	
	if (gameMode == OFFLINE_UNSOLVED)
		[yGameView updateDisplay];
	else
		[yGameView updateServerDataWithService: service];
}

/** Returns @"WIN" or @"LOSE" if in a primitive state since Y has no draws/ties.  
 ** Returns nil if not in a primitive state **/
- (NSString *) primitive { 
	NSMutableSet *edgesReached = [NSMutableSet set];
	NSString *currentPlayerPiece;
	NSNumber *currentPosition;
	YGameQueue *queue = [[YGameQueue alloc] init];
	
	//NSMutableDictionary *positionConnections = yGameView.boardView.neighborsForPosition;
	NSArray *leftEdges = [yGameView leftEdges];
	
	
	//Might need to do away with this... 
	if ([[self legalMoves] count] == 0){
		[queue release];
		return misere ? @"LOSE" : @"WIN";
	}
	
	//Check current player's pieces
	if (!p1Turn)
		currentPlayerPiece = O;
	else 
		currentPlayerPiece = X;
	
	//for each position in left edges
	for (NSNumber * position in leftEdges){
		[queue emptyFringe]; //don't empty the blacklist, just the queue
			
		//If the current player's piece is in that position, add it to the queue
		if ([self boardContainsPlayerPiece: currentPlayerPiece forPosition: position]){
			[queue push: position];
			[edgesReached setSet: [yGameView positionEdges: position]];
		}
		while ([queue notEmpty]){
			currentPosition = [queue pop];
			
			
			//Add each neighboring position that contains the current player's piece to the queue
			for (NSNumber * neighborPosition in [yGameView positionConnections: currentPosition]){

				if ([self boardContainsPlayerPiece: currentPlayerPiece forPosition: neighborPosition]){
					[queue push: neighborPosition];
					NSSet * neighborEdges = [yGameView positionEdges: neighborPosition];
					
					//If neighborPosition touches any edges, add them to edgesReached
					if (neighborEdges)
						[edgesReached unionSet: neighborEdges];
				}
			}
			//Check if all of the edges are reached
			if ([edgesReached count] == 3){
				[queue release];
				return misere ? @"LOSE" : @"WIN";
			}
			
		}
	}
	
	
	//Check opponent's pieces
	if (p1Turn)
		currentPlayerPiece = O;
	else 
		currentPlayerPiece = X;
	
	//for each position in left edges
	for (NSNumber * position in leftEdges){
		[queue emptyFringe]; //don't empty the blacklist, just the queue
		
		//If the current player's piece is in that position, add it to the queue
		if ([self boardContainsPlayerPiece: currentPlayerPiece forPosition: position]){
			[queue push: position];
			[edgesReached setSet: [yGameView positionEdges: position]];
		}
		while ([queue notEmpty]){
			currentPosition = [queue pop];
			
			
			//Add each neighboring position that contains the current player's piece to the queue
			for (NSNumber * neighborPosition in [yGameView positionConnections: currentPosition]){
				if ([self boardContainsPlayerPiece: currentPlayerPiece forPosition: neighborPosition]){
					[queue push: neighborPosition];
					NSSet * neighborEdges = [yGameView positionEdges: neighborPosition];
					//If neighborPosition touches any edges, add them to edgesReached
					if (neighborEdges)
						[edgesReached unionSet: neighborEdges];
				}
			}
			//Check if all of the edges are reached
			if ([edgesReached count] == 3){
				[queue release];
				return misere ? @"WIN" : @"LOSE";
			}
			
		}
	}
	
	[queue release];
	return nil;
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


/** 
 A really simple utility function that deals with the whole 'convert an NSNumber to an int and check for a player's piece in that
 position thing 
 */
- (BOOL) boardContainsPlayerPiece: (NSString *) piece forPosition: (NSNumber *) position{

	if ([[board objectAtIndex: [position intValue] - 1] isEqual: piece]){
		return YES;
	}
	else return NO;
}

/** 
 Convert the NSArray representation of a board to an NSString.
 A convenience method for making server requests.
 
 @param board a Y board, represented as an NSArray
 @return the same board, represented as an NSString
 */
+ (NSString *) stringForBoard: (NSArray *) _board {
	NSString *boardString = @"";
	for (NSString *piece in _board) {
		if ([piece isEqualToString: @"+"])
			piece = @" ";
		boardString = [boardString stringByAppendingString: piece];
		
	}
	return boardString;
}


- (void) dealloc {
	[player1Name release];
	[player2Name release];
	[board release];
	[humanMove release];

	[service release];
	[super dealloc];
}

@end
