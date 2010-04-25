//
//  GCJSONService.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 4/24/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Handles nyc.cs server requests for games in which the server
 response is a JSON object.
 */
@interface GCJSONService : NSObject {
	@private
	NSArray  *previous;
	NSArray  *current;
	NSString *myBoard;
	BOOL     status;
	BOOL     connected;
}

/// Return whether or not the last request connected to the Internet
- (BOOL) connected;

/// Return whether or not the last request received a status OK response from the server
- (BOOL) status;

/// Return the "opposite" game value
+ (NSString	*) flip: (NSString *) value;

/// Return the value of the current board
- (NSString *) getValue;

/// Return the remoteness of the current board
- (NSInteger) getRemoteness;

/// Return the value of the position after a move
- (NSString *) getValueAfterMove: (NSString *) move;

/// Return the remoteness of the position after a move
- (NSInteger) getRemotenessAfterMove: (NSString *) move;

/// Requests the game data from the server
- (void) retrieveDataForBoard: (NSString *) board URL: (NSString *) posURL andNextMovesURL: (NSString *) nextURL;

@end
