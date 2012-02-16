//
//  GCJSONService.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/31/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCGame.h"

#import "GCMoveValuesRequest.h"
#import "GCPositionValueRequest.h"


@protocol GCJSONServiceDelegate;


@interface GCJSONService : NSObject <GCMoveValuesRequestDelegate, GCPositionValueRequestDelegate>
{
    NSString *baseURLString;
    NSString *parameterString;
    
    BOOL moveValueSent, positionValueSent;
    
    id<GCJSONServiceDelegate> delegate;
    
    
    NSMutableData *resultData;
}

@property (nonatomic, assign) id<GCJSONServiceDelegate> delegate;

- (id) initWithServiceName: (NSString *) name
                parameters: (NSDictionary *) params;


- (void) retrieveDataForBoard: (NSString *) boardString
                      withKey: (NSString *) boardKey
                forPlayerSide: (GCPlayerSide) side;

@end



@protocol GCJSONServiceDelegate <NSObject>

@optional

- (void) jsonServiceDidReachServer: (GCJSONService *) service;

- (void) jsonServiceDidReceiveResponse: (GCJSONService *) service;

- (void) jsonServiceDidReceiveStatusOK: (GCJSONService *) service;

- (void) jsonService: (GCJSONService *) service didReceivePositionValue: (GCGameValue *) value remoteness: (NSInteger) remoteness;

- (void) jsonService: (GCJSONService *) service didReceiveValues: (NSArray *) values remotenesses: (NSArray *) remotenesses forMoves: (NSArray *) moves;

- (void) jsonService: (GCJSONService *) service didFailWithError: (NSError *) error;

- (void) jsonServiceDidFinish: (GCJSONService *) service;

@end
