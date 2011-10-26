//
//  GCConnectFour.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 9/15/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCGame.h"
#import "GCJSONService.h"
#import "GCConnectFourPosition.h"


@interface GCConnectFour : NSObject <GCGame> {
//    GCConnectFourViewController *c4view;
	GCJSONService				*service;
    GCConnectFourPosition       *position;
    //	BOOL						p1Turn;     // position.p1Turn
    //	NSMutableArray				*board;     // position.board
    GCPlayer                    *leftPlayer, *rightPlayer;
    NSDictionary                *playSettings;
	int							width, height, pieces;
	BOOL						predictions, moveValues;
	BOOL						misere;
	PlayMode					gameMode;
	NSString					*humanMove;
    NSMutableArray				*serverHistoryStack;
	NSMutableArray				*serverUndoStack;
}

- (NSArray *) legalMoves;       // Convenience method -- calls -generateMoves: with current position.
- (NSString *) boardString;     // Generate board string for the current position.

@property (readonly) GCConnectFourPosition  *position;
@property (readonly) PlayMode               gameMode;

@end
