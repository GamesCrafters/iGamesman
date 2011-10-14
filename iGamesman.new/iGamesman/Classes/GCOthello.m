//
//  GCOthello.m
//  iGamesman
//
//  Created by Luca Weihs on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GCOthello.h"

#define BLANK @"+"
#define LEFTPLAYERPIECE @"X"
#define RIGHTPLAYERPIECE @"O"

#define PASS @"PASS"

@implementation GCOthello
@synthesize leftPlayer, rightPlayer;
@synthesize rows, cols;
@synthesize misere;
@synthesize autoPass;
@synthesize leftPlayerTurn;
@synthesize board, myOldMoves;
@synthesize leftPlayerPieces, rightPlayerPieces;
@synthesize predictions, moveValues;

- (id) init {
	if (self = [super init]) {
		myOldMoves = [[NSMutableArray alloc] initWithCapacity:rows*cols*2];
		rows = 8;
		cols = 8;
		misere = NO;
		leftPlayerTurn = YES;
		leftPlayerPieces = 2;
		rightPlayerPieces = 2;
		autoPass = NO;
		othView = nil;
		
		board = [[NSMutableArray alloc] initWithCapacity: rows * cols];
		for (int i = 0; i < rows * cols; i += 1) {
			[board addObject: BLANK];
		}
		int col = cols/2 - 1;
        int row = rows/2 - 1;
		[board replaceObjectAtIndex:col+row*cols withObject:LEFTPLAYERPIECE];
		[board replaceObjectAtIndex:1+col+row*cols withObject:RIGHTPLAYERPIECE];
		[board replaceObjectAtIndex:col+(row+1)*cols withObject:RIGHTPLAYERPIECE];
		[board replaceObjectAtIndex:1+col+(row+1)*cols withObject:LEFTPLAYERPIECE];
	}
	return self;
}

- (Position) doMove: (Move) move{
	[othView doMove:move];
	if  ([move intValue] != -1) {
		NSMutableArray *oldBoard = [[NSMutableArray alloc] initWithCapacity: 3];
		[oldBoard addObject:[board copy]];
		[oldBoard addObject:[NSNumber numberWithInt:leftPlayerPieces]];
		[oldBoard addObject:[NSNumber numberWithInt:rightPlayerPieces]];
		[myOldMoves addObject:oldBoard];
		NSArray *flips = [self getFlips:[move intValue]];
		NSString *myPiece = leftPlayerTurn ? LEFTPLAYERPIECE : RIGHTPLAYERPIECE;
		for (NSNumber *x in flips) {		
			[board replaceObjectAtIndex:[x intValue] withObject:myPiece];
		}
		[board replaceObjectAtIndex:[move intValue] withObject:myPiece];
		int changedPieces = [flips count];
		if (leftPlayerTurn) {
			leftPlayerPieces += changedPieces + 1;
			rightPlayerPieces -= changedPieces;
		} else {
			rightPlayerPieces += changedPieces + 1;
			leftPlayerPieces -= changedPieces;
		}
	} 
	leftPlayerTurn = !leftPlayerTurn;
    if (gameMode == OFFLINE_UNSOLVED) {
        [othView updateLegalMoves];
        [othView updateLabels];
    } else {
        [othView updateServerDataWithService: service];
    }
}

- (void) undoMove: (Move) move toPosition: (Position) toPos{
	[othView undoMove:move];
	NSArray *b = [[myOldMoves lastObject] retain];
	[myOldMoves removeLastObject];
	board = [[b objectAtIndex:0] mutableCopy];
	leftPlayerPieces = [[b objectAtIndex:1] intValue];
	rightPlayerPieces = [[b objectAtIndex:2] intValue];
	if ([move intValue] != -1) {
		leftPlayerTurn = !leftPlayerTurn;
	} 
	if (gameMode == OFFLINE_UNSOLVED) {
		[othView updategenerateMoves];
		[othView updateLabels];
	} else {
		[othView updateServerDataWithService: service];
	}
}

- (GameValue) primitive: (Position) pos{
	if ([[[self generateMoves: nil] objectAtIndex:0] isEqual:PASS]) {
		leftPlayerTurn = !leftPlayerTurn;
		if ([[[self generateMoves: nil] objectAtIndex:0] isEqual:PASS]) {
			leftPlayerTurn = !leftPlayerTurn;
			if (leftPlayerPieces > rightPlayerPieces) {
				if (leftPlayerTurn) {
					return WIN;
				} else{
					return LOSE;
				}
			}
			else if (rightPlayerPieces > leftPlayerPieces) {
				if (leftPlayerTurn ) {
					return LOSE;
				} else {
					return WIN;
				}
			} else {
				return TIE;
			}
		}
		leftPlayerTurn = !leftPlayerTurn;
	}
	return NONPRIMITIVE;
}

- (NSArray *) generateMoves: (Position) pos{
	NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity:rows*cols];
	for (int i=0; i < rows*cols; i += 1) {
		if ([[board objectAtIndex:i] isEqualToString:BLANK]) {
			if([[self getFlips:i] count] > 0) {
				[moves addObject: [NSNumber numberWithInt:i]];
			}
		}
	}
	if([moves count] == 0)
		[moves addObject:PASS];
	return moves;
}

