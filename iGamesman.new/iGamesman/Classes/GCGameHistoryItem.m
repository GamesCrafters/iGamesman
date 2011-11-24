//
//  GCGameHistoryItem.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/23/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import "GCGameHistoryItem.h"

@implementation GCGameHistoryItem

- (id) initWithPosition: (Position) _position
                andMove: (Move) _move
{
    self = [super init];
    
    if (self)
    {
        [(NSObject *) _position retain];
        [(NSObject *) _move retain];
        position = _position;
        move = _move;
    }
    
    return self;
}


- (void) dealloc
{
    [(NSObject *) position release];
    [(NSObject *) move release];
    
    [super dealloc];
}

- (Position) position
{
    return position;
}


- (Move) move
{
    return move;
}

@end
