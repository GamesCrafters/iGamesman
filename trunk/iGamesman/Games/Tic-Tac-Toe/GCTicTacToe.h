//
//  GCTicTacToe.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/10/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCGame.h"

#import "GCTicTacToeView.h"


@class GCTicTacToePosition;

@interface GCTicTacToe : NSObject <GCGame, GCTicTacToeViewDelegate>
{
    GCTicTacToePosition *position;

    GCPlayer *leftPlayer, *rightPlayer;
    
    GCMoveCompletionHandler moveHandler;
    
    GCTicTacToeView *tttView;
    
    
    BOOL showMoveValues, showDeltaRemoteness;
    
    NSArray *moveValues;
    NSArray *remotenessValues;
}

@end
