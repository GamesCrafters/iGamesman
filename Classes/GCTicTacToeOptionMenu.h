//
//  GCTicTacToeOptionMenu.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 9/22/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCTicTacToe.h"
#import "GCOptionMenu.h"
#import "GCRulesDelegate.h"


@interface GCTicTacToeOptionMenu : UITableViewController <GCOptionMenu> {
	id <GCRulesDelegate> delegate;
	GCTicTacToe *game;
	int rows, cols, inarow;
	BOOL misere;
}

@property (nonatomic, assign) id <GCRulesDelegate> delegate;

- (id) initWithGame: (GCTicTacToe *) _game;

@end
