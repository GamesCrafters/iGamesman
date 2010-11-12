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
#define XVERT @"X"
#define XHORIZ @"x"
#define YVERT @"Y"
#define YHORIZ @"y"
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
		if (p1Turn)
		{
			if ([[board objectAtIndex: i] isEqual: XVERT])
				[result addObject: [NSArray arrayWithObjects: [NSNumber numberWithInt: i], XHORIZ, SPIN, nil]];
			else if ([[board objectAtIndex: i] isEqual: XHORIZ])
				[result addObject: [NSArray arrayWithObjects: [NSNumber numberWithInt: i], XVERT, SPIN, nil]];
			else if ([[board objectAtIndex: i] isEqual: BLANK])
			{
				[result addObject: [NSArray arrayWithObjects: [NSNumber numberWithInt: i], XVERT, PLACE, nil]];
				[result addObject: [NSArray arrayWithObjects: [NSNumber numberWithInt: i], XHORIZ, PLACE, nil]];
			}
	    }
		else
		{
			if ([[board objectAtIndex: i] isEqual: YVERT])
				[result addObject: [NSArray arrayWithObjects: [NSNumber numberWithInt: i], YHORIZ, SPIN, nil]];
			else if ([[board objectAtIndex: i] isEqual: YHORIZ])
				 [result addObject: [NSArray arrayWithObjects: [NSNumber numberWithInt: i], YVERT, SPIN, nil]];
			else if ([[board objectAtIndex: i] isEqual: BLANK])
			{
				[result addObject: [NSArray arrayWithObjects: [NSNumber numberWithInt: i], YVERT, PLACE, nil]];
			    [result addObject: [NSArray arrayWithObjects: [NSNumber numberWithInt: i], YHORIZ, PLACE, nil]];
			}
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
	else if (!p1Turn)
	{
		if ([[move objectAtIndex: 1] isEqual: XHORIZ])
		{
			[board replaceObjectAtIndex: [[move objectAtIndex: 0] intValue] withObject: XVERT];
		}
		else 
		{
			[board replaceObjectAtIndex: [[move objectAtIndex: 0] intValue] withObject: XHORIZ];
		}
	}
	else
	{
		if ([[move objectAtIndex: 1] isEqual: YHORIZ])
		{
			[board replaceObjectAtIndex: [[move objectAtIndex: 0] intValue] withObject: YVERT];
		}
		else 
		{
			[board replaceObjectAtIndex: [[move objectAtIndex: 0] intValue] withObject: YHORIZ];
		}
	}
	p1Turn = !p1Turn;
}

- (NSString *) primitive {
	for (int i = 0; i < rows * cols; i += 1) {
		NSString *piece = [board objectAtIndex: i];
		if ([piece isEqual: BLANK])
			continue;
		BOOL case1 = YES;
		if ([piece isEqual: XHORIZ] || [piece isEqual: YHORIZ])
		{
		// Check the horizontal case
			
			for (int j = i; j < i + inalign; j += 1) {
				if (j >= cols * rows || i % cols > j % cols || ![[board objectAtIndex: j] isEqual: piece]) {
					case1 = NO;
					break;
				}
			}
			if (case1)
			{
				if (p1Turn)
					return (misere ? @"LOSE" : @"WIN");
					return (misere ? @"WIN" : @"LOSE");
			}
		}
		
		// Check the vertical case
		BOOL case2 = YES;
		if ([piece isEqual: XVERT] || [piece isEqual: YVERT])
        {
			for (int j = i; j < i + cols * inalign; j += cols) {
				if ( j >= cols * rows || ![[board objectAtIndex: j] isEqual: piece] ) {
					case2 = NO;
					break;
				}
			}
			if (case2)
			{
				if (p1Turn)
					return (misere ? @"LOSE" : @"WIN");
					return (misere ? @"WIN" : @"LOSE");
			}
		}
	}
		
	// Finally, check if the board is full	
	BOOL full = YES;
	for (int i = 0; i < cols * rows; i += 1) {
		if ([[board objectAtIndex: i] isEqual: BLANK]) {
			full = NO;
			break;
		}
	}
	if (full)
	{
		BOOL tie = YES;
		for (int i = 0; i < cols * rows; i += 1) { 
			NSString *piece = [board objectAtIndex: i];
			if([piece isEqual: XVERT] || [piece isEqual: XHORIZ])
			{
				//vertical case
				BOOL pass = YES;
				for (int j = i; j < i + cols * inalign; j += cols) {
					if ( j >= cols * rows || !([[board objectAtIndex: j] isEqual: XVERT] || [[board objectAtIndex: j] isEqual: XHORIZ])) {
						pass = NO;
					}
				}
				if (pass)
				{
					tie = NO;
					break;
				}
				pass = YES;
				//horizontal case
				for (int j = i; j < i + inalign; j += 1) {
					if (j >= cols * rows || i % cols > j % cols || !([[board objectAtIndex: j] isEqual: XVERT] || [[board objectAtIndex: j] isEqual: XHORIZ])) 
					{
						pass = NO;
						
					}
				}
				if (pass)
				{
					tie = NO;
					break;
				}
			}
			else 
			{
				//vertical case
				BOOL pass = YES;
				for (int j = i; j < i + cols * inalign; j += cols) {
					if ( j >= cols * rows || !([[board objectAtIndex: j] isEqual: YVERT] || [[board objectAtIndex: j] isEqual: YHORIZ])) {
						pass = NO;
					}
				}
				if (pass)
				{
					tie = NO;
					break;
				}
				pass = YES;
				//horizontal case
				for (int j = i; j < i + inalign; j += 1) {
					if (j >= cols * rows || i % cols > j % cols || !([[board objectAtIndex: j] isEqual: YVERT] || [[board objectAtIndex: j] isEqual: YHORIZ])) 
					{
						pass = NO;
						
					}
				}
				if (pass)
				{
					tie = NO;
					break;
				}
				
			}
		}
		if (tie){
			return @"TIE";
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
