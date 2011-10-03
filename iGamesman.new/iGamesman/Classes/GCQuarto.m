//
//  GCQuarto.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 10/3/11.
//  Copyright 2011 Kevin Jorgensen. All rights reserved.
//

#import "GCQuarto.h"



@interface GCQuartoPiece : NSObject
{
    BOOL _tall, _light, _square, _hollow;
}

@property (nonatomic, readonly) BOOL tall, light, square, hollow;

- (id) initWithTall: (BOOL) tall
              light: (BOOL) light
             square: (BOOL) square
             hollow: (BOOL) hollow;

@end

@implementation GCQuartoPiece

@synthesize tall = _tall, light = _light, square = _square, hollow = _hollow;

- (id) initWithTall: (BOOL) tall light: (BOOL) light square: (BOOL) square hollow: (BOOL) hollow
{
    self = [super init];
    
    if (self)
    {
        _tall = tall;
        _light = light;
        _square = square;
        _hollow = hollow;
    }
    
    return self;
}

@end



@implementation GCQuarto

- (id)init
{
    self = [super init];
    if (self) {
        board = [[NSMutableArray alloc] initWithCapacity: 16];
        
        pieces = [[NSMutableArray alloc] initWithCapacity: 16];
    }
    
    return self;
}

@end
