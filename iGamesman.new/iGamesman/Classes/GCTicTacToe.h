//
//  GCTicTacToe.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/21/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCGame.h"

#import "GCPlayer.h"
#import "GCTicTacToePosition.h"
#import "GCTicTacToeView.h"


@interface GCTicTacToe : NSObject <GCGame, GCTicTacToeViewDelegate>
{
    GCTicTacToePosition *position;
    
    GCPlayer *leftPlayer, *rightPlayer;
}

@end
