//
//  GCPositionValueRequest.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/3/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCGame.h"

@protocol GCPositionValueRequestDelegate;

/**
 * Utility class used by GCJSONService. Encapsulates a "getMoveValue" request.
 */
@interface GCPositionValueRequest : NSObject
{    
    NSURL *baseURL;
    NSString *parameterString;
    
    NSMutableData *resultData;
}

+ (id) requestWithBaseURL: (NSURL *) baseURL parameterString: (NSString *) params forPosition: (NSString *) boardString delegate: (id<GCPositionValueRequestDelegate>) delegate;

@end



@protocol GCPositionValueRequestDelegate

- (void) positionRequestReachedServer: (GCPositionValueRequest *) request;
- (void) positionRequestDidReceiveResponse: (GCPositionValueRequest *) request;
- (void) positionRequest: (GCPositionValueRequest *) request didFailWithError: (NSError *) error;
- (void) positionRequestDidReceiveStatusOK: (GCPositionValueRequest *) request;
- (void) positionRequest: (GCPositionValueRequest *) request receivedValue: (GCGameValue *) value remoteness: (NSInteger) remoteness;

@end
