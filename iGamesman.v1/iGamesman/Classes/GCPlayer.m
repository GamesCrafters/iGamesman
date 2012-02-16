//
//  GCPlayer.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 9/28/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import "GCPlayer.h"

@implementation GCPlayer

- (NSString *) name
{
    return _name;
}


- (void) setName: (NSString *) name
{
    [name retain];
    if (_name)
        [_name release];
    
    _name = [name retain];
    [name release];
}


- (PlayerType) type
{
    return _type;
}


- (void) setType: (PlayerType) type
{
    _type = type;
}


- (CGFloat) percentPerfect
{
    return _percentPerfect;
}


- (void) setPercentPerfect: (CGFloat) percentPerfect
{
    assert((0 <= percentPerfect) && (percentPerfect <= 100));
    
    _percentPerfect = percentPerfect;
}


#pragma mark - Memory lifecycle

- (id) init
{
    self = [super init];
    if (self)
    {
        _name = nil;
        _percentPerfect = 100;
    }
    
    return self;
}


- (void) dealloc
{
    [_name release];
    
    [super dealloc];
}


@end
