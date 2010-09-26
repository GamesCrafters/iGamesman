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
#define X @"X"
#define O @"O"


@implementation GCOthello
@synthesize player1Name, player2Name; 
@synthesize player1Type, player2Type;
@synthesize rows, cols;
@synthesize misere;

- (id) init {
	if (self = [super init]) {
		player1Name = @"Player 1";
		player2Name = @"Player 2";
		
		rows = 8;
		cols = 8;
		misere = NO;
		
		board = [[NSMutableArray alloc] initWithCapacity: rows * cols];
		for (int i = 0; i < rows * cols; i += 1)
			[board addObject: BLANK];
	}
	return self;
}

- (NSString *) gameName {
	return @"Othello";
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
