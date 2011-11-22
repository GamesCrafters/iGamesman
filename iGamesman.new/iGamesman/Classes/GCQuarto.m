//
//  GCQuarto.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 10/3/11.
//  Copyright 2011 GamesCrafters. All rights reserved.
//

#import "GCQuarto.h"

#import "GCQuartoPiece.h"
#import "GCQuartoPosition.h"
#import "GCQuartoView.h"


@implementation GCQuarto

#pragma mark -
#pragma mark Memory lifecycle

- (id) init
{
    self = [super init];
    
    if (self)
    {
        position = [[GCQuartoPosition alloc] init];
    }
    
    return self;
}


- (void) dealloc
{
    [position release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark GCGame protocol

- (UIView *) viewWithFrame: (CGRect) frame
{
    GCQuartoView *quartoView = [[[GCQuartoView alloc] initWithFrame: frame] autorelease];
    quartoView.delegate = self;
    return quartoView;
}


- (void) startGameWithLeft: (GCPlayer *) _leftPlayer right: (GCPlayer *) _rightPlayer andPlaySettings: (NSDictionary *) settingsDict
{
    leftPlayer  = [_leftPlayer retain];
    rightPlayer = [_rightPlayer retain];
    
    if ([settingsDict objectForKey: GCGameModeKey] == GCGameModeOfflineUnsolved)
        mode = OFFLINE_UNSOLVED;
    else if ([settingsDict objectForKey: GCGameModeOnlineSolved])
        mode = ONLINE_SOLVED;
}


#pragma mark -
#pragma mark GCQuartoViewDelegate

- (GCQuartoPosition *) currentPosition
{
    return position;
}

@end
