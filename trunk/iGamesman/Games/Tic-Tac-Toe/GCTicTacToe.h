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
    GCTicTacToePosition *_position;

    GCPlayer *_leftPlayer, *_rightPlayer;
    
    GCMoveCompletionHandler _moveHandler;
    
    GCTicTacToeView *_tttView;
    
    
    BOOL _showMoveValues, _showDeltaRemoteness;
    
    NSArray *_moveValues;
    NSArray *_remotenessValues;
}

@end
