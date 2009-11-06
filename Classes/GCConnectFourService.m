//
//  GCConnectFourService.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 10/28/09.
//  Copyright 2009 GamesCrafters. All rights reserved.
//

#import "GCConnectFourService.h"
#import "JSON.h"


@implementation GCConnectFourService

/** Designated initializer */
- (id) init {
	if (self = [super init]) {
		previous = nil;
		current = nil;
		myBoard = nil;
		connected = NO;
		status = NO;
	}
	return self;
}

/** 
 Returns whether the most recent request for server data successfully
 connected to the Internet.
 
 @return YES if Internet connection succeeded, NO if not
 */
- (BOOL) connected {
	return connected;
}

/**
 Returns whether the most recent request for server data received
 a status="ok" response from the server.
 
 @return YES if status OK, NO if not
 */
- (BOOL) status {
	return status;
}

/** 
 Convert the NSArray representation of a board to an NSString.
 A convenience method for making server requests.
 
 @param board a Connect-4 board, represented as an NSArray
 @return the same board, represented as an NSString
 */
- (NSString *) stringForBoard: (NSArray *) board {
	NSString *boardString = @"";
	for (NSString *piece in board) {
		if ([piece isEqualToString: @"+"])
			piece = @" ";
		boardString = [NSString stringWithFormat: @"%@%@", boardString, piece];
	}
	return boardString;
}

/** 
 Returns the "opposite" position value.
 
 @param value a game value (win, lose, tie, or draw)
 @return the opposite game value
 */
- (NSString *) flip: (NSString *) value {
	if ([value isEqualToString: @"win"]) return @"lose";
	if ([value isEqualToString: @"lose"]) return @"win";
	return value;
}

/**
 Gets the value of the current board, based on the most recent
 server data request.
 
 @return the value of the current board. Returns nil if the value is unavailable.
 */
- (NSString *) getValue {
	for (NSDictionary *position in previous) {
		NSString *aBoard = [position objectForKey: @"board"];
		if ([aBoard isEqual: [self stringForBoard: myBoard]]) {
			NSString *val = [position objectForKey: @"value"];
			if (val == nil) return nil;
			return [self flip: val];
		}
	}
	return nil;
}

/**
 Gets the remoteness of the current board, based on the most recent 
 server data request.
 
 @return the remoteness of the current board. Returns -1 if the remoteness is unavailable.
 */
- (NSInteger) getRemoteness {
	for (NSDictionary *position in previous) {
		NSString *aBoard = [position objectForKey: @"board"];
		if ([aBoard isEqual: [self stringForBoard: myBoard]]) {
			NSString *remote = [position objectForKey: @"remoteness"];
			if (remote == nil) return -1;
			return [remote intValue];
		}
	}
	return -1;
}

/** 
 Gets the value of the child board after MOVE, based on the most recent
 server data request.
 
 @param move a move in Connect-4 (an integer in the range [0, width - 1])
 @return the value of the resulting board. Returns nil if the value is unavailable.
 */
- (NSString *) getValueAfterMove: (NSString *) move {
	for (NSDictionary *position in current) {
		NSString *aMove = [position objectForKey: @"move"];
		if ([aMove isEqual: move]) {
			NSString *val = [position objectForKey: @"value"];
			return val; // If VAL is nil, I want to return nil anyway
		}
	}
	return nil;
}

/** 
 Handles the requests to the server. Given a board and its parameters,
 it makes the request and stores the result for later access by the 
 above methods.
 
 @param board a Connect-4 board
 @param width the number of columns
 @param height the number of rows
 @param pieces the number needed in a row to win
 */
- (void) retrieveDataForBoard: (NSArray *) board width: (NSInteger) width height: (NSInteger) height pieces: (NSInteger) pieces {
	myBoard = board;
	
	// Convert the board to a string
	NSString *boardString = [self stringForBoard: board];
	boardString = [boardString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	
	if (previous == nil) {
		NSString *result = [NSString stringWithContentsOfURL: 
							[NSURL URLWithString: 
							 [NSString stringWithFormat: @"http://nyc.cs.berkeley.edu:8080/gcweb/service/gamesman/puzzles/connect4/getMoveValue;width=%d;height=%d;pieces=%d;board=%@", width, height, pieces, boardString]]
													encoding: NSUTF8StringEncoding
													   error: NULL];
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		id response = [parser objectWithString: result];
		if (response != nil) {
			connected = YES;
			if ([[response objectForKey: @"status"] isEqual: @"ok"]) {
				status = YES;
				previous = [[NSArray alloc] initWithObjects: [response objectForKey: @"response"], nil];
			} else
				status = NO;
		} else {
			connected = NO;
			previous = nil;
		}
	} else
		previous = current;
	
	NSString *result = [NSString stringWithContentsOfURL: 
						[NSURL URLWithString: 
						 [NSString stringWithFormat: @"http://nyc.cs.berkeley.edu:8080/gcweb/service/gamesman/puzzles/connect4/getNextMoveValues;width=%d;height=%d;pieces=4;board=%@", width, height, boardString]]
												encoding: NSUTF8StringEncoding
												   error: NULL];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	id response = [parser objectWithString: result];
	if (response != nil) {
		connected = YES;
		if ([response isKindOfClass: [NSDictionary class]]) {
			if ([[response objectForKey: @"status"] isEqual: @"ok"]) {
				status = YES;
				current = [[response objectForKey: @"response"] retain];
			} else
				status = NO;
		}
	} else
		connected = NO;
}

@end
