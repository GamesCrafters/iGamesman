//
//  GCMoveValuesRequest.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/8/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "GCGame.h"

@protocol GCMoveValuesRequestDelegate;

/**
 * Utility class used by GCJSONService. Encapsulates a "getNextMoveValues" request.
 */
@interface GCMoveValuesRequest : NSObject
{    
    NSURL *baseURL;
    NSString *parameterString;
    
    NSMutableData *resultData;
}

+ (id) requestWithBaseURL: (NSURL *) baseURL parameterString: (NSString *) params forPosition: (NSString *) boardString delegate: (id<GCMoveValuesRequestDelegate>) delegate;

@end



@protocol GCMoveValuesRequestDelegate

- (void) moveValuesRequestReachedServer: (GCMoveValuesRequest *) request;

- (void) moveValuesRequestDidReceiveResponse: (GCMoveValuesRequest *) request;

- (void) moveValuesRequest: (GCMoveValuesRequest *) request 
          didFailWithError: (NSError *) error;

- (void) moveValuesRequestDidReceiveStatusOK: (GCMoveValuesRequest *) request;

- (void) moveValuesRequest: (GCMoveValuesRequest *) request 
            receivedValues: (NSArray *) values 
              remotenesses: (NSArray *) remotenesses 
                  forMoves: (NSArray *) moves;

@end