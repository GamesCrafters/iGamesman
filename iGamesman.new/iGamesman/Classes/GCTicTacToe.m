//
//  GCTicTacToe.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/21/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import "GCTicTacToe.h"

#import "GCTicTacToeView.h"

@implementation GCTicTacToe

#pragma mark -
#pragma mark Memory lifecycle

- (id) init
{
    self = [super init];
    
    if (self)
    {
        position = [[GCTicTacToePosition alloc] initWithWidth: 3 height: 3 toWin: 3];
        position.leftTurn = YES;
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
    GCTicTacToeView *tttView = [[GCTicTacToeView alloc] initWithFrame: frame];
    tttView.delegate = self;
    return [tttView autorelease];
}


- (void) startGameWithLeft: (GCPlayer *) left
                     right: (GCPlayer *) right
           andPlaySettings: (NSDictionary *) settingsDict
{
    leftPlayer = [left retain];
    rightPlayer = [right retain];
}


#pragma mark -
#pragma mark GCTicTacToeViewDelegate

- (GCTicTacToePosition *) currentPosition
{
    return position;
}

@end
