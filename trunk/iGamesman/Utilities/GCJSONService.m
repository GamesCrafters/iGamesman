//
//  GCJSONService.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/31/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCJSONService.h"


@implementation GCJSONService

@synthesize delegate;

#pragma mark - Memory lifecycle

- (id) initWithServiceName: (NSString *) name
                parameters: (NSDictionary *) params
{
    self = [super init];
    
    if (self)
    {
        baseURLString = [NSString stringWithFormat: @"http://nyc.cs.berkeley.edu:8080/gcweb/service/gamesman/puzzles/%@/", name];
        [baseURLString retain];
        
        parameterString = @"";
        for (NSString *key in params)
        {
            parameterString = [parameterString stringByAppendingFormat: @"%@=%@;", key, [params objectForKey: key]];
        }
        
        [parameterString retain];
    }
    
    return self;
}


- (void) dealloc
{
    [parameterString release];
    
    [super dealloc];
}


#pragma mark - 

- (void) retrieveDataForBoard: (NSString *) boardString
                      withKey: (NSString *) boardKey
                forPlayerSide: (GCPlayerSide) side
{
    moveValueSent = NO;
    positionValueSent = NO;
    
    [GCPositionValueRequest requestWithBaseURL: [NSURL URLWithString: baseURLString]
                               parameterString: parameterString
                                   forPosition: boardString
                                      delegate: self];
    
    [GCMoveValuesRequest requestWithBaseURL: [NSURL URLWithString: baseURLString]
                            parameterString: parameterString
                                forPosition: boardString
                                   delegate: self];
}


#pragma mark - GCPositionValueRequestDelegate

- (void) positionRequestReachedServer: (GCPositionValueRequest *) request
{
    if ([delegate respondsToSelector: @selector(jsonServiceDidReachServer:)])
        [delegate jsonServiceDidReachServer: self];
}


- (void) positionRequestDidReceiveResponse: (GCPositionValueRequest *) request
{
    if ([delegate respondsToSelector: @selector(jsonServiceDidReceiveResponse:)])
        [delegate jsonServiceDidReceiveResponse: self];
}


- (void) positionRequest: (GCPositionValueRequest *) request didFailWithError: (NSError *) error
{
    if ([delegate respondsToSelector: @selector(jsonService:didFailWithError:)])
        [delegate jsonService: self didFailWithError: error];
}


- (void) positionRequestDidReceiveStatusOK: (GCPositionValueRequest *) request
{
    if ([delegate respondsToSelector: @selector(jsonServiceDidReceiveStatusOK:)])
        [delegate jsonServiceDidReceiveStatusOK: self];
}


- (void) positionRequest: (GCPositionValueRequest *) request receivedValue: (GCGameValue *) value remoteness: (NSInteger) remoteness
{
    if ([delegate respondsToSelector: @selector(jsonService:didReceivePositionValue:remoteness:)])
        [delegate jsonService: self didReceivePositionValue: value remoteness: remoteness];
    
    positionValueSent = YES;
    
    if (positionValueSent && moveValueSent)
    {
        if ([delegate respondsToSelector: @selector(jsonServiceDidFinish:)])
            [delegate jsonServiceDidFinish: self];
    }   
}


#pragma mark - GCMoveValuesRequestDelegate

- (void) moveValuesRequestReachedServer: (GCMoveValuesRequest *) request
{
    
}


- (void) moveValuesRequestDidReceiveResponse: (GCMoveValuesRequest *) request
{
    
}


- (void) moveValuesRequest: (GCMoveValuesRequest *) request didFailWithError: (NSError *) error
{
    
}


- (void) moveValuesRequestDidReceiveStatusOK: (GCMoveValuesRequest *) request
{
    
}


- (void) moveValuesRequest: (GCMoveValuesRequest *) request
            receivedValues: (NSArray *) values
              remotenesses: (NSArray *) remotenesses
                  forMoves: (NSArray *) moves
{
    if ([delegate respondsToSelector: @selector(jsonService:didReceiveValues:remotenesses:forMoves:)])
        [delegate jsonService: self didReceiveValues: values remotenesses: remotenesses forMoves: moves];
    
    moveValueSent = YES;
    
    if (positionValueSent && moveValueSent)
    {
        if ([delegate respondsToSelector: @selector(jsonServiceDidFinish:)])
            [delegate jsonServiceDidFinish: self];
    }
}


@end
