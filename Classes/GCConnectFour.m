//
//  GCConnectFour.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 1/29/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCConnectFour.h"
#import "GCConnectFourOptionMenu.h"
#import "GCConnectFourViewController.h"


@implementation GCConnectFour

@synthesize player1Name, player2Name;
@synthesize width, height, pieces;
@synthesize board;

- (id) init {
	if (self = [super init]) {
		player1Name = @"Player 1";
		player2Name = @"Player 2";
		
		width = 6;
		height = 5;
		pieces = 4;
		
		board = [[NSMutableArray alloc] initWithCapacity: width * height];
		for (int i = 0; i < width * height; i += 1)
			[board addObject: @"+"];
	}
	return self;
}

- (NSString *) gameName { 
	return @"Connect-4"; 
}

- (BOOL) supportsPlayMode:(PlayMode)mode {
	if (mode == ONLINESOLVED) return YES;
	if (mode == OFFLINEUNSOLVED) return NO;
	return NO;
}

- (UIViewController *) optionMenu {
	return [[GCConnectFourOptionMenu alloc] initWithGame: self];
}

- (UIViewController *) gameViewController {
	return [[GCConnectFourViewController alloc] initWithGame: self];
}

- (BOOL) startGame {
	[self resetBoard];
	
	return YES;
}

- (NSString *) getBoard {
	if (!board)
		return @"";
	NSString *B = @"";
	for (int i = 0; i < width * height; i += 1)
		B = [B stringByAppendingString: [board objectAtIndex: i]];
	return B;
}

- (void) resetBoard {
	if (board != nil) {
		[board release];
		board = nil;
	}
	
	board = [[NSMutableArray alloc] initWithCapacity: width * height];
	for (int i = 0; i < width * height; i += 1)
		[board addObject: @"+"];
}

- (void) dealloc {
	[board release];
	[super dealloc];
}

@end