- (void) startGameWithLeft: (GCPlayer *) leftGCPlayer
                     right: (GCPlayer *) rightGCPlayer
           andPlaySettings: (NSDictionary *) settingsDict{
	[self setLeftPlayer: leftGCPlayer];
	[self setRightPlayer: rightGCPlayer];
	
	gameMode = ONLINE_SOLVED;
	leftPlayerTurn = YES;
	if (!othView)
		[othView release];
    
    if (gameMode == OFFLINE_UNSOLVED) {
        predictions = NO;
        moveValues = NO;
    }
	if (gameMode == ONLINE_SOLVED) {
		service = [[GCJSONService alloc] init];
		[othView updateServerDataWithService: service];
	}
}

/* Accessors for the players and “meta-game” settings */
- (GCPlayer *) leftPlayer{
	return leftPlayer;
}

- (void) setLeftPlayer: (GCPlayer *) left{
	leftPlayer = left;
}

- (GCPlayer *) rightPlayer{
	return rightPlayer;
}

- (void) setRightPlayer: (GCPlayer *) right{
	rightPlayer = right;
}

- (NSDictionary *) playSettings{
	return nil;
}

- (void) setPlaySettings: (NSDictionary *) settingsDict{
}

- (UIView *) view{
	return nil;
}

- (void) waitForHumanMoveWithCompletion: (void (^) (Move move)) completionHandler{
}

- (UIView *) variantsView{
	return nil;
}

/* Accessors for misere */
//Unnecessary as misere is a property

/* Pause any ongoing tasks (such as server requests) */
- (void) pause{
}

/* Resume any tasks paused by -pause */
- (void) resume{
}

/* Report the play modes supported by the game */
- (BOOL) supportsPlayMode: (PlayMode) mode{
	switch (mode) {
		case OFFLINE_UNSOLVED:
		case ONLINE_SOLVED:
			return YES;
		default:
			return NO;
	}
}

/* Show/hide move values and predictions */
- (void) showPredictions: (BOOL) predictions{
}
- (void) showMoveValues: (BOOL) moveValues{
}

/* Report whose turn it is (left or right) */
- (PlayerSide) currentPlayer {
	return leftPlayerTurn ? PLAYER_LEFT : PLAYER_RIGHT;
}

/*******************************************************
 Helper functions not in the protocol
*******************************************************/

- (PlayMode) playMode {
	return gameMode;
}

+ (NSString *) stringForBoard: (NSArray *) _board {
	NSString *boardString = @"";
	for (NSString *piece in _board) {
		if ([piece isEqualToString: BLANK])
			piece = @"_";
        else if([piece isEqualToString:LEFTPLAYERPIECE])
            piece = @"B";
        else if([piece isEqualToString:RIGHTPLAYERPIECE])
            piece = @"W";
		boardString = [NSString stringWithFormat: @"%@%@", boardString, piece];
	}
	return boardString;
}

- (NSArray *) getFlips: (int) loc {
	NSMutableArray *flips = [[NSMutableArray alloc] initWithCapacity:rows*cols];
	if ([[board objectAtIndex:loc] isEqualToString:BLANK]) {			
		NSString *myPiece = leftPlayerTurn ? LEFTPLAYERPIECE : RIGHTPLAYERPIECE;
		int offsets[8] = {1,-1,cols,-cols,cols+1,cols-1,-cols+1,-cols-1};
		for (int i=0; i<8; i+=1) {
			int offset = offsets[i];
			NSMutableArray *tempFlips = [[NSMutableArray alloc] initWithCapacity:rows*cols];
			int tempLoc = loc;
			while (YES) {
				tempLoc += offset;
				if ([self isOutOfBounds: tempLoc offset:offset]) break;
				if ([[board objectAtIndex:tempLoc] isEqualToString: BLANK]) break; 
				if ([[board objectAtIndex:tempLoc] isEqualToString: myPiece]) {
					[flips addObjectsFromArray: tempFlips];
					break;
				}
				[tempFlips addObject: [NSNumber numberWithInt: tempLoc]];
			}
		}
	}
	return flips;
}

- (BOOL) isOutOfBounds: (int) loc offset: (int) offset {
	if (loc < 0 || loc >= rows*cols) {
		return YES;
	}
	if ((offset == -1 || offset == -cols-1 || offset== cols-1) 
		&& (loc % cols == cols-1 )) {
		return YES;
	}
	if ((offset == 1 || offset == cols + 1 || offset== -cols+1) 
		&& (loc % cols == 0)) {
		return YES;
	}
	return NO;
}

- (void) resetBoard {
	myOldMoves = [[NSMutableArray alloc] initWithCapacity:rows*cols*2];
	leftPlayerPieces = 2;
	rightPlayerPieces = 2;
	if (board != nil) {
		[board release];
		board = nil;
	}
	board = [[NSMutableArray alloc] initWithCapacity:cols*rows];
	for (int i = 0; i < cols * rows; i += 1)
		[board addObject: BLANK];
	
	int row = rows/2 -1;
	int col = cols/2 -1;
	[board replaceObjectAtIndex:col+row*cols withObject:LEFTPLAYERPIECE];
	[board replaceObjectAtIndex:col+row*cols+1 withObject:RIGHTPLAYERPIECE];
	[board replaceObjectAtIndex:col+(row+1)*cols withObject:RIGHTPLAYERPIECE];
	[board replaceObjectAtIndex:col+(row+1)*cols+1 withObject:LEFTPLAYERPIECE];
}

@end
