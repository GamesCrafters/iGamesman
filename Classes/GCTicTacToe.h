//
//  GCTicTacToe.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 9/17/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCGame.h"

@interface GCTicTacToe : GCGame {
	NSString *player1Name, *player2Name;
	PlayerType player1Type, player2Type;
	
	int rows, cols, inarow;
	BOOL misere;
	NSMutableArray *board;
}

@property (nonatomic, retain) NSString *player1Name, *player2Name;
@property (nonatomic, assign) PlayerType player1Type, player2Type;
@property (nonatomic, assign, getter=isMisere) BOOL misere;
@property (nonatomic, assign) int rows, cols, inarow;

@end
