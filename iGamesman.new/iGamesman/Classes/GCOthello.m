//
//  GCOthello.m
//  iGamesman
//
//  Created by Luca Weihs on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GCOthello.h"
#import "GCOthelloViewController.h"

#define BLANK @"+"
#define LEFTPLAYERPIECE @"X"
#define RIGHTPLAYERPIECE @"O"

#define PASS @"PASS"

@implementation GCOthello
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

- (UIView *) viewWithFrame: (CGRect) frame
{
	othView = [[GCOthelloViewController alloc] initWithGame: self];
	[othView loadView: frame];
    return othView.view;
}

- (void) userChoseMove: (NSNumber *) move{
	moveHandler(move);
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
		[othView updateLegalMoves];
        [othView updateLabels];
        [othView updateServerDataWithService: service];
    }
	return board;
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

- (GameValue) primitive{
	if ([[[self generateMoves] objectAtIndex:0] isEqual:PASS]) {
		leftPlayerTurn = !leftPlayerTurn;
		if ([[[self generateMoves] objectAtIndex:0] isEqual:PASS]) {
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

- (GameValue) primitive: (Position) pos{
	NSLog(@"happens");
	return [self primitive];
}


- (NSArray *) generateMoves{
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

- (Position) currentPosition{
	return board;
}

- (void) startGameWithLeft: (GCPlayer *) leftGCPlayer
                     right: (GCPlayer *) rightGCPlayer
           andPlaySettings: (NSDictionary *) settingsDict{
	
	gameSettings = settingsDict;
	leftPlayer = [leftGCPlayer retain];
	rightPlayer = [rightGCPlayer retain];
	
	gameMode = (PlayMode) [settingsDict objectForKey:@"GameMode"];
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

- (GCPlayer *) rightPlayer{
	return rightPlayer;
}

// LeftPlayer / RightPlayer are properties

- (NSDictionary *) playSettings{
	return nil;
}

- (void) setPlaySettings: (NSDictionary *) settingsDict{
}

- (UIView *) view{
	return othView;
}

- (void) waitForHumanMoveWithCompletion: (GCMoveCompletionHandler) completionHandler{
	if([[[self generateMoves] objectAtIndex: 0] isEqual: @"PASS"]) {
		if(!autoPass) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Legal Moves" 
															message:@"Click OK to pass"
														   delegate:self
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles: nil];
			[alert show];
			[alert release]; 
		}
		completionHandler([NSNumber numberWithInt: -1]);
	} else {
		othView.touchesEnabled = YES;
		leftPlayerTurn;
		moveHandler = Block_copy(completionHandler);
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	//Do nothing at the moment
	//completionHandler([NSNumber numberWithInt: -1]);
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
- (void) showPredictions: (BOOL) pred{
	predictions = pred;
	[othView updateLabels];
}
- (void) showMoveValues: (BOOL) move{
	moveValues = move;
	[othView updateLegalMoves];
}

/* Report whose turn it is (left or right) */
- (PlayerSide) currentPlayer {
	return leftPlayerTurn ? PLAYER_LEFT : PLAYER_RIGHT;
}

/*******************************************************
 Helper functions not in the protocol
*******************************************************/

- (NSString *) getValue {	
	return [service getValue];
}

- (NSInteger) getRemoteness {
	return [service getRemoteness];
}

- (NSString *) getValueOfMove: (NSNumber *) move {
    int row = [move intValue] / cols + 1;
    if (row==4) {
        row = 1;
    } else if (row==1) {
        row =4;
    } else if (row==2){
        row = 3;
    } else {
        row  = 2;
    }
	NSString *serverMove = [NSString stringWithFormat: @"%c%d", 'a' + [move intValue] % cols,  row];
    NSString * value = [service getValueAfterMove: serverMove];
    if ([value isEqualToString:@"win"]){
        value = @"lose";
    } else if ([value isEqualToString:@"lose"]) {
        value = @"win";
    }
	return value;
}

- (NSInteger) getRemotenessOfMove: (NSNumber *) move {
	NSString *serverMove = [NSString stringWithFormat: @"%c%d", 'A' + [move intValue] % cols, 1 + [move intValue] / cols];
	return [service getRemotenessAfterMove: serverMove];
}

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
		if(leftPlayerTurn) NSLog(@"LeftPlayerTurn");
		else NSLog(@"RightPlayerTurn");
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
