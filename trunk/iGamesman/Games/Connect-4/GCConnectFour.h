//
//  GCConnectFour.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/13/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCGame.h"

#import "GCConnectFourView.h"

@class GCConnectFourPosition;

@interface GCConnectFour : NSObject <GCGame, GCConnectFourViewDelegate>
{
    GCConnectFourPosition *_position;
    
    GCPlayer *_leftPlayer, *_rightPlayer;
    
    GCMoveCompletionHandler _moveHandler;
    
    GCConnectFourView *_connectFourView;
    
    
    BOOL _showMoveValues, _showDeltaRemoteness;
    
    NSArray *_moveValues, *_remotenessValues;
}

@end
