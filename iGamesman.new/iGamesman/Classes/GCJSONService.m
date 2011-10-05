//
//  GCJSONService.m
//  GamesmanMobile
//
//  Created by Kevin Jorgensen on 4/24/10.
//  Copyright 2010 GamesCrafters. All rights reserved.
//

#import "GCJSONService.h"
#import "SBJsonParser.h"


@implementation GCJSONService

/** Designated initializer */
- (id) init {
	if (self = [super init]) {
		previous  = nil;
		current   = nil;
		myBoard   = nil;
		status    = NO;
		connected = NO;
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
 Returns the "opposite" position value.
 
 @param value a game value (win, lose, tie, or draw)
 @return the opposite game value
 */
+ (NSString *) flip: (NSString *) value {
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
		if ([aBoard isEqual: myBoard]) {
			NSString *val = [position objectForKey: @"value"];
			if (val == nil) 
				return nil;
			if ([position objectForKey: @"move"] == nil) // Handles the case of the first position
				return val;								 // where the value is NOT flipped
			return [GCJSONService flip: val];
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
		if ([aBoard isEqual: myBoard]) {
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
 
 @param move a move in the game in the format used by the server
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
 Gets the remoteness of the child board after MOVE, based on the most
 recent server data request.
 
 @param move a move in the game in the format used by the server
 @return the remoteness of the resulting board. Returns -1 if the value is unavailable.
 */
- (NSInteger) getRemotenessAfterMove: (NSString *) move {
	for (NSDictionary *position in current) {
		NSString *aMove = [position objectForKey: @"move"];
		if ([aMove isEqualToString: move])
			return [[position objectForKey: @"remoteness"] integerValue];
	}
	return -1;
}


/**
 Handles requests to the server. Given a URL for position value
 and another for next move values, makes the request and stores
 the result for later access by the above methods.
 
 @param board a board in the game in the format used by the server
 @param posURL the URL of the server request that yields the value of a position
 @param nextURL the URL of the server request that gives the values of children positions
 */
- (void) retrieveDataForBoard: (NSString *) board URL: (NSString *) posURL andNextMovesURL: (NSString *) nextURL {
	if (![myBoard isEqual: board]) {
		myBoard = [board retain];
		
		BOOL found = NO;
		for (NSDictionary *position in previous) {
			NSString *aBoard = [position objectForKey: @"board"];
			if ([aBoard isEqual: myBoard]) {
				found = YES;
				break;
			}
		}
		
		if (!previous || !found) {
			NSString *result = [[NSString alloc] initWithContentsOfURL: [NSURL URLWithString: posURL]
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
			[parser release];
		} else
			previous = current;
		
		NSString *result = [[NSString alloc] initWithContentsOfURL: [NSURL URLWithString: nextURL]
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
		[parser release];
	}
}


- (void) dealloc {
	if (previous) [previous release];
	if (current) [current release];
	[super dealloc];
}

@end
