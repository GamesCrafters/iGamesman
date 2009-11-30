//
//  GCConnectFour.m
//  Gamesman
//
//  Created by Kevin Jorgensen on 11/19/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import "GCConnectFour.h"
#import "GCOptionMenu.h"
#import "GCConnectFourViewController.h"


@implementation GCConnectFour

- (id) init {
	if (self = [super init]) {
		optionMenu = [[GCConnectFourOptionMenu alloc] initWithStyle: UITableViewStyleGrouped];
		p1Name = @"Player 1";
		p2Name = @"Player 2";
	}
	return self;
}


- (id <GCOptionMenu>) getOptionMenu {
	return optionMenu;
}

- (UIViewController *) getGameViewController {
	int width = [optionMenu getWidth];
	int height = [optionMenu getHeight];
	int pieces = [optionMenu getPieces];
	GCConnectFourViewController *view = [[GCConnectFourViewController alloc] initWithWidth: width 
																					height: height 
																					pieces: pieces];
	[view setPlayer1Name: p1Name];
	[view setPlayer2Name: p2Name];
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

@end
