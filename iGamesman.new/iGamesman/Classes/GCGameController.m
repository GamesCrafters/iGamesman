//
//  GCGameController.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/22/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import "GCGameController.h"

#import "GCGame.h"

#import "GCPlayer.h"


@implementation GCGameController

- (id) initWithGame: (id<GCGame>) _game
{
    self = [super init];
    
    if (self)
    {
        game = _game;
    }
    
    return self;
}


- (void) processHumanMove: (Move) move
{
    [game doMove: move];
    
    [self go];
}


- (void) go
{
    PlayerSide currentPlayerSide = [game currentPlayer];
    
    GCPlayer *currentPlayer;
    if (currentPlayerSide == PLAYER_LEFT)
        currentPlayer = [game leftPlayer];
    else
        currentPlayer = [game rightPlayer];
    
    
    void (^moveCompletion) (Move) = ^(Move move)
    {
        [self processHumanMove: move];
    };
    
    
    if ([game primitive: [game currentPosition]] == NONPRIMITIVE)
    {
        if ([currentPlayer type] == HUMAN)
        {
            [game waitForHumanMoveWithCompletion: moveCompletion];
        }
        else
        {
            
        }
    }
}

@end
