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


- (NSString *) description
{
    return [NSString stringWithFormat: @"%c%c%c%c", (_tall ? 'T' : 's'), (_light ? 'L' : 'd'), (_square ? 'Q' : 'c'), (_hollow ? 'H' : 'f')];
}

@end



@implementation GCQuarto

- (id)init
{
    self = [super init];
    if (self) {
        board = [[NSMutableArray alloc] initWithCapacity: 16];
        
        pieces = [[NSMutableArray alloc] initWithCapacity: 16];
        
        for (int i = 0; i < 16; i += 1)
        {
            BOOL tall   = (i & 1) != 0;
            BOOL light  = (i & 2) != 0;
            BOOL square = (i & 4) != 0;
            BOOL hollow = (i & 8) != 0;
            
            GCQuartoPiece *piece = [[GCQuartoPiece alloc] initWithTall: tall light: light square: square hollow: hollow];
            [pieces addObject: piece];
            [piece release];
        }
        
        NSLog(@"%@", pieces);
    }
    
    return self;
}

@end
