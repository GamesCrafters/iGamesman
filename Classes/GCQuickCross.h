//
//  GCQuickCross.h
//  GamesmanMobile
//
//  Created by Andrew Zhai and Chih Hu on 9/26/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCGame.h"

@interface GCQuickCross : GCGame {
	NSString *player1Name, *player2Name;
	PlayerType player1Type, player2Type;
		
	int rows, cols, inalign;
	BOOL misere;
	NSMutableArray *board;
}

@property (nonatomic, retain) NSString *player1Name, *player2Name;
@property (nonatomic, assign) PlayerType player1Type, player2Type;
@property (nonatomic, assign, getter=isMisere) BOOL misere;
@property (nonatomic, assign) int rows, cols, inalign;

- (void) resetBoard;

@end
