//
//  GCConnectFourService.h
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 10/28/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Handles the nyc server requests for Connect-4. Simplifies the task of getting
 values from the server to a few simple method calls, rather than opening up the
 URL and manually parsing the JSON response each time.
 */
@interface GCConnectFourService : NSObject {
	@private
		NSArray *previous;
		NSArray *current;
		NSArray *myBoard;
		BOOL connected;
		BOOL status;
}

/// Return whether or not the last request connected to the Internet
- (BOOL) connected;

/// Return whether or not the last request received a status OK response from the server
- (BOOL) status;

/// Return a string representation of a board
- (NSString *) stringForBoard: (NSArray *) board;

/// Return the "opposite" game value
- (NSString	*) flip: (NSString *) value;

/// Return the value of the current board
- (NSString *) getValue;

/// Return the remoteness of the current board
- (NSInteger) getRemoteness;

/// Return the value of the position after a move
- (NSString *) getValueAfterMove: (NSString *) move;

/// Requests the game data from the server
- (void) retrieveDataForBoard: (NSArray *) board width: (NSInteger) width height: (NSInteger) height pieces: (NSInteger) pieces;

@end
