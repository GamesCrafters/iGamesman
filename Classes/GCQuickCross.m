//
//  GCQuickCross.m
//  GamesmanMobile
//
//  Created by Andrew Zhai and Chih Hu on 9/26/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCQuickCross.h"
#import "GCQuickCrossOptionMenu.h"
#import "GCQuickCrossViewController.h"

#define BLANK @"+"
#define VERT @"|"
#define HORIZ @"-"
#define PLACE @"place"
#define SPIN @"spin"

@implementation GCQuickCross

@synthesize player1Name, player2Name;
@synthesize player1Type, player2Type;
@synthesize rows, cols, inalign, misere;
@synthesize p1Turn;

- (id) init {
	if (self = [super init]) {
		player1Name = @"Player 1";
		player2Name = @"Player 2";
		
		rows = 4;
		cols = 4;
		inalign = 4;
		
		p1Turn = YES;
 		
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

- (UIViewController *) gameViewController {
	return qcView;
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

- (NSArray *) getBoard {
	return board;
}

- (Player) currentPlayer {
	return p1Turn ? PLAYER1 : PLAYER2;
}

- (NSArray *) legalMoves {
	NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity: 2 * rows * cols];
	for (int i = 0; i < [board count]; i += 1) {
		if ([[board objectAtIndex: i] isEqual: VERT])
			[result addObject: [NSArray arrayWithObjects: [NSNumber numberWithInt: i], HORIZ, SPIN, nil]];
		else if ([[board objectAtIndex: i] isEqual: HORIZ])
			[result addObject: [NSArray arrayWithObjects: [NSNumber numberWithInt: i], VERT, SPIN, nil]];
		else if ([[board objectAtIndex: i] isEqual: BLANK])
		{
			[result addObject: [NSArray arrayWithObjects: [NSNumber numberWithInt: i], VERT, PLACE, nil]];
			[result addObject: [NSArray arrayWithObjects: [NSNumber numberWithInt: i], HORIZ, PLACE, nil]];
		}
	}
	return [result autorelease];
}			

- (void) doMove: (NSArray *) move {
	[qcView doMove: move];
	
	NSString *piece = [move objectAtIndex: 1]; 
	[board replaceObjectAtIndex: [[move objectAtIndex: 0] intValue] withObject: piece];
	p1Turn = !p1Turn;
	
	[qcView updateDisplay];
}

- (void) undoMove: (NSArray*) move {
	[qcView undoMove: move];
	if ([[move objectAtIndex: 2] isEqual: PLACE]) {
		[board replaceObjectAtIndex: [[move objectAtIndex: 0] intValue] withObject: BLANK];
	}
	else if ([[move objectAtIndex: 1] isEqual: HORIZ])
	{
		[board replaceObjectAtIndex: [[move objectAtIndex: 0] intValue] withObject: VERT];
	}
	else 
	{
		[board replaceObjectAtIndex: [[move objectAtIndex: 0] intValue] withObject: HORIZ];
	}
	p1Turn = !p1Turn;
}

- (NSString *) primitive {
	for (int i = 0; i < rows * cols; i += 1) {
		NSString *piece = [board objectAtIndex: i];
		if ([piece isEqual: BLANK])
			continue;
		BOOL case1 = YES;
		if ([piece isEqual: VERT])
		{
		// Check the horizontal case for vertical 
			
			for (int j = i; j < i + inalign; j += 1) {
				if (j >= cols * rows || i % cols > j % cols || ![[board objectAtIndex: j] isEqual: piece]) {
					case1 = NO;
					break;
				}
			}
			if (case1)
			{
				return (misere ? @"WIN" : @"LOSE");
			}
		}
		
		BOOL case2 = YES;
		if ([piece isEqual: HORIZ])
		{
			// Check the horizontal case for Horizontal
			
			for (int j = i; j < i + inalign; j += 1) {
				if (j >= cols * rows || i % cols > j % cols || ![[board objectAtIndex: j] isEqual: piece]) {
					case2 = NO;
					break;
				}
			}
			if (case2)
			{
			
				return (misere ? @"WIN" : @"LOSE");
			}
		}
		// Check the vertical case for vert
			 
		BOOL case3 = YES;
		if ([piece isEqual: VERT])
        {
			for (int j = i; j < i + cols * inalign; j += cols) {
				if ( j >= cols * rows || ![[board objectAtIndex: j] isEqual: piece] ) {
					case3 = NO;
					break;
				}
			}
			if (case3)
			{
				
				return (misere ? @"WIN" : @"LOSE");
			}
		}
		// Check the vertical case for Horiz
			
		BOOL case4 = YES;
		if ([piece isEqual: HORIZ])
		{
			for (int j = i; j < i + cols * inalign; j += cols) {
				if ( j >= cols * rows || ![[board objectAtIndex: j] isEqual: piece] ) {
					case4 = NO;
					break;
				}
			}
			if (case4)
			{
				
				return (misere ? @"WIN" : @"LOSE");
			}
		}
		
		// Check the diagonal case (positive slope) for HORIZ
		BOOL case5 = YES;
		if ([piece isEqual: HORIZ])
		{
			for (int j = i; j < i + inalign + cols * inalign; j += (cols + 1) ) {
				if ( j >= cols * rows || (i % cols > j % cols) || ![[board objectAtIndex: j] isEqual: piece] ) {
					case5 = NO;
					break;
				}
			}
			if (case5)
			{
				
				return (misere ? @"WIN" : @"LOSE");
			}
		}
		
		// Check the diagonal case (positive slope) for VERT
		BOOL case6 = YES;
		if ([piece isEqual: VERT])
		{
			for (int j = i; j < i + inalign + cols * inalign; j += (cols + 1) ) {
				if ( j >= cols * rows || (i % cols > j % cols) || ![[board objectAtIndex: j] isEqual: piece] ) {
					case6 = NO;
					break;
				}
			}
			if (case6)
			{
				
				return (misere ? @"WIN" : @"LOSE");
			}
		}
		
		// Check the diagonal case (negative slope) for VERT
		BOOL case7 = YES;
		if ([piece isEqual: VERT])
		{
			for (int j = i; j < i + cols * inalign - inalign; j += (cols - 1) ) {
				if ( j >= cols * rows || (i % cols < j % cols) || ![[board objectAtIndex: j] isEqual: piece] ) {
					case7 = NO;
					break;
				}
			}
			if (case7)
			{
				
				return (misere ? @"WIN" : @"LOSE");
			}
		}
		
		// Check the diagonal case (negative slope) for HORIZ
		BOOL case8 = YES;
		if ([piece isEqual: HORIZ])
		{
			for (int j = i; j < i + cols * inalign - inalign; j += (cols - 1) ) {
				if ( j >= cols * rows || (i % cols < j % cols) || ![[board objectAtIndex: j] isEqual: piece] ) {
					case8 = NO;
					break;
				}
			}
			if (case8)
			{
				
				return (misere ? @"WIN" : @"LOSE");
			}
		}
		
	}
	return nil;
}

- (void) startGameInMode:(PlayMode)mode {
	[self resetBoard];
	
	gameMode = mode;
	
	p1Turn = YES;
	
	if (!qcView)
		[qcView release];
	qcView = [[GCQuickCrossViewController alloc] initWithGame: self];
}

- (void) notifyWhenReady {
	if (gameMode == OFFLINE_UNSOLVED)
		[[NSNotificationCenter defaultCenter] postNotificationName: @"GameIsReady" object: self];
}				 

- (void) askUserForInput {
	qcView.touchesEnabled = YES;
}

- (void) stopUserInput {
	qcView.touchesEnabled = NO;
}

- (NSArray *) getHumanMove {
	return humanMove;
}

- (void) postHumanMove: (NSArray *) move {
	humanMove = move;
	[[NSNotificationCenter defaultCenter] postNotificationName: @"HumanChoseMove" object: self];
}
				 
@end
