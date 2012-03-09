//
//  GCGameHistoryItem.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/23/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import "GCGameHistoryItem.h"

@implementation GCGameHistoryItem

- (id) initWithPosition: (GCPosition *) position
                 player: (GCPlayerSide) side
                   move: (GCMove *) move
                  value: (GCGameValue *) value
             remoteness: (NSInteger) remoteness
{
    self = [super init];
    
    if (self)
    {
        _position = [position retain];
        _player = side;
        _move = [move retain];
        _value = [value retain];
        _remoteness = remoteness;
        
        _moveValues = [[NSMutableDictionary alloc] init];
        _moveRemotenesses = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


- (void) dealloc
{
    [_position release];
    [_move release];
    [_value release];
    
    [_moveValues release];
    [_moveRemotenesses release];
    
    [super dealloc];
}


- (NSString *) description
{
    NSString *desc = [NSString stringWithFormat: @"position: %@\nside: %@\nmove: %@\nvalue: %@\nremoteness: %d\nmove values: %@", _position,
                      (_player == GC_PLAYER_LEFT ? @"Left" : @"Right"), _move, _value, _remoteness, _moveValues];
    return desc;
}


#pragma mark -

- (GCPosition *) position
{
    return _position;
}


- (GCPlayerSide) playerSide
{
    return _player;
}


- (GCMove *) move
{
    return _move;
}


- (GCGameValue *) value
{
    return _value;
}


- (NSInteger) remoteness
{
    return _remoteness;
}


- (NSArray *) moves
{
    return [_moveValues allKeys];
}


- (GCGameValue *) valueForMove: (GCGameValue *) move
{
    return [_moveValues objectForKey: move];
}


- (NSInteger) remotenessForMove: (GCMove *) move
{
    return [[_moveRemotenesses objectForKey: move] integerValue];
}


- (void) setGameValue: (GCGameValue *) value
{
    _value = value;
}


- (void) setRemoteness: (NSInteger) remoteness
{
    _remoteness = remoteness;
}


- (void) setGameValue: (NSString *) value remoteness: (NSInteger) remoteness forMove: (GCMove *) move
{
    [_moveValues setObject: value forKey: move];
    [_moveRemotenesses setObject: [NSNumber numberWithInteger: remoteness] forKey: move];
}

@end
