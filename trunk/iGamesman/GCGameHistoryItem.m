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
                   move: (GCMove *) _move
                  value: (GCGameValue *) _value
             remoteness: (NSInteger) _remoteness
{
    self = [super init];
    
    if (self)
    {
        position = [_position retain];
        move = [_move retain];
        value = [_value retain];
        remoteness = _remoteness;
        
        moveValues = [[NSMutableDictionary alloc] init];
        moveRemotenesses = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


- (void) dealloc
{
    [position release];
    [move release];
    [value release];
    
    [moveValues release];
    [moveRemotenesses release];
    
    [super dealloc];
}


- (NSString *) description
{
    NSString *desc = [NSString stringWithFormat: @"position: %@\nmove: %@\nvalue: %@\nremoteness: %d\nmove values: %@", position, move, value, remoteness, moveValues];
    return desc;
}


#pragma mark -

- (GCPosition *) position
{
    return position;
}


- (GCMove *) move
{
    return move;
}


- (GCGameValue *) value
{
    return value;
}


- (NSInteger) remoteness
{
    return remoteness;
}


- (NSArray *) moves
{
    return [moveValues allKeys];
}


- (GCGameValue *) valueForMove: (GCGameValue *) _move
{
    return [moveValues objectForKey: _move];
}


- (NSInteger) remotenessForMove: (GCMove *) _move
{
    return [[moveRemotenesses objectForKey: _move] integerValue];
}


- (void) setGameValue: (GCGameValue *) _value
{
    value = _value;
}


- (void) setRemoteness: (NSInteger) _remoteness
{
    remoteness = _remoteness;
}


- (void) setGameValue: (NSString *) _value remoteness: (NSInteger) _remoteness forMove: (GCMove *) _move
{
    [moveValues setObject: _value forKey: _move];
    [moveRemotenesses setObject: [NSNumber numberWithInteger: _remoteness] forKey: _move];
}

@end
