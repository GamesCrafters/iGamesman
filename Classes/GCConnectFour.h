//
//  GCConnectFour.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 1/29/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCGame.h"


/**
 The controlling class for Connect-4
 */
@interface GCConnectFour : GCGame {
	NSString *player1Name, *player2Name;
	int width, height, pieces;
	NSMutableArray *board;
}

@property (nonatomic, retain) NSString *player1Name, *player2Name;
@property (nonatomic, assign) int width, height, pieces;
@property (nonatomic, retain) NSArray *board;

- (void) resetBoard;

@end
