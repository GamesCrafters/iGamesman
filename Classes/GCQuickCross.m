//
//  GCQuickCross.m
//  GamesmanMobile
//
//  Created by Andrew Zhai and Chih Hu on 9/26/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCQuickCross.h"
#import "GCQuickCrossOptionMenu.h"

#define BLANK @"+"
#define vert @"|"
#define hori @"-"

@implementation GCQuickCross

@synthesize player1Name, player2Name;
@synthesize player1Type, player2Type;
@synthesize rows, cols, inalign, misere;

- (id) init {
	if (self = [super init]) {
		player1Name = @"Player 1";
		player2Name = @"Player 2";
		
		rows = 4;
		cols = 4;
		inalign = 4;
 		
		misere = NO;
		
		board = [[NSMutableArray alloc] initWithCapacity: rows * cols];
		for (int i = 0; i < rows * cols; i += 1)
			[board addObject: BLANK];	}
	return self;
}

- (NSString *) gameName {
	return @"QuickCross";
}

- (BOOL) supportsPlayMode: (PlayMode) mode {
	return mode == OFFLINE_UNSOLVED;
}

- (UIViewController *) optionMenu {
	return [[GCQuickCrossOptionMenu alloc] initWithGame: self];
}
- (void) resetBoard {
	if (board != nil) {
		[board release];
		board = nil;
	}
	
	board = [[NSMutableArray alloc] initWithCapacity: rows * cols];
	for (int i = 0; i < rows * cols; i += 1)
		[board addObject: BLANK];
}
@end
