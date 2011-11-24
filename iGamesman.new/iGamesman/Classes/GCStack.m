//
//  GCStack.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/23/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import "GCStack.h"

@implementation GCStack

- (id) init
{
    self = [super init];
    
    if (self)
    {
        _stack = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (BOOL) isEmpty
{
    return ([_stack count] == 0);
}


- (void) push: (id) object
{
    [_stack addObject: object];
}


- (id) peek
{
    return [_stack lastObject];
}


- (void) pop
{
    [_stack removeLastObject];
}


- (void) flush
{
    while (![self isEmpty])
    {
        [self pop];
    }
}


- (void) dealloc
{
    [_stack release];
    
    [super dealloc];
}

@end
