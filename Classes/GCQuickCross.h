//
//  GCQuickCross.h
//  GamesmanMobile
//
//  Created by Andrew Zhai and Chih Hu on 9/26/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCGame.h"

@class GCQuickCrossViewController;

@interface GCQuickCross : GCGame {
	GCQuickCrossViewController *qcView;
	
	NSString *player1Name, *player2Name;
	PlayerType player1Type, player2Type;
	
	BOOL p1Turn;
	
	PlayMode gameMode;
	
	int rows, cols, inalign;
	BOOL misere;
	NSMutableArray *board;
	NSArray *humanMove;
}

@property (nonatomic, retain) NSString *player1Name, *player2Name;
@property (nonatomic, assign) PlayerType player1Type, player2Type;
@property (nonatomic, assign, getter=isMisere) BOOL misere;
@property (nonatomic, assign) int rows, cols, inalign;
@property (nonatomic, assign) BOOL p1Turn;
- (void) resetBoard;
- (void) postHumanMove: (NSArray *) move;

@end
