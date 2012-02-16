//
//  GCGameHistoryItem.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/23/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import "GCGameHistoryItem.h"

@implementation GCGameHistoryItem

- (id) initWithPosition: (GCPosition *) _position
                andMove: (GCMove *) _move
{
    self = [super init];
    
    if (self)
    {
        position = [_position retain];
        move = [_move retain];
    }
    
    return self;
}


- (void) dealloc
{
    [position release];
    [move release];
    
    [super dealloc];
}

- (GCPosition *) position
{
    return position;
}


- (GCMove *) move
{
    return move;
}

@end
