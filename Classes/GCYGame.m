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
@synthesize yGameView;
@synthesize misere;
@synthesize innerTriangleLength;
@synthesize service;
@synthesize gameMode;

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
		
		board = [[NSMutableArray alloc] initWithCapacity: 15];
		for (int i = 0; i < 15; i += 1)
			[board addObject: BLANK];
		
	}
	
	return self;
}

- (NSString *) gameName {
	return @"Y";
}

- (BOOL) supportsPlayMode:(PlayMode)mode {
	return mode == OFFLINE_UNSOLVED;
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
	
	[self resetBoard];
	
	if(mode == ONLINE_SOLVED){
		service = [[GCJSONService alloc] init];
		[self startFetch];
	}
	
	gameMode = mode;
}


- (NSArray *) getBoard {
	return board;
}


- (void) resetBoard {
	if (board)
		[board release];
	
	board = [[NSMutableArray alloc] initWithCapacity: [yGameView boardSize]];
	for (int i = 0; i < [yGameView boardSize]; i++)
		[board addObject: BLANK];

}
	

- (Player) currentPlayer {
	return p1Turn ? PLAYER1 : PLAYER2;
}


- (void) askUserForInput {
	[yGameView enableButtons];
}

- (void) stopUserInput {
	[yGameView disableButtons];
}

- (void) postHumanMove: (NSNumber *) num{
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
	
	return moves;
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
	
	if (gameMode != ONLINE_SOLVED)
		[yGameView updateLabels];
	
	if(gameMode == ONLINE_SOLVED){
		[self startFetch];
	}	
}










/** Returns @"WIN" or @"LOSE" if in a primitive state since Y has no draws/ties.  Returns nil if not in a primitive state **/
- (NSString *) primitive: (NSArray *) theBoard  { 
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
	
	//Super Happy Fun Time!!!
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
				NSLog(@"Game Over");
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
				NSLog(@"Game Over");
				return misere ? @"WIN" : @"LOSE";
			}
			
		}
	}
	
	[queue release];
	return nil;
}



- (void) startFetch{
	waiter = [[NSThread alloc] initWithTarget: self selector: @selector (fetchNewData) object: nil];
	[waiter start];
}

- (void) fetchNewData{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSString *boardString = [self stringForBoard: board];
	//NSString *boardURL = [boardString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	//NSString *boardVal = [[NSString stringWithFormat: @"http://nyc.cs.berkeley.edu:8080/gcweb/service/gamesman/puzzles/y/getMoveValue;side=%d;board=%@", (size - 5)/2 +2, boardURL] retain];
	//NSString *moveVals = [[NSString stringWithFormat: @"http://nyc.cs.berkeley.edu:8080/gcweb/service/gamesman/puzzles/y/getNextMoveValues;side=%d;board=%@", (size - 5)/2 +2, boardURL] retain];
	//[service retrieveDataForBoard: boardString URL: boardVal andNextMovesURL: moveVals];
	//[self performSelectorOnMainThread: @selector (fetchFinished) withObject: nil waitUntilDone: NO];
	[pool release];
	
}

- (void) fetchFinished{
	if(waiter)	[waiter release];
	if(![service status] || ![service connected]){
		[[NSNotificationCenter defaultCenter] postNotificationName: @"GameEncounteredProblem" object: self ];
	}
	else{
		[yGameView updateLabels];
		[[NSNotificationCenter defaultCenter] postNotificationName: @"GameIsReady" object: self ];
	}
}



- (void) notifyWhenReady {
	if (gameMode == OFFLINE_UNSOLVED)
		[[NSNotificationCenter defaultCenter] postNotificationName: @"GameIsReady" object: self];
}


/** A really simple utility function that deals with the whole 'convert an NSNumber to an int and check for a player's piece in that
 ** position' thing **/
- (BOOL) boardContainsPlayerPiece: (NSString *) piece forPosition: (NSNumber *) position{

	if ([[board objectAtIndex: [position intValue] - 1] isEqual: piece]){
		return YES;
	}
	else return NO;
}



- (void) dealloc {
	[player1Name release];
	[player2Name release];
	[board release];
	[humanMove release];

	//[service release];
	[super dealloc];
}

@end
