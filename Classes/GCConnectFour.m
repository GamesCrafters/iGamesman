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
	return view;
}

@end
