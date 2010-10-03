//
//  GCOthello.m
//  GamesmanMobile
//
//  Created by Class Account on 9/26/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCOthello.h"
#import "GCOthelloOptionMenu.h"

#define BLANK @"+"
#define P1PIECE @"X"
#define P2PIECE @"O"

#define PASS @"PASS"


@implementation GCOthello
@synthesize player1Name, player2Name; 
@synthesize player1Type, player2Type;
@synthesize rows, cols;
@synthesize misere;
@synthesize p1Turn;

- (id) init {
	if (self = [super init]) {
		player1Name = @"Player 1";
		player2Name = @"Player 2";
		NSMutableArray *myOldMoves = [[NSMutableArray alloc] initWithCapacity:rows*cols*2];
		rows = 8;
		cols = 8;
		misere = NO;
		p1Turn = YES;
		int p1pieces = 2;
		int p2pieces = 2;
		
		board = [[NSMutableArray alloc] initWithCapacity: rows * cols];
		for (int i = 0; i < rows * cols; i += 1) {
			[board addObject: BLANK];
		}
		int x = rows/2;
		int y = cols/2;
		[board replaceObjectAtIndex:x+y*cols withObject:P1PIECE];
		[board replaceObjectAtIndex:x+y*cols+1 withObject:P2PIECE];
		[board replaceObjectAtIndex:x+(y+1)*cols withObject:P2PIECE];
		[board replaceObjectAtIndex:x+(y+1)*cols+1 withObject:P1PIECE];
	}
	return self;
}

- (NSString *) gameName {
	return @"Othello";
}


- (NSArray *) getBoard {
	return board;
}

- (Player) currentPlayer {
	return p1Turn ? PLAYER1 : PLAYER2;
}

-(NSArray *) legalMoves {
	NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity:rows*cols];
	for (int i=0; i< rows*cols; i+=1) {
		if ([[board objectAtIndex:i] isEqual:BLANK]) {
			if([[self getFlips: i] count] > 0) {
				[moves addObject: [NSNumber numberWithInt: i]];
			}
		}
	}
	if ([moves count]==0) {
		[moves addObject:PASS];
	}
	return moves;
}

-(NSArray *) getFlips: (int) loc {
	NSMutableArray *flips = [[NSMutableArray alloc] initWithCapacity:rows*cols];
	NSString *myPiece = p1Turn ? P1PIECE : P2PIECE;
	NSString *oppPiece = p1Turn ? P2PIECE : P1PIECE;
	int offsets[8] = {1,-1,cols,-cols,cols+1,cols-1,-cols+1,-cols-1};
	for (int i=0; i<9; i+=1) {
		int offset = offsets[i];
		NSMutableArray *tempFlips = [[NSMutableArray alloc] initWithCapacity:rows*cols];
		int tempLoc = loc;
		while (YES) {
			tempLoc += offset;
			if ([self isOutOfBounds: loc offset:offset]) break;
			if ([[board objectAtIndex:tempLoc] isEqual: BLANK]) break; 
			if ([[board objectAtIndex:tempLoc] isEqual: myPiece]) {
				[flips addObjectsFromArray: tempFlips];
				break;
			}
			[tempFlips addObject: [NSNumber numberWithInt: tempLoc]];
		}
	}
	return flips;
}

-(BOOL) isOutOfBounds: (int) loc offset: (int) offset {
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
	return NO:
}

- (void) doMove:(NSNumber *)move {
	NSMutableArray *oldBoard = [[NSArray alloc] initWithCapacity: 3]
	[oldBoard addObject:[board copy]];
	[oldBoard addObject:[NSNumber numberWithInt:p1pieces]];
	[oldBoard addObject:[NSNumber numberWithInt:p2pieces]];
	[myOldMoves addObject:oldBoard];
	NSArray *flips = [self getFlips:[move intValue]];
	NSString *myPiece = p1Turn ? P1PIECE : P2PIECE;
	for (NSNumber *x in flips) {		
		[board replaceObjectAtIndex:[x intValue] withObject:myPiece];
	}
	[board replaceObjectAtIndex:[move intValue] withObject:myPiece];
	int changedPieces = [flips count]
	if (p1Turn) {
		p1pieces += changedPieces + 1;
		p2pieces -= changedPieces;
	} else {
		p2pieces += changedPieces + 1;
		p1pieces -= changedPieces;
	}
	
}

- (void) undoMove:(id)move {
	NSArray *b = [[myOldMoves lastObject] retain];
	[myOldMoves removeLastObject];
	board = [b objectAtIndex:0];
	p1pieces = [b objectAtIndex:1];
	p2pieces = [b objectAtIndex:2];
}

- (NSString *) primitive {
	if ([[legalMoves objectAtIndex:0] isEqual:PASS]) {
		p1Turn = !p1Turn;
		if ([[legalMoves objectAtIndex:0] isEqual:PASS]) {
			p1Turn = !p1Turn;
			if (p1pieces > p2pieces) return  p1Turn ? @"WIN" : @"LOSE";
			else if (p2pieces > p1pieces) return p1Turn ? @"LOSE" : @"WIN";
			else return @"TIE";
		}
		p1Turn = !p1Turn;
	}
}


- (BOOL) supportsPlayMode: (PlayMode) mode {
	return mode == OFFLINE_UNSOLVED;
}

- (UIViewController *) optionMenu {
	return [[GCOthelloOptionMenu alloc] initWithGame: self];
}

- (void) resetBoard {
	if (board != nil) {
		[board release];
		board = nil;
	}
	board = [[NSMutableArray alloc] initWithCapacity: cols * rows];
	for (int i = 0; i < cols * rows; i += 1)
		[board addObject: BLANK];
}


@end
