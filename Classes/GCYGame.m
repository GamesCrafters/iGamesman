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
@synthesize positionConnections;
@synthesize edgesForPosition;
@synthesize leftEdges;
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
		
		[self setGrossDictionaryValues];
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
			[self setGrossDictionaryValues];
			for (int i = 0; i < 15; i += 1)
				[board addObject: BLANK];
			break;
		case 1:
			board = [[NSMutableArray alloc] initWithCapacity: 30];
			[self setGrossDictionaryValues];
			for (int i = 0; i < 30; i += 1)
				[board addObject: BLANK];
			break;
		case 2:
			board = [[NSMutableArray alloc] initWithCapacity: 48];
			[self setGrossDictionaryValues];
			for (int i = 0; i < 48; i += 1)
				[board addObject: BLANK];
			break;
		default: 
			board = nil;
			break;
	}
	

	//NSLog(@"board count: %d", [board count]);
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
	//NSLog(@"do move alpha: %d", slot);
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
	NSLog(currentPlayerPiece);
	for (NSNumber * position in leftEdges){
		[queue emptyFringe]; //don't empty the blacklist, just the queue
			
		//If the current player's piece is in that position, add it to the queue
		if ([self boardContainsPlayerPiece: currentPlayerPiece forPosition: position]){
			[queue push: position];
			[edgesReached setSet: [edgesForPosition objectForKey: position]];
		}
		while ([queue notEmpty]){
			currentPosition = [queue pop];
			
			
			//Add each neighboring position that contains the current player's piece to the queue
			for (NSNumber * neighborPosition in [positionConnections objectForKey: currentPosition]){
				//NSLog(@"%@, %@", [currentPosition description], [neighborPosition description]);
				if ([self boardContainsPlayerPiece: currentPlayerPiece forPosition: neighborPosition]){
					[queue push: neighborPosition];
					NSSet * neighborEdges = [edgesForPosition objectForKey: neighborPosition];
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
	NSLog(currentPlayerPiece);
	for (NSNumber * position in leftEdges){
		[queue emptyFringe]; //don't empty the blacklist, just the queue
		
		//If the current player's piece is in that position, add it to the queue
		if ([self boardContainsPlayerPiece: currentPlayerPiece forPosition: position]){
			[queue push: position];
			[edgesReached setSet: [edgesForPosition objectForKey: position]];
		}
		while ([queue notEmpty]){
			currentPosition = [queue pop];
			
			
			//Add each neighboring position that contains the current player's piece to the queue
			for (NSNumber * neighborPosition in [positionConnections objectForKey: currentPosition]){
				//NSLog(@"%@, %@", [currentPosition description], [neighborPosition description]);
				if ([self boardContainsPlayerPiece: currentPlayerPiece forPosition: neighborPosition]){
					[queue push: neighborPosition];
					NSSet * neighborEdges = [edgesForPosition objectForKey: neighborPosition];
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


/** The really gross function that sets values for position connections, leftEdges (technically an array, not a dictionary), and edgesForPosition **/
- (void) setGrossDictionaryValues{
	if (positionConnections)
		[positionConnections release];
	
	if (leftEdges)
		[leftEdges release];
	
	if (edgesForPosition)
		[edgesForPosition release];
	
	switch (layers){
		case 0:
			positionConnections = [[NSDictionary alloc] initWithObjectsAndKeys: 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 3], nil], [NSNumber numberWithInt: 1], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 4], 
															   [NSNumber numberWithInt: 5], nil], [NSNumber numberWithInt: 2], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 5], 
															   [NSNumber numberWithInt: 6], nil], [NSNumber numberWithInt: 3], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 7], 
															   [NSNumber numberWithInt: 8], nil], [NSNumber numberWithInt: 4], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 4], 
															   [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 9], nil], [NSNumber numberWithInt: 5], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 9], 
															   [NSNumber numberWithInt: 10], nil], [NSNumber numberWithInt: 6], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 4], [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 11], 
															   [NSNumber numberWithInt: 12], nil], [NSNumber numberWithInt: 7], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 4], [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 7], 
															   [NSNumber numberWithInt: 9], [NSNumber numberWithInt: 12], [NSNumber numberWithInt: 13], nil],  [NSNumber numberWithInt: 8], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 8], 
															   [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 13], [NSNumber numberWithInt: 14], nil], [NSNumber numberWithInt: 9], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 9], [NSNumber numberWithInt: 14], 
																[NSNumber numberWithInt: 15], nil], [NSNumber numberWithInt: 10], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 7], [NSNumber numberWithInt: 12], nil], [NSNumber numberWithInt: 11], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 7], [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 11], 
																[NSNumber numberWithInt: 13], nil], [NSNumber numberWithInt: 12], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 9], [NSNumber numberWithInt: 12], 
																[NSNumber numberWithInt: 14], nil], [NSNumber numberWithInt: 13], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 9], [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 13], 
																[NSNumber numberWithInt: 15], nil], [NSNumber numberWithInt: 14], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 14], nil], [NSNumber numberWithInt: 15], nil];
			
			edgesForPosition = [[NSDictionary alloc] initWithObjectsAndKeys: 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 3], nil], [NSNumber numberWithInt: 1], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 1], nil], [NSNumber numberWithInt: 2], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 3], nil], [NSNumber numberWithInt: 3], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 1], nil], [NSNumber numberWithInt: 4], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 3], nil], [NSNumber numberWithInt: 6], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 1], nil], [NSNumber numberWithInt: 7], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 3], nil], [NSNumber numberWithInt: 10], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 2], nil], [NSNumber numberWithInt: 11], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 2], nil], [NSNumber numberWithInt: 12], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 2], nil], [NSNumber numberWithInt: 13], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 2], nil], [NSNumber numberWithInt: 14], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 3], nil], [NSNumber numberWithInt: 15],  nil];
			
			leftEdges = [[NSArray alloc] initWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 4], 
							   [NSNumber numberWithInt: 7], [NSNumber numberWithInt: 11], nil];
			break;
		case 1:
			positionConnections = [[NSDictionary alloc] initWithObjectsAndKeys: 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 20], 
															   [NSNumber numberWithInt: 21], [NSNumber numberWithInt: 22], nil], [NSNumber numberWithInt: 1], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 4], 
															   [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 22], [NSNumber numberWithInt: 23], nil], [NSNumber numberWithInt: 2], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 5], 
															   [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 19], [NSNumber numberWithInt: 20], nil], [NSNumber numberWithInt: 3], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 7], 
															   [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 23], [NSNumber numberWithInt: 24], nil], [NSNumber numberWithInt: 4], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 4], 
															   [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 9], nil], [NSNumber numberWithInt: 5], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 9], 
															   [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 18], [NSNumber numberWithInt: 19], nil], [NSNumber numberWithInt: 6], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 4], [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 11], 
															   [NSNumber numberWithInt: 12], [NSNumber numberWithInt: 24], [NSNumber numberWithInt: 25], nil], [NSNumber numberWithInt: 7], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 4], [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 7], 
															   [NSNumber numberWithInt: 9], [NSNumber numberWithInt: 12], [NSNumber numberWithInt: 13], nil], [NSNumber numberWithInt: 8], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 8], 
															   [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 13], [NSNumber numberWithInt: 14], nil], [NSNumber numberWithInt: 9], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 9], [NSNumber numberWithInt: 14], 
																[NSNumber numberWithInt: 15], [NSNumber numberWithInt: 17], [NSNumber numberWithInt: 18], nil], [NSNumber numberWithInt: 10], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 7], [NSNumber numberWithInt: 12], [NSNumber numberWithInt: 25], 
																[NSNumber numberWithInt: 26], [NSNumber numberWithInt: 27], nil], [NSNumber numberWithInt: 11], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 7], [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 11], 
																[NSNumber numberWithInt: 13], [NSNumber numberWithInt: 27], [NSNumber numberWithInt: 28], nil], [NSNumber numberWithInt: 12], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 9], [NSNumber numberWithInt: 12], 
																[NSNumber numberWithInt: 14], [NSNumber numberWithInt: 28], [NSNumber numberWithInt: 29], nil], [NSNumber numberWithInt: 13], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 9], [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 13], 
																[NSNumber numberWithInt: 15], [NSNumber numberWithInt: 29], [NSNumber numberWithInt: 30], nil], [NSNumber numberWithInt: 14], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 14], [NSNumber numberWithInt: 16], 
																[NSNumber numberWithInt: 17], [NSNumber numberWithInt: 30], nil], [NSNumber numberWithInt: 15], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 15], [NSNumber numberWithInt: 17], [NSNumber numberWithInt: 30], nil], [NSNumber numberWithInt: 16], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 15], [NSNumber numberWithInt: 16], 
																[NSNumber numberWithInt: 18], nil], [NSNumber numberWithInt: 17], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 17], 
																[NSNumber numberWithInt: 19], nil], [NSNumber numberWithInt: 18], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 18], 
																[NSNumber numberWithInt: 20], nil], [NSNumber numberWithInt: 19], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 19], 
																[NSNumber numberWithInt: 21], nil], [NSNumber numberWithInt: 20], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 20], [NSNumber numberWithInt: 22], nil], [NSNumber numberWithInt: 21], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 21], 
																[NSNumber numberWithInt: 23], nil], [NSNumber numberWithInt: 22], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 4], [NSNumber numberWithInt: 22], 
																[NSNumber numberWithInt: 24], nil], [NSNumber numberWithInt: 23], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 4], [NSNumber numberWithInt: 7], [NSNumber numberWithInt: 23], 
																[NSNumber numberWithInt: 25], nil], [NSNumber numberWithInt: 24], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 7], [NSNumber numberWithInt: 11], [NSNumber numberWithInt: 24], 
																[NSNumber numberWithInt: 26], nil], [NSNumber numberWithInt: 25], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 11], [NSNumber numberWithInt: 25], [NSNumber numberWithInt: 27], nil], [NSNumber numberWithInt: 26], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 11], [NSNumber numberWithInt: 12], [NSNumber numberWithInt: 26], 
																[NSNumber numberWithInt: 28], nil], [NSNumber numberWithInt: 27], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 12], [NSNumber numberWithInt: 13], [NSNumber numberWithInt: 27], 
																[NSNumber numberWithInt: 29], nil], [NSNumber numberWithInt: 28], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 13], [NSNumber numberWithInt: 14], [NSNumber numberWithInt: 28], 
																[NSNumber numberWithInt: 30], nil], [NSNumber numberWithInt: 29], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 14], [NSNumber numberWithInt: 15], [NSNumber numberWithInt: 16], 
																[NSNumber numberWithInt: 29], nil], [NSNumber numberWithInt: 30], nil];
			

			edgesForPosition = [[NSDictionary alloc] initWithObjectsAndKeys: 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 3], nil], [NSNumber numberWithInt: 21], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 1], nil], [NSNumber numberWithInt: 22], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 1], nil], [NSNumber numberWithInt: 23], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 1], nil], [NSNumber numberWithInt: 24], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 1], nil], [NSNumber numberWithInt: 25], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 2], nil], [NSNumber numberWithInt: 26], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 2], nil], [NSNumber numberWithInt: 27], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 2], nil], [NSNumber numberWithInt: 28], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 2], nil], [NSNumber numberWithInt: 29], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 2], nil], [NSNumber numberWithInt: 30], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 3], nil], [NSNumber numberWithInt: 16], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 3], nil], [NSNumber numberWithInt: 17], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 3], nil], [NSNumber numberWithInt: 18], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 3], nil], [NSNumber numberWithInt: 19], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 3], nil], [NSNumber numberWithInt: 20], nil];
			
			leftEdges = [[NSArray alloc] initWithObjects: [NSNumber numberWithInt: 21], [NSNumber numberWithInt: 22], [NSNumber numberWithInt: 23], 
							   [NSNumber numberWithInt: 24], [NSNumber numberWithInt: 25], [NSNumber numberWithInt: 26], nil];
			
			
			break;
		case 2:
			positionConnections = [[NSDictionary alloc] initWithObjectsAndKeys: 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 20], 
															   [NSNumber numberWithInt: 21], [NSNumber numberWithInt: 22], nil], [NSNumber numberWithInt: 1], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 4], 
															   [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 22], [NSNumber numberWithInt: 23], nil], [NSNumber numberWithInt: 2], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 5], 
															   [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 19], [NSNumber numberWithInt: 20], nil], [NSNumber numberWithInt: 3], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 7], 
															   [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 23], [NSNumber numberWithInt: 24], nil], [NSNumber numberWithInt: 4], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 4], 
															   [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 9], nil], [NSNumber numberWithInt: 5], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 9], 
															   [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 18], [NSNumber numberWithInt: 19], nil], [NSNumber numberWithInt: 6], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 4], [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 11], 
															   [NSNumber numberWithInt: 12], [NSNumber numberWithInt: 24], [NSNumber numberWithInt: 25], nil], [NSNumber numberWithInt: 7],
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 4], [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 7], 
															   [NSNumber numberWithInt: 9], [NSNumber numberWithInt: 12], [NSNumber numberWithInt: 13], nil], [NSNumber numberWithInt: 8], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 5], [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 8], 
															   [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 13], [NSNumber numberWithInt: 14], nil], [NSNumber numberWithInt: 9], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 9], [NSNumber numberWithInt: 14], 
																[NSNumber numberWithInt: 15], [NSNumber numberWithInt: 17], [NSNumber numberWithInt: 18], nil], [NSNumber numberWithInt: 10], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 7], [NSNumber numberWithInt: 12], [NSNumber numberWithInt: 25], 
																[NSNumber numberWithInt: 26], [NSNumber numberWithInt: 27], nil], [NSNumber numberWithInt: 11], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 7], [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 11], 
																[NSNumber numberWithInt: 13], [NSNumber numberWithInt: 27], [NSNumber numberWithInt: 28], nil], [NSNumber numberWithInt: 12], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 8], [NSNumber numberWithInt: 9], [NSNumber numberWithInt: 12], 
																[NSNumber numberWithInt: 14], [NSNumber numberWithInt: 28], [NSNumber numberWithInt: 29], nil], [NSNumber numberWithInt: 13], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 9], [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 13], 
																[NSNumber numberWithInt: 15], [NSNumber numberWithInt: 29], [NSNumber numberWithInt: 30], nil], [NSNumber numberWithInt: 14], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 14], [NSNumber numberWithInt: 16], 
																[NSNumber numberWithInt: 17], [NSNumber numberWithInt: 30], nil], [NSNumber numberWithInt: 15], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 15], [NSNumber numberWithInt: 17], [NSNumber numberWithInt: 30],
																[NSNumber numberWithInt: 31], [NSNumber numberWithInt: 32], [NSNumber numberWithInt: 48], nil], [NSNumber numberWithInt: 16], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 15], [NSNumber numberWithInt: 16], 
																[NSNumber numberWithInt: 18], [NSNumber numberWithInt: 32], [NSNumber numberWithInt: 33], nil], [NSNumber numberWithInt: 17], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 17], 
																[NSNumber numberWithInt: 19], [NSNumber numberWithInt: 33], [NSNumber numberWithInt: 34], nil], [NSNumber numberWithInt: 18], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 6], [NSNumber numberWithInt: 18], 
																[NSNumber numberWithInt: 20], [NSNumber numberWithInt: 34], [NSNumber numberWithInt: 35], nil], [NSNumber numberWithInt: 19], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 19], 
																[NSNumber numberWithInt: 21], [NSNumber numberWithInt: 35], [NSNumber numberWithInt: 36], nil], [NSNumber numberWithInt: 20], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 20], [NSNumber numberWithInt: 22], 
																[NSNumber numberWithInt: 36], [NSNumber numberWithInt: 37], [NSNumber numberWithInt: 38], nil], [NSNumber numberWithInt: 21], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 21], 
																[NSNumber numberWithInt: 23], [NSNumber numberWithInt: 38], [NSNumber numberWithInt: 39], nil], [NSNumber numberWithInt: 22], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 4], [NSNumber numberWithInt: 22], 
																[NSNumber numberWithInt: 24], [NSNumber numberWithInt: 39], [NSNumber numberWithInt: 40], nil], [NSNumber numberWithInt: 23], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 4], [NSNumber numberWithInt: 7], [NSNumber numberWithInt: 23], 
																[NSNumber numberWithInt: 25], [NSNumber numberWithInt: 40], [NSNumber numberWithInt: 41], nil], [NSNumber numberWithInt: 24], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 7], [NSNumber numberWithInt: 11], [NSNumber numberWithInt: 24], 
																[NSNumber numberWithInt: 26], [NSNumber numberWithInt: 41], [NSNumber numberWithInt: 42], nil], [NSNumber numberWithInt: 25], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 11], [NSNumber numberWithInt: 25], [NSNumber numberWithInt: 27], 
																[NSNumber numberWithInt: 42], [NSNumber numberWithInt: 43], [NSNumber numberWithInt: 44], nil], [NSNumber numberWithInt: 26], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 11], [NSNumber numberWithInt: 12], [NSNumber numberWithInt: 26], 
																[NSNumber numberWithInt: 28], [NSNumber numberWithInt: 44], [NSNumber numberWithInt: 45], nil], [NSNumber numberWithInt: 27], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 12], [NSNumber numberWithInt: 13], [NSNumber numberWithInt: 27], 
																[NSNumber numberWithInt: 29], [NSNumber numberWithInt: 45], [NSNumber numberWithInt: 46], nil], [NSNumber numberWithInt: 28], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 13], [NSNumber numberWithInt: 14], [NSNumber numberWithInt: 28], 
																[NSNumber numberWithInt: 30], [NSNumber numberWithInt: 46], [NSNumber numberWithInt: 47], nil], [NSNumber numberWithInt: 29], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 14], [NSNumber numberWithInt: 15], [NSNumber numberWithInt: 16], 
																[NSNumber numberWithInt: 29], [NSNumber numberWithInt: 47], [NSNumber numberWithInt: 48], nil], [NSNumber numberWithInt: 30], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 16], [NSNumber numberWithInt: 32], [NSNumber numberWithInt: 48], nil], [NSNumber numberWithInt: 31], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 16], [NSNumber numberWithInt: 17], [NSNumber numberWithInt: 31], 
																[NSNumber numberWithInt: 33], nil], [NSNumber numberWithInt: 32], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 17], [NSNumber numberWithInt: 18], [NSNumber numberWithInt: 32], 
																[NSNumber numberWithInt: 34], nil], [NSNumber numberWithInt: 33], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 18], [NSNumber numberWithInt: 19], [NSNumber numberWithInt: 33], 
																[NSNumber numberWithInt: 35], nil], [NSNumber numberWithInt: 34], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 19], [NSNumber numberWithInt: 20], [NSNumber numberWithInt: 34], 
																[NSNumber numberWithInt: 36], nil], [NSNumber numberWithInt: 35], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 20], [NSNumber numberWithInt: 21], [NSNumber numberWithInt: 35], 
																[NSNumber numberWithInt: 37], nil], [NSNumber numberWithInt: 36], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 21], [NSNumber numberWithInt: 36], [NSNumber numberWithInt: 38], nil], [NSNumber numberWithInt: 37], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 21], [NSNumber numberWithInt: 22], [NSNumber numberWithInt: 37], 
																[NSNumber numberWithInt: 39], nil], [NSNumber numberWithInt: 38], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 22], [NSNumber numberWithInt: 23], [NSNumber numberWithInt: 38], 
																[NSNumber numberWithInt: 40], nil], [NSNumber numberWithInt: 39], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 23], [NSNumber numberWithInt: 24], [NSNumber numberWithInt: 39], 
																[NSNumber numberWithInt: 41], nil], [NSNumber numberWithInt: 40], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 24], [NSNumber numberWithInt: 25], [NSNumber numberWithInt: 40], 
																[NSNumber numberWithInt: 42], nil], [NSNumber numberWithInt: 41], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 25], [NSNumber numberWithInt: 26], [NSNumber numberWithInt: 41], 
																[NSNumber numberWithInt: 43], nil], [NSNumber numberWithInt: 42], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 26], [NSNumber numberWithInt: 42], [NSNumber numberWithInt: 44], nil], [NSNumber numberWithInt: 43], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 26], [NSNumber numberWithInt: 27], [NSNumber numberWithInt: 43], 
																[NSNumber numberWithInt: 45], nil], [NSNumber numberWithInt: 44], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 27], [NSNumber numberWithInt: 28], [NSNumber numberWithInt: 44], 
																[NSNumber numberWithInt: 46], nil], [NSNumber numberWithInt: 45], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 28], [NSNumber numberWithInt: 29], [NSNumber numberWithInt: 45], 
																[NSNumber numberWithInt: 47], nil], [NSNumber numberWithInt: 46], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 29], [NSNumber numberWithInt: 30], [NSNumber numberWithInt: 46], 
																[NSNumber numberWithInt: 48], nil], [NSNumber numberWithInt: 47], 
								 
								 [NSSet setWithObjects: [NSNumber numberWithInt: 16], [NSNumber numberWithInt: 30], [NSNumber numberWithInt: 31], 
																[NSNumber numberWithInt: 47], nil], [NSNumber numberWithInt: 48], nil];
			
			edgesForPosition = [[NSDictionary alloc] initWithObjectsAndKeys: 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 3], nil], [NSNumber numberWithInt: 37], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 1], nil], [NSNumber numberWithInt: 38], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 1], nil], [NSNumber numberWithInt: 39], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 1], nil], [NSNumber numberWithInt: 40], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 1], nil], [NSNumber numberWithInt: 41], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 1], nil], [NSNumber numberWithInt: 42], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 2], nil], [NSNumber numberWithInt: 43], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 2], nil], [NSNumber numberWithInt: 44], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 2], nil], [NSNumber numberWithInt: 45], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 2], nil], [NSNumber numberWithInt: 46], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 2], nil], [NSNumber numberWithInt: 47], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 2], nil], [NSNumber numberWithInt: 48], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 3], nil], [NSNumber numberWithInt: 31], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 3], nil], [NSNumber numberWithInt: 32], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 3], nil], [NSNumber numberWithInt: 33], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 3], nil], [NSNumber numberWithInt: 34], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 3], nil], [NSNumber numberWithInt: 35], 
									  [NSSet setWithObjects: [NSNumber numberWithInt: 3], nil], [NSNumber numberWithInt: 36], nil];
			
			leftEdges = [[NSArray alloc] initWithObjects: [NSNumber numberWithInt: 37], [NSNumber numberWithInt: 38], [NSNumber numberWithInt: 39], 
							   [NSNumber numberWithInt: 40], [NSNumber numberWithInt: 41], [NSNumber numberWithInt: 42], [NSNumber numberWithInt: 43], nil];
			break;
		default:
			positionConnections = nil;
			edgesForPosition = nil;
			leftEdges = nil;
			break;
	}
}


- (void) dealloc {
	[player1Name release];
	[player2Name release];
	[board release];
	[humanMove release];
	[positionConnections release];
	[leftEdges release];
	[edgesForPosition release];
	//[service release];
	[super dealloc];
}

@end
