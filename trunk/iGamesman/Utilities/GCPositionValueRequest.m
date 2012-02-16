//
//  GCPositionValueRequest.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/3/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCPositionValueRequest.h"

#import "SBJson.h"



@interface GCPositionValueRequest ()
{
    id<GCPositionValueRequestDelegate> delegate;
}

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
        baseURL = [url retain];
        parameterString = [params retain];
    }
    
    return self;
}


- (void) dealloc
{
    [baseURL release];
    [parameterString release];
    
    [super dealloc];
}


#pragma mark -

- (void) setDelegate: (id<GCPositionValueRequestDelegate>) _delegate
{
    delegate = _delegate;
}


- (void) getValueForPosition: (NSString *) boardString
{
    NSString *methodString = [NSString stringWithFormat: @"getMoveValue;%@board=%@", parameterString, boardString];
    NSURL *positionValueURL = [NSURL URLWithString: methodString relativeToURL: baseURL];
    
    resultData = [[NSMutableData alloc] init];
    
    NSURLRequest *request = [NSURLRequest requestWithURL: positionValueURL];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest: request delegate: self];
    
    if (connection)
    {
        [delegate positionRequestReachedServer: self];
    }
}


#pragma mark - NSURLConnection delegate

- (void) connection: (NSURLConnection *) connection didReceiveResponse: (NSURLResponse *) response
{
    [resultData setData: nil];
    
    if ([response isKindOfClass: [NSHTTPURLResponse class]])
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if ([httpResponse statusCode] == 200)
        {
            [delegate positionRequestDidReceiveResponse: self];
        }
        else
        {
            [delegate positionRequest: self didFailWithError: [NSError errorWithDomain: @"Server Error" code: 100 userInfo: nil]];
        }
    }
}


- (void) connection: (NSURLConnection *) connection didReceiveData: (NSData *) data
{
    [resultData appendData: data];
}


- (void) connection: (NSURLConnection *) connection didFailWithError: (NSError *) error
{
    [resultData release];
    
    [delegate positionRequest: self didFailWithError: error];
}


- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{    
    NSDictionary *resultObject = [resultData JSONValue];
    
    [resultData release];
    
    if ([[resultObject objectForKey: @"status"] isEqualToString: @"ok"])
    {
        [delegate positionRequestDidReceiveStatusOK: self];
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
        
        [delegate positionRequest: self receivedValue: positionValue remoteness: [remoteness unsignedIntegerValue]];
    }
}

@end
