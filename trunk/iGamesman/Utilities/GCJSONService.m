//
//  GCJSONService.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/31/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCJSONService.h"


@implementation GCJSONService

@synthesize delegate = _delegate;

#pragma mark - Memory lifecycle

- (id) initWithServiceName: (NSString *) name
                parameters: (NSDictionary *) params
{
    self = [super init];
    
    if (self)
    {
        _baseURLString = [NSString stringWithFormat: @"http://nyc.cs.berkeley.edu:8080/gcweb/service/gamesman/puzzles/%@/", name];
        [_baseURLString retain];
        
        _parameterString = @"";
        for (NSString *key in params)
        {
            _parameterString = [_parameterString stringByAppendingFormat: @"%@=%@;", key, [params objectForKey: key]];
        }
        
        [_parameterString retain];
    }
    
    return self;
}


- (void) dealloc
{
    [_parameterString release];
    
    [super dealloc];
}


#pragma mark - 

- (void) retrieveDataForBoard: (NSString *) boardString
                      withKey: (NSString *) boardKey
                forPlayerSide: (GCPlayerSide) side
{
    _moveValueSent = NO;
    _positionValueSent = NO;
    
    [GCPositionValueRequest requestWithBaseURL: [NSURL URLWithString: _baseURLString]
                               parameterString: _parameterString
                                   forPosition: boardString
                                      delegate: self];
    
    [GCMoveValuesRequest requestWithBaseURL: [NSURL URLWithString: _baseURLString]
                            parameterString: _parameterString
                                forPosition: boardString
                                   delegate: self];
}


#pragma mark - GCPositionValueRequestDelegate

- (void) positionRequestReachedServer: (GCPositionValueRequest *) request
{
    if ([_delegate respondsToSelector: @selector(jsonServiceDidReachServer:)])
        [_delegate jsonServiceDidReachServer: self];
}


- (void) positionRequestDidReceiveResponse: (GCPositionValueRequest *) request
{
    if ([_delegate respondsToSelector: @selector(jsonServiceDidReceiveResponse:)])
        [_delegate jsonServiceDidReceiveResponse: self];
}


- (void) positionRequest: (GCPositionValueRequest *) request didFailWithError: (NSError *) error
{
    if ([_delegate respondsToSelector: @selector(jsonService:didFailWithError:)])
        [_delegate jsonService: self didFailWithError: error];
}


- (void) positionRequestDidReceiveStatusOK: (GCPositionValueRequest *) request
{
    if ([_delegate respondsToSelector: @selector(jsonServiceDidReceiveStatusOK:)])
        [_delegate jsonServiceDidReceiveStatusOK: self];
}


- (void) positionRequest: (GCPositionValueRequest *) request receivedValue: (GCGameValue *) value remoteness: (NSInteger) remoteness
{
    if ([_delegate respondsToSelector: @selector(jsonService:didReceivePositionValue:remoteness:)])
        [_delegate jsonService: self didReceivePositionValue: value remoteness: remoteness];
    
    _positionValueSent = YES;
    
    if (_positionValueSent && _moveValueSent)
    {
        if ([_delegate respondsToSelector: @selector(jsonServiceDidFinish:)])
            [_delegate jsonServiceDidFinish: self];
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
    if ([_delegate respondsToSelector: @selector(jsonService:didFailWithError:)])
        [_delegate jsonService: self didFailWithError: error];
}


- (void) moveValuesRequestDidReceiveStatusOK: (GCMoveValuesRequest *) request
{
    
}


- (void) moveValuesRequest: (GCMoveValuesRequest *) request
            receivedValues: (NSArray *) values
              remotenesses: (NSArray *) remotenesses
                  forMoves: (NSArray *) moves
{
    if ([_delegate respondsToSelector: @selector(jsonService:didReceiveValues:remotenesses:forMoves:)])
        [_delegate jsonService: self didReceiveValues: values remotenesses: remotenesses forMoves: moves];
    
    _moveValueSent = YES;
    
    if (_positionValueSent && _moveValueSent)
    {
        if ([_delegate respondsToSelector: @selector(jsonServiceDidFinish:)])
            [_delegate jsonServiceDidFinish: self];
    }
}


@end
