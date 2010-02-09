//
//  NewGame.m
//  Gamesman
//
//  Created by AUTHOR_NAME on MM/DD/YYYY.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "NewGame.h"
#import "NewGameViewController.h"


@implementation NewGame

- (id) init {
	if (self = [super init]) {
		optionMenu = [[NewGameOptionMenu alloc] initWithStyle: UITableViewStyleGrouped];
		p1Name = @"Player 1";
		p2Name = @"Player 2";
	}
	return self;
}

- (id <GCOptionMenu>) getOptionMenu {
	return optionMenu;
}

- (UIViewController *) getGameViewController {
	// Retrieve information from the option menu
	NewGameViewController *view = [[NewGameViewController alloc] init];
	return view;
}

- (NSString *) player1Name {
	return p1Name;
}

- (NSString *) player2Name {
	return p2Name;
}

- (void) setPlayer1Name:(NSString *) name {
	p1Name = name;
}

- (void) setPlayer2Name:(NSString *) name {
	p2Name = name;
}

- (BOOL) supportsGameMode:(GameMode)mode {
	return (mode == ONLINESOLVED);
}

- (void) dealloc {
	[optionMenu release];
	
	[super dealloc];
}


@end
