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
@synthesize innerTriangleLength;

- (id) init {
	if (self = [super init]) {
		player1Name = @"Player 1";
		player2Name = @"Player 2";
		
		player1Type = HUMAN;
		player2Type = HUMAN;
		
		layers = 1;
		innerTriangleLength = 2;
		
		p1Turn = YES;
		
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
	gameMode = mode;
}


- (NSArray *) getBoard {
	return board;
}


- (void) resetBoard {
	if (board)
		[board release];
	
	
	switch (layers){
		case 0:
			board = [[NSMutableArray alloc] initWithCapacity: 15];
			for (int i = 0; i < 15; i += 1)
				[board addObject: BLANK];
			break;
		case 1:
			board = [[NSMutableArray alloc] initWithCapacity: 30];
			for (int i = 0; i < 30; i += 1)
				[board addObject: BLANK];
			break;
		case 2:
			board = [[NSMutableArray alloc] initWithCapacity: 48];
			for (int i = 0; i < 48; i += 1)
				[board addObject: BLANK];
			break;
		default: 
			board = nil;
			break;
	}

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


- (void) doMove: (NSNumber *) move {
	
	[yGameView doMove: move];
	
	int slot = [move integerValue] - 1;
	[board replaceObjectAtIndex: slot withObject: (p1Turn ? X : O)];
	p1Turn = !p1Turn;
	
	[yGameView updateLabels];
	//printing this out would be disgusting.	
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
		return @"WIN";
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
				return @"WIN";
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
				return @"LOSE";
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
