//
//  GCStack.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/23/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import "GCStack.h"


@interface GCStack ()
{
    NSMutableArray *stack;
}
@end



@implementation GCStack

- (id) init
{
    self = [super init];
    
    if (self)
    {
        stack = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (BOOL) isEmpty
{
    return ([stack count] == 0);
}


- (NSUInteger) count
{
    return [stack count];
}


- (void) push: (id) object
{
    [stack addObject: object];
}


- (id) peek
{
    return [stack lastObject];
}


- (void) pop
{
    [stack removeLastObject];
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
    [stack release];
    
    [super dealloc];
}


- (NSEnumerator *) objectEnumerator
{
    return [stack objectEnumerator];
}

@end
