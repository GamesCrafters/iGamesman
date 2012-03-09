//
//  GCPositionValueRequest.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/3/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCPositionValueRequest.h"



@interface GCPositionValueRequest ()

- (id) initWithBaseURL: (NSURL *) baseURL parameterString: (NSString *) params;

- (void) setDelegate: (id<GCPositionValueRequestDelegate>) delegate;

- (void) getValueForPosition: (NSString *) boardString;

@end



@implementation GCPositionValueRequest


#pragma mark - Factory method

+ (id) requestWithBaseURL: (NSURL *) baseURL
          parameterString: (NSString *) params
              forPosition: (NSString *) boardString
                 delegate: (id<GCPositionValueRequestDelegate>) delegate
{
    GCPositionValueRequest *request = [[GCPositionValueRequest alloc] initWithBaseURL: baseURL parameterString: params];
    [request setDelegate: delegate];
    
    [request getValueForPosition: boardString];
    
    return [request autorelease];
}


#pragma mark - Memory lifecycle

- (id) initWithBaseURL: (NSURL *) url parameterString: (NSString *) params
{
    self = [super init];
    
    if (self)
    {
        _baseURL = [url retain];
        _parameterString = [params retain];
    }
    
    return self;
}


- (void) dealloc
{
    [_baseURL release];
    [_parameterString release];
    
    [super dealloc];
}


#pragma mark -

- (void) setDelegate: (id<GCPositionValueRequestDelegate>) delegate
{
    _delegate = delegate;
}


- (void) getValueForPosition: (NSString *) boardString
{
    NSString *methodString = [NSString stringWithFormat: @"getMoveValue;%@board=%@", _parameterString, boardString];
    NSURL *positionValueURL = [NSURL URLWithString: methodString relativeToURL: _baseURL];
    
    _resultData = [[NSMutableData alloc] init];
    
    NSURLRequest *request = [NSURLRequest requestWithURL: positionValueURL];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest: request delegate: self];
    
    if (connection)
    {
        [_delegate positionRequestReachedServer: self];
    }
}


#pragma mark - NSURLConnection delegate

- (void) connection: (NSURLConnection *) connection didReceiveResponse: (NSURLResponse *) response
{
    [_resultData setData: nil];
    
    if ([response isKindOfClass: [NSHTTPURLResponse class]])
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if ([httpResponse statusCode] == 200)
        {
            [_delegate positionRequestDidReceiveResponse: self];
        }
        else
        {
            [_delegate positionRequest: self didFailWithError: [NSError errorWithDomain: @"Server Error" code: 100 userInfo: nil]];
        }
    }
}


- (void) connection: (NSURLConnection *) connection didReceiveData: (NSData *) data
{
    [_resultData appendData: data];
}


- (void) connection: (NSURLConnection *) connection didFailWithError: (NSError *) error
{
    [_resultData release];
    
    [_delegate positionRequest: self didFailWithError: error];
}


- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{    
    NSDictionary *resultObject = [NSJSONSerialization JSONObjectWithData: _resultData options: 0 error: nil];
    
    [_resultData release];
    
    if ([[resultObject objectForKey: @"status"] isEqualToString: @"ok"])
    {
        [_delegate positionRequestDidReceiveStatusOK: self];
    }
    else if ([[resultObject objectForKey: @"status"] isEqualToString: @"error"])
    {
        [_delegate positionRequest: self didFailWithError: [NSError errorWithDomain: @"Server reported error" code: 200 userInfo: nil]];
        return;
    }
    
    NSDictionary *response = [resultObject objectForKey: @"response"];
    
    if (response)
    {
        NSString *value = [response objectForKey: @"value"];
        NSNumber *remoteness = [response objectForKey: @"remoteness"];
        
        NSArray *objs = [NSArray arrayWithObjects: GCGameValueWin, GCGameValueLose, GCGameValueTie, GCGameValueDraw, nil];
        NSArray *keys = [NSArray arrayWithObjects: @"win", @"lose", @"tie", @"draw", nil];
        NSDictionary *valueMap = [NSDictionary dictionaryWithObjects: objs forKeys: keys];
        
        GCGameValue *positionValue = [valueMap objectForKey: value];
        if (!positionValue)
            positionValue = GCGameValueUnknown;
        
        [_delegate positionRequest: self receivedValue: positionValue remoteness: [remoteness unsignedIntegerValue]];
    }
}

@end
